Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60252 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242Ab2FYVgT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jun 2012 17:36:19 -0400
Received: by bkcji2 with SMTP id ji2so3662478bkc.19
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Jun 2012 14:36:18 -0700 (PDT)
From: Alexander Block <ablock84@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: Alexander Block <ablock84@googlemail.com>
Subject: [PATCH] Btrfs: use _IOR for BTRFS_IOC_SUBVOL_GETFLAGS
Date: Mon, 25 Jun 2012 23:36:12 +0200
Message-Id: <1340660172-1531-1-git-send-email-ablock84@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We used the wrong ioctl macro for the getflags ioctl before.
As we don't have the set/getflags ioctls in the user space ioctl.h
at the moment, it's safe to fix it now.

Signed-off-by: Alexander Block <ablock84@googlemail.com>
---
 fs/btrfs/ioctl.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 497c530..e440aa6 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -339,7 +339,7 @@ struct btrfs_ioctl_get_dev_stats {
 #define BTRFS_IOC_WAIT_SYNC  _IOW(BTRFS_IOCTL_MAGIC, 22, __u64)
 #define BTRFS_IOC_SNAP_CREATE_V2 _IOW(BTRFS_IOCTL_MAGIC, 23, \
 				   struct btrfs_ioctl_vol_args_v2)
-#define BTRFS_IOC_SUBVOL_GETFLAGS _IOW(BTRFS_IOCTL_MAGIC, 25, __u64)
+#define BTRFS_IOC_SUBVOL_GETFLAGS _IOR(BTRFS_IOCTL_MAGIC, 25, __u64)
 #define BTRFS_IOC_SUBVOL_SETFLAGS _IOW(BTRFS_IOCTL_MAGIC, 26, __u64)
 #define BTRFS_IOC_SCRUB _IOWR(BTRFS_IOCTL_MAGIC, 27, \
 			      struct btrfs_ioctl_scrub_args)
-- 
1.7.10

