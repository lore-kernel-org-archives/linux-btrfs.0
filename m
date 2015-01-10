Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:45945 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751085AbbAJK6S (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Sat, 10 Jan 2015 05:58:18 -0500
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v2] Btrfs: fix directory inconsistency after fsync log replay
Date: Sat, 10 Jan 2015 10:56:48 +0000
Message-Id: <1420887408-13868-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1420575641-9762-1-git-send-email-fdmanana@suse.com>
References: <1420575641-9762-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we have an inode (file) with a link count greater than 1, remove
one of its hard links, fsync the inode, power fail/crash and then
replay the fsync log on the next mount, we end up getting the parent
directory's metadata inconsistent - its i_size still reflects the
deleted hard link and has dangling index entries (with no matching
inode reference entries). This prevents the directory from ever being
deletable, as its i_size can never decrease to BTRFS_EMPTY_DIR_SIZE
even if all of its children inodes are deleted, and the dangling index
entries can never be removed (as they point to an inode that does not
exist anymore).

This is easy to reproduce with the following excerpt from the test case
for xfstests that I just made:

    _scratch_mkfs >> $seqres.full 2>&1

    _init_flakey
    _mount_flakey

    # Create a test file with 2 hard links in the same directory.
    mkdir -p $SCRATCH_MNT/a/b
    echo "hello world" > $SCRATCH_MNT/a/b/foo
    ln $SCRATCH_MNT/a/b/foo $SCRATCH_MNT/a/b/bar

    # Make sure all metadata and data are durably persisted.
    sync

    # Now remove one of the hard links and fsync the inode.
    rm -f $SCRATCH_MNT/a/b/bar
    $XFS_IO_PROG -c "fsync" $SCRATCH_MNT/a/b/foo

    # Simulate a crash/power loss. This makes sure the next mount
    # will see an fsync log and will replay that log.

    _load_flakey_table $FLAKEY_DROP_WRITES
    _unmount_flakey

    _load_flakey_table $FLAKEY_ALLOW_WRITES
    _mount_flakey

    # Remove the last hard link of the file and attempt to remove its parent
    # directory - this failed in btrfs because the fsync log and replay code
    # didn't decrement the parent directory's i_size and left dangling directory
    # index entries - this made the btrfs rmdir implementation always fail with
    # the error -ENOTEMPTY.
    #
    # The dangling directory index entries were visible to user space, but it was
    # impossible to do anything on them (unlink, open, read, write, stat, etc)
    # because the inode they pointed to did not exist anymore.
    #
    # The parent directory's metadata inconsistency (stale index entries) was
    # also detected by btrfs' fsck tool, which is run automatically by the fstests
    # framework when the test finishes. The error message reported by fsck was:
    #
    # root 5 inode 259 errors 2001, no inode item, link count wrong
    #   unresolved ref dir 258 index 3 namelen 3 name bar filetype 1 errors 4, no inode ref
    #
    rm -f $SCRATCH_MNT/a/b/*
    rmdir $SCRATCH_MNT/a/b
    rmdir $SCRATCH_MNT/a

To fix this just make sure that after an unlink, if the inode is fsync'ed,
he parent inode is fully logged in the fsync log.

A test case for xfstests follows soon.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: No changes, only updated commit message to be more detailed.

 fs/btrfs/tree-log.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 9a02da1..1d65a46 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4272,6 +4272,9 @@ static int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 	struct dentry *old_parent = NULL;
 	int ret = 0;
 	u64 last_committed = root->fs_info->last_trans_committed;
+	const struct dentry * const first_parent = parent;
+	const bool did_unlink = (BTRFS_I(inode)->last_unlink_trans >
+				 last_committed);
 
 	sb = inode->i_sb;
 
@@ -4327,7 +4330,6 @@ static int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 		goto end_trans;
 	}
 
-	inode_only = LOG_INODE_EXISTS;
 	while (1) {
 		if (!parent || !parent->d_inode || sb != parent->d_inode->i_sb)
 			break;
@@ -4336,8 +4338,22 @@ static int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 		if (root != BTRFS_I(inode)->root)
 			break;
 
+		/*
+		 * On unlink we must make sure our immediate parent directory
+		 * inode is fully logged. This is to prevent leaving dangling
+		 * directory index entries and a wrong directory inode's i_size.
+		 * Not doing so can result in a directory being impossible to
+		 * delete after log replay (rmdir will always fail with error
+		 * -ENOTEMPTY).
+		 */
+		if (did_unlink && parent == first_parent)
+			inode_only = LOG_INODE_ALL;
+		else
+			inode_only = LOG_INODE_EXISTS;
+
 		if (BTRFS_I(inode)->generation >
-		    root->fs_info->last_trans_committed) {
+		    root->fs_info->last_trans_committed ||
+		    inode_only == LOG_INODE_ALL) {
 			ret = btrfs_log_inode(trans, root, inode, inode_only,
 					      0, LLONG_MAX, ctx);
 			if (ret)
-- 
2.1.3

