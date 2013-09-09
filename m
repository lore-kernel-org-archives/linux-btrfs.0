Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:29542 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab3IIGKc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Sep 2013 02:10:32 -0400
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: anand.jain@oracle.com
Subject: [PATCH] Btrfs-progs: fix typo in btrfs_err_str()
Date: Mon, 9 Sep 2013 14:08:12 +0800
Message-Id: <1378706892-5341-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Raid5 and raid6 at least need three and foure devices respectively,
fix it.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
based on david's integration 20130903
---
 ioctl.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/ioctl.h b/ioctl.h
index e959720..c0dcc06 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -484,9 +484,9 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 		case BTRFS_ERROR_DEV_RAID10_MIN_NOT_MET:
 			return "unable to go below four devices on raid10";
 		case BTRFS_ERROR_DEV_RAID5_MIN_NOT_MET:
-			return "unable to go below two devices on raid5";
+			return "unable to go below three devices on raid5";
 		case BTRFS_ERROR_DEV_RAID6_MIN_NOT_MET:
-			return "unable to go below three devices on raid6";
+			return "unable to go below four devices on raid6";
 		case BTRFS_ERROR_DEV_TGT_REPLACE:
 			return "unable to remove the dev_replace target dev";
 		case BTRFS_ERROR_DEV_MISSING_NOT_FOUND:
-- 
1.8.3.1

