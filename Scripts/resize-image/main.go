package main

import (
	"errors"
	"flag"
	"fmt"
	"image"
	"image/jpeg"
	"image/png"
	"os"
	"path/filepath"
	"strconv"
	"strings"

	"golang.org/x/image/draw"
)

type flags struct {
	Input  string
	Output string
	Size   image.Point
}

func main() {
	parsedFlags, err := parseFlags()
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	decodedImage, err := decodeImage(parsedFlags.Input)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	if decodedImage.Bounds().Max == parsedFlags.Size {
		fmt.Println("Image is already the right size")
		return
	}

	err = os.MkdirAll(parsedFlags.Output, os.ModePerm)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	inputComponents := strings.Split(parsedFlags.Input, "/")
	filename := inputComponents[len(inputComponents)-1]
	err = createImage(decodedImage, filename, parsedFlags.Output, parsedFlags.Size)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	fmt.Println("Done resizing image")
}

func createImage(decodedImage image.Image, filename string, outputDirectory string, newSize image.Point) error {
	output, err := os.Create(filepath.Join(outputDirectory, filename))
	if err != nil {
		return err
	}
	defer output.Close()

	inputSpecs := image.NewRGBA(image.Rect(0, 0, int(newSize.X), int(newSize.Y)))
	draw.NearestNeighbor.Scale(inputSpecs, inputSpecs.Rect, decodedImage, decodedImage.Bounds(), draw.Over, nil)
	return png.Encode(output, inputSpecs)
}

func decodeImage(path string) (image.Image, error) {
	input, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer input.Close()

	fileExtension := getFileExtension(path)
	switch fileExtension {
	case "jpeg", "jpg":
		return jpeg.Decode(input)
	case "png":
		return png.Decode(input)
	default:
		return nil, fmt.Errorf("%s file extension are not supported", fileExtension)
	}
}

func getFileExtension(str string) string {
	splitString := strings.Split(str, ".")
	fileExtension := splitString[len(splitString)-1]
	return fileExtension
}

func parseFlags() (flags, error) {
	inputPath := flag.String("i", "", "input path")
	outputPath := flag.String("o", "", "output path")
	outputSize := flag.String("s", "", "output size")
	flag.Parse()

	if *inputPath == "" {
		return flags{}, errors.New("No input path provided")
	}
	if *outputPath == "" {
		return flags{}, errors.New("No output path provided")
	}
	if *outputSize == "" {
		return flags{}, errors.New("No output size provided")
	}

	splittedSize := strings.Split(*outputSize, "x")
	if len(splittedSize) != 2 {
		return flags{}, errors.New("Invalid output size")
	}

	x, y := splittedSize[0], splittedSize[1]
	xInt, err := strconv.Atoi(x)
	if err != nil {
		return flags{}, err
	}

	yInt, err := strconv.Atoi(y)
	if err != nil {
		return flags{}, err
	}

	return flags{*inputPath, *outputPath, image.Point{xInt, yInt}}, nil
}
