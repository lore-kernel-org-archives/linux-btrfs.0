Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:65422 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757060Ab3DASBc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Apr 2013 14:01:32 -0400
Message-ID: <1364839290.21627.67.camel@x61.thuisdomein>
Subject: [PATCH 5/8] btrfs: do not export "u64" to userspace
From: Paul Bolle <pebolle@tiscali.nl>
To: Chris Mason <chris.mason@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 01 Apr 2013 20:01:30 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs.h exports "u64" to userspace. Use "__u64" instead.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested with a kernel build. I'm not familiar with userspace code using
btrfs.h.

 include/uapi/linux/btrfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index fa3a5f9..3ee970b 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -460,7 +460,7 @@ struct btrfs_ioctl_send_args {
 				   struct btrfs_ioctl_search_args)
 #define BTRFS_IOC_INO_LOOKUP _IOWR(BTRFS_IOCTL_MAGIC, 18, \
 				   struct btrfs_ioctl_ino_lookup_args)
-#define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 19, u64)
+#define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 19, __u64)
 #define BTRFS_IOC_SPACE_INFO _IOWR(BTRFS_IOCTL_MAGIC, 20, \
 				    struct btrfs_ioctl_space_args)
 #define BTRFS_IOC_START_SYNC _IOR(BTRFS_IOCTL_MAGIC, 24, __u64)
-- 
1.7.11.7

