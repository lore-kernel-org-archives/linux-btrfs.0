Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41559 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab2FXVUb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Jun 2012 17:20:31 -0400
Received: by mail-bk0-f46.google.com with SMTP id ji2so2680230bkc.19
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Jun 2012 14:20:30 -0700 (PDT)
From: Alexander Block <ablock84@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: Alexander Block <ablock84@googlemail.com>
Subject: [PATCH 1/5] Btrfs-progs: add BTRFS_IOC_SUBVOL_GET/SETFLAGS to ioctl.h
Date: Sun, 24 Jun 2012 23:20:04 +0200
Message-Id: <1340572808-30281-2-git-send-email-ablock84@googlemail.com>
In-Reply-To: <1340572808-30281-1-git-send-email-ablock84@googlemail.com>
References: <1340572808-30281-1-git-send-email-ablock84@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs send/receive needs this ioctl to make a subvolume
r/o after it was received.
---
 ioctl.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/ioctl.h b/ioctl.h
index f2e5d8d..d6311f6 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -312,6 +312,8 @@ struct btrfs_ioctl_logical_ino_args {
 				    struct btrfs_ioctl_space_args)
 #define BTRFS_IOC_SNAP_CREATE_V2 _IOW(BTRFS_IOCTL_MAGIC, 23, \
 				   struct btrfs_ioctl_vol_args_v2)
+#define BTRFS_IOC_SUBVOL_GETFLAGS _IOW(BTRFS_IOCTL_MAGIC, 25, __u64)
+#define BTRFS_IOC_SUBVOL_SETFLAGS _IOW(BTRFS_IOCTL_MAGIC, 26, __u64)
 #define BTRFS_IOC_SCRUB _IOWR(BTRFS_IOCTL_MAGIC, 27, \
 				struct btrfs_ioctl_scrub_args)
 #define BTRFS_IOC_SCRUB_CANCEL _IO(BTRFS_IOCTL_MAGIC, 28)
-- 
1.7.10

