FROM golang:1.27 AS build
WORKDIR /src
COPY go.mod go.sum* ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o /out/server .

FROM gcr.io/distroless/static-debian13:nonroot
COPY --from=build /out/server /server
ENV PORT=8080
EXPOSE 8080
USER 1000:1000
CMD ["/server"]
