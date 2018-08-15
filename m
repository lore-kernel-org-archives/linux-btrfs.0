Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38294 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729388AbeHOSTi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Aug 2018 14:19:38 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C0DE1AD6A
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Aug 2018 15:27:01 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/7] btrfs: Remove needless locking in iterate_inode_refs
Date: Wed, 15 Aug 2018 18:26:51 +0300
Message-Id: <1534346817-9108-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1534346817-9108-1-git-send-email-nborisov@suse.com>
References: <1534346817-9108-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In iterate_inode_refs the eb is cloned via btrfs_clone_extent_buffer
which creates a private extent buffer with the dummy flag set and
ref count of 1. Then this buffer is locked for reading and its ref
count is incremented by 1. Finally it's fed to the passed iterate_irefs_t
function. The actual iterate call back is inode_to_path (coming from
paths_from_inode) which feeds the eb to btrfs_ref_to_path. In this
final function the passed eb is only read by first assigning it to
the local eb variable. This variable is only modified in the case
another eb was referenced from the passed path that is eb != eb_in
check triggers.

Considering this there is no point in locking the cloned eb in
iterate_inode_refs since it's never being modified and is not published
anywhere. Furthermore the cloned eb is completely fine having its ref
count be 1.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/backref.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index ae750b1574a2..1cb0b31c5059 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -2018,9 +2018,6 @@ static int iterate_inode_refs(u64 inum, struct btrfs_root *fs_root,
 			ret = -ENOMEM;
 			break;
 		}
-		extent_buffer_get(eb);
-		btrfs_tree_read_lock(eb);
-		btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
 		btrfs_release_path(path);
 
 		item = btrfs_item_nr(slot);
@@ -2039,7 +2036,6 @@ static int iterate_inode_refs(u64 inum, struct btrfs_root *fs_root,
 			len = sizeof(*iref) + name_len;
 			iref = (struct btrfs_inode_ref *)((char *)iref + len);
 		}
-		btrfs_tree_read_unlock_blocking(eb);
 		free_extent_buffer(eb);
 	}
 
-- 
2.7.4
