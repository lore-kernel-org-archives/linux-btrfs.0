From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH 1/9] Btrfs: introduce sub transaction stuff
Date: Wed, 25 May 2011 06:21:04 -0400
Message-ID: <4DDCD810.7090904@cn.fujitsu.com>
References: <1305792692-10635-1-git-send-email-liubo2009@cn.fujitsu.com> <1305792692-10635-2-git-send-email-liubo2009@cn.fujitsu.com> <1305850961-sup-454@shiny> <1306161195-sup-8189@shiny> <4DDC7E08.4020207@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, josef <josef@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DDC7E08.4020207@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/24/2011 11:56 PM, liubo wrote:
>> > The problems I hit:
>> > 
>> > When an inode is dropped from cache (just via iput) and then read in
>> > again, the BTRFS_I(inode)->logged_trans goes back to zero.  When this
>> > happens the logging code assumes the inode isn't in the log and hits
>> > -EEXIST if it finds inode items.
>> > 
> 
> ok, I just find where the problem addresses.  This is because I've put
> a check between logged_trans and transaction_id, which is inclined to
> filter those that are first logged, and I'm sorry for not taking the
> 'iput' stuff into consideration.  And it's easy to fix this, as we
> can just kick this check off and put another check while searching
> 'BTRFS_INODE_ITEM_KEY', since if we cannot find a inode item in a tree,
> it proves that this inode is definitely not in the tree.
> 
> So I'd like to make some changes like this patch(_UNTEST_):

I've thought of this problem more and came up with a _better and more efficient_ patch.
It will always get BTRFS_I(inode)->logged_trans correct value.

But I'm still trying to test it somehow... :P

Here it is:

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 40f6f8f..d22b3bf 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1769,12 +1769,9 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 	add_pending_csums(trans, inode, ordered_extent->file_offset,
 			  &ordered_extent->list);
 
-	ret = btrfs_ordered_update_i_size(inode, 0, ordered_extent);
-	if (!ret) {
-		ret = btrfs_update_inode(trans, root, inode);
-		BUG_ON(ret);
-	} else
-		btrfs_set_inode_last_trans(trans, inode);
+	btrfs_ordered_update_i_size(inode, 0, ordered_extent);
+	ret = btrfs_update_inode(trans, root, inode);
+	BUG_ON(ret);
 	ret = 0;
 out:
 	if (nolock) {
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 912397c..92fe5dd 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3032,6 +3032,37 @@ out:
 	return ret;
 }
 
+static int check_logged_trans(struct btrfs_trans_handle *trans,
+			      struct btrfs_root *root, struct inode *inode)
+{
+	struct btrfs_inode_item *inode_item;
+	struct btrfs_path *path;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	ret = btrfs_search_slot(trans, root,
+				&BTRFS_I(inode)->location, path, 0, 0);
+	if (ret) {
+		if (ret > 0)
+			ret = 0;
+		goto out;
+	}
+
+	btrfs_unlock_up_safe(path, 1);
+	inode_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
+				    struct btrfs_inode_item);
+
+	BTRFS_I(inode)->logged_trans = btrfs_inode_transid(path->nodes[0],
+							   inode_item);
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
+
 static int inode_in_log(struct btrfs_trans_handle *trans,
 		 struct inode *inode)
 {
@@ -3084,6 +3115,18 @@ int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto end_no_trans;
 
+	/*
+	 * After we iput a inode and reread it from disk, logged_trans is 0.
+	 * However, this inode _may_ still remain in log tree and not be
+	 * committed yet.
+	 * So we need to check the log tree to get logged_trans a right value.
+	 */
+	if (!BTRFS_I(inode)->logged_trans && root->log_root) {
+		ret = check_logged_trans(trans, root->log_root, inode);
+		if (ret)
+			goto end_no_trans;
+	}
+
 	if (inode_in_log(trans, inode)) {
 		ret = BTRFS_NO_LOG_SYNC;
 		goto end_no_trans;


thanks,
liubo
