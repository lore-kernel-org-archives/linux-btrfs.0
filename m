Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:16639 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752177Ab2G3KCb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Jul 2012 06:02:31 -0400
Message-ID: <50165B85.5020100@cn.fujitsu.com>
Date: Mon, 30 Jul 2012 18:01:41 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] Btrfs: fix the snapshot that should not exist
References: <5010EA3E.4040009@cn.fujitsu.com> <501248B5.8010408@jp.fujitsu.com>
In-Reply-To: <501248B5.8010408@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On fri, 27 Jul 2012 16:52:21 +0900, Hidetoshi Seto wrote:
>>  # ll /mnt/1/snap0/1
>>  total 0
>>  [None]
>>  # cd /mnt/1/snap0/1/snap0
>>  [Enter a unexisted directory successfully...]
> 
> I confirmed that "mkdir snap0" failed with "File exists" and
> that rmdir can remove the directory snap0. So it is a kind of
> "invisible" rather than "unexisted".

I think it is not like the typically invisible directories on linux, and in the users'
view, this directory should not exist, in other words, it is a unexisted directory to
the users, so I use "unexisted".

> (snip)
> 
>> @@ -1062,17 +1068,33 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>>  	ret = btrfs_reloc_post_snapshot(trans, pending);
>>  	if (ret)
>>  		goto abort_trans;
>> +
>> +	ret = btrfs_insert_dir_item(trans, parent_root,
>> +				    dentry->d_name.name, dentry->d_name.len,
>> +				    parent_inode, &key,
>> +				    BTRFS_FT_DIR, index);
>> +	/* We have check the name at the beginning, so it is impossible. */
>> +	BUG_ON(ret == -EEXIST);
>> +	if (ret)
>> +		goto abort_trans;
>> +
>> +	btrfs_i_size_write(parent_inode, parent_inode->i_size +
>> +					 dentry->d_name.len * 2);
>> +	ret = btrfs_update_inode(trans, parent_root, parent_inode);
>> +	if (ret)
>> +		goto abort_trans;
>>  fail:
>>  	dput(parent);
>>  	trans->block_rsv = rsv;
>>  no_free_objectid:
>>  	kfree(new_root_item);
>>  root_item_alloc_fail:
>> +	btrfs_free_path(path);
>> +path_alloc_fail:
>>  	btrfs_block_rsv_release(root, &pending->block_rsv, (u64)-1);
>>  	return ret;
>>  
>>  abort_trans:
>> -	dput(parent);
> 
> I think you can remove this line in your 1/2 patch.

Yes. will be modified in the next version of the patches.

> 
>>  	btrfs_abort_transaction(trans, root, ret);
>>  	goto fail;
>>  }
>> @@ -1386,13 +1408,13 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>>  	 */
>>  	mutex_lock(&root->fs_info->reloc_mutex);
>>  
>> -	ret = btrfs_run_delayed_items(trans, root);
>> +	ret = create_pending_snapshots(trans, root->fs_info);
>>  	if (ret) {
>>  		mutex_unlock(&root->fs_info->reloc_mutex);
>>  		goto cleanup_transaction;
>>  	}
>>  
>> -	ret = create_pending_snapshots(trans, root->fs_info);
>> +	ret = btrfs_run_delayed_items(trans, root);
>>  	if (ret) {
>>  		mutex_unlock(&root->fs_info->reloc_mutex);
>>  		goto cleanup_transaction;
> 
> It would be nice to have a patch description to tell why you
> have to change the order here.

OK, I will add comment in the next version of the patches.

Thanks for your review.

Miao
