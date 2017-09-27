Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45087 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752406AbdI0NwS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Sep 2017 09:52:18 -0400
Date: Wed, 27 Sep 2017 15:50:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v7 5/6] Btrfs: heuristic add byte set calculation
Message-ID: <20170927135043.GE31640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170825091845.4120-1-nefelim4ag@gmail.com>
 <20170825091845.4120-6-nefelim4ag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170825091845.4120-6-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 25, 2017 at 12:18:44PM +0300, Timofey Titovets wrote:
> Calculate byte set size for data sample:
> Calculate how many unique bytes has been in sample
> By count all bytes in bucket with count > 0
> If byte set low (~25%), data are easily compressible
> 
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> ---
>  fs/btrfs/heuristic.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/fs/btrfs/heuristic.c b/fs/btrfs/heuristic.c
> index f1fa6e4f1c11..ef723e991576 100644
> --- a/fs/btrfs/heuristic.c
> +++ b/fs/btrfs/heuristic.c
> @@ -24,6 +24,7 @@
>  #define ITER_SHIFT 256
>  #define BUCKET_SIZE 256
>  #define MAX_SAMPLE_SIZE (BTRFS_MAX_UNCOMPRESSED*READ_SIZE/ITER_SHIFT)
> +#define BYTE_SET_THRESHOLD 64

Explanation needed, partially covered by the changelog but we need to
see it in the code as well.

> 
>  struct bucket_item {
>  	u32 count;
> @@ -66,6 +67,27 @@ static struct list_head *heuristic_alloc_workspace(void)
>  	return ERR_PTR(-ENOMEM);
>  }
> 
> +static u32 byte_set_size(const struct workspace *ws)
> +{
> +	u32 a = 0;

Please use 'i'.

> +	u32 byte_set_size = 0;
> +
> +	for (; a < BYTE_SET_THRESHOLD; a++) {

	for (i = 0; ...)


> +		if (ws->bucket[a].count > 0)
> +			byte_set_size++;
> +	}
> +
> +	for (; a < BUCKET_SIZE; a++) {

So here the initialization is intentionally skipped, please add a
comment that this is expected or explain like "continue past the first
sample until ...".

> +		if (ws->bucket[a].count > 0) {
> +			byte_set_size++;
> +			if (byte_set_size > BYTE_SET_THRESHOLD)
> +				return byte_set_size;
> +		}
> +	}
> +
> +	return byte_set_size;
> +}
> +
>  static bool sample_repeated_patterns(struct workspace *ws)
>  {
>  	u32 i = 0;
> @@ -138,6 +160,10 @@ static int heuristic(struct list_head *ws, struct inode *inode,
>  		workspace->bucket[byte].count++;
>  	}
> 
> +	a = byte_set_size(workspace);
> +	if (a > BYTE_SET_THRESHOLD)
> +		return 2;
> +
>  	return 1;
>  }
> 
> --
> 2.14.1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
