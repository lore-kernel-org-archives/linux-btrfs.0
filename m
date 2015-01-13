Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:45706 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753357AbbAMQ2U (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Tue, 13 Jan 2015 11:28:20 -0500
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs: fix fsync log replay for inodes with a mix of regular refs and extrefs
Date: Tue, 13 Jan 2015 16:27:48 +0000
Message-Id: <1421166468-8721-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we have an inode with a large number of hard links, some of which may
be extrefs, turn a regular ref into an extref, fsync the inode and then
replay the fsync log (after a crash/reboot), we can endup with an fsync
log that makes the replay code always fail with -EOVERFLOW when processing
the inode's references.

This is easy to reproduce with the test case I made for xfstests. Its steps
are the following:

   _scratch_mkfs "-O extref" >> $seqres.full 2>&1
   _init_flakey
   _mount_flakey

   # Create a test file with 3001 hard links. This number is large enough to
   # make btrfs start using extrefs at some point even if the fs has the maximum
   # possible leaf/node size (64Kb).
   echo "hello world" > $SCRATCH_MNT/foo
   for i in `seq 1 3000`; do
       ln $SCRATCH_MNT/foo $SCRATCH_MNT/foo_link_`printf "%04d" $i`
   done

   # Make sure all metadata and data are durably persisted.
   sync

   # Now remove one link, add a new one with a new name, add another new one with
   # the same name as the one we just removed and fsync the inode.
   rm -f $SCRATCH_MNT/foo_link_0001
   ln $SCRATCH_MNT/foo $SCRATCH_MNT/foo_link_3001
   ln $SCRATCH_MNT/foo $SCRATCH_MNT/foo_link_0001
   $XFS_IO_PROG -c "fsync" $SCRATCH_MNT/foo

   # Simulate a crash/power loss. This makes sure the next mount
   # will see an fsync log and will replay that log.

   _load_flakey_table $FLAKEY_DROP_WRITES
   _unmount_flakey

   _load_flakey_table $FLAKEY_ALLOW_WRITES
   _mount_flakey

So on overflow error when overwriting a reference item (regular or extend
reference item), delete the old and replace it with the one in the fsync
log.

This issue has been present since the introduction of the extrefs feature
(2012).

A test case for xfstests follows soon. This test only passes if the previous
patch titled "Btrfs: fix fsync when extend references are added to an inode"
is applied too.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index ecf462a..a1ce105 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1245,6 +1245,28 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 
 	/* finally write the back reference in the inode */
 	ret = overwrite_item(trans, root, path, eb, slot, key);
+	if (ret == -EOVERFLOW) {
+		/*
+		 * This means we have a reference item in the fs/subvol tree
+		 * that groups multiple references, some of which were added
+		 * by the above loop, some are current and some are obsolete
+		 * and are going to be deleted by a future stage of the fsync
+		 * log replay code. So just delete the item and copy the
+		 * one from the log tree into the fs/subvol tree - this is
+		 * safe and later if a link count in the inode is incorrect,
+		 * it will be corrected by our log replay code.
+		 */
+		ret = btrfs_search_slot(trans, root, key, path, -1, 1);
+		if (WARN_ON(ret == 1))
+			ret = -EIO;
+		if (ret < 0)
+			goto out;
+		ret = btrfs_del_item(trans, root, path);
+		if (ret)
+			goto out;
+		btrfs_release_path(path);
+		ret = overwrite_item(trans, root, path, eb, slot, key);
+	}
 out:
 	btrfs_release_path(path);
 	kfree(name);
-- 
2.1.3

