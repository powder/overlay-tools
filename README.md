# Birthday Overlay Tools

This Sinatra application provides API and view endpoints to calculate and display the number of days since a given birthday. It's designed to be easily integrated as a browser overlay for streaming software like OBS.

## Features

*   **API Endpoint (`/api/birthday`):** Returns the number of days in JSON format.
*   **Styled View (`/view/birthday`):** Displays the number of days with simple styling suitable for stream overlays (transparent background, white text with outline, bottom-right position).
*   **No-Style View (`/no_style/birthday`):** Displays the number of days with minimal HTML and no styling, allowing users to apply their own CSS.

## Prerequisites

*   Ruby (e.g., version 3.0.0 or newer)
*   Bundler

## Setup and Running

1.  **Clone the repository (if applicable).**
2.  **Install dependencies:**
    ```bash
    bundle install
    ```
3.  **Start the Puma server:**
    ```bash
    bundle exec puma config.ru
    ```
    The application will typically start on `http://localhost:9292`.

## Usage

All endpoints require a `birthday` query parameter. The birthday can be provided in two formats:

*   **Date only:** `YYYY-MM-DD` (e.g., `1990-01-15`)
*   **Date and Time:** `YYYY-MM-DDTHH:MM:SS` (e.g., `1990-01-15T10:30:00`) - Time is assumed to be in the server's local timezone or UTC if specified with a `Z` or offset.

### API Endpoint: `/api/birthday`

Returns a JSON object with the number of days since the provided birthday.

**Example Request:**

```
GET /api/birthday?birthday=2000-07-15
```

Or using `curl`:

```bash
curl "http://localhost:9292/api/birthday?birthday=2000-07-15"
curl "http://localhost:9292/api/birthday?birthday=2000-07-15T14:00:00"
```

**Example Success Response (JSON):**

```json
{
  "days_since": 8750
}
```

**Example Error Response (JSON, HTTP 400):**

```json
{
  "error": "Invalid date format. Please use YYYY-MM-DD or YYYY-MM-DDTHH:MM:SS."
}
```

The Grape API is self-documenting to some extent. If you have tools that can process Grape API structures, they might provide further details.

### Styled View: `/view/birthday`

Renders an HTML page with basic styling for OBS overlay usage.

**Example URL:**

```
http://localhost:9292/view/birthday?birthday=1985-03-20
http://localhost:9292/view/birthday?birthday=1985-03-20T08:00:00
```

This view will show the number of days in the bottom-right corner with white text and a black outline.

### No-Style View: `/no_style/birthday`

Renders a plain HTML page with the number of days, without any specific styling. This is useful if you want to apply your own custom CSS.

**Example URL:**

```
http://localhost:9292/no_style/birthday?birthday=1999-12-31
```

The HTML output will be simple, for example:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Days Since Birthday (No Style)</title>
</head>
<body>
    <div class="birthday-calculator">
        <p><span class="days-count">9000</span> <span class="days-label">days</span> have passed since the specified date.</p>
    </div>
</body>
</html>
```

## Testing

To run the tests:

```bash
bundle exec rspec
```
(Note: Test files need to be created first.)

## Contributing

Feel free to open issues or pull requests if you have suggestions or find bugs.
