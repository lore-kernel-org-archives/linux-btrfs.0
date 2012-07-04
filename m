Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41824 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab2GDNkO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jul 2012 09:40:14 -0400
Received: by mail-bk0-f46.google.com with SMTP id j10so2633865bkw.19
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Jul 2012 06:40:14 -0700 (PDT)
From: Alexander Block <ablock84@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: Alexander Block <ablock84@googlemail.com>
Subject: [RFC PATCH 5/6] Btrfs-progs: update ioctl.h to support btrfs send ioctl
Date: Wed,  4 Jul 2012 15:39:33 +0200
Message-Id: <1341409174-13619-6-git-send-email-ablock84@googlemail.com>
In-Reply-To: <1341409174-13619-1-git-send-email-ablock84@googlemail.com>
References: <1341409174-13619-1-git-send-email-ablock84@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add btrfs_ioctl_send_args and BTRFS_IOC_SEND to ioctl.h

Signed-off-by: Alexander Block <ablock84@googlemail.com>
---
 ioctl.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/ioctl.h b/ioctl.h
index 77503e6..d35710c 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -282,6 +282,15 @@ struct btrfs_ioctl_received_subvol_args {
 	__u64	reserved[16];
 };
 
+struct btrfs_ioctl_send_args {
+	__s64 send_fd;			/* in */
+	__u64 clone_sources_count;	/* in */
+	__u64 *clone_sources;		/* in */
+	__u64 parent_root;		/* in */
+	__u64 flags;			/* in */
+	__u64 reserved[4];		/* in */
+};
+
 /* BTRFS_IOC_SNAP_CREATE is no longer used by the btrfs command */
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
@@ -353,4 +362,6 @@ struct btrfs_ioctl_clone_range_args {
 
 #define BTRFS_IOC_SET_RECEIVED_SUBVOL _IOWR(BTRFS_IOCTL_MAGIC, 37, \
 				struct btrfs_ioctl_received_subvol_args)
+#define BTRFS_IOC_SEND _IOW(BTRFS_IOCTL_MAGIC, 38, struct btrfs_ioctl_send_args)
+
 #endif
-- 
1.7.10

