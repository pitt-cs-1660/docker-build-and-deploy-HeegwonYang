# =============================================================================
# build stage
# =============================================================================
# Set base image
FROM golang:1.23 AS build_stage

# Set the working directory
WORKDIR /app

# copy go.mod, main.go, and templates into the build stage
COPY go.mod .
COPY main.go .
COPY /templates/ ./templates/

# Compile the application into a static binary using CGO_ENABLED=0
RUN CGO_ENABLED=0 go build -o binary_file .

# =============================================================================
# final stage
# =============================================================================
# Set base image
FROM scratch

# Set the working directory
WORKDIR /app

# Copy the compiled binary and templates directory from the build stage
COPY --from=build_stage /app/binary_file .
COPY --from=build_stage /app/templates/ ./templates/

# Set a CMD that runs the binary
CMD ["./binary_file"]