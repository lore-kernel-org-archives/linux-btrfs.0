From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] Btrfs: avoid taking the chunk_mutex in do_chunk_alloc
Date: Tue, 12 Apr 2011 17:36:43 +0200
Message-ID: <20110412153643.GI31675@twin.jikos.cz>
References: <1302568224-4567-1-git-send-email-josef@redhat.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1302568224-4567-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Mon, Apr 11, 2011 at 08:30:24PM -0400, Josef Bacik wrote:
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 0d00a07..a566780 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -740,10 +740,11 @@ struct btrfs_space_info {
>  	 */
>  	unsigned long reservation_progress;
>  
> -	int full;		/* indicates that we cannot allocate any more
> +	int full:1;		/* indicates that we cannot allocate any more
>  				   chunks for this space */
> -	int force_alloc;	/* set if we need to force a chunk alloc for
> +	int force_alloc:1;	/* set if we need to force a chunk alloc for
>  				   this space */
> +	int chunk_alloc:1;	/* set if we are allocating a chunk */
>  
>  	struct list_head list;
>  

please make the bitfields unsigned.

david
