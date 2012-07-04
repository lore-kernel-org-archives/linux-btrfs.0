Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60596 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab2GDNiu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jul 2012 09:38:50 -0400
Received: by bkwj10 with SMTP id j10so2632593bkw.19
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Jul 2012 06:38:49 -0700 (PDT)
From: Alexander Block <ablock84@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: Alexander Block <ablock84@googlemail.com>
Subject: [RFC PATCH 1/7] Btrfs: use _IOR for BTRFS_IOC_SUBVOL_GETFLAGS
Date: Wed,  4 Jul 2012 15:38:22 +0200
Message-Id: <1341409108-13567-2-git-send-email-ablock84@googlemail.com>
In-Reply-To: <1341409108-13567-1-git-send-email-ablock84@googlemail.com>
References: <1341409108-13567-1-git-send-email-ablock84@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We used the wrong ioctl macro for the getflags ioctl before.
As we don't have the set/getflags ioctls in the user space ioctl.h
at the moment, it's safe to fix it now.

Reviewed-by: David Sterba <dsterba@suse.cz>
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

