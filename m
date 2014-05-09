Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45232 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbaEINj2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 May 2014 09:39:28 -0400
Date: Fri, 9 May 2014 15:39:26 +0200
From: David Sterba <dsterba@suse.cz>
To: Zach Brown <zab@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs: return errno instead of -1 from compression
Message-ID: <20140509133926.GA5988@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1399590979-15331-1-git-send-email-zab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1399590979-15331-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 08, 2014 at 07:16:17PM -0400, Zach Brown wrote:
> The compression layer seems to have been built to return -1 and have
> callers make up errors that make sense.  This isn't great because there
> are different classes of errors that originate down in the compression
> layer.  Allocation failure and corrupt compressed data to name two.
> 
> --- a/fs/btrfs/lzo.c
> +++ b/fs/btrfs/lzo.c
> @@ -143,7 +143,7 @@ static int lzo_compress_pages(struct list_head *ws,
>  		if (ret != LZO_E_OK) {
>  			printk(KERN_DEBUG "BTRFS: deflate in loop returned %d\n",
>  			       ret);
> -			ret = -1;
> +			ret = -EIO;
>  			goto out;
>  		}
>  
> @@ -189,7 +189,7 @@ static int lzo_compress_pages(struct list_head *ws,
>  				kunmap(out_page);
>  				if (nr_pages == nr_dest_pages) {
>  					out_page = NULL;
> -					ret = -1;
> +					ret = -EIO;

This is not a true EIO, the error conditions says that the caller
prepared nr_dest_pages for the compressed data but the compression wants
more.

The number of pages is at most 128k / PAGE_SIZE.

It's a soft error, the data are written uncompressed. The closest errno
here seems E2BIG that would apply in the following hunk as well.


>  					goto out;
>  				}
>  
> @@ -208,7 +208,7 @@ static int lzo_compress_pages(struct list_head *ws,
>  
>  		/* we're making it bigger, give up */
>  		if (tot_in > 8192 && tot_in < tot_out) {
> -			ret = -1;
> +			ret = -EIO;

Here, E2BIG.

>  			goto out;
>  		}
>  
> @@ -335,7 +335,7 @@ cont:
>  					break;
>  
>  				if (page_in_index + 1 >= total_pages_in) {
> -					ret = -1;
> +					ret = -EIO;

That looks like an internal error, we should never ask for more pages
than is in the input, so the buffer offset calculations are wrong.

>  					goto done;
>  				}
>  

Analogically the same applies to zlib. The rest of the EIOs look ok.
