Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.dpl.mendix.net ([83.96.177.10]:36995 "EHLO
	smtp.dpl.mendix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156AbcGCVcb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Jul 2016 17:32:31 -0400
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
To: linux-btrfs@vger.kernel.org
Cc: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Subject: [PATCH] btrfs-progs: use the correct struct for BTRFS_IOC_LOGICAL_INO
Date: Sun,  3 Jul 2016 23:22:26 +0200
Message-Id: <1467580946-2899-1-git-send-email-hans.van.kranenburg@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

BTRFS_IOC_LOGICAL_INO takes a btrfs_ioctl_logical_ino_args as argument,
not a btrfs_ioctl_ino_path_args. The lines were probably copy/pasted
when the code was written.

Since btrfs_ioctl_logical_ino_args and btrfs_ioctl_ino_path_args have
the same size, the actual IOCTL definition here does not change.

But, it makes the code less confusing for the reader.

Signed-off-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
---
 ioctl.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ioctl.h b/ioctl.h
index 5f18bcb..620dd3d 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -685,7 +685,7 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 #define BTRFS_IOC_INO_PATHS _IOWR(BTRFS_IOCTL_MAGIC, 35, \
 					struct btrfs_ioctl_ino_path_args)
 #define BTRFS_IOC_LOGICAL_INO _IOWR(BTRFS_IOCTL_MAGIC, 36, \
-					struct btrfs_ioctl_ino_path_args)
+					struct btrfs_ioctl_logical_ino_args)
 #define BTRFS_IOC_SET_RECEIVED_SUBVOL _IOWR(BTRFS_IOCTL_MAGIC, 37, \
 				struct btrfs_ioctl_received_subvol_args)
 #define BTRFS_IOC_SEND _IOW(BTRFS_IOCTL_MAGIC, 38, struct btrfs_ioctl_send_args)
-- 
2.8.1

