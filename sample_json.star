load("render.star", "render")
load("time.star", "time")
load("encoding/base64.star", "base64")
load("http.star", "http")

# your metabase url here
URL = ""

# icon or logo to display
SC_ICON = base64.decode("""
iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAAXNSR0IArs4c6QAABNxJREFUWEe9l0+IV1UUxz/n3vd+M1O4s6gW86YR/5RSkplRGxcK2sZykRTqqhZNRLYIAi0olJYppIZGiyyyIdCFpmBii4isjAoUzdR5Bm10E0I587t/4t733s/fb/z9md8QvdXM+d17zvec8z1/rtDh8yACvtPv/ci76ZJ2iqoLN7jnriEG9gBDHnFtD3dE4hXwjyYdE36/1glEBwDLUuFM3ZDt1iRjYIH+zBfB01jM3oR8zFPonI73Nq0elIDzjC6w2AtE6z440E/UKQCELKINatEgVy5UupsVtQOQCBjD8EGN3mCxBiTp03p53BuNTix+PGFig4eouyMAD1rAeu5/DPxpi3dl7Pt1v9mG04iqw+M1Jk5XNqoDLYqrHw3ZCY1aZXEB7Sy9b2AwGpVY3MmEfFVHAFV4PCNrQI79R8YrFFajtMU9lZAfa05FIwJVmdTJziTIIxYfqK9nl/vbblmNaIf/SZMvay7JCMCzMhG+NpMMb6yhD1hcKJe0g/EALHAj1HkFsJ1s2vWKkHZTwtVPKptSoQklYskuamS0JF8wMP2LhCpse2yoVvC3ZI5edy3+siZfUJAdkapBWEZeVcjOLt7HMFr4AdgLbp1GrQsIDf4bhT/gkc0aebILiLpGpXX8azUmdha2oy8L51huXtbI3A6Xo+cO/lAk86H+hJCfMmSHBJZo8vmTDC+ucfW8KTj0cAcORT0Wf10zOCpcuBEB1Mm2J6itXbyvSumwJl8Po87ixgX/kIOjFrV/AHUe7JDBb03Q2yy2E49iFAxuR0q+TTzZvQ4uCQy5sn92yr3DX9Pkd1uG31Wkb4TjDrtDocaBXyzuqCALFMzvkoYwpcTFQcU8MWT7NOrFHswPmKpaPpSQr7dk7yiSNw1mu8OO10h/LeZFJGevEo5RsLj9/QBwOtI/CRPucEL+TJ3snMBJi99bQ5+1uC8EFivkgS4RiFlvAJhhCkrv/QmHO5IyuMtwc7VCFoEsUfhdkJ6Dv+YY7nw9Qb3VhQOtKZghCWMJGvyPKflyS/ayJt9tyfZ7WJqQLzeMPJ0wcdiQndLIyi6dtJWEMyzDkgOhD/gjGtnh8Ks9vK0RsfiPHLJPwZiGzb2aUSCzYnBeLMOqEU0xsiVF3utBRqdRgcSRbA4X1o4WWdkdO43v6L3Db9FM7Iq2q1Y8Dno92W89WnGMRLEhhU/CLAjGTFMFdxrfZTPzl1TRikMfjytTYxgZhjfq3sNolgOyGkZuY0L+aWMYVdr+p3F8RpM/ets4LqJQ7GuGbK1GfdlmIYlb5vQZW/7fTt4si2Vs8GtTJo63XUhKEHEnbLOSeYHAl8YX/q7m9fTXS0HRYi0O/AgrmcF9lZKHyok2KkVtd8IpRlak8F21lJbGW9prk5FgpQVcIKqALkHEfaGOrKhx5fuuAFpTMfK5Rp4NZakhNfCEgk0K9ZLFTWlUzeJeCHc06sNbMvuBRz5O4FtLg3gHE/Lneq7lJYA2D5MY7c88PJjAUguTGhmw+OMFAFlj8ZMaBgz8LHAWeL5a3TR6oXD54oweJgWIdk+zUPJxA2tiQpXB6bIgLzLmMO9r8ldm/DQroxBfxp775npqexz+Dg91iftgnCUhveFISabQkBoyV4z7sNTK35qpMeHP6309TptBzLLrtFzr9jz/FzFOiYVxEEyaAAAAAElFTkSuQmCC
""")

# this function fetches failed submissions
def get_failed_submissions():
    rep = http.get(URL)
    if rep.status_code != 200:
        fail("Request failed with status %d", rep.status_code)
    
    # note: update this json parser to match whatever you're fetching
    failed_submissions = rep.json()[0]["Count"]

    # casting as a string on the way out in case it's a float. if it's a date or whatever else, think about how you cast here
    return str(failed_submissions)

def main(config):

    # make the call!
	message= get_failed_submissions() + " failed submissions this week"

    # main rendering block
	return render.Root(
		child = render.Stack(
			children=[	
                
                # our image to make this thing look cool as hell
                render.Image(
                    src=SC_ICON,
                    width=30,
                    height=30
                ),

                # a scrolling marquee
				render.Marquee(
					width=64,
					child=render.Text(
						content = message,
					)
				),				

			],
		)
	)

    