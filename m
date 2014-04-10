Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:4724 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750735AbaDJEAL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Apr 2014 00:00:11 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s3A401DE031776
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Apr 2014 12:00:01 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: correct prompt of minimal num of devs for raid56
Date: Thu, 10 Apr 2014 11:55:36 +0800
Message-ID: <1397102136-2491-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For btrfs,
Raid5 can't go below 2 devs, not 3;
Raid6 can't go below 3 devs, not 4.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 ioctl.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/ioctl.h b/ioctl.h
index c3ee270..6742ba6 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -489,9 +489,9 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 		case BTRFS_ERROR_DEV_RAID10_MIN_NOT_MET:
 			return "unable to go below four devices on raid10";
 		case BTRFS_ERROR_DEV_RAID5_MIN_NOT_MET:
-			return "unable to go below three devices on raid5";
+			return "unable to go below two devices on raid5";
 		case BTRFS_ERROR_DEV_RAID6_MIN_NOT_MET:
-			return "unable to go below four devices on raid6";
+			return "unable to go below three devices on raid6";
 		case BTRFS_ERROR_DEV_TGT_REPLACE:
 			return "unable to remove the dev_replace target dev";
 		case BTRFS_ERROR_DEV_MISSING_NOT_FOUND:
-- 
1.8.1.4

