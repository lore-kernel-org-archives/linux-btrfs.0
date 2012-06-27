Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38676 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab2F0NRD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jun 2012 09:17:03 -0400
Received: by bkcji2 with SMTP id ji2so935423bkc.19
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jun 2012 06:17:02 -0700 (PDT)
From: Alexander Block <ablock84@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: Alexander Block <ablock84@googlemail.com>
Subject: [RFC PATCHv2 1/3] Btrfs-progs: add BTRFS_IOC_SUBVOL_GET/SETFLAGS to ioctl.h
Date: Wed, 27 Jun 2012 15:16:49 +0200
Message-Id: <1340803011-21882-2-git-send-email-ablock84@googlemail.com>
In-Reply-To: <1340803011-21882-1-git-send-email-ablock84@googlemail.com>
References: <1340803011-21882-1-git-send-email-ablock84@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs send/receive and btrfs props needs this ioctl. This patch
requires a recent kernel with the "Btrfs: use _IOR for
BTRFS_IOC_SUBVOL_GETFLAGS" patch applied.

Signed-off-by: Alexander Block <ablock84@googlemail.com>
---
 ioctl.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/ioctl.h b/ioctl.h
index f2e5d8d..6670e08 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -312,6 +312,8 @@ struct btrfs_ioctl_logical_ino_args {
 				    struct btrfs_ioctl_space_args)
 #define BTRFS_IOC_SNAP_CREATE_V2 _IOW(BTRFS_IOCTL_MAGIC, 23, \
 				   struct btrfs_ioctl_vol_args_v2)
+#define BTRFS_IOC_SUBVOL_GETFLAGS _IOR(BTRFS_IOCTL_MAGIC, 25, __u64)
+#define BTRFS_IOC_SUBVOL_SETFLAGS _IOW(BTRFS_IOCTL_MAGIC, 26, __u64)
 #define BTRFS_IOC_SCRUB _IOWR(BTRFS_IOCTL_MAGIC, 27, \
 				struct btrfs_ioctl_scrub_args)
 #define BTRFS_IOC_SCRUB_CANCEL _IO(BTRFS_IOCTL_MAGIC, 28)
-- 
1.7.10

