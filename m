Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41824 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab2GDNkH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jul 2012 09:40:07 -0400
Received: by mail-bk0-f46.google.com with SMTP id j10so2633865bkw.19
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Jul 2012 06:40:06 -0700 (PDT)
From: Alexander Block <ablock84@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: Alexander Block <ablock84@googlemail.com>
Subject: [RFC PATCH 1/6] Btrfs-progs: add BTRFS_IOC_SUBVOL_GET/SETFLAGS to ioctl.h
Date: Wed,  4 Jul 2012 15:39:29 +0200
Message-Id: <1341409174-13619-2-git-send-email-ablock84@googlemail.com>
In-Reply-To: <1341409174-13619-1-git-send-email-ablock84@googlemail.com>
References: <1341409174-13619-1-git-send-email-ablock84@googlemail.com>
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

