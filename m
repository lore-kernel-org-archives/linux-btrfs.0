Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61425 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760927AbbBIUDz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Feb 2015 15:03:55 -0500
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 15/16] Btrfs-progs: skip opening all devices with restore
Date: Mon, 9 Feb 2015 15:03:18 -0500
Message-ID: <1423512199-16552-16-git-send-email-jbacik@fb.com>
In-Reply-To: <1423512199-16552-1-git-send-email-jbacik@fb.com>
References: <1423512199-16552-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we go to fixup the dev items after a restore we scan all existing devices.
If you happen to be a btrfs developer you could possibly open up some random
device that you didn't just restore onto, which gives you weird errors and makes
you super cranky and waste a day trying to figure out what is failing.  This
will make it so that we use the fd we've already opened for opening our ctree.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 btrfs-find-root.c | 2 +-
 btrfs-image.c     | 9 ++++++---
 chunk-recover.c   | 2 +-
 disk-io.c         | 8 +++++---
 disk-io.h         | 3 ++-
 super-recover.c   | 2 +-
 6 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index 3edb833..c6e6b82 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -79,7 +79,7 @@ static struct btrfs_root *open_ctree_broken(int fd, const char *device)
 		return NULL;
 	}
 
-	ret = btrfs_scan_fs_devices(fd, device, &fs_devices, 0, 1);
+	ret = btrfs_scan_fs_devices(fd, device, &fs_devices, 0, 1, 0);
 	if (ret)
 		goto out;
 
diff --git a/btrfs-image.c b/btrfs-image.c
index 3c78388..04ec473 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -2557,16 +2557,19 @@ static int restore_metadump(const char *input, FILE *out, int old_restore,
 	ret = wait_for_worker(&mdrestore);
 
 	if (!ret && !multi_devices && !old_restore) {
+		struct btrfs_root *root;
 		struct stat st;
 
-		info = open_ctree_fs_info(target, 0, 0,
+		root = open_ctree_fd(fileno(out), target, 0,
 					  OPEN_CTREE_PARTIAL |
-					  OPEN_CTREE_WRITES);
-		if (!info) {
+					  OPEN_CTREE_WRITES |
+					  OPEN_CTREE_NO_DEVICES);
+		if (!root) {
 			fprintf(stderr, "unable to open %s\n", target);
 			ret = -EIO;
 			goto out;
 		}
+		info = root->fs_info;
 
 		if (stat(target, &st)) {
 			fprintf(stderr, "statting %s failed\n", target);
diff --git a/chunk-recover.c b/chunk-recover.c
index 94efc43..832b3b1 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1520,7 +1520,7 @@ static int recover_prepare(struct recover_control *rc, char *path)
 		goto fail_free_sb;
 	}
 
-	ret = btrfs_scan_fs_devices(fd, path, &fs_devices, 0, 1);
+	ret = btrfs_scan_fs_devices(fd, path, &fs_devices, 0, 1, 0);
 	if (ret)
 		goto fail_free_sb;
 
diff --git a/disk-io.c b/disk-io.c
index ca39f17..0aec56e 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1006,7 +1006,8 @@ void btrfs_cleanup_all_caches(struct btrfs_fs_info *fs_info)
 
 int btrfs_scan_fs_devices(int fd, const char *path,
 			  struct btrfs_fs_devices **fs_devices,
-			  u64 sb_bytenr, int super_recover)
+			  u64 sb_bytenr, int super_recover,
+			  int skip_devices)
 {
 	u64 total_devs;
 	u64 dev_size;
@@ -1033,7 +1034,7 @@ int btrfs_scan_fs_devices(int fd, const char *path,
 		return ret;
 	}
 
-	if (total_devs != 1) {
+	if (!skip_devices && total_devs != 1) {
 		ret = btrfs_scan_lblkid();
 		if (ret)
 			return ret;
@@ -1114,7 +1115,8 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 		fs_info->on_restoring = 1;
 
 	ret = btrfs_scan_fs_devices(fp, path, &fs_devices, sb_bytenr,
-				    (flags & OPEN_CTREE_RECOVER_SUPER));
+				    (flags & OPEN_CTREE_RECOVER_SUPER),
+				    (flags & OPEN_CTREE_NO_DEVICES));
 	if (ret)
 		goto out;
 
diff --git a/disk-io.h b/disk-io.h
index f963a96..53df8f0 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -33,6 +33,7 @@ enum btrfs_open_ctree_flags {
 	OPEN_CTREE_RESTORE		= (1 << 4),
 	OPEN_CTREE_NO_BLOCK_GROUPS	= (1 << 5),
 	OPEN_CTREE_EXCLUSIVE		= (1 << 6),
+	OPEN_CTREE_NO_DEVICES		= (1 << 7),
 };
 
 static inline u64 btrfs_sb_offset(int mirror)
@@ -68,7 +69,7 @@ void btrfs_release_all_roots(struct btrfs_fs_info *fs_info);
 void btrfs_cleanup_all_caches(struct btrfs_fs_info *fs_info);
 int btrfs_scan_fs_devices(int fd, const char *path,
 			  struct btrfs_fs_devices **fs_devices, u64 sb_bytenr,
-			  int super_recover);
+			  int super_recover, int skip_devices);
 int btrfs_setup_chunk_tree_and_device_map(struct btrfs_fs_info *fs_info);
 
 struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr,
diff --git a/super-recover.c b/super-recover.c
index 197fc4b..e2c3129 100644
--- a/super-recover.c
+++ b/super-recover.c
@@ -279,7 +279,7 @@ int btrfs_recover_superblocks(const char *dname,
 	}
 	init_recover_superblock(&recover);
 
-	ret = btrfs_scan_fs_devices(fd, dname, &recover.fs_devices, 0, 1);
+	ret = btrfs_scan_fs_devices(fd, dname, &recover.fs_devices, 0, 1, 0);
 	close(fd);
 	if (ret) {
 		ret = 1;
-- 
1.8.3.1

