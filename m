Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:57808 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753479AbaIWI01 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Sep 2014 04:26:27 -0400
Message-ID: <1411460741.23262.1.camel@localhost.localdomain>
Subject: Re: [PATCH v4] btrfs-progs: fix page align issue for lzo compress
 in restore
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Date: Tue, 23 Sep 2014 16:25:41 +0800
In-Reply-To: <1411439156-9972-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <20140922134115.GP9715@twin.jikos.cz>
	 <1411439156-9972-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2014-09-23 at 10:25 +0800, Gui Hecheng wrote:
> When runing restore under lzo compression, "bad compress length"
> problems are encountered.
> It is because there is a page align problem with the @decompress_lzo,
> as follows:
> 		|------| |----|-| |------|...|------|
> 		  page         ^    page       page
> 			       |
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
> 	v3->v4: keep type safety
> ---
>  cmds-restore.c | 29 +++++++++++++++++++++++++++--
>  1 file changed, 27 insertions(+), 2 deletions(-)
> 
> diff --git a/cmds-restore.c b/cmds-restore.c
> index 38a131e..fa5d5d1 100644
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
> @@ -93,6 +96,28 @@ static inline size_t read_compress_length(unsigned char *buf)
>  	return le32_to_cpu(dlen);
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
> +	 * The LZO_LEN bytes is guaranteed to be
> +	 * in one page as a whole, so if a page
> +	 * has fewer than LZO_LEN bytes left,
> +	 * the LZO_LEN bytes should be fetched
> +	 * at the start of the next page
> +	 */
> +	*in_len += bytes_left;
> +	*tot_in = tot_in_aligned;
> +}
> +
>  static int decompress_lzo(unsigned char *inbuf, char *outbuf, u64 compress_len,
>  			  u64 *decompress_len)
>  {
> @@ -135,8 +160,8 @@ static int decompress_lzo(unsigned char *inbuf, char *outbuf, u64 compress_len,
>  		}
>  		out_len += new_len;
>  		outbuf += new_len;
> +		align_if_need(&tot_in, &in_len);
>  		inbuf += in_len;
> -		tot_in += in_len;
>  	}
>  
>  	*decompress_len = out_len;

Sorry, please scratch this one, the comments should be reformated. 

