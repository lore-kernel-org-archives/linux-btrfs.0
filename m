Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f48.google.com ([74.125.83.48]:34973 "EHLO
        mail-pg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752398AbdHBSw0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Aug 2017 14:52:26 -0400
Received: by mail-pg0-f48.google.com with SMTP id v189so24532478pgd.2
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Aug 2017 11:52:25 -0700 (PDT)
From: filipbystricky@google.com
To: linux-btrfs@vger.kernel.org
Cc: salyzyn@android.com, Filip Bystricky <filipbystricky@google.com>
Subject: [PATCH 3/3] compile error fixes
Date: Wed,  2 Aug 2017 11:51:11 -0700
Message-Id: <20170802185111.187922-3-filipbystricky@google.com>
In-Reply-To: <20170802185111.187922-1-filipbystricky@google.com>
References: <20170802185111.187922-1-filipbystricky@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filip Bystricky <filipbystricky@google.com>

Android currently does not fully support libblkid, and android's bionic 
doesn't implement some pthread extras such as pthread_tryjoin_np and 
pthread_cancel. This patch fixes the resulting errors while trying to 
be as unobtrusive as possible, and is therefore just a temporary fix. 
For complete support of tools that use background tasks, the way those
are managed (in particular, how they are cancelled) would need to be 
reworked.

Signed-off-by: Filip Bystricky <filipbystricky@google.com>
Reviewed-by: Mark Salyzyn <salyzyn@android.com>
---
 androidcompat.h | 38 ++++++++++++++++++++++++++++++++------
 cmds-scrub.c    |  5 +++++
 mkfs/common.c   |  8 ++++++++
 mkfs/main.c     |  7 +++++++
 task-utils.c    |  1 +
 utils.c         | 18 ++++++++++++++++++
 utils.h         |  1 +
 7 files changed, 72 insertions(+), 6 deletions(-)

diff --git a/androidcompat.h b/androidcompat.h
index eec76dad..bd0be172 100644
--- a/androidcompat.h
+++ b/androidcompat.h
@@ -7,22 +7,48 @@
 #ifndef __ANDROID_H__
 #define __ANDROID_H__
 
-#ifdef ANDROID
-
-#define pthread_setcanceltype(type, oldtype)	(0)
-#define pthread_setcancelstate(state, oldstate)	(0)
+#ifdef __BIONIC__
 
+/*
+ * Bionic doesn't implement pthread_cancel or helpers.
+ *
+ * TODO: this is a temporary fix to just get the tools to compile.
+ * What we really want is to rework how background tasks are managed.
+ * All of the threads that are being cancelled are running in infinite loops.
+ * They should instead be checking a flag at each iteration to see if they
+ * should continue. Then cancelling would just be a matter of setting the flag.
+ *
+ * Most background tasks are managed using btrfs's task_utils library, in which
+ * case they are passed a task_ctx struct pointer.
+ *
+ * However, in two cases, they are created and cancelled directly with the pthread library:
+ *   - chunk-recover.c:scan_devices creates a thread for each device to scan, giving
+ *     each a struct device_scan*.
+ *   - cmds-scrub.c:scrub_start creates a single thread and gives it a struct task_ctx*.
+ *
+ * Breakdown by command:
+ *   - btrfs check (cmds-check.c) uses a task (task_ctx) for indicating progress
+ *   - mkfs.btrfs (mkfs/main.c) doesn't appear to use any background tasks.
+ */
 #define pthread_cancel(ret)	pthread_kill((ret), SIGUSR1)
 
+/*
+ * If given pointers are non-null, just zero out the pointed-to value.
+ * This also eliminates some unused variable warnings.
+ */
+#define pthread_setcanceltype(type, oldtype)	((oldtype) ? (*(oldtype) = 0) : 0)
+#define pthread_setcancelstate(state, oldstate)	((oldstate) ? (*(oldstate) = 0) : 0)
+#define pthread_tryjoin_np(thread, retval) ((retval) ? ((int)(*(retval) = NULL)) : 0)
+
 typedef struct blkid_struct_probe *blkid_probe;
 
 #include <dirent.h>
 #define direct dirent
 
-#else	/* !ANDROID */
+#else	/* !__BIONIC__ */
 
 #include <sys/dir.h>
 
-#endif	/* !ANDROID */
+#endif	/* !__BIONIC__ */
 
 #endif	/* __ANDROID_H__ */
diff --git a/cmds-scrub.c b/cmds-scrub.c
index 5388fdcf..5d8f6c24 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -46,6 +46,11 @@
 #include "commands.h"
 #include "help.h"
 
+#if defined(__BIONIC__) && !defined(PTHREAD_CANCELED)
+/* bionic's pthread does not define PTHREAD_CANCELED */
+#define PTHREAD_CANCELED   ((void *)-1)
+#endif
+
 static const char * const scrub_cmd_group_usage[] = {
 	"btrfs scrub <command> [options] <path>|<device>",
 	NULL
diff --git a/mkfs/common.c b/mkfs/common.c
index 1e8f26ea..0e4d5c39 100644
--- a/mkfs/common.c
+++ b/mkfs/common.c
@@ -549,6 +549,13 @@ out:
  *	 0 for nothing found
  *	-1 for internal error
  */
+#ifdef ANDROID /* none of these blkid functions exist in Android */
+static int check_overwrite(const char *device)
+{
+	/* We can't tell, so assume there is an existing fs or partition */
+	return 1;
+}
+#else
 static int check_overwrite(const char *device)
 {
 	const char	*type;
@@ -619,6 +626,7 @@ out:
 			  "existing filesystem.\n", device);
 	return ret;
 }
+#endif /* ANDROID */
 
 /*
  * Check if a device is suitable for btrfs
diff --git a/mkfs/main.c b/mkfs/main.c
index 61f746b3..8ebb11a4 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -1149,6 +1149,12 @@ static int zero_output_file(int out_fd, u64 size)
 	return ret;
 }
 
+#ifdef ANDROID /* all Androids use ssd (and android currently does not fully support libblkid) */
+static int is_ssd(const char *file)
+{
+	return 1;
+}
+#else
 static int is_ssd(const char *file)
 {
 	blkid_probe probe;
@@ -1196,6 +1202,7 @@ static int is_ssd(const char *file)
 
 	return rotational == '0';
 }
+#endif /* ANDROID */
 
 static int _cmp_device_by_id(void *priv, struct list_head *a,
 			     struct list_head *b)
diff --git a/task-utils.c b/task-utils.c
index 12b00027..1e89f13c 100644
--- a/task-utils.c
+++ b/task-utils.c
@@ -21,6 +21,7 @@
 #include <unistd.h>
 
 #include "task-utils.h"
+#include "androidcompat.h"
 
 struct task_info *task_init(void *(*threadfn)(void *), int (*postfn)(void *),
 			    void *thread_private)
diff --git a/utils.c b/utils.c
index d2489e70..bd1c8ec0 100644
--- a/utils.c
+++ b/utils.c
@@ -258,6 +258,23 @@ out:
 	return ret;
 }
 
+#ifdef ANDROID
+/*
+ * TODO: bring liblkid into the tree, or implement an alternative way to wipe the superblock.
+ * The android tree currently doesn't have blkid_new_probe or blkid_probe_set_device,
+ * so this function is not supported.
+ * btrfs_wipe_existing_sb returns 1 to indicate a soft error (see below).
+ * For now, we consider lack of blkid support to be a soft error.
+ * IMPORTANT: this means that mkfs.btrfs will not currently wipe an existing superblock
+ * on android!
+ */
+static int btrfs_wipe_existing_sb(int fd)
+{
+	error("cannot wipe existing superblock (fd = %d): "
+		  "missing functions blkid_new_probe and blkid_set_device", fd);
+	return 1;
+}
+#else
 static int btrfs_wipe_existing_sb(int fd)
 {
 	const char *off = NULL;
@@ -308,6 +325,7 @@ out:
 	blkid_free_probe(pr);
 	return ret;
 }
+#endif /* ANDROID */
 
 int btrfs_prepare_device(int fd, const char *file, u64 *block_count_ret,
 		u64 max_block_count, unsigned opflags)
diff --git a/utils.h b/utils.h
index 24d0a200..f8a522fb 100644
--- a/utils.h
+++ b/utils.h
@@ -28,6 +28,7 @@
 #include "btrfs-list.h"
 #include "sizes.h"
 #include "messages.h"
+#include "androidcompat.h"
 
 #define BTRFS_SCAN_MOUNTED	(1ULL << 0)
 #define BTRFS_SCAN_LBLKID	(1ULL << 1)
-- 
2.14.0.rc1.383.gd1ce394fe2-goog

