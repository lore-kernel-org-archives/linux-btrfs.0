Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38324 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729287AbeHOSTj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Aug 2018 14:19:39 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 12465AD6D
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Aug 2018 15:27:03 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/7] btrfs: Remove needless locking in iterate_inode_extrefs
Date: Wed, 15 Aug 2018 18:26:52 +0300
Message-Id: <1534346817-9108-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1534346817-9108-1-git-send-email-nborisov@suse.com>
References: <1534346817-9108-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In iterate_inode_exrefs the eb is cloned via btrfs_clone_extent_buffer
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
 fs/btrfs/backref.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 1cb0b31c5059..99e43f438d90 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -2076,10 +2076,6 @@ static int iterate_inode_extrefs(u64 inum, struct btrfs_root *fs_root,
 			ret = -ENOMEM;
 			break;
 		}
-		extent_buffer_get(eb);
-
-		btrfs_tree_read_lock(eb);
-		btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
 		btrfs_release_path(path);
 
 		item_size = btrfs_item_size_nr(eb, slot);
@@ -2100,7 +2096,6 @@ static int iterate_inode_extrefs(u64 inum, struct btrfs_root *fs_root,
 			cur_offset += btrfs_inode_extref_name_len(eb, extref);
 			cur_offset += sizeof(*extref);
 		}
-		btrfs_tree_read_unlock_blocking(eb);
 		free_extent_buffer(eb);
 
 		offset++;
-- 
2.7.4
