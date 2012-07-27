Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54431 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab2G0Hw6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jul 2012 03:52:58 -0400
Received: from m1.gw.fujitsu.co.jp (unknown [10.0.50.71])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 49A913EE0B6
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Jul 2012 16:52:56 +0900 (JST)
Received: from smail (m1 [127.0.0.1])
	by outgoing.m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 2EEDB45DE55
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Jul 2012 16:52:56 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 0ED8445DE56
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Jul 2012 16:52:56 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id F3D0E1DB803A
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Jul 2012 16:52:55 +0900 (JST)
Received: from m1000.s.css.fujitsu.com (m1000.s.css.fujitsu.com [10.240.81.136])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 9F0B4E38001
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Jul 2012 16:52:55 +0900 (JST)
Message-ID: <501248B5.8010408@jp.fujitsu.com>
Date: Fri, 27 Jul 2012 16:52:21 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
MIME-Version: 1.0
To: miaox@cn.fujitsu.com
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] Btrfs: fix the snapshot that should not exist
References: <5010EA3E.4040009@cn.fujitsu.com>
In-Reply-To: <5010EA3E.4040009@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(2012/07/26 15:57), Miao Xie wrote:
> The snapshot should be the image of the fs tree before it was created,
> so the metadata of the snapshot should not exist in the its tree. But now, we
> found the directory item and directory name index is in both the snapshot tree
> and the fs tree. It introduces some problem and makes the users feel strange:
> 
>  # mkfs.btrfs /dev/sda1
>  # mount /dev/sda1 /mnt
>  # mkdir /mnt/1
>  # cd /mnt/1
>  # btrfs subvolume snapshot /mnt snap0
>  # ll /mnt/1
>  total 0
>  drwxr-xr-x 1 root root 10 Ju1 24 12:11 1
> 			^^^
>  # ll /mnt/1/snap0/
>  total 0
>  drwxr-xr-x 1 root root 10 Ju1 24 12:11 1
>                         ^^^
>                         It is also 10, but...
>  # ll /mnt/1/snap0/1
>  total 0
>  [None]
>  # cd /mnt/1/snap0/1/snap0
>  [Enter a unexisted directory successfully...]

I confirmed that "mkdir snap0" failed with "File exists" and
that rmdir can remove the directory snap0. So it is a kind of
"invisible" rather than "unexisted".

> 
> There is nothing in the directory 1 in snap0, but btrfs told the length of
> this directory is 10. Beside that, we can enter an unexisted directory, it is
> very strange to the users.
> 
>  # btrfs subvolume snapshot /mnt/1/snap0 /mnt/snap1
>  # ll /mnt/1/snap0/1/
>  total 0
>  [None]
>  # ll /mnt/snap1/1/
>  total 0
>  drwxr-xr-x 1 root root 0 Ju1 24 12:14 snap0
> 
> And the source of snap1 did have any directory in Directory 1, but snap1 have
> a snap0, it is different between the source and the snapshot.
> 
> So I think we should insert directory item and directory name index and update
> the parent inode as the last step of snapshot creation, and do not leave the
> useless metadata in the tree.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---

(snip)

> @@ -1062,17 +1068,33 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>  	ret = btrfs_reloc_post_snapshot(trans, pending);
>  	if (ret)
>  		goto abort_trans;
> +
> +	ret = btrfs_insert_dir_item(trans, parent_root,
> +				    dentry->d_name.name, dentry->d_name.len,
> +				    parent_inode, &key,
> +				    BTRFS_FT_DIR, index);
> +	/* We have check the name at the beginning, so it is impossible. */
> +	BUG_ON(ret == -EEXIST);
> +	if (ret)
> +		goto abort_trans;
> +
> +	btrfs_i_size_write(parent_inode, parent_inode->i_size +
> +					 dentry->d_name.len * 2);
> +	ret = btrfs_update_inode(trans, parent_root, parent_inode);
> +	if (ret)
> +		goto abort_trans;
>  fail:
>  	dput(parent);
>  	trans->block_rsv = rsv;
>  no_free_objectid:
>  	kfree(new_root_item);
>  root_item_alloc_fail:
> +	btrfs_free_path(path);
> +path_alloc_fail:
>  	btrfs_block_rsv_release(root, &pending->block_rsv, (u64)-1);
>  	return ret;
>  
>  abort_trans:
> -	dput(parent);

I think you can remove this line in your 1/2 patch.

>  	btrfs_abort_transaction(trans, root, ret);
>  	goto fail;
>  }
> @@ -1386,13 +1408,13 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>  	 */
>  	mutex_lock(&root->fs_info->reloc_mutex);
>  
> -	ret = btrfs_run_delayed_items(trans, root);
> +	ret = create_pending_snapshots(trans, root->fs_info);
>  	if (ret) {
>  		mutex_unlock(&root->fs_info->reloc_mutex);
>  		goto cleanup_transaction;
>  	}
>  
> -	ret = create_pending_snapshots(trans, root->fs_info);
> +	ret = btrfs_run_delayed_items(trans, root);
>  	if (ret) {
>  		mutex_unlock(&root->fs_info->reloc_mutex);
>  		goto cleanup_transaction;

It would be nice to have a patch description to tell why you
have to change the order here.

Thanks,
H.Seto

