Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.136]:59357 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759886Ab3DIRIs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Apr 2013 13:08:48 -0400
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp1) (RZmta 31.24 OK)
	with ESMTP id X0628ep39FGDUY for <linux-btrfs@vger.kernel.org>;
	Tue, 9 Apr 2013 19:08:46 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 09/17] Btrfs-progs: btrfs-receive: different levels (amount) of debug output
Date: Tue,  9 Apr 2013 19:08:37 +0200
Message-Id: <9c63079d735d556d8a37bcb941c38cea5954f0f7.1365524492.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365524492.git.sbehrens@giantdisaster.de>
References: <cover.1365524492.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365524492.git.sbehrens@giantdisaster.de>
References: <cover.1365524492.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There used to be 2 levels of verbose output, now there are 3:
- None at all (no -v option given).
- Some information about received snapshots / subvolumes (-v option).
- Each received command is printed (-vv option).

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 cmds-receive.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index eedff13..8afffe6 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -268,7 +268,7 @@ static int process_mkfile(const char *path, void *user)
 	struct btrfs_receive *r = user;
 	char *full_path = path_cat(r->full_subvol_path, path);
 
-	if (g_verbose >= 1)
+	if (g_verbose >= 2)
 		fprintf(stderr, "mkfile %s\n", path);
 
 	ret = creat(full_path, 0600);
@@ -292,7 +292,7 @@ static int process_mkdir(const char *path, void *user)
 	struct btrfs_receive *r = user;
 	char *full_path = path_cat(r->full_subvol_path, path);
 
-	if (g_verbose >= 1)
+	if (g_verbose >= 2)
 		fprintf(stderr, "mkdir %s\n", path);
 
 	ret = mkdir(full_path, 0700);
@@ -312,7 +312,7 @@ static int process_mknod(const char *path, u64 mode, u64 dev, void *user)
 	struct btrfs_receive *r = user;
 	char *full_path = path_cat(r->full_subvol_path, path);
 
-	if (g_verbose >= 1)
+	if (g_verbose >= 2)
 		fprintf(stderr, "mknod %s mode=%llu, dev=%llu\n",
 				path, mode, dev);
 
@@ -333,7 +333,7 @@ static int process_mkfifo(const char *path, void *user)
 	struct btrfs_receive *r = user;
 	char *full_path = path_cat(r->full_subvol_path, path);
 
-	if (g_verbose >= 1)
+	if (g_verbose >= 2)
 		fprintf(stderr, "mkfifo %s\n", path);
 
 	ret = mkfifo(full_path, 0600);
@@ -353,7 +353,7 @@ static int process_mksock(const char *path, void *user)
 	struct btrfs_receive *r = user;
 	char *full_path = path_cat(r->full_subvol_path, path);
 
-	if (g_verbose >= 1)
+	if (g_verbose >= 2)
 		fprintf(stderr, "mksock %s\n", path);
 
 	ret = mknod(full_path, 0600 | S_IFSOCK, 0);
@@ -373,7 +373,7 @@ static int process_symlink(const char *path, const char *lnk, void *user)
 	struct btrfs_receive *r = user;
 	char *full_path = path_cat(r->full_subvol_path, path);
 
-	if (g_verbose >= 1)
+	if (g_verbose >= 2)
 		fprintf(stderr, "symlink %s -> %s\n", path, lnk);
 
 	ret = symlink(lnk, full_path);
@@ -394,7 +394,7 @@ static int process_rename(const char *from, const char *to, void *user)
 	char *full_from = path_cat(r->full_subvol_path, from);
 	char *full_to = path_cat(r->full_subvol_path, to);
 
-	if (g_verbose >= 1)
+	if (g_verbose >= 2)
 		fprintf(stderr, "rename %s -> %s\n", from, to);
 
 	ret = rename(full_from, full_to);
@@ -416,7 +416,7 @@ static int process_link(const char *path, const char *lnk, void *user)
 	char *full_path = path_cat(r->full_subvol_path, path);
 	char *full_link_path = path_cat(r->full_subvol_path, lnk);
 
-	if (g_verbose >= 1)
+	if (g_verbose >= 2)
 		fprintf(stderr, "link %s -> %s\n", path, lnk);
 
 	ret = link(full_link_path, full_path);
@@ -438,7 +438,7 @@ static int process_unlink(const char *path, void *user)
 	struct btrfs_receive *r = user;
 	char *full_path = path_cat(r->full_subvol_path, path);
 
-	if (g_verbose >= 1)
+	if (g_verbose >= 2)
 		fprintf(stderr, "unlink %s\n", path);
 
 	ret = unlink(full_path);
@@ -458,7 +458,7 @@ static int process_rmdir(const char *path, void *user)
 	struct btrfs_receive *r = user;
 	char *full_path = path_cat(r->full_subvol_path, path);
 
-	if (g_verbose >= 1)
+	if (g_verbose >= 2)
 		fprintf(stderr, "rmdir %s\n", path);
 
 	ret = rmdir(full_path);
@@ -631,7 +631,7 @@ static int process_set_xattr(const char *path, const char *name,
 	struct btrfs_receive *r = user;
 	char *full_path = path_cat(r->full_subvol_path, path);
 
-	if (g_verbose >= 1) {
+	if (g_verbose >= 2) {
 		fprintf(stderr, "set_xattr %s - name=%s data_len=%d "
 				"data=%.*s\n", path, name, len,
 				len, (char*)data);
@@ -656,7 +656,7 @@ static int process_remove_xattr(const char *path, const char *name, void *user)
 	struct btrfs_receive *r = user;
 	char *full_path = path_cat(r->full_subvol_path, path);
 
-	if (g_verbose >= 1) {
+	if (g_verbose >= 2) {
 		fprintf(stderr, "remove_xattr %s - name=%s\n",
 				path, name);
 	}
@@ -680,7 +680,7 @@ static int process_truncate(const char *path, u64 size, void *user)
 	struct btrfs_receive *r = user;
 	char *full_path = path_cat(r->full_subvol_path, path);
 
-	if (g_verbose >= 1)
+	if (g_verbose >= 2)
 		fprintf(stderr, "truncate %s size=%llu\n", path, size);
 
 	ret = truncate(full_path, size);
@@ -702,7 +702,7 @@ static int process_chmod(const char *path, u64 mode, void *user)
 	struct btrfs_receive *r = user;
 	char *full_path = path_cat(r->full_subvol_path, path);
 
-	if (g_verbose >= 1)
+	if (g_verbose >= 2)
 		fprintf(stderr, "chmod %s - mode=0%o\n", path, (int)mode);
 
 	ret = chmod(full_path, mode);
@@ -724,7 +724,7 @@ static int process_chown(const char *path, u64 uid, u64 gid, void *user)
 	struct btrfs_receive *r = user;
 	char *full_path = path_cat(r->full_subvol_path, path);
 
-	if (g_verbose >= 1)
+	if (g_verbose >= 2)
 		fprintf(stderr, "chown %s - uid=%llu, gid=%llu\n", path,
 				uid, gid);
 
@@ -750,7 +750,7 @@ static int process_utimes(const char *path, struct timespec *at,
 	char *full_path = path_cat(r->full_subvol_path, path);
 	struct timespec tv[2];
 
-	if (g_verbose >= 1)
+	if (g_verbose >= 2)
 		fprintf(stderr, "utimes %s\n", path);
 
 	tv[0] = *at;
-- 
1.8.2.1

