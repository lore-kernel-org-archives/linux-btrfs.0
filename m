Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39637 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723AbcBKQzx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Feb 2016 11:55:53 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 20332AB9D
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Feb 2016 16:55:52 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: remove error message from search ioctl for nonexistent tree
Date: Thu, 11 Feb 2016 17:55:49 +0100
Message-Id: <1455209749-22874-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Let's remove the error message that appears when the tree_id is not
present. This can happen with the quota tree and has been observed in
practice. The applications are supposed to handle -ENOENT and we don't
need to report that in the system log as it's not a fatal error.

Reported-by: Vlastimil Babka <vbabka@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ioctl.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 952172ca7e45..ab390c7958f5 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2097,8 +2097,6 @@ static noinline int search_ioctl(struct inode *inode,
 		key.offset = (u64)-1;
 		root = btrfs_read_fs_root_no_name(info, &key);
 		if (IS_ERR(root)) {
-			btrfs_err(info, "could not find root %llu",
-			       sk->tree_id);
 			btrfs_free_path(path);
 			return -ENOENT;
 		}
-- 
2.7.1

