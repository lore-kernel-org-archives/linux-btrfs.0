From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH v4 3/8] btrfs: Factor out enumeration of chunks to a separate
 function
Date: Thu, 07 Apr 2011 14:00:38 -0400
Message-ID: <4D9DFBC6.5010505@redhat.com>
References: <1302195975-3088-1-git-send-email-hugo@carfax.org.uk> <1302195975-3088-4-git-send-email-hugo@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: Hugo Mills <hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1302195975-3088-4-git-send-email-hugo@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/07/2011 01:06 PM, Hugo Mills wrote:
> The main balance function has two loops which are functionally
> identical in their looping mechanism, but which perform a different
> operation on the chunks they loop over. To avoid repeating code more
> than necessary, factor this loop out into a separate iterator function
> which takes a function parameter for the action to be performed.
>
> Signed-off-by: Hugo Mills<hugo@carfax.org.uk>
> ---
>   fs/btrfs/volumes.c |  179 +++++++++++++++++++++++++++++-----------------------
>   1 files changed, 99 insertions(+), 80 deletions(-)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 5378b94..ffba817 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2029,6 +2029,97 @@ static u64 div_factor(u64 num, int factor)
>   	return num;
>   }
>
> +/* Define a type, and two functions which can be used for the two
> + * phases of the balance operation: one for counting chunks, and one
> + * for actually moving them. */
> +typedef void (*balance_iterator_function)(struct btrfs_root *,
> +					  struct btrfs_balance_info *,
> +					  struct btrfs_path *,
> +					  struct btrfs_key *);
> +
> +void balance_count_chunks(struct btrfs_root *chunk_root,
> +			  struct btrfs_balance_info *bal_info,
> +			  struct btrfs_path *path,
> +			  struct btrfs_key *key)
> +{
> +	spin_lock(&chunk_root->fs_info->balance_info_lock);
> +	bal_info->expected++;
> +	spin_unlock(&chunk_root->fs_info->balance_info_lock);
> +}
> +
> +void balance_move_chunks(struct btrfs_root *chunk_root,
> +			 struct btrfs_balance_info *bal_info,
> +			 struct btrfs_path *path,
> +			 struct btrfs_key *key)
> +{
> +	int ret;
> +
> +	ret = btrfs_relocate_chunk(chunk_root,
> +				   chunk_root->root_key.objectid,
> +				   key->objectid,
> +				   key->offset);
> +	BUG_ON(ret&&  ret != -ENOSPC);
> +	spin_lock(&chunk_root->fs_info->balance_info_lock);
> +	bal_info->completed++;
> +	spin_unlock(&chunk_root->fs_info->balance_info_lock);
> +	printk(KERN_INFO "btrfs: balance: %llu/%llu block groups completed\n",
> +	       bal_info->completed, bal_info->expected);
> +}
> +
> +/* Iterate through all chunks, performing some function on each one. */
> +int balance_iterate_chunks(struct btrfs_root *chunk_root,
> +			   struct btrfs_balance_info *bal_info,
> +			   balance_iterator_function fn)
> +{
> +	int ret;
> +	struct btrfs_path *path;
> +	struct btrfs_key key;
> +	struct btrfs_key found_key;
> +
> +	path = btrfs_alloc_path();
> +	if (!path)
> +		return -ENOSPC;

Return ENOMEM, we're out of memory not space.

> +
> +	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
> +	key.offset = (u64)-1;
> +	key.type = BTRFS_CHUNK_ITEM_KEY;
> +
> +	while (!bal_info->cancel_pending) {
> +		ret = btrfs_search_slot(NULL, chunk_root,&key, path, 0, 0);
> +		if (ret<  0)
> +			break;
> +		/*
> +		 * this shouldn't happen, it means the last relocate
> +		 * failed
> +		 */
> +		if (ret == 0)
> +			break;
> +
> +		ret = btrfs_previous_item(chunk_root, path, 0,
> +					  BTRFS_CHUNK_ITEM_KEY);
> +		if (ret)
> +			break;
> +
> +		btrfs_item_key_to_cpu(path->nodes[0],&found_key,
> +				      path->slots[0]);
> +		if (found_key.objectid != key.objectid)
> +			break;
> +
> +		/* chunk zero is special */
> +		if (found_key.offset == 0)
> +			break;
> +
> +		/* Call the function to do the work for this chunk */
> +		btrfs_release_path(chunk_root, path);
> +		fn(chunk_root, bal_info, path,&found_key);
> +
> +		key.offset = found_key.offset - 1;
> +	}
> +
> +	btrfs_free_path(path);
> +	return ret;
> +}
> +
>   int btrfs_balance(struct btrfs_root *dev_root)
>   {
>   	int ret;
> @@ -2036,11 +2127,8 @@ int btrfs_balance(struct btrfs_root *dev_root)
>   	struct btrfs_device *device;
>   	u64 old_size;
>   	u64 size_to_free;
> -	struct btrfs_path *path;
> -	struct btrfs_key key;
>   	struct btrfs_root *chunk_root = dev_root->fs_info->chunk_root;
>   	struct btrfs_trans_handle *trans;
> -	struct btrfs_key found_key;
>   	struct btrfs_balance_info *bal_info;
>
>   	if (dev_root->fs_info->sb->s_flags&  MS_RDONLY)
> @@ -2061,8 +2149,7 @@ int btrfs_balance(struct btrfs_root *dev_root)
>   	}
>   	spin_lock(&dev_root->fs_info->balance_info_lock);
>   	dev_root->fs_info->balance_info = bal_info;
> -	bal_info->expected = -1; /* One less than actually counted,
> -				    because chunk 0 is special */
> +	bal_info->expected = 0;
>   	bal_info->completed = 0;
>   	bal_info->cancel_pending = 0;
>   	spin_unlock(&dev_root->fs_info->balance_info_lock);
> @@ -2091,91 +2178,23 @@ int btrfs_balance(struct btrfs_root *dev_root)
>   	}
>
>   	/* step two, count the chunks */
> -	path = btrfs_alloc_path();
> -	if (!path) {
> -		ret = -ENOSPC;
> -		goto error;
> -	}
> -
> -	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
> -	key.offset = (u64)-1;
> -	key.type = BTRFS_CHUNK_ITEM_KEY;
> -
> -	ret = btrfs_search_slot(NULL, chunk_root,&key, path, 0, 0);
> -	if (ret<= 0) {
> -		printk(KERN_ERR "btrfs: Failed to find the last chunk.\n");
> -		BUG();
> -	}
> -
> -	while (1) {
> -		ret = btrfs_previous_item(chunk_root, path, 0,
> -					  BTRFS_CHUNK_ITEM_KEY);
> -		if (ret)
> -			break;
> -
> -		spin_lock(&dev_root->fs_info->balance_info_lock);
> -		bal_info->expected++;
> -		spin_unlock(&dev_root->fs_info->balance_info_lock);
> -	}
> -
> -	btrfs_free_path(path);
> -	path = btrfs_alloc_path();
> -	if (!path) {
> -		ret = -ENOSPC;
> +	ret = balance_iterate_chunks(chunk_root, bal_info,
> +				     balance_count_chunks);
> +	if (ret)
>   		goto error;
> -	}
>
>   	/* step three, relocate all the chunks */
> -	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
> -	key.offset = (u64)-1;
> -	key.type = BTRFS_CHUNK_ITEM_KEY;
> -
> -	while (!bal_info->cancel_pending) {
> -		ret = btrfs_search_slot(NULL, chunk_root,&key, path, 0, 0);
> -		if (ret<  0)
> -			goto error;
> -
> -		/*
> -		 * this shouldn't happen, it means the last relocate
> -		 * failed
> -		 */
> -		if (ret == 0)
> -			break;
> -
> -		ret = btrfs_previous_item(chunk_root, path, 0,
> -					  BTRFS_CHUNK_ITEM_KEY);
> -		if (ret)
> -			break;
> -
> -		btrfs_item_key_to_cpu(path->nodes[0],&found_key,
> -				      path->slots[0]);
> -		if (found_key.objectid != key.objectid)
> -			break;
> -
> -		/* chunk zero is special */
> -		if (found_key.offset == 0)
> -			break;
> +	ret = balance_iterate_chunks(chunk_root, bal_info,
> +				     balance_move_chunks);
> +	if (ret)
> +		goto error;
>
> -		btrfs_release_path(chunk_root, path);
> -		ret = btrfs_relocate_chunk(chunk_root,
> -					   chunk_root->root_key.objectid,
> -					   found_key.objectid,
> -					   found_key.offset);
> -		BUG_ON(ret&&  ret != -ENOSPC);
> -		key.offset = found_key.offset - 1;
> -		spin_lock(&dev_root->fs_info->balance_info_lock);
> -		bal_info->completed++;
> -		spin_unlock(&dev_root->fs_info->balance_info_lock);
> -		printk(KERN_INFO "btrfs: balance: %llu/%llu block groups completed\n",
> -		       bal_info->completed, bal_info->expected);
> -	}
>   	ret = 0;
>   	if (bal_info->cancel_pending) {
>   		printk(KERN_INFO "btrfs: balance cancelled\n");
>   		ret = -EINTR;
>   	}
>   error:
> -	btrfs_free_path(path);
>   	spin_lock(&dev_root->fs_info->balance_info_lock);
>   	kfree(dev_root->fs_info->balance_info);
>   	dev_root->fs_info->balance_info = NULL;

