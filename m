Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35765 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbbILBoX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Sep 2015 21:44:23 -0400
Message-ID: <55F38371.9010200@suse.com>
Date: Fri, 11 Sep 2015 21:44:17 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
CC: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>,
        Chris Mason <clm@fb.com>
Subject: [PATCH] btrfs: skip waiting on ordered range for special files
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs_evict_inode, we properly truncate the page cache for evicted
inodes but then we call btrfs_wait_ordered_range for every inode as well.
It's the right thing to do for regular files but results in incorrect
behavior for device inodes for block devices.

filemap_fdatawrite_range gets called with inode->i_mapping which gets
resolved to the block device inode before getting passed to
wbc_attach_fdatawrite_inode and ultimately to inode_to_bdi.  What happens
next depends on whether there's an open file handle associated with the
inode.  If there is, we write to the block device, which is unexpected
behavior.  If there isn't, we through normally and inode->i_data is used.
We can also end up racing against open/close which can result in crashes
when i_mapping points to a block device inode that has been closed.

Since there can't be any page cache associated with special file inodes,
it's safe to skip the btrfs_wait_ordered_range call entirely and avoid
the problem.

Cc: <stable@vger.kernel.org>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=100911
Tested-by: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5035,7 +5035,8 @@ void btrfs_evict_inode(struct inode *ino
 		goto no_delete;
 	}
 	/* do we really want it for ->i_nlink > 0 and zero btrfs_root_refs? */
-	btrfs_wait_ordered_range(inode, 0, (u64)-1);
+	if (!special_file(inode->i_mode))
+		btrfs_wait_ordered_range(inode, 0, (u64)-1);
 
 	btrfs_free_io_failure_record(inode, 0, (u64)-1);
 

-- 
Jeff Mahoney
SUSE Labs
