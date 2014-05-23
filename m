Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43401 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751266AbaEWDkT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 May 2014 23:40:19 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s4N3eIvp031937
	for <linux-btrfs@vger.kernel.org>; Fri, 23 May 2014 11:40:18 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <t-itoh@jp.fujitsu.com>
Subject: [PATCH] Btrfs: clear compress-force when remounting with compress option
Date: Fri, 23 May 2014 11:36:52 +0800
Message-ID: <1400816212-2501-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
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
 fs/btrfs/super.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 4662d92..c3bb35f 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -513,6 +513,14 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 					btrfs_info(root->fs_info,
 						   "btrfs: use %s compression",
 						   compress_type);
+				/*
+				 * If we remount from compress-force=xxx to
+				 * compress=xxx, we need clear FORCE_COMPRESS
+				 * flag, otherwise, there is no way for users
+				 * to disable forcible compression separately.
+				 */
+				btrfs_clear_and_info(root, FORCE_COMPRESS,
+						     "compress is not forced anymore");
 			}
 			break;
 		case Opt_ssd:
-- 
1.9.0

