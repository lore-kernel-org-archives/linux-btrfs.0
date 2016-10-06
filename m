Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44314 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941813AbcJFNlt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Oct 2016 09:41:49 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D7FA7ADAA
        for <linux-btrfs@vger.kernel.org>; Thu,  6 Oct 2016 13:41:47 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/4] btrfs-progs: ioctl: add 64bit compat for SEND
Date: Thu,  6 Oct 2016 15:41:40 +0200
Message-Id: <20161006134141.837-4-dsterba@suse.com>
In-Reply-To: <20161006134141.837-1-dsterba@suse.com>
References: <20161006134141.837-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The ioctl value of SEND will be different on 32bit userspace and 64bit
kernel due to different pointer type width, that unfortunatelly made it
into the structure definition.

To maintain backward compatibility, we must do it in the 64bit->32bit
way, because we don't have the kernel side workardound like
SET_RECEIVED_SUBVOL has.  Changing value of SEND would then break
existing users of the raw ioctl.

The compatibility structure and ioctl should not be used, exists for
documentation, and testing.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 ioctl.h | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/ioctl.h b/ioctl.h
index 6baa51ab1724..f7233da90637 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -635,8 +635,8 @@ struct btrfs_ioctl_send_args {
 	__u64 reserved[4];		/* in */
 } __attribute__((packed));
 /*
- * Size of structure depends on pointer width, was not caught.  Kernel handles
- * pointer width differences transparently
+ * Size of structure depends on pointer width, was not caught in the early
+ * days.  Kernel handles pointer width differences transparently.
  */
 BUILD_ASSERT(sizeof(__u64 *) == 8
 	     ? sizeof(struct btrfs_ioctl_send_args) == 72
@@ -644,6 +644,28 @@ BUILD_ASSERT(sizeof(__u64 *) == 8
 		? sizeof(struct btrfs_ioctl_send_args) == 68
 		: 0));
 
+/*
+ * Different pointer width leads to structure size change. Kernel should accept
+ * both ioctl values (derived from the structures) for backward compatibility.
+ * Size of this structure is same on 32bit and 64bit though.
+ *
+ * NOTE: do not use in your code, this is for testing only
+ */
+struct btrfs_ioctl_send_args_64 {
+	__s64 send_fd;			/* in */
+	__u64 clone_sources_count;	/* in */
+	union {
+		__u64 __user *clone_sources;	/* in */
+		__u64 __clone_sources_alignment;
+	};
+	__u64 parent_root;		/* in */
+	__u64 flags;			/* in */
+	__u64 reserved[4];		/* in */
+} __attribute__((packed));
+BUILD_ASSERT(sizeof(struct btrfs_ioctl_send_args_64) == 72);
+
+#define BTRFS_IOC_SEND_64_COMPAT_DEFINED 1
+
 /* Error codes as returned by the kernel */
 enum btrfs_err_code {
 	notused,
@@ -761,6 +783,11 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 				struct btrfs_ioctl_received_subvol_args_32)
 #endif
 
+#ifdef BTRFS_IOC_SEND_64_COMPAT_DEFINED
+#define BTRFS_IOC_SEND_64 _IOW(BTRFS_IOCTL_MAGIC, 38, \
+		struct btrfs_ioctl_send_args_64)
+#endif
+
 #define BTRFS_IOC_SEND _IOW(BTRFS_IOCTL_MAGIC, 38, struct btrfs_ioctl_send_args)
 #define BTRFS_IOC_DEVICES_READY _IOR(BTRFS_IOCTL_MAGIC, 39, \
 				     struct btrfs_ioctl_vol_args)
-- 
2.10.0

