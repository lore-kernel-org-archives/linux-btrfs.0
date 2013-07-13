Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:40070 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757602Ab3GMLZY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Jul 2013 07:25:24 -0400
Received: by mail-wg0-f51.google.com with SMTP id e11so8736024wgh.6
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Jul 2013 04:25:22 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: add missing error checks to add_data_references
Date: Sat, 13 Jul 2013 12:25:15 +0100
Message-Id: <1373714715-10250-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The function relocation.c:add_data_references() was not checking
if all calls to __add_tree_block() and find_data_references() were
succeeding or not.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/relocation.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 1209649..295a611 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3628,7 +3628,7 @@ int add_data_references(struct reloc_control *rc,
 	unsigned long ptr;
 	unsigned long end;
 	u32 blocksize = btrfs_level_size(rc->extent_root, 0);
-	int ret;
+	int ret = 0;
 	int err = 0;
 
 	eb = path->nodes[0];
@@ -3655,6 +3655,10 @@ int add_data_references(struct reloc_control *rc,
 		} else {
 			BUG();
 		}
+		if (ret) {
+			err = ret;
+			goto out;
+		}
 		ptr += btrfs_extent_inline_ref_size(key.type);
 	}
 	WARN_ON(ptr > end);
@@ -3700,6 +3704,7 @@ int add_data_references(struct reloc_control *rc,
 		}
 		path->slots[0]++;
 	}
+out:
 	btrfs_release_path(path);
 	if (err)
 		free_block_list(blocks);
-- 
1.7.9.5

