Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:57714 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751785AbdK2JQU (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 29 Nov 2017 04:16:20 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 6/9] btrfs-progs: mkfs: Fix regression preventing --rootdir to create file
Date: Wed, 29 Nov 2017 17:16:01 +0800
Message-Id: <20171129091604.2194-7-wqu@suse.com>
In-Reply-To: <20171129091604.2194-1-wqu@suse.com>
References: <20171129091604.2194-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 460e93f25754 ("btrfs-progs: mkfs: check the status of file at mkfs")
will try to check the file state before creating fs on it.

The check is mostly fine for normal mkfs case, while for --rootdir
option, it's allowed to create new file if destination file doesn't
exist.

Fix it by allowing non-existing file if --rootdir is specified.

Fixes: 460e93f25754 ("btrfs-progs: mkfs: check the status of file at mkfs")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 mkfs/main.c |  6 ++++--
 utils.c     | 15 +++++++++++++++
 utils.h     |  1 +
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/mkfs/main.c b/mkfs/main.c
index 64cf03289188..a34b73bfb845 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -733,7 +733,7 @@ int main(int argc, char **argv)
 	u32 stripesize = 4096;
 	int zero_end = 1;
 	int fd = -1;
-	int ret;
+	int ret = 0;
 	int close_ret;
 	int i;
 	int mixed = 0;
@@ -913,7 +913,9 @@ int main(int argc, char **argv)
 
 	while (dev_cnt-- > 0) {
 		file = argv[optind++];
-		if (is_block_device(file) == 1)
+		if (source_dir_set && is_path_exist(file) == 0)
+			ret = 0;
+		else if (is_block_device(file) == 1)
 			ret = test_dev_for_mkfs(file, force_overwrite);
 		else
 			ret = test_status_for_mkfs(file, force_overwrite);
diff --git a/utils.c b/utils.c
index 524f463d3140..22c137514592 100644
--- a/utils.c
+++ b/utils.c
@@ -456,6 +456,21 @@ static int is_reg_file(const char *path)
 	return S_ISREG(statbuf.st_mode);
 }
 
+int is_path_exist(const char *path)
+{
+	struct stat statbuf;
+	int ret;
+
+	ret = stat(path, &statbuf);
+	if (ret < 0) {
+		if (errno == ENOENT)
+			return 0;
+		else
+			return -errno;
+	}
+	return 1;
+}
+
 /*
  * This function checks if the given input parameter is
  * an uuid or a path
diff --git a/utils.h b/utils.h
index a82d46f6d7cc..860c25d3cdba 100644
--- a/utils.h
+++ b/utils.h
@@ -122,6 +122,7 @@ int set_label(const char *btrfs_dev, const char *label);
 char *__strncpy_null(char *dest, const char *src, size_t n);
 int is_block_device(const char *file);
 int is_mount_point(const char *file);
+int is_path_exist(const char *file);
 int check_arg_type(const char *input);
 int open_path_or_dev_mnt(const char *path, DIR **dirstream, int verbose);
 int btrfs_open(const char *path, DIR **dirstream, int verbose, int dir_only);
-- 
2.15.0

