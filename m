From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 3/4] Btrfs: don't allocate chunks as aggressively
Date: Mon, 18 Oct 2010 17:13:14 -0400
Message-ID: <20101018211313.GA2539@localhost.localdomain>
References: <1287178115-18229-1-git-send-email-josef@redhat.com> <1287178115-18229-4-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1287178115-18229-4-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 15, 2010 at 05:28:34PM -0400, Josef Bacik wrote:
> Because the ENOSPC code over reserves super aggressively we end up allocating
> chunks way more often than we should.  For example with my fs_mark tests on a
> 2gb fs I can end up reserved 1gb just for metadata, when only 34mb of that is
> being used.  So instead check to see if the amount of space actually used is
> less than 30% of the total space, and if so don't allocate a chunk.
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  fs/btrfs/extent-tree.c |   11 ++++++++---
>  1 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 14a52dd..265d8e0 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3224,7 +3224,8 @@ static void force_metadata_allocation(struct btrfs_fs_info *info)
>  	rcu_read_unlock();
>  }
>  
> -static int should_alloc_chunk(struct btrfs_space_info *sinfo,
> +static int should_alloc_chunk(struct btrfs_fs_info *info,
> +			      struct btrfs_space_info *sinfo,
>  			      u64 alloc_bytes)
>  {
>  	u64 num_bytes = sinfo->total_bytes - sinfo->bytes_readonly;
> @@ -3237,6 +3238,9 @@ static int should_alloc_chunk(struct btrfs_space_info *sinfo,
>  	    alloc_bytes < div_factor(num_bytes, 8))
>  		return 0;
>  
> +	if (sinfo->bytes_used < div_factor(num_bytes, 3))
> +		return 0;
> +
>  	return 1;
>  }
>  
> @@ -3268,7 +3272,7 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
>  		goto out;
>  	}
>  
> -	if (!force && !should_alloc_chunk(space_info, alloc_bytes)) {
> +	if (!force && !should_alloc_chunk(fs_info, space_info, alloc_bytes)) {
>  		spin_unlock(&space_info->lock);
>  		goto out;
>  	}
> @@ -3317,7 +3321,8 @@ static int maybe_allocate_chunk(struct btrfs_trans_handle *trans,
>  		return 0;
>  
>  	spin_lock(&sinfo->lock);
> -	ret = should_alloc_chunk(sinfo, num_bytes + 2 * 1024 * 1024);
> +	ret = should_alloc_chunk(root->fs_info, sinfo,
> +				 num_bytes + 2 * 1024 * 1024);
>  	spin_unlock(&sinfo->lock);
>  	if (!ret)
>  		return 0;
> -- 
> 1.6.6.1
> 

Self-NAK on this one, it seems to cause a few problems with -m single and
smaller fs's, so just drop it.  It only creates too much overhead on really
small fs's anyway, and if you no likey that overhead, use mixed block groups :).
Thanks,

Josef
