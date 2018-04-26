Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:34586 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752962AbeDZHtH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Apr 2018 03:49:07 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 7602548AE92A
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Apr 2018 15:49:03 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: remove unused fs_info parameter
Date: Thu, 26 Apr 2018 15:49:02 +0800
Message-ID: <1524728942-14403-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since the commit below parameter fs_info in alloc_reloc_control
be no used. So remove it.
commit c6100a4b4e3d ("Btrfs: replace tree->mapping with
tree->private_data")

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 fs/btrfs/relocation.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 00b7d3231821..d7b7b86f4931 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4299,7 +4299,7 @@ struct inode *create_reloc_inode(struct btrfs_fs_info *fs_info,
 	return inode;
 }
 
-static struct reloc_control *alloc_reloc_control(struct btrfs_fs_info *fs_info)
+static struct reloc_control *alloc_reloc_control(void)
 {
 	struct reloc_control *rc;
 
@@ -4366,7 +4366,7 @@ int btrfs_relocate_block_group(struct btrfs_fs_info *fs_info, u64 group_start)
 	int rw = 0;
 	int err = 0;
 
-	rc = alloc_reloc_control(fs_info);
+	rc = alloc_reloc_control();
 	if (!rc)
 		return -ENOMEM;
 
@@ -4562,7 +4562,7 @@ int btrfs_recover_relocation(struct btrfs_root *root)
 	if (list_empty(&reloc_roots))
 		goto out;
 
-	rc = alloc_reloc_control(fs_info);
+	rc = alloc_reloc_control();
 	if (!rc) {
 		err = -ENOMEM;
 		goto out;
-- 
1.9.1



