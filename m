Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:43402 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab3IFIhC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Sep 2013 04:37:02 -0400
Message-ID: <52299420.4070702@giantdisaster.de>
Date: Fri, 06 Sep 2013 10:36:48 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: miaox@cn.fujitsu.com
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: eliminate the exceptional root_tree refs=0
References: <6864a70d966df33d27a523d944e14f23b6594b7d.1378389401.git.sbehrens@giantdisaster.de> <52294720.8050906@cn.fujitsu.com>
In-Reply-To: <52294720.8050906@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 06 Sep 2013 11:08:16 +0800, Miao Xie wrote:
> On 	thu, 5 Sep 2013 16:58:43 +0200, Stefan Behrens wrote:
>> The fact that btrfs_root_refs() returned 0 for the tree_root caused
>> bugs in the past, therefore it is set to 1 with this patch and
>> (hopefully) all affected code is adapted to this change.
>>
>> I verified this change by temporarily adding WARN_ON() checks
>> everywhere where btrfs_root_refs() is used, checking whether the
>> logic of the code is changed by btrfs_root_refs() returning 1
>> instead of 0 for root->root_key.objectid == BTRFS_ROOT_TREE_OBJECTID.
>> With these added checks, I ran the xfstests './check -g auto'.
>>
>> The two roots chunk_root and log_root_tree that are only referenced
>> by the superblock and the log_roots below the log_root_tree still
>> have btrfs_root_refs() == 0, only the tree_root is changed.
>>
>> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
>> ---
>>  fs/btrfs/disk-io.c   |  1 +
>>  fs/btrfs/inode-map.c |  3 +--
>>  fs/btrfs/inode.c     | 21 ++++++++-------------
>>  3 files changed, 10 insertions(+), 15 deletions(-)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index fa8b2c6..ffc3e43 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -2667,6 +2667,7 @@ retry_root_backup:
>>  
>>  	btrfs_set_root_node(&tree_root->root_item, tree_root->node);
>>  	tree_root->commit_root = btrfs_root_node(tree_root);
>> +	btrfs_set_root_refs(&tree_root->root_item, 1);
>>  
>>  	location.objectid = BTRFS_EXTENT_TREE_OBJECTID;
>>  	location.type = BTRFS_ROOT_ITEM_KEY;
>> diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
>> index 2c66ddb..d11e1c6 100644
>> --- a/fs/btrfs/inode-map.c
>> +++ b/fs/btrfs/inode-map.c
>> @@ -412,8 +412,7 @@ int btrfs_save_ino_cache(struct btrfs_root *root,
>>  		return 0;
>>  
>>  	/* Don't save inode cache if we are deleting this root */
>> -	if (btrfs_root_refs(&root->root_item) == 0 &&
>> -	    root != root->fs_info->tree_root)
>> +	if (btrfs_root_refs(&root->root_item) == 0)
>>  		return 0;
>>  
>>  	if (!btrfs_test_opt(root, INODE_MAP_CACHE))
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index 26992ee..7d0ef55 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -4472,8 +4472,10 @@ void btrfs_evict_inode(struct inode *inode)
>>  	trace_btrfs_inode_evict(inode);
>>  
>>  	truncate_inode_pages(&inode->i_data, 0);
>> -	if (inode->i_nlink && (btrfs_root_refs(&root->root_item) != 0 ||
>> -			       btrfs_is_free_space_inode(inode)))
>> +	if (inode->i_nlink &&
>> +	    ((btrfs_root_refs(&root->root_item) != 0 &&
>> +	      root->root_key.objectid != BTRFS_ROOT_TREE_OBJECTID) ||
>> +	     btrfs_is_free_space_inode(inode)))
> 
> if (inode->i_nlink && btrfs_root_refs(&root->root_item)) {
> }
> 
> is OK, because with this patch, the refs of the free space inodes' root(tree root)
> should be 1. For the ino cache inodes' root(fs/file root), if the root is dead,
> we can drop the ino cache inode safely. And if the root is not dead, the refs
> should be > 0, we will skip the drop.

Thank you for your comments!

It needs to be like this or it doesn't work. The code that you propose
changes the logic when close_ctree() calls iput(fs_info->btree_inode).
The if-condition in btrfs_evict_inode() used to be false for
fs_info->btree_inode before this patch and would become true. And the
system locks up in the middle of a './check -g auto' run with page cache
issues and I have also seen the OOM killer killing the entire test box.

But maybe you can propose how to make this if-statement more explicit
and readable, maybe by explicitly checking for inode ==
fs_info->btree_inode?


>>  		goto no_delete;
>>  
>>  	if (is_bad_inode(inode)) {
>> @@ -4490,7 +4492,8 @@ void btrfs_evict_inode(struct inode *inode)
>>  	}
>>  
>>  	if (inode->i_nlink > 0) {
>> -		BUG_ON(btrfs_root_refs(&root->root_item) != 0);
>> +		BUG_ON(btrfs_root_refs(&root->root_item) != 0 &&
>> +		       root->root_key.objectid != BTRFS_ROOT_TREE_OBJECTID);
> 
> This change is unnecessary because the refs of the root tree is 1 now.

Because of the thing above, this is needed.


> 
>>  		goto no_delete;
>>  	}
>>  
>> @@ -4731,14 +4734,7 @@ static void inode_tree_del(struct inode *inode)
>>  	}
>>  	spin_unlock(&root->inode_lock);
>>  
>> -	/*
>> -	 * Free space cache has inodes in the tree root, but the tree root has a
>> -	 * root_refs of 0, so this could end up dropping the tree root as a
>> -	 * snapshot, so we need the extra !root->fs_info->tree_root check to
>> -	 * make sure we don't drop it.
>> -	 */
>> -	if (empty && btrfs_root_refs(&root->root_item) == 0 &&
>> -	    root != root->fs_info->tree_root) {
>> +	if (empty && btrfs_root_refs(&root->root_item) == 0) {
>>  		synchronize_srcu(&root->fs_info->subvol_srcu);
>>  		spin_lock(&root->inode_lock);
>>  		empty = RB_EMPTY_ROOT(&root->inode_tree);
>> @@ -7872,8 +7868,7 @@ int btrfs_drop_inode(struct inode *inode)
>>  		return 1;
>>  
>>  	/* the snap/subvol tree is on deleting */
>> -	if (btrfs_root_refs(&root->root_item) == 0 &&
>> -	    root != root->fs_info->tree_root)
>> +	if (btrfs_root_refs(&root->root_item) == 0)
>>  		return 1;
>>  	else
>>  		return generic_drop_inode(inode);
> 
> The others is OK.

