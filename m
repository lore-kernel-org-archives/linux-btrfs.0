Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:33326 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbbL1Q00 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Dec 2015 11:26:26 -0500
From: Sanidhya Solanki <jpage.lkml@gmail.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sanidhya Solanki <jpage.lkml@gmail.com>
Subject: [PATCH] BTRFS: Adds an option to select RAID Stripe size
Date: Mon, 28 Dec 2015 07:24:11 -0500
Message-Id: <1451305451-31222-1-git-send-email-jpage.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

An option to select the RAID Stripe size is made
available in the BTRFS Filesystem, via an option
in the BTRFS Config setup, with minimal change
to the existing code base.

Signed-off-by: Sanidhya Solanki <jpage.lkml@gmail.com>
---
 fs/btrfs/Kconfig   | 42 ++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/Makefile  |  2 ++
 fs/btrfs/scrub.c   |  4 ++++
 fs/btrfs/super.c   |  4 ++++
 fs/btrfs/volumes.c |  2 +-
 fs/btrfs/volumes.h |  4 +++-
 6 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index 80e9c18..1454d21 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -28,6 +28,48 @@ config BTRFS_FS
 
 	  If unsure, say N.
 
+choice
+         prompt "Choose Stripe Size"
+         default RS_1024
+         help
+           Allows you to select the size of the stripe, which is the smallest sized
+           data block to be replicated.
+           Selecting a larger size than your physical block size may lead to data
+           fragmentation in some cases.
+
+        config RS_512
+                 bool "512 bytes"
+
+        config RS_1024
+                 bool "1024 bytes"
+
+        config RS_2048
+                 bool "2048 bytes"
+
+        config RS_4096
+                 bool "4096 bytes"
+
+        config RS_8192
+                 bool "8192 bytes"
+
+        config RS_16384
+                 bool "16384 bytes"
+
+        config RS_32768
+                 bool "32768 bytes"
+
+endchoice
+
+config BTRFS_RAID_STRIPE
+        int
+        default 512 if RS_512
+        default 1024 if RS_1024
+        default 2048 if RS_2048
+        default 4096 if RS_4096
+        default 8192 if RS_8192
+        default 16384 if RS_16384
+        default 32768 if RS_32768
+
 config BTRFS_FS_POSIX_ACL
 	bool "Btrfs POSIX Access Control Lists"
 	depends on BTRFS_FS
diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index 6d1d0b9..1c4e384 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -17,3 +17,5 @@ btrfs-$(CONFIG_BTRFS_FS_CHECK_INTEGRITY) += check-integrity.o
 btrfs-$(CONFIG_BTRFS_FS_RUN_SANITY_TESTS) += tests/free-space-tests.o \
 	tests/extent-buffer-tests.o tests/btrfs-tests.o \
 	tests/extent-io-tests.o tests/inode-tests.o tests/qgroup-tests.o
+
+btrfs-$(CONFIG_BTRFS_RAID_STRIPE) += scrub.o super.o volumes.o
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index b091d94..4d0f802 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -63,6 +63,10 @@ struct scrub_ctx;
  */
 #define SCRUB_MAX_PAGES_PER_BLOCK	16	/* 64k per node/leaf/sector */
 
+#define STRIPE_LENGTH CONFIG_BTRFS_RAID_STRIPE
+
+#define BTRFS_STRIPE_LEN	(64 * STRIPE_LENGTH)
+
 struct scrub_recover {
 	atomic_t		refs;
 	struct btrfs_bio	*bbio;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 24154e4..3d91f8d 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -64,6 +64,10 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/btrfs.h>
 
+#define STRIPE_LENGTH CONFIG_BTRFS_RAID_STRIPE
+
+#define BTRFS_STRIPE_LEN	(64 * STRIPE_LENGTH)
+
 static const struct super_operations btrfs_super_ops;
 static struct file_system_type btrfs_fs_type;
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 4564522..e1b2e5c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4461,7 +4461,7 @@ static int btrfs_cmp_device_info(const void *a, const void *b)
 static u32 find_raid56_stripe_len(u32 data_devices, u32 dev_stripe_target)
 {
 	/* TODO allow them to set a preferred stripe size */
-	return 64 * 1024;
+	return BTRFS_STRIPE_LEN;
 }
 
 static void check_raid56_incompat_flag(struct btrfs_fs_info *info, u64 type)
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index d5c84f6..9115a80 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -26,7 +26,9 @@
 
 extern struct mutex uuid_mutex;
 
-#define BTRFS_STRIPE_LEN	(64 * 1024)
+#define STRIPE_LENGTH CONFIG_BTRFS_RAID_STRIPE
+
+#define BTRFS_STRIPE_LEN	(64 * STRIPE_LENGTH)
 
 struct buffer_head;
 struct btrfs_pending_bios {
-- 
2.5.0

