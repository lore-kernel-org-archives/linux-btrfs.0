Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36591 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755291AbcLONil (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Dec 2016 08:38:41 -0500
Received: by mail-wm0-f65.google.com with SMTP id m203so6538662wma.3
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Dec 2016 05:38:33 -0800 (PST)
From: Seraphime Kirkovski <kirkseraph@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, jbacik@fb.com, clm@fb.com,
        Seraphime Kirkovski <kirkseraph@gmail.com>
Subject: [PATCH 4/4] Btrfs: code cleanup min/max -> min_t/max_t
Date: Thu, 15 Dec 2016 14:38:28 +0100
Message-Id: <20161215133828.25791-1-kirkseraph@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This cleans up the cases where the min/max macros were used with a cast
rather than using directly min_t/max_t.

Signed-off-by: Seraphime Kirkovski <kirkseraph@gmail.com>
---
 fs/btrfs/file-item.c | 4 ++--
 fs/btrfs/ioctl.c     | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 5fd5f45..7ae52cf 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -867,8 +867,8 @@ int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
 		tmp = min(tmp, (next_offset - file_key.offset) >>
 					 root->fs_info->sb->s_blocksize_bits);
 
-		tmp = max((u64)1, tmp);
-		tmp = min(tmp, (u64)MAX_CSUM_ITEMS(root, csum_size));
+		tmp = max_t(u64, 1, tmp);
+		tmp = min_t(u64, tmp, MAX_CSUM_ITEMS(root, csum_size));
 		ins_size = csum_size * tmp;
 	} else {
 		ins_size = csum_size;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 8bf0d44..fc6dc14 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -394,7 +394,7 @@ static noinline int btrfs_ioctl_fitrim(struct file *file, void __user *arg)
 		q = bdev_get_queue(device->bdev);
 		if (blk_queue_discard(q)) {
 			num_devices++;
-			minlen = min((u64)q->limits.discard_granularity,
+			minlen = min_t(u64, q->limits.discard_granularity,
 				     minlen);
 		}
 	}
-- 
2.10.2

