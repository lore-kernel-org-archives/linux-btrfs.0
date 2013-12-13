Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60332 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab3LMAvx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Dec 2013 19:51:53 -0500
Received: from m4.gw.fujitsu.co.jp (unknown [10.0.50.74])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 57E093EE166
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Dec 2013 09:51:52 +0900 (JST)
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 4B04545DE4E
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Dec 2013 09:51:52 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.nic.fujitsu.com [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 34F9745DD76
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Dec 2013 09:51:52 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 29A9FE38003
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Dec 2013 09:51:52 +0900 (JST)
Received: from m1001.s.css.fujitsu.com (m1001.s.css.fujitsu.com [10.240.81.139])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id D44D91DB8032
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Dec 2013 09:51:51 +0900 (JST)
Message-Id: <201312130051.AA00031@FM-323941448.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Fri, 13 Dec 2013 09:51:42 +0900
To: linux-btrfs@vger.kernel.org
Cc: mfasheh@suse.de
Subject: [PATCH] Btrfs: fix error check of btrfs_lookup_dentry()
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Clean up btrfs_lookup_dentry() to never return NULL, but PTR_ERR(-ENOENT)
instead. This keeps the return value convention consistent.

Callers who use btrfs_lookup_dentry() require a trivial update.

create_snapshot() in particular looks like it can also lose a BUG_ON(!inode)
which is not really needed - there seems less harm in returning ENOENT to
userspace at that point in the stack than there is to crash the machine.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/inode.c | 15 +++++++++++----
 fs/btrfs/ioctl.c | 13 ++++++++++---
 2 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3b4ffaf..f9b45a7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4910,7 +4910,7 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
 		return ERR_PTR(ret);
 
 	if (location.objectid == 0)
-		return NULL;
+		return ERR_PTR(-ENOENT);
 
 	if (location.type == BTRFS_INODE_ITEM_KEY) {
 		inode = btrfs_iget(dir->i_sb, &location, root, NULL);
@@ -4974,10 +4974,17 @@ static void btrfs_dentry_release(struct dentry *dentry)
 static struct dentry *btrfs_lookup(struct inode *dir, struct dentry *dentry,
 				   unsigned int flags)
 {
-	struct dentry *ret;
+	struct inode *inode;
 
-	ret = d_splice_alias(btrfs_lookup_dentry(dir, dentry), dentry);
-	return ret;
+	inode = btrfs_lookup_dentry(dir, dentry);
+	if (IS_ERR(inode)) {
+		if (PTR_ERR(inode) == -ENOENT)
+			inode = NULL;
+		else
+			return ERR_CAST(inode);
+	}
+
+	return d_splice_alias(inode, dentry);
 }
 
 unsigned char btrfs_filetype_table[] = {
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9d46f60..716779c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -389,6 +389,7 @@ static noinline int create_subvol(struct inode *dir,
 	struct btrfs_root *new_root;
 	struct btrfs_block_rsv block_rsv;
 	struct timespec cur_time = CURRENT_TIME;
+	struct inode *inode;
 	int ret;
 	int err;
 	u64 objectid;
@@ -550,8 +551,14 @@ fail:
 	if (err && !ret)
 		ret = err;
 
-	if (!ret)
-		d_instantiate(dentry, btrfs_lookup_dentry(dir, dentry));
+	if (!ret) {
+		inode = btrfs_lookup_dentry(dir, dentry);
+		if (IS_ERR(inode)) {
+			ret = PTR_ERR(inode);
+			goto out;
+		}
+		d_instantiate(dentry, inode);
+	}
 out:
 	btrfs_subvolume_release_metadata(root, &block_rsv, qgroup_reserved);
 	return ret;
@@ -639,7 +646,7 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 		ret = PTR_ERR(inode);
 		goto fail;
 	}
-	BUG_ON(!inode);
+
 	d_instantiate(dentry, inode);
 	ret = 0;
 fail:

