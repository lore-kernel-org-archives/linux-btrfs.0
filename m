From: Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH] Btrfs: fix max chunk size check in chunk allocator
Date: Fri, 13 Apr 2012 16:09:25 +0200
Message-ID: <4F883395.9050705@gmx.net>
References: <1334325908-5326-1-git-send-email-idryomov@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Ilya Dryomov <idryomov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1334325908-5326-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 13.04.2012 16:05, Ilya Dryomov wrote:
> Fix a bug, where in case we need to adjust stripe_size so that the
> length of the resulting chunk is less than or equal to max_chunk_size,
> DUP chunks turn out to be only half as big as they could be.
> 
> Cc: Arne Jansen <sensille@gmx.net>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>  fs/btrfs/volumes.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index a872b48..c462d84 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3324,12 +3324,14 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>  	stripe_size = devices_info[ndevs-1].max_avail;
>  	num_stripes = ndevs * dev_stripes;
>  
> -	if (stripe_size * num_stripes > max_chunk_size * ncopies) {
> +	if (stripe_size * ndevs > max_chunk_size * ncopies) {
>  		stripe_size = max_chunk_size * ncopies;
> -		do_div(stripe_size, num_stripes);
> +		do_div(stripe_size, ndevs);
>  	}
>  
>  	do_div(stripe_size, dev_stripes);
> +
> +	/* align to BTRFS_STRIPE_LEN */
>  	do_div(stripe_size, BTRFS_STRIPE_LEN);
>  	stripe_size *= BTRFS_STRIPE_LEN;
>  

Reviewed-by: Arne Jansen <sensille@gmx.net>

