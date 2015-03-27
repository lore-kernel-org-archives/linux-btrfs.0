Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:36145 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752971AbbC0S0P (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Fri, 27 Mar 2015 14:26:15 -0400
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs: incremental send, don't delay directory renames unnecessarily
Date: Fri, 27 Mar 2015 18:25:57 +0000
Message-Id: <1427480757-27307-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Even though we delay the rename of directories when they become
descendents of other directories that were also renamed in the send
root to prevent infinite path build loops, we were doing it in cases
where this was not needed and was actually harmful resulting in
infinite path build loops as we ended up with a circular dependency
of delayed directory renames.

Consider the following reproducer:

  $ mkfs.btrfs -f /dev/sdb
  $ mount /dev/sdb /mnt
  $ mkfs.btrfs -f /dev/sdc
  $ mount /dev/sdc /mnt2

  $ mkdir /mnt/data
  $ mkdir /mnt/data/n1
  $ mkdir /mnt/data/n1/n2
  $ mkdir /mnt/data/n4
  $ mkdir /mnt/data/n1/n2/p1
  $ mkdir /mnt/data/n1/n2/p1/p2
  $ mkdir /mnt/data/t6
  $ mkdir /mnt/data/t7
  $ mkdir -p /mnt/data/t5/t7
  $ mkdir /mnt/data/t2
  $ mkdir /mnt/data/t4
  $ mkdir -p /mnt/data/t1/t3
  $ mkdir /mnt/data/p1
  $ mv /mnt/data/t1 /mnt/data/p1
  $ mkdir -p /mnt/data/p1/p2
  $ mv /mnt/data/t4 /mnt/data/p1/p2/t1
  $ mv /mnt/data/t5 /mnt/data/n4/t5
  $ mv /mnt/data/n1/n2/p1/p2 /mnt/data/n4/t5/p2
  $ mv /mnt/data/t7 /mnt/data/n4/t5/p2/t7
  $ mv /mnt/data/t2 /mnt/data/n4/t1
  $ mv /mnt/data/p1 /mnt/data/n4/t5/p2/p1
  $ mv /mnt/data/n1/n2 /mnt/data/n4/t5/p2/p1/p2/n2
  $ mv /mnt/data/n4/t5/p2/p1/p2/t1 /mnt/data/n4/t5/p2/p1/p2/n2/t1
  $ mv /mnt/data/n4/t5/t7 /mnt/data/n4/t5/p2/p1/p2/n2/t1/t7
  $ mv /mnt/data/n4/t5/p2/p1/t1/t3 /mnt/data/n4/t5/p2/p1/p2/n2/t1/t3
  $ mv /mnt/data/n4/t5/p2/p1/p2/n2/p1 /mnt/data/n4/t5/p2/p1/p2/n2/t1/t7/p1
  $ mv /mnt/data/t6 /mnt/data/n4/t5/p2/p1/p2/n2/t1/t3/t5
  $ mv /mnt/data/n4/t5/p2/p1/t1 /mnt/data/n4/t5/p2/p1/p2/n2/t1/t3/t1
  $ mv /mnt/data/n1 /mnt/data/n4/t5/p2/p1/p2/n2/t1/t7/p1/n1

  $ btrfs subvolume snapshot -r /mnt /mnt/snap1

  $ mv /mnt/data/n4/t1 /mnt/data/n4/t5/p2/p1/p2/n2/t1/t7/p1/t1
  $ mv /mnt/data/n4/t5/p2/p1/p2/n2/t1 /mnt/data/n4/
  $ mv /mnt/data/n4/t5/p2/p1/p2/n2 /mnt/data/n4/t1/n2
  $ mv /mnt/data/n4/t1/t7/p1 /mnt/data/n4/t1/n2/p1
  $ mv /mnt/data/n4/t1/t3/t1 /mnt/data/n4/t1/n2/t1
  $ mv /mnt/data/n4/t1/t3 /mnt/data/n4/t1/n2/t1/t3
  $ mv /mnt/data/n4/t5/p2/p1/p2 /mnt/data/n4/t1/n2/p1/p2
  $ mv /mnt/data/n4/t1/t7 /mnt/data/n4/t1/n2/p1/t7
  $ mv /mnt/data/n4/t5/p2/p1 /mnt/data/n4/t1/n2/p1/p2/p1
  $ mv /mnt/data/n4/t1/n2/t1/t3/t5 /mnt/data/n4/t1/n2/p1/p2/t5
  $ mv /mnt/data/n4/t5 /mnt/data/n4/t1/n2/p1/p2/p1/t5
  $ mv /mnt/data/n4/t1/n2/p1/p2/p1/t5/p2 /mnt/data/n4/t1/n2/p1/p2/p1/p2
  $ mv /mnt/data/n4/t1/n2/p1/p2/p1/p2/t7 /mnt/data/n4/t1/t7

  $ btrfs subvolume snapshot -r /mnt /mnt/snap2

  $ btrfs send /mnt/snap1 | btrfs receive /mnt2
  $ btrfs send -p /mnt/snap1 /mnt/snap2 | btrfs receive -vv /mnt2
  ERROR: send ioctl failed with -12: Cannot allocate memory

This reproducer resulted in an infinite path build loop when building the
path for inode 266 because the following circular dependency of delayed
directory renames was created:

   ino 272 <- ino 261 <- ino 259 <- ino 268 <- ino 267 <- ino 261

Where the notation "X <- Y" means the rename of inode X is delayed by the
rename of inode Y (X will be renamed after Y is renamed). This resulted
in an infinite path build loop of inode 266 because that inode has inode
261 as an ancestor in the send root and inode 261 is in the circular
dependency of delayed renames listed above.

Fix this by not delaying the rename of a directory inode if an ancestor of
the inode in the send root, which has a delayed rename operation, is not
also a descendent of the inode in the parent root.

Thanks to Robbie Ko for sending the reproducer example.
A test case for xfstests follows soon.

Reported-by: Robbie Ko <robbieko@synology.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/send.c | 43 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 41 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index a1216f9..f879406 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -3353,6 +3353,32 @@ out:
 	return ret;
 }
 
+/*
+ * Check if ino ino1 is an ancestor of inode ino2 in the given root.
+ * Return 1 if true, 0 if false and < 0 on error.
+ */
+static int is_ancestor(struct btrfs_root *root,
+		       const u64 ino1,
+		       const u64 ino2,
+		       struct fs_path *fs_path)
+{
+	u64 ino = ino2;
+
+	while (ino > BTRFS_FIRST_FREE_OBJECTID) {
+		int ret;
+		u64 parent;
+
+		fs_path_reset(fs_path);
+		ret = get_first_ref(root, ino, &parent, NULL, fs_path);
+		if (ret < 0)
+			return ret;
+		if (parent == ino1)
+			return 1;
+		ino = parent;
+	}
+	return 0;
+}
+
 static int wait_for_parent_move(struct send_ctx *sctx,
 				struct recorded_ref *parent_ref)
 {
@@ -3374,11 +3400,24 @@ static int wait_for_parent_move(struct send_ctx *sctx,
 	 * Our current directory inode may not yet be renamed/moved because some
 	 * ancestor (immediate or not) has to be renamed/moved first. So find if
 	 * such ancestor exists and make sure our own rename/move happens after
-	 * that ancestor is processed.
+	 * that ancestor is processed to avoid path build infinite loops (done
+	 * at get_cur_path()).
 	 */
 	while (ino > BTRFS_FIRST_FREE_OBJECTID) {
 		if (is_waiting_for_move(sctx, ino)) {
-			ret = 1;
+			/*
+			 * If the current inode is an ancestor of ino in the
+			 * parent root, we need to delay the rename of the
+			 * current inode, otherwise don't delayed the rename
+			 * because we can end up with a circular dependency
+			 * of renames, resulting in some directories never
+			 * getting the respective rename operations issued in
+			 * the send stream or getting into infinite path build
+			 * loops.
+			 */
+			ret = is_ancestor(sctx->parent_root,
+					  sctx->cur_ino, ino,
+					  path_before);
 			break;
 		}
 
-- 
2.1.3

