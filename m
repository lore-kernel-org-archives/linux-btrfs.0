Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42230 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753106AbaE1LY1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 May 2014 07:24:27 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s4SBOPUS029428
	for <linux-btrfs@vger.kernel.org>; Wed, 28 May 2014 19:24:25 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/4] Btrfs-progs: fsck: fix wrong check for btrfs_read_fs_root()
Date: Wed, 28 May 2014 19:20:41 +0800
Message-ID: <1401276041-18349-4-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1401276041-18349-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1401276041-18349-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When encountering a corrupted fs root node, fsck hit following message:

Check tree block failed, want=29360128, have=0
Check tree block failed, want=29360128, have=0
Check tree block failed, want=29360128, have=0
Check tree block failed, want=29360128, have=0
Check tree block failed, want=29360128, have=0
read block failed check_tree_block
Checking filesystem on /dev/sda9
UUID: 0d295d80-bae2-45f2-a106-120dbfd0e173
checking extents
Segmentation fault (core dumped)

This is because in btrfs_setup_all_roots(), we check
btrfs_read_fs_root() return value by verifing whether it is
NULL pointer, this is wrong since btrfs_read_fs_root() return
PTR_ERR(ret), fix it.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 btrfs-calc-size.c | 2 +-
 disk-io.c         | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/btrfs-calc-size.c b/btrfs-calc-size.c
index a832ee0..5eabdfc 100644
--- a/btrfs-calc-size.c
+++ b/btrfs-calc-size.c
@@ -326,7 +326,7 @@ static int calc_root_size(struct btrfs_root *tree_root, struct btrfs_key *key,
 	int size_fail = 0;
 
 	root = btrfs_read_fs_root(tree_root->fs_info, key);
-	if (!root) {
+	if (IS_ERR(root)) {
 		fprintf(stderr, "Failed to read root %Lu\n", key->objectid);
 		return 1;
 	}
diff --git a/disk-io.c b/disk-io.c
index bbfd8e7..c1c5b70 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -946,7 +946,7 @@ int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info, u64 root_tree_bytenr,
 	key.offset = (u64)-1;
 	fs_info->fs_root = btrfs_read_fs_root(fs_info, &key);
 
-	if (!fs_info->fs_root)
+	if (IS_ERR(fs_info->fs_root))
 		return -EIO;
 	return 0;
 }
-- 
1.9.0

