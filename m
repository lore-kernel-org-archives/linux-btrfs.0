Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:56391 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751999AbaHAD1c (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jul 2014 23:27:32 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s713RSZl005238
	for <linux-btrfs@vger.kernel.org>; Fri, 1 Aug 2014 11:27:28 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: SSD related mount option dependency rework.
Date: Fri, 1 Aug 2014 11:27:31 +0800
Message-ID: <1406863651-11042-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

According to Documentations/filesystem/btrfs.txt, ssd/ssd_spread/nossd
has their own dependency(See below), but only ssd_spread implying ssd is
implemented.

ssd_spread implies ssd, conflicts nossd.
ssd conflicts nossd.
nossd conflicts ssd and ssd_spread.

This patch adds ssd{,_spread} confliction with nossd.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/super.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 8e16bca..2508a16 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -515,19 +515,22 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 						   compress_type);
 			}
 			break;
-		case Opt_ssd:
-			btrfs_set_and_info(root, SSD,
-					   "use ssd allocation scheme");
-			break;
 		case Opt_ssd_spread:
 			btrfs_set_and_info(root, SSD_SPREAD,
 					   "use spread ssd allocation scheme");
+			/* suppress the ssd mount option log */
 			btrfs_set_opt(info->mount_opt, SSD);
+			/* fall through for other ssd routine */
+		case Opt_ssd:
+			btrfs_set_and_info(root, SSD,
+					   "use ssd allocation scheme");
+			btrfs_clear_opt(info->mount_opt, NOSSD);
 			break;
 		case Opt_nossd:
 			btrfs_set_and_info(root, NOSSD,
 					     "not using ssd allocation scheme");
 			btrfs_clear_opt(info->mount_opt, SSD);
+			btrfs_clear_opt(info->mount_opt, SSD_SPREAD);
 			break;
 		case Opt_barrier:
 			btrfs_clear_and_info(root, NOBARRIER,
-- 
2.0.3

