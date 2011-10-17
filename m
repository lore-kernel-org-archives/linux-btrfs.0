From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH 11/12 v5] Btrfs: do not iput inode when inode is still
 in log
Date: Mon, 17 Oct 2011 13:22:54 +0800
Message-ID: <4E9BBBAE.3040503@cn.fujitsu.com>
References: <1312623467-31487-1-git-send-email-liubo2009@cn.fujitsu.com> <1312623467-31487-12-git-send-email-liubo2009@cn.fujitsu.com> <1318811223-sup-6400@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1318811223-sup-6400@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On 10/17/2011 08:30 AM, Chris Mason wrote:
> Excerpts from Liu Bo's message of 2011-08-06 05:37:46 -0400:
>> We maintain the inode's logged_trans to avoid reloging it, but if we iput
>> the inode and reread it, we'll get logged_trans to zero.
>>
>> So when an inode is still in log tree, and transaction is not committed yet,
>> we do not iput the inode.
> 
> I know you've tried a few different methods for this, but I think this
> one will end up leading to OOM, since it pins the inodes in ram and we
> don't have a way for the inode shrinker to force a commit.
> 

Ok, I see what the problem is.

> So I took this code out and couldn't trigger my eexist oops anymore.
> I'm going through right now to make sure this isn't because someone took
> the BUG_ON out ;)
> 

Right, without the patch, it should make copy_items()'s btrfs_insert_empty_items()
return -EEXIST.

> The big problem was the code wasn't expecting to find previously logged
> items for the inode because the last trans field wasn't set.  It seems

If the last trans field isn't set, it means the inode has not been modified, so
it does not need to find the logged things, does it?  Or am I missing something?

> like we should just be able to deal with these eexist returns without
> any real trouble?
> 

Agree, actually this patch came from Josef's advice that we could hold the inode
in cache till sometime is ok, but I have to apologize for not getting the OOM problems
into consideration.

So we can go back to tree lookup method, can you pick this one instead?

From: Liu Bo <liubo2009@cn.fujitsu.com>

[PATCH] Btrfs: deal with EEXIST after iput

There are two cases when BTRFS_I(inode)->logged_trans is zero:
a) an inode is just allocated;
b) iput an inode and reread it.

However, in b) if btrfs is not committed yet, and this inode _may_ still remain
in log tree.

So we need to check the log tree to get logged_trans a right value
in case it hits a EEXIST while logging.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/inode.c    |    9 +++------
 fs/btrfs/tree-log.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8db16fa..e310b5b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1770,12 +1770,9 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
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
index 8bedfb8..fea4f39 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3035,6 +3035,37 @@ out:
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
@@ -3087,6 +3118,18 @@ int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
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
-- 
1.6.5.2


> -chris
> 

