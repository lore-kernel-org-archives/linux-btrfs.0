Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:49498 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751563AbdETROM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 20 May 2017 13:14:12 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dC7x5-0003S8-Vd
        for linux-btrfs@vger.kernel.org; Sat, 20 May 2017 19:14:03 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: [PATCH v2 2/2] Btrfs: compression must free at least PAGE_SIZE
Date: Sat, 20 May 2017 19:14:00 +0200
Message-ID: <20170520191400.25202d75@jupiter.sol.kaishome.de>
References: <20170520164953.7344-1-nefelim4ag@gmail.com>
        <20170520164953.7344-3-nefelim4ag@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sat, 20 May 2017 19:49:53 +0300
schrieb Timofey Titovets <nefelim4ag@gmail.com>:

> Btrfs already skip store of data where compression didn't free at
> least one byte. So make logic better and make check that compression
> free at least one PAGE_SIZE, because in another case it useless to
> store this data compressed
> 
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> ---
>  fs/btrfs/lzo.c  | 5 ++++-
>  fs/btrfs/zlib.c | 3 ++-
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
> index bd0b0938..7f38bc3c 100644
> --- a/fs/btrfs/lzo.c
> +++ b/fs/btrfs/lzo.c
> @@ -229,8 +229,11 @@ static int lzo_compress_pages(struct list_head
> *ws, in_len = min(bytes_left, PAGE_SIZE);
>  	}
> 
> -	if (tot_out > tot_in)
> +	/* Compression must save at least one PAGE_SIZE */
> +	if (tot_out + PAGE_SIZE => tot_in) {

Shouldn't this be ">" instead of ">=" (btw, I don't think => works)...

Given the case that tot_in is 8192, and tot_out is 4096, we saved a
complete page but 4096+4096 would still be equal to 8192.

The former logic only pretended that there is no point in compression
if we saved 0 bytes.

BTW: What's the smallest block size that btrfs stores? Is it always
PAGE_SIZE? I'm not familiar with btrfs internals...

> +		ret = -E2BIG;
>  		goto out;
> +	}
> 
>  	/* store the size of all chunks of compressed data */
>  	cpage_out = kmap(pages[0]);
> diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
> index 135b1082..2b04259b 100644
> --- a/fs/btrfs/zlib.c
> +++ b/fs/btrfs/zlib.c
> @@ -191,7 +191,8 @@ static int zlib_compress_pages(struct list_head
> *ws, goto out;
>  	}
> 
> -	if (workspace->strm.total_out >= workspace->strm.total_in) {
> +	/* Compression must save at least one PAGE_SIZE */
> +	if (workspace->strm.total_out + PAGE_SIZE >=
> workspace->strm.total_in) { ret = -E2BIG;

Same as above...

>  		goto out;
>  	}
> --
> 2.13.0


-- 
Regards,
Kai

Replies to list-only preferred.

