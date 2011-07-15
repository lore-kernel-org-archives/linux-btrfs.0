From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: Re: [PATCH 6/7] btrfs: Don't BUG_ON alloc_path errors in find_next_chunk
Date: Fri, 15 Jul 2011 11:43:52 +0900
Message-ID: <4E1FA968.1070703@jp.fujitsu.com>
References: <1310681702-13922-1-git-send-email-mfasheh@suse.com> <1310681702-13922-2-git-send-email-mfasheh@suse.com> <1310681702-13922-3-git-send-email-mfasheh@suse.com> <1310681702-13922-4-git-send-email-mfasheh@suse.com> <1310681702-13922-5-git-send-email-mfasheh@suse.com> <1310681702-13922-6-git-send-email-mfasheh@suse.com> <1310681702-13922-7-git-send-email-mfasheh@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: Mark Fasheh <mfasheh@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1310681702-13922-7-git-send-email-mfasheh@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

(2011/07/15 7:15), Mark Fasheh wrote:
> I also removed the BUG_ON from error return of find_next_chunk in
> init_first_rw_device(). It turns out that the only caller of
> init_first_rw_device() also BUGS on any nonzero return so no actual behavior
> change has occurred here.
> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.com>
> ---
>  fs/btrfs/volumes.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 530a2fc..90d956c 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1037,7 +1037,8 @@ static noinline int find_next_chunk(struct btrfs_root *root,
>  	struct btrfs_key found_key;
>  
>  	path = btrfs_alloc_path();
> -	BUG_ON(!path);
> +	if (!path)
> +		return -ENOMEM;

If find_next_chunk() returns -ENOMEM, space_info->full becomes 1 by following code.

3205 static int do_chunk_alloc(struct btrfs_trans_handle *trans,
3206                           struct btrfs_root *extent_root, u64 alloc_bytes,
3207                           u64 flags, int force)
3208 {
...
3277         ret = btrfs_alloc_chunk(trans, extent_root, flags);
3278         spin_lock(&space_info->lock);
3279         if (ret)
3280                 space_info->full = 1;
3281         else
3282                 ret = 1;

Is it OK?

Thanks,
Tsutomu

>  
>  	key.objectid = objectid;
>  	key.offset = (u64)-1;
> @@ -2663,7 +2664,8 @@ static noinline int init_first_rw_device(struct btrfs_trans_handle *trans,
>  
>  	ret = find_next_chunk(fs_info->chunk_root,
>  			      BTRFS_FIRST_CHUNK_TREE_OBJECTID, &chunk_offset);
> -	BUG_ON(ret);
> +	if (ret)
> +		return ret;
>  
>  	alloc_profile = BTRFS_BLOCK_GROUP_METADATA |
>  			(fs_info->metadata_alloc_profile &


