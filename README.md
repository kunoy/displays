
# Displays

This is a shell script to save and restore display settings using the `displayplacer` command.

## Usage

### Save Display Settings

To save the current display settings:

```sh
./displays save
```

This command saves the current display settings to `~/.displays/current`.

### Reset Display Settings

To reset the display settings to the saved configuration:

```sh
./displays reset
```

This command restores the display settings from `~/.displays/current`.

## Installation

1. Make sure you have `displayplacer` installed. You can install it using `brew`:

    ```sh
    brew install displayplacer
    ```

2. Clone this repository and navigate to the project directory:

    ```sh
    git clone https://github.com/yourusername/yourrepository.git
    cd yourrepository
    ```

3. Make the script executable:

    ```sh
    chmod +x displays.sh
    ```

## License

This project is licensed under the MIT License
