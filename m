Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:17293 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753254Ab3G3DI0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Jul 2013 23:08:26 -0400
Message-ID: <51F72E65.4000002@cn.fujitsu.com>
Date: Tue, 30 Jul 2013 11:09:25 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Filipe David Borba Manana <fdmanana@gmail.com>
CC: linux-btrfs@vger.kernel.org, jbacik@fusionio.com
Subject: Re: [PATCH v2] Btrfs: optimize function btrfs_read_chunk_tree
References: <1372853956-10569-1-git-send-email-fdmanana@gmail.com> <1375122154-5177-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1375122154-5177-1-git-send-email-fdmanana@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On mon, 29 Jul 2013 19:22:34 +0100, Filipe David Borba Manana wrote:
> After reading all device items from the chunk tree, don't
> exit the loop and then navigate down the tree again to find
> the chunk items. Instead just read all device items and
> chunk items with a single tree search. This is possible
> because all device items are found before any chunk item in
> the chunks tree.
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
> 
> V2: Simplified logic inside the loop
>     (suggested by Josef Bacik on irc).
> 
>  fs/btrfs/volumes.c |   30 ++++++++++--------------------
>  1 file changed, 10 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 090f57c..45c5ec3 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -5676,14 +5676,13 @@ int btrfs_read_chunk_tree(struct btrfs_root *root)
>  	mutex_lock(&uuid_mutex);
>  	lock_chunks(root);
>  
> -	/* first we search for all of the device items, and then we
> -	 * read in all of the chunk items.  This way we can create chunk
> -	 * mappings that reference all of the devices that are afound
> -	 */
> +	/* Read all device items, and then all the chunk items. All
> +	   device items are found before any chunk item (their object id
> +	   is smaller than the lowest possible object id for a chunk
> +	   item - BTRFS_FIRST_CHUNK_TREE_OBJECTID). */

According to the coding style of the kernel(Documentation/CodingStyle),
the preferred style for long (multi-line) comments is:

	/*
	 * This is the preferred style for multi-line
	 * comments in the Linux kernel source code.
	 *
	 * Description:  A column of asterisks on the left side,
	 * with beginning and ending almost-blank lines.
	 */

The other code is OK.

Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>

>  	key.objectid = BTRFS_DEV_ITEMS_OBJECTID;
>  	key.offset = 0;
>  	key.type = 0;
> -again:
>  	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
>  	if (ret < 0)
>  		goto error;
> @@ -5699,17 +5698,13 @@ again:
>  			break;
>  		}
>  		btrfs_item_key_to_cpu(leaf, &found_key, slot);
> -		if (key.objectid == BTRFS_DEV_ITEMS_OBJECTID) {
> -			if (found_key.objectid != BTRFS_DEV_ITEMS_OBJECTID)
> -				break;
> -			if (found_key.type == BTRFS_DEV_ITEM_KEY) {
> -				struct btrfs_dev_item *dev_item;
> -				dev_item = btrfs_item_ptr(leaf, slot,
> +		if (found_key.type == BTRFS_DEV_ITEM_KEY) {
> +			struct btrfs_dev_item *dev_item;
> +			dev_item = btrfs_item_ptr(leaf, slot,
>  						  struct btrfs_dev_item);
> -				ret = read_one_dev(root, leaf, dev_item);
> -				if (ret)
> -					goto error;
> -			}
> +			ret = read_one_dev(root, leaf, dev_item);
> +			if (ret)
> +				goto error;
>  		} else if (found_key.type == BTRFS_CHUNK_ITEM_KEY) {
>  			struct btrfs_chunk *chunk;
>  			chunk = btrfs_item_ptr(leaf, slot, struct btrfs_chunk);
> @@ -5719,11 +5714,6 @@ again:
>  		}
>  		path->slots[0]++;
>  	}
> -	if (key.objectid == BTRFS_DEV_ITEMS_OBJECTID) {
> -		key.objectid = 0;
> -		btrfs_release_path(path);
> -		goto again;
> -	}
>  	ret = 0;
>  error:
>  	unlock_chunks(root);
> 

