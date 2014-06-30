Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52948 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753967AbaF3Czn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Jun 2014 22:55:43 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5U2tcD4016488
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Jun 2014 10:55:38 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2] Btrfs: clear compress-force when remounting with compress option
Date: Mon, 30 Jun 2014 10:51:25 +0800
Message-ID: <1404096685-10591-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Steps to reproduce:
 # mkfs.btrfs -f /dev/sdb
 # mount /dev/sdb /mnt -o compress-force=lzo
 # mount /dev/sdb /mnt -o remount,compress=zlib
 # cat /proc/mounts

Remounting from compress-force to compress could not clear compress-force
option. The problem is there is no way for users to clear compress-force
option separately.

Fix this problem by clearing @FORCE_COMPRESS flag when remounting to
compress=xxx.

Suggested-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
v1->v2: remove unnecessary message output which was addressed
        by David.
---
 fs/btrfs/super.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 4662d92..5aae8f0 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -513,6 +513,13 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 					btrfs_info(root->fs_info,
 						   "btrfs: use %s compression",
 						   compress_type);
+				/*
+				 * If we remount from compress-force=xxx to
+				 * compress=xxx, we need clear FORCE_COMPRESS
+				 * flag, otherwise, there is no way for users
+				 * to disable forcible compression separately.
+				 */
+				btrfs_clear_opt(info->mount_opt, FORCE_COMPRESS);
 			}
 			break;
 		case Opt_ssd:
-- 
1.8.3.1

