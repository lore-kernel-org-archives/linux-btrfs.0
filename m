Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41863 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932332AbbCDQFk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Mar 2015 11:05:40 -0500
Message-ID: <54F72D48.8070702@fb.com>
Date: Wed, 4 Mar 2015 11:05:28 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, Liu Bo <bo.li.liu@oracle.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix ASSERT(list_empty(&cur_trans->dirty_bgs_list)
References: <1425318415-322-1-git-send-email-jbacik@fb.com> <20150303110257.GA18292@localhost.localdomain> <20150303163533.GE11093@twin.jikos.cz>
In-Reply-To: <20150303163533.GE11093@twin.jikos.cz>
Content-Type: multipart/mixed;
	boundary="------------040504090505090303050401"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--------------040504090505090303050401
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit

On 03/03/2015 11:35 AM, David Sterba wrote:
> On Tue, Mar 03, 2015 at 07:02:58PM +0800, Liu Bo wrote:
>> On Mon, Mar 02, 2015 at 12:46:55PM -0500, Josef Bacik wrote:
>>> Dave could hit this assert consistently running btrfs/078.  This is because
>>> when we update the block groups we could truncate the free space, which would
>>> try to delete the csums for that range and dirty the csum root.  For this to
>>> happen we have to have already written out the csum root so it's kind of hard to
>>> hit this case.  This patch fixes this by changing the logic to only write the
>>> dirty block groups if the dirty_cowonly_roots list is empty.  This will get us
>>> the same effect as before since we add the extent root last, and will cover the
>>> case that we dirty some other root again but not the extent root.  Thanks,
>>
>> Free space inode is NODATASUM, so its searching csum tree in
>> __btrfs_free_extent() is really unnecessary, by skipping that, csum tree
>> won't be inserted into dirty_cowonly_roots list again, so it also passed btrfs/078,
>> at least on my box.
>
> I can hit the bug [1] even with Josef's patch, I'm can test your fix if you
> want.
>
> MKFS_OPTIONS  -- -O skinny-metadata,extref -m single -d single --mixed /dev/sdc1
> MOUNT_OPTIONS -- -o enospc_debug,space_cache,noatime /dev/sdc1 /mnt/a2
>
> on top of 3.19-rc5 with Chris' for-linus.
>

Can you try this on top of this patch and send me the logs?  Thanks,

Josef


--------------040504090505090303050401
Content-Type: text/plain; charset="UTF-8"; name="out.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="out.txt"

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 9936421..a54f9b5 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -219,6 +219,7 @@ static void add_root_to_dirty_list(struct btrfs_root *root)
 
 	spin_lock(&root->fs_info->trans_lock);
 	if (!test_and_set_bit(BTRFS_ROOT_DIRTY, &root->state)) {
+		printk(KERN_ERR "dirtying root %llu\n", root->objectid);
 		/* Want the extent tree to be the last on the list */
 		if (root->objectid == BTRFS_EXTENT_TREE_OBJECTID)
 			list_move_tail(&root->dirty_list,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b7f0502..2488a35 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5369,6 +5369,8 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 
 		spin_lock(&trans->transaction->dirty_bgs_lock);
 		if (list_empty(&cache->dirty_list)) {
+			printk(KERN_ERR "dirtying bg %llu\n",
+			       cache->key.objectid);
 			list_add_tail(&cache->dirty_list,
 				      &trans->transaction->dirty_bgs);
 			btrfs_get_block_group(cache);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index e1a96af..ec50d17 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1027,6 +1027,10 @@ static int update_cowonly_root(struct btrfs_trans_handle *trans,
 
 	old_root_used = btrfs_root_used(&root->root_item);
 
+	printk(KERN_ERR "writing root %llu, dirty cowonly roots empty %d, "
+	       "dirty bgs empty %d\n", root->objectid,
+	       list_empty(&fs_info->dirty_cowonly_roots),
+	       list_empty(&trans->transaction->dirty_bgs));
 	while (1) {
 		old_root_bytenr = btrfs_root_bytenr(&root->root_item);
 
@@ -1050,6 +1054,7 @@ static int update_cowonly_root(struct btrfs_trans_handle *trans,
 
 		old_root_used = btrfs_root_used(&root->root_item);
 		if (list_empty(&fs_info->dirty_cowonly_roots)) {
+			printk(KERN_ERR "writing dirty block groups\n");
 			ret = btrfs_write_dirty_block_groups(trans, root);
 			if (ret)
 				return ret;
@@ -1123,6 +1128,7 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans,
 			return ret;
 	}
 
+	printk(KERN_ERR "done writy dirty cowonly roots\n");
 	list_add_tail(&fs_info->extent_root->dirty_list,
 		      &trans->transaction->switch_commits);
 	btrfs_after_dev_replace_commit(fs_info);
@@ -2000,6 +2006,14 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	switch_commit_roots(cur_trans, root->fs_info);
 
 	assert_qgroups_uptodate(trans);
+	if (!list_empty(&cur_trans->dirty_bgs)) {
+		struct btrfs_block_group_cache *cache;
+
+		cache = list_first_entry(&cur_trans->dirty_bgs,
+					 struct btrfs_block_group_cache,
+					 bg_list);
+		printk(KERN_ERR "bg %llu still dirty\n", cache->key.objectid);
+	}
 	ASSERT(list_empty(&cur_trans->dirty_bgs));
 	update_super_roots(root);
 

--------------040504090505090303050401--
