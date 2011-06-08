From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH v2] btrfs: scrub: errors in tree enumeration
Date: Wed, 08 Jun 2011 09:48:35 -0400
Message-ID: <4DEF7DB3.2090902@redhat.com>
References: <1307522322-20381-1-git-send-email-sensille@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1307522322-20381-1-git-send-email-sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/08/2011 04:38 AM, Arne Jansen wrote:
> due to the semantics of btrfs_search_slot the path can point to an
> invalid slot when ret > 0. This condition went unnoticed, which in
> turn could have led to an incomplete scrubbing.
> 
> Signed-off-by: Arne Jansen <sensille@gmx.net>
> ---
> 
> Change in v2:
> fix return value of scrub_enumerate_chunks
> 
> ---
>  fs/btrfs/scrub.c |   29 ++++++++++++++++++-----------
>  1 files changed, 18 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index df50fd1..c4f3a2b 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -906,11 +906,7 @@ again:
>  		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
>  		if (ret < 0)
>  			goto out;
> -
> -		l = path->nodes[0];
> -		slot = path->slots[0];
> -		btrfs_item_key_to_cpu(l, &key, slot);
> -		if (key.objectid != logical) {
> +		if (ret > 0) {
>  			ret = btrfs_previous_item(root, path, 0,
>  						  BTRFS_EXTENT_ITEM_KEY);

Looks like you have the same problem here since btrfs_previous_item can
point to some random slot that's not correct either.

>  			if (ret < 0)
> @@ -1064,8 +1060,15 @@ int scrub_enumerate_chunks(struct scrub_dev *sdev, u64 start, u64 end)
>  	while (1) {
>  		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
>  		if (ret < 0)
> -			goto out;
> -		ret = 0;
> +			break;
> +		if (ret > 0) {
> +			if (path->slots[0] >=
> +			    btrfs_header_nritems(path->nodes[0])) {
> +				ret = btrfs_next_leaf(root, path);
> +				if (ret)
> +					break;
> +			}
> +		}
>  
>  		l = path->nodes[0];
>  		slot = path->slots[0];
> @@ -1075,7 +1078,7 @@ int scrub_enumerate_chunks(struct scrub_dev *sdev, u64 start, u64 end)
>  		if (found_key.objectid != sdev->dev->devid)
>  			break;
>  
> -		if (btrfs_key_type(&key) != BTRFS_DEV_EXTENT_KEY)
> +		if (btrfs_key_type(&found_key) != BTRFS_DEV_EXTENT_KEY)
>  			break;
>  
>  		if (found_key.offset >= end)
> @@ -1104,7 +1107,7 @@ int scrub_enumerate_chunks(struct scrub_dev *sdev, u64 start, u64 end)
>  		cache = btrfs_lookup_block_group(fs_info, chunk_offset);
>  		if (!cache) {
>  			ret = -ENOENT;
> -			goto out;
> +			break;
>  		}
>  		ret = scrub_chunk(sdev, chunk_tree, chunk_objectid,
>  				  chunk_offset, length);
> @@ -1116,9 +1119,13 @@ int scrub_enumerate_chunks(struct scrub_dev *sdev, u64 start, u64 end)
>  		btrfs_release_path(path);
>  	}
>  
> -out:
>  	btrfs_free_path(path);
> -	return ret;
> +
> +	/*
> +	 * ret can still be 1 from search_slot or next_leaf,
> +	 * that's not an error
> +	 */
> +	return ret < 0 ? ret : 0;

Why not just set ret to 0 if you have to do a btrfs_next_leaf?  Thanks,

Josef
