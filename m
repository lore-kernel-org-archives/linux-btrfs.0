Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:59477 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754147Ab3HPSCe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Aug 2013 14:02:34 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Chris Mason <chris.mason@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: use __u64 in exported user headers
Date: Fri, 16 Aug 2013 14:02:33 -0400
Message-Id: <1376676153-3206-1-git-send-email-vapier@gentoo.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/uapi/linux/btrfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 5ef0df5..7150b26 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -484,7 +484,7 @@ struct btrfs_ioctl_send_args {
 				   struct btrfs_ioctl_search_args)
 #define BTRFS_IOC_INO_LOOKUP _IOWR(BTRFS_IOCTL_MAGIC, 18, \
 				   struct btrfs_ioctl_ino_lookup_args)
-#define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 19, u64)
+#define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 19, __u64)
 #define BTRFS_IOC_SPACE_INFO _IOWR(BTRFS_IOCTL_MAGIC, 20, \
 				    struct btrfs_ioctl_space_args)
 #define BTRFS_IOC_START_SYNC _IOR(BTRFS_IOCTL_MAGIC, 24, __u64)
-- 
1.8.3.2

