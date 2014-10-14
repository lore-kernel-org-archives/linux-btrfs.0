Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:64990 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754161AbaJNIGX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Oct 2014 04:06:23 -0400
From: Marc Dietrich <marvin24@gmx.de>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v4] btrfs-progs: fix page align issue for lzo compress in restore
Date: Tue, 14 Oct 2014 10:06:16 +0200
Message-ID: <1929724.Hf7kupaGA7@fb07-iapwap2>
In-Reply-To: <1411461294-24093-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <20140922134115.GP9715@twin.jikos.cz> <1411461294-24093-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2599312.NCrjPfWl0h"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart2599312.NCrjPfWl0h
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"

This hasn't landed in an btrfs-progs branch I found. Any update?

Marc

Am Dienstag, 23. September 2014, 16:34:54 schrieb Gui Hecheng:
> When runing restore under lzo compression, "bad compress length"
> problems are encountered.
> It is because there is a page align problem with the @decompress_lzo,
> 
> as follows:
> 		|------| |----|-| |------|...|------|
> 
> 		  page         ^    page       page
> 
> 			  3 bytes left
> 
> 	When lzo compress pages im RAM, lzo will ensure that
> 	the 4 bytes len will be in one page as a whole.
> 	There is a situation that 3 (or less) bytes are left
> 	at the end of a page, and then the 4 bytes len is
> 	stored at the start of the next page.
> 	But the @decompress_lzo doesn't goto the start of
> 	the next page and continue to read the next 4 bytes
> 	which is across two pages, so a random value is fetched
> 	as a "bad compress length".
> 
> So we check page alignment every time before we are going to
> fetch the next @len and after the former piece of data is decompressed.
> If the current page that we reach has less than 4 bytes left,
> then we should fetch the next @len at the start of next page.
> 
> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> Reviewed-by: Marc Dietrich <marvin24@gmx.de>
> ---
> changelog
> 	v1->v2: adopt alignment check method suggested by Marc
> 	v2->v3: make code more readable
> 	v3->v4: keep type safety & reformat comments
> ---
>  cmds-restore.c | 27 +++++++++++++++++++++++++--
>  1 file changed, 25 insertions(+), 2 deletions(-)
> 
> diff --git a/cmds-restore.c b/cmds-restore.c
> index e09acc4..1fe2df0 100644
> --- a/cmds-restore.c
> +++ b/cmds-restore.c
> @@ -56,7 +56,10 @@ static int get_xattrs = 0;
>  static int dry_run = 0;
> 
>  #define LZO_LEN 4
> -#define PAGE_CACHE_SIZE 4096
> +#define PAGE_CACHE_SIZE 4096UL
> +#define PAGE_CACHE_MASK (~(PAGE_CACHE_SIZE - 1))
> +#define PAGE_CACHE_ALIGN(addr) (((addr) + PAGE_CACHE_SIZE - 1)	\
> +							& PAGE_CACHE_MASK)
>  #define lzo1x_worst_compress(x) ((x) + ((x) / 16) + 64 + 3)
> 
>  static int decompress_zlib(char *inbuf, char *outbuf, u64 compress_len,
> @@ -93,6 +96,26 @@ static inline size_t read_compress_length(unsigned char
> *buf) return le32_to_cpu(dlen);
>  }
> 
> +static void align_if_need(size_t *tot_in, size_t *in_len)
> +{
> +	size_t tot_in_aligned;
> +	size_t bytes_left;
> +
> +	tot_in_aligned = PAGE_CACHE_ALIGN(*tot_in);
> +	bytes_left = tot_in_aligned - *tot_in;
> +
> +	if (bytes_left >= LZO_LEN)
> +		return;
> +
> +	/*
> +	 * The LZO_LEN bytes is guaranteed to be in one page as a whole,
> +	 * so if a page has fewer than LZO_LEN bytes left, the LZO_LEN bytes
> +	 * should be fetched at the start of the next page
> +	 */
> +	*in_len += bytes_left;
> +	*tot_in = tot_in_aligned;
> +}
> +
>  static int decompress_lzo(unsigned char *inbuf, char *outbuf, u64
> compress_len, u64 *decompress_len)
>  {
> @@ -135,8 +158,8 @@ static int decompress_lzo(unsigned char *inbuf, char
> *outbuf, u64 compress_len, }
>  		out_len += new_len;
>  		outbuf += new_len;
> +		align_if_need(&tot_in, &in_len);
>  		inbuf += in_len;
> -		tot_in += in_len;
>  	}
> 
>  	*decompress_len = out_len;

--nextPart2599312.NCrjPfWl0h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABAgAGBQJUPNl4AAoJEKyeR39HFBtoy6kIAKEKWnP4cy4IBe+S3up+i0Am
X/7f2BZ7KApstF+lrQsPJPcZ6eDjZcFbUoL7CMjNsWHC3D/vNBV+Jt053Rr6+f9q
mD4QneJJwdzTw0MO5qbSTu3XWY3gsNGx/jlSYHQ5KbwgUx+EupPflp05sSiRg+Zq
YgEMZ6RfpnZSEzS1Gw1xfEd/OSTeYAZHJoUahcph9rw6YId741cNsPLGO6xvnBpx
swlmrbI5rGrWkrvu5RniNczQHfksWuKDtjsYEkTuso5ZEIkuJ18zg1q2u197oC/j
JSkbPe7KPyBIeAvY2xQ23cSj1dJVoPS/N5tlhCZBsWEi30Xkn9UkphRbpMjHRbE=
=YgHd
-----END PGP SIGNATURE-----

--nextPart2599312.NCrjPfWl0h--

