# VERT

### System Dependencies
[yt-dlp](https://github.com/yt-dlp/yt-dlp)

[ffmpeg](https://github.com/FFmpeg/FFmpeg)

### Begin a new conversion

  Returns base64 string containing your wav audio.

* **URL**

  /conversion/create

* **Method:**

  `POST`

* **Data Params**

  **Required:**
 
   `{ input_url: [your_youtube_url] }`

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** `{ video_title : "Rick Astley - Never Gonna Give You Up (Official Music Video)", wav_base64 : [base64 string], message: "Video successfully converted to audio." }`
 
* **Error Response:**

  * **Code:** 500 INTERNAL SERVER ERROR <br />
    **Content:** `{ message : "Something went wrong during the audio extraction." }`

  * **Code:** 500 INTERNAL SERVER ERROR <br />
    **Content:** `{ message : "Something went wrong during the audio conversion." }`
    
  * **Code:** 422 UNPROCESSABLE ENTITY <br />
    **Content:** `{ message : "URL is invalid" }`
  
  * **Code:** 429 TOO MANY REQUESTS <br />

* **Sample Call:**

  ```javascript
    fetch('http://api.vert.com/conversion/create', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ input_url: "https://www.youtube.com/watch?v=dQw4w9WgXcQ" })
        });
  ```
