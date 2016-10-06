Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44309 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753055AbcJFNls (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Oct 2016 09:41:48 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AE357ADC2
        for <linux-btrfs@vger.kernel.org>; Thu,  6 Oct 2016 13:41:46 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/4] btrfs-progs: ioctl: add 32bit compat for SET_RECEIVED_SUBVOL
Date: Thu,  6 Oct 2016 15:41:39 +0200
Message-Id: <20161006134141.837-3-dsterba@suse.com>
In-Reply-To: <20161006134141.837-1-dsterba@suse.com>
References: <20161006134141.837-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The ioctl value of SET_RECEIVED_SUBVOL will be different on 32bit
userspace and 64bit kernel. This is transparently handled on the kernel
side. We now define the same structure so we can verify the ioctl value.

The defined structure and ioctl should not be used. It is exists only
for testing purposes, documenting the mess and as a warning for the
future.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 ioctl.h | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/ioctl.h b/ioctl.h
index d0c06657f0c0..6baa51ab1724 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -570,6 +570,38 @@ struct btrfs_ioctl_received_subvol_args {
 BUILD_ASSERT(sizeof(struct btrfs_ioctl_received_subvol_args) == 200);
 
 /*
+ * If we have a 32-bit userspace and 64-bit kernel, then the UAPI
+ * structures are incorrect, as the timespec structure from userspace
+ * is 4 bytes too small. We define these alternatives here for backward
+ * compatibility, the kernel understands both values.
+ */
+
+/*
+ * Structure size is different on 32bit and 64bit, has some padding if the
+ * structure is embedded. Packing makes sure the size is same on both, but will
+ * be misaligned on 64bit.
+ *
+ * NOTE: do not use in your code, this is for testing only
+ */
+struct btrfs_ioctl_timespec_32 {
+	__u64 sec;
+	__u32 nsec;
+} __attribute__ ((__packed__));
+
+struct btrfs_ioctl_received_subvol_args_32 {
+	char	uuid[BTRFS_UUID_SIZE];	/* in */
+	__u64	stransid;		/* in */
+	__u64	rtransid;		/* out */
+	struct btrfs_ioctl_timespec_32 stime; /* in */
+	struct btrfs_ioctl_timespec_32 rtime; /* out */
+	__u64	flags;			/* in */
+	__u64	reserved[16];		/* in */
+} __attribute__ ((__packed__));
+BUILD_ASSERT(sizeof(struct btrfs_ioctl_received_subvol_args_32) == 192);
+
+#define BTRFS_IOC_SET_RECEIVED_SUBVOL_32_COMPAT_DEFINED 1
+
+/*
  * Caller doesn't want file data in the send stream, even if the
  * search of clone sources doesn't find an extent. UPDATE_EXTENT
  * commands will be sent instead of WRITE commands.
@@ -723,6 +755,12 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 					struct btrfs_ioctl_logical_ino_args)
 #define BTRFS_IOC_SET_RECEIVED_SUBVOL _IOWR(BTRFS_IOCTL_MAGIC, 37, \
 				struct btrfs_ioctl_received_subvol_args)
+
+#ifdef BTRFS_IOC_SET_RECEIVED_SUBVOL_32_COMPAT_DEFINED
+#define BTRFS_IOC_SET_RECEIVED_SUBVOL_32 _IOWR(BTRFS_IOCTL_MAGIC, 37, \
+				struct btrfs_ioctl_received_subvol_args_32)
+#endif
+
 #define BTRFS_IOC_SEND _IOW(BTRFS_IOCTL_MAGIC, 38, struct btrfs_ioctl_send_args)
 #define BTRFS_IOC_DEVICES_READY _IOR(BTRFS_IOCTL_MAGIC, 39, \
 				     struct btrfs_ioctl_vol_args)
-- 
2.10.0

