Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:39685 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506AbaIHUyh (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Mon, 8 Sep 2014 16:54:37 -0400
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs: fix directory recovery from fsync log
Date: Mon,  8 Sep 2014 22:53:18 +0100
Message-Id: <1410213198-16232-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When replaying a directory from the fsync log, if a directory entry
exists both in the fs/subvol tree and in the log, the directory's inode
got its i_size updated incorrectly, accounting for the dentry's name
twice.

Reproducer, from a test for xfstests:

    _scratch_mkfs >> $seqres.full 2>&1
    _init_flakey
    _mount_flakey

    touch $SCRATCH_MNT/foo
    sync

    touch $SCRATCH_MNT/bar
    xfs_io -c "fsync" $SCRATCH_MNT
    xfs_io -c "fsync" $SCRATCH_MNT/bar

    _load_flakey_table $FLAKEY_DROP_WRITES
    _unmount_flakey

    _load_flakey_table $FLAKEY_ALLOW_WRITES
    _mount_flakey

    [ -f $SCRATCH_MNT/foo ] || echo "file foo is missing"
    [ -f $SCRATCH_MNT/bar ] || echo "file bar is missing"

    _unmount_flakey
    _check_scratch_fs $FLAKEY_DEV

The filesystem check at the end failed with the message:
"root 5 root dir 256 error".

A test case for xfstests follows.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index faa568e..d60425c 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1638,6 +1638,7 @@ static noinline int replay_one_name(struct btrfs_trans_handle *trans,
 	    found_key.type == log_key.type &&
 	    found_key.offset == log_key.offset &&
 	    btrfs_dir_type(path->nodes[0], dst_di) == log_type) {
+		update_size = false;
 		goto out;
 	}
 
-- 
1.9.1

