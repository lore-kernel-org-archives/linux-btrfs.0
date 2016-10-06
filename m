Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44302 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752199AbcJFNlq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Oct 2016 09:41:46 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4A082ADB2
        for <linux-btrfs@vger.kernel.org>; Thu,  6 Oct 2016 13:41:45 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/4] btrfs-progs: ioctl: pack structures
Date: Thu,  6 Oct 2016 15:41:38 +0200
Message-Id: <20161006134141.837-2-dsterba@suse.com>
In-Reply-To: <20161006134141.837-1-dsterba@suse.com>
References: <20161006134141.837-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add the packed attribute to several structures so we avoid any
accidental size changes due to compiler-dependent padding.

Expected alignment is 8 bytes, padded where needed.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 ioctl.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/ioctl.h b/ioctl.h
index a7235c00c1a0..d0c06657f0c0 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -149,7 +149,7 @@ struct btrfs_ioctl_scrub_args {
 	struct btrfs_scrub_progress progress;	/* out */
 	/* pad to 1k */
 	__u64 unused[(1024-32-sizeof(struct btrfs_scrub_progress))/8];
-};
+} __attribute__((packed));
 BUILD_ASSERT(sizeof(struct btrfs_ioctl_scrub_args) == 1024);
 
 #define BTRFS_IOCTL_DEV_REPLACE_CONT_READING_FROM_SRCDEV_MODE_ALWAYS	0
@@ -160,7 +160,7 @@ struct btrfs_ioctl_dev_replace_start_params {
 						 * above */
 	__u8 srcdev_name[BTRFS_DEVICE_PATH_NAME_MAX + 1];	/* in */
 	__u8 tgtdev_name[BTRFS_DEVICE_PATH_NAME_MAX + 1];	/* in */
-};
+} __attribute__((packed, aligned (8)));
 BUILD_ASSERT(sizeof(struct btrfs_ioctl_dev_replace_start_params) == 2072);
 
 #define BTRFS_IOCTL_DEV_REPLACE_STATE_NEVER_STARTED	0
@@ -175,7 +175,7 @@ struct btrfs_ioctl_dev_replace_status_params {
 	__u64 time_stopped;	/* out, seconds since 1-Jan-1970 */
 	__u64 num_write_errors;	/* out */
 	__u64 num_uncorrectable_read_errors;	/* out */
-};
+} __attribute__((packed));
 BUILD_ASSERT(sizeof(struct btrfs_ioctl_dev_replace_status_params) == 48);
 
 #define BTRFS_IOCTL_DEV_REPLACE_CMD_START			0
@@ -556,7 +556,7 @@ BUILD_ASSERT(sizeof(struct btrfs_ioctl_qgroup_create_args) == 16);
 struct btrfs_ioctl_timespec {
 	__u64 sec;
 	__u32 nsec;
-};
+} __attribute__((packed, aligned (8)));
 
 struct btrfs_ioctl_received_subvol_args {
 	char	uuid[BTRFS_UUID_SIZE];	/* in */
@@ -601,7 +601,7 @@ struct btrfs_ioctl_send_args {
 	__u64 parent_root;		/* in */
 	__u64 flags;			/* in */
 	__u64 reserved[4];		/* in */
-};
+} __attribute__((packed));
 /*
  * Size of structure depends on pointer width, was not caught.  Kernel handles
  * pointer width differences transparently
-- 
2.10.0

