ARG REGISTRY

FROM ${REGISTRY}golang:1.20 as builder

# have to define this after FROM, otherwise its ignored.   ARG's before FROM can only be used in the image name
ARG GOPROXY 

WORKDIR /app
COPY src .

ENV GOPROXY=${GOPROXY}
RUN go get
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux go build -o main 

############################
# STEP 2 build a small image
############################
#
FROM ${REGISTRY}alpine
# Copy our static executable.
#
COPY --from=builder /app/main /go/bin/app
# Run the test-port binary.
ENTRYPOINT ["/go/bin/app"]