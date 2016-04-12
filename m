Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:51870 "EHLO
	mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbcDLAPi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Apr 2016 20:15:38 -0400
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 55AA6AC01B7
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Apr 2016 09:15:33 +0900 (JST)
Subject: Re: [PATCH 1/2] btrfs: use dynamic allocation for root item in
 create_subvol
To: David Sterba <dsterba@suse.com>
References: <cover.1460397148.git.dsterba@suse.com>
 <7d013acc6e07b39bd224f9c0097775c0a8e138df.1460397148.git.dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Message-ID: <570C3E09.6070001@jp.fujitsu.com>
Date: Tue, 12 Apr 2016 09:15:05 +0900
MIME-Version: 1.0
In-Reply-To: <7d013acc6e07b39bd224f9c0097775c0a8e138df.1460397148.git.dsterba@suse.com>
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016/04/12 3:04, David Sterba wrote:
> The size of root item is more than 400 bytes, which is quite a lot of
> stack space. As we do IO from inside the subvolume ioctls, we should
> keep the stack usage low in case the filesystem is on top of other
> layers (NFS, device mapper, iscsi, etc).
> 
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>   fs/btrfs/ioctl.c | 49 ++++++++++++++++++++++++++-----------------------
>   1 file changed, 26 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 053e677839fe..0be13b9c53d9 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -439,7 +439,7 @@ static noinline int create_subvol(struct inode *dir,
>   {
>   	struct btrfs_trans_handle *trans;
>   	struct btrfs_key key;
> -	struct btrfs_root_item root_item;
> +	struct btrfs_root_item *root_item;
>   	struct btrfs_inode_item *inode_item;
>   	struct extent_buffer *leaf;
>   	struct btrfs_root *root = BTRFS_I(dir)->root;
> @@ -455,6 +455,10 @@ static noinline int create_subvol(struct inode *dir,
>   	u64 qgroup_reserved;
>   	uuid_le new_uuid;
>   
> +	root_item = kzalloc(sizeof(*root_item), GFP_KERNEL);
> +	if (!root_item)
> +		return -ENOMEM;
> +
>   	ret = btrfs_find_free_objectid(root->fs_info->tree_root, &objectid);
>   	if (ret)
>   		return ret;

'kfree(root_item)' is necessary here and other 'return'.

Thanks,
Tsutomu

> @@ -509,47 +513,45 @@ static noinline int create_subvol(struct inode *dir,
>   			    BTRFS_UUID_SIZE);
>   	btrfs_mark_buffer_dirty(leaf);
>   
> -	memset(&root_item, 0, sizeof(root_item));
> -
> -	inode_item = &root_item.inode;
> +	inode_item = &root_item->inode;
>   	btrfs_set_stack_inode_generation(inode_item, 1);
>   	btrfs_set_stack_inode_size(inode_item, 3);
>   	btrfs_set_stack_inode_nlink(inode_item, 1);
>   	btrfs_set_stack_inode_nbytes(inode_item, root->nodesize);
>   	btrfs_set_stack_inode_mode(inode_item, S_IFDIR | 0755);
>   
> -	btrfs_set_root_flags(&root_item, 0);
> -	btrfs_set_root_limit(&root_item, 0);
> +	btrfs_set_root_flags(root_item, 0);
> +	btrfs_set_root_limit(root_item, 0);
>   	btrfs_set_stack_inode_flags(inode_item, BTRFS_INODE_ROOT_ITEM_INIT);
>   
> -	btrfs_set_root_bytenr(&root_item, leaf->start);
> -	btrfs_set_root_generation(&root_item, trans->transid);
> -	btrfs_set_root_level(&root_item, 0);
> -	btrfs_set_root_refs(&root_item, 1);
> -	btrfs_set_root_used(&root_item, leaf->len);
> -	btrfs_set_root_last_snapshot(&root_item, 0);
> +	btrfs_set_root_bytenr(root_item, leaf->start);
> +	btrfs_set_root_generation(root_item, trans->transid);
> +	btrfs_set_root_level(root_item, 0);
> +	btrfs_set_root_refs(root_item, 1);
> +	btrfs_set_root_used(root_item, leaf->len);
> +	btrfs_set_root_last_snapshot(root_item, 0);
>   
> -	btrfs_set_root_generation_v2(&root_item,
> -			btrfs_root_generation(&root_item));
> +	btrfs_set_root_generation_v2(root_item,
> +			btrfs_root_generation(root_item));
>   	uuid_le_gen(&new_uuid);
> -	memcpy(root_item.uuid, new_uuid.b, BTRFS_UUID_SIZE);
> -	btrfs_set_stack_timespec_sec(&root_item.otime, cur_time.tv_sec);
> -	btrfs_set_stack_timespec_nsec(&root_item.otime, cur_time.tv_nsec);
> -	root_item.ctime = root_item.otime;
> -	btrfs_set_root_ctransid(&root_item, trans->transid);
> -	btrfs_set_root_otransid(&root_item, trans->transid);
> +	memcpy(root_item->uuid, new_uuid.b, BTRFS_UUID_SIZE);
> +	btrfs_set_stack_timespec_sec(&root_item->otime, cur_time.tv_sec);
> +	btrfs_set_stack_timespec_nsec(&root_item->otime, cur_time.tv_nsec);
> +	root_item->ctime = root_item->otime;
> +	btrfs_set_root_ctransid(root_item, trans->transid);
> +	btrfs_set_root_otransid(root_item, trans->transid);
>   
>   	btrfs_tree_unlock(leaf);
>   	free_extent_buffer(leaf);
>   	leaf = NULL;
>   
> -	btrfs_set_root_dirid(&root_item, new_dirid);
> +	btrfs_set_root_dirid(root_item, new_dirid);
>   
>   	key.objectid = objectid;
>   	key.offset = 0;
>   	key.type = BTRFS_ROOT_ITEM_KEY;
>   	ret = btrfs_insert_root(trans, root->fs_info->tree_root, &key,
> -				&root_item);
> +				root_item);
>   	if (ret)
>   		goto fail;
>   
> @@ -601,12 +603,13 @@ static noinline int create_subvol(struct inode *dir,
>   	BUG_ON(ret);
>   
>   	ret = btrfs_uuid_tree_add(trans, root->fs_info->uuid_root,
> -				  root_item.uuid, BTRFS_UUID_KEY_SUBVOL,
> +				  root_item->uuid, BTRFS_UUID_KEY_SUBVOL,
>   				  objectid);
>   	if (ret)
>   		btrfs_abort_transaction(trans, root, ret);
>   
>   fail:
> +	kfree(root_item);
>   	trans->block_rsv = NULL;
>   	trans->bytes_reserved = 0;
>   	btrfs_subvolume_release_metadata(root, &block_rsv, qgroup_reserved);
> 

