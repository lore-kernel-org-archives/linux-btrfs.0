Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:46006 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901AbaAIWrs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jan 2014 17:47:48 -0500
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5])
	by smtpfb2-g21.free.fr (Postfix) with ESMTP id 40422D1AEA4
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Jan 2014 23:47:45 +0100 (CET)
From: Pascal VITOUX <vitoux.pascal@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Pascal VITOUX <vitoux.pascal@gmail.com>
Subject: [PATCH] btrfs-progs: skip non-regular files while defragmenting
Date: Thu,  9 Jan 2014 23:47:14 +0100
Message-Id: <1389307634-8226-1-git-send-email-vitoux.pascal@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Skip non-regular files to avoid ioctl errors while defragmenting.

They are silently ignored in recursive mode but reported as errors when
used as command-line arguments.

Signed-off-by: Pascal VITOUX <vitoux.pascal@gmail.com>
---
 cmds-filesystem.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 1c1926b..54fba10 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -646,7 +646,7 @@ static int defrag_callback(const char *fpath, const struct stat *sb,
 	int e = 0;
 	int fd = 0;
 
-	if (typeflag == FTW_F) {
+	if ((typeflag == FTW_F) && S_ISREG(sb->st_mode)) {
 		if (defrag_global_verbose)
 			printf("%s\n", fpath);
 		fd = open(fpath, O_RDWR);
@@ -748,6 +748,7 @@ static int cmd_defrag(int argc, char **argv)
 		defrag_global_range.flags |= BTRFS_DEFRAG_RANGE_START_IO;
 
 	for (i = optind; i < argc; i++) {
+		struct stat st;
 		dirstream = NULL;
 		fd = open_file_or_dir(argv[i], &dirstream);
 		if (fd < 0) {
@@ -757,16 +758,21 @@ static int cmd_defrag(int argc, char **argv)
 			close_file_or_dir(fd, dirstream);
 			continue;
 		}
+		if (fstat(fd, &st)) {
+			fprintf(stderr, "ERROR: failed to stat %s - %s\n",
+					argv[i], strerror(errno));
+			defrag_global_errors++;
+			close_file_or_dir(fd, dirstream);
+			continue;
+		}
+		if (!(S_ISDIR(st.st_mode) || S_ISREG(st.st_mode))) {
+			fprintf(stderr, "ERROR: %s is not a directory or a regular "
+					"file.\n", argv[i]);
+			defrag_global_errors++;
+			close_file_or_dir(fd, dirstream);
+			continue;
+		}
 		if (recursive) {
-			struct stat st;
-
-			if (fstat(fd, &st)) {
-				fprintf(stderr, "ERROR: failed to stat %s - %s\n",
-						argv[i], strerror(errno));
-				defrag_global_errors++;
-				close_file_or_dir(fd, dirstream);
-				continue;
-			}
 			if (S_ISDIR(st.st_mode)) {
 				ret = nftw(argv[i], defrag_callback, 10,
 						FTW_MOUNT | FTW_PHYS);
-- 
1.8.5.2

