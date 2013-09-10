Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:59921 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab3IJPqm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Sep 2013 11:46:42 -0400
Received: by mail-pa0-f53.google.com with SMTP id lb1so7838106pab.40
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Sep 2013 08:46:41 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix typo in btrfs_err_str()
Date: Tue, 10 Sep 2013 23:46:36 +0800
Message-Id: <1378827996-1305-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

raid5 and raid6 at least need three and four devices
respectively, fix it.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 include/uapi/linux/btrfs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 45e6189..1e65895 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -495,9 +495,9 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
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
1.7.11.7

