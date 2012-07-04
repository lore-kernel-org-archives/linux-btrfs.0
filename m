Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64940 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab2GDNkJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jul 2012 09:40:09 -0400
Received: by bkwj10 with SMTP id j10so2633951bkw.19
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Jul 2012 06:40:08 -0700 (PDT)
From: Alexander Block <ablock84@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: Alexander Block <ablock84@googlemail.com>
Subject: [RFC PATCH 2/6] Btrfs-progs: update ioctl.h to support clone range ioctl
Date: Wed,  4 Jul 2012 15:39:30 +0200
Message-Id: <1341409174-13619-3-git-send-email-ablock84@googlemail.com>
In-Reply-To: <1341409174-13619-1-git-send-email-ablock84@googlemail.com>
References: <1341409174-13619-1-git-send-email-ablock84@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Added missing btrfs_ioctl_clone_range_args and BTRFS_IOC_CLONE_RANGE
to ioctl.h

Signed-off-by: Alexander Block <ablock84@googlemail.com>
---
 ioctl.h |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/ioctl.h b/ioctl.h
index 6670e08..023ca4c 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -281,6 +281,13 @@ struct btrfs_ioctl_logical_ino_args {
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_SCAN_DEV _IOW(BTRFS_IOCTL_MAGIC, 4, \
 				   struct btrfs_ioctl_vol_args)
+
+struct btrfs_ioctl_clone_range_args {
+	__s64 src_fd;
+	__u64 src_offset, src_length;
+	__u64 dest_offset;
+};
+
 /* trans start and trans end are dangerous, and only for
  * use by applications that know how to avoid the
  * resulting deadlocks
@@ -296,7 +303,8 @@ struct btrfs_ioctl_logical_ino_args {
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_BALANCE _IOW(BTRFS_IOCTL_MAGIC, 12, \
 				   struct btrfs_ioctl_vol_args)
-/* 13 is for CLONE_RANGE */
+#define BTRFS_IOC_CLONE_RANGE _IOW(BTRFS_IOCTL_MAGIC, 13, \
+				   struct btrfs_ioctl_clone_range_args)
 #define BTRFS_IOC_SUBVOL_CREATE _IOW(BTRFS_IOCTL_MAGIC, 14, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_SNAP_DESTROY _IOW(BTRFS_IOCTL_MAGIC, 15, \
-- 
1.7.10

