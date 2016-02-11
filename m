Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39720 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbcBKQ5N (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Feb 2016 11:57:13 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id A9898AB9D
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Feb 2016 16:57:12 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 6/9] btrfs: readdir: use GFP_KERNEL
Date: Thu, 11 Feb 2016 17:57:12 +0100
Message-Id: <49e350a4919fb1751127111cf6dd6fed02815781.1455208920.git.dsterba@suse.com>
In-Reply-To: <cover.1455208920.git.dsterba@suse.com>
References: <cover.1455208920.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Readdir is initiated from userspace and is not on the critical
writeback path, we don't need to use GFP_NOFS for allocations.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5f06eb1f4384..2bd47fb228b2 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5788,7 +5788,7 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 			if (name_len <= sizeof(tmp_name)) {
 				name_ptr = tmp_name;
 			} else {
-				name_ptr = kmalloc(name_len, GFP_NOFS);
+				name_ptr = kmalloc(name_len, GFP_KERNEL);
 				if (!name_ptr) {
 					ret = -ENOMEM;
 					goto err;
-- 
2.7.1

