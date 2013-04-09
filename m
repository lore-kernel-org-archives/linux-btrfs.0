Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.139]:50830 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933361Ab3DIRIs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Apr 2013 13:08:48 -0400
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp1) (RZmta 31.24 OK)
	with ESMTP id X0628ep39FGDUZ for <linux-btrfs@vger.kernel.org>;
	Tue, 9 Apr 2013 19:08:46 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 10/17] Btrfs-progs: small parent_subvol cleanup for cmds-receive.c
Date: Tue,  9 Apr 2013 19:08:38 +0200
Message-Id: <bb0a24da383a2ed98c5d8f079d0832423e085b33.1365524492.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365524492.git.sbehrens@giantdisaster.de>
References: <cover.1365524492.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365524492.git.sbehrens@giantdisaster.de>
References: <cover.1365524492.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

parent_subvol is local to process_snapshot() and not needed outside.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 cmds-receive.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index 8afffe6..081665f 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -63,7 +63,6 @@ struct btrfs_receive
 	char *full_subvol_path;
 
 	struct subvol_info *cur_subvol;
-	struct subvol_info *parent_subvol;
 
 	struct subvol_uuid_search sus;
 };
@@ -151,7 +150,6 @@ static int process_subvol(const char *path, const u8 *uuid, u64 ctransid,
 		goto out;
 
 	r->cur_subvol = calloc(1, sizeof(*r->cur_subvol));
-	r->parent_subvol = NULL;
 
 	r->cur_subvol->path = strdup(path);
 	free(r->full_subvol_path);
@@ -191,13 +189,13 @@ static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
 	struct btrfs_receive *r = user;
 	char uuid_str[128];
 	struct btrfs_ioctl_vol_args_v2 args_v2;
+	struct subvol_info *parent_subvol;
 
 	ret = finish_subvol(r);
 	if (ret < 0)
 		goto out;
 
 	r->cur_subvol = calloc(1, sizeof(*r->cur_subvol));
-	r->parent_subvol = NULL;
 
 	r->cur_subvol->path = strdup(path);
 	free(r->full_subvol_path);
@@ -221,9 +219,9 @@ static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
 	memset(&args_v2, 0, sizeof(args_v2));
 	strncpy_null(args_v2.name, path);
 
-	r->parent_subvol = subvol_uuid_search(&r->sus, 0, parent_uuid,
+	parent_subvol = subvol_uuid_search(&r->sus, 0, parent_uuid,
 			parent_ctransid, NULL, subvol_search_by_received_uuid);
-	if (!r->parent_subvol) {
+	if (!parent_subvol) {
 		ret = -ENOENT;
 		fprintf(stderr, "ERROR: could not find parent subvolume\n");
 		goto out;
@@ -239,12 +237,12 @@ static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
 		}
 	}*/
 
-	args_v2.fd = openat(r->mnt_fd, r->parent_subvol->path,
+	args_v2.fd = openat(r->mnt_fd, parent_subvol->path,
 			O_RDONLY | O_NOATIME);
 	if (args_v2.fd < 0) {
 		ret = -errno;
 		fprintf(stderr, "ERROR: open %s failed. %s\n",
-				r->parent_subvol->path, strerror(-ret));
+				parent_subvol->path, strerror(-ret));
 		goto out;
 	}
 
@@ -253,7 +251,7 @@ static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
 	if (ret < 0) {
 		ret = -errno;
 		fprintf(stderr, "ERROR: creating snapshot %s -> %s "
-				"failed. %s\n", r->parent_subvol->path,
+				"failed. %s\n", parent_subvol->path,
 				path, strerror(-ret));
 		goto out;
 	}
-- 
1.8.2.1

