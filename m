Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.140]:28938 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762947Ab3DIRIs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Apr 2013 13:08:48 -0400
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp1) (RZmta 31.24 OK)
	with ESMTP id X0628ep39FGDUW for <linux-btrfs@vger.kernel.org>;
	Tue, 9 Apr 2013 19:08:46 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 07/17] Btrfs-progs: free memory and close file descriptor in btrfs receive
Date: Tue,  9 Apr 2013 19:08:35 +0200
Message-Id: <584ea0d3ebaeff6cdc8ca14f4e7ffafa50c81928.1365524492.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365524492.git.sbehrens@giantdisaster.de>
References: <cover.1365524492.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365524492.git.sbehrens@giantdisaster.de>
References: <cover.1365524492.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nothing really important since this is not part of the library and
at the end exit() is called.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 cmds-receive.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index fc5094e..dc72e9e 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -151,6 +151,7 @@ static int process_subvol(const char *path, const u8 *uuid, u64 ctransid,
 	r->parent_subvol = NULL;
 
 	r->cur_subvol->path = strdup(path);
+	free(r->full_subvol_path);
 	r->full_subvol_path = path_cat(r->root_path, path);
 
 	fprintf(stderr, "At subvol %s\n", path);
@@ -196,6 +197,7 @@ static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
 	r->parent_subvol = NULL;
 
 	r->cur_subvol->path = strdup(path);
+	free(r->full_subvol_path);
 	r->full_subvol_path = path_cat(r->root_path, path);
 
 	fprintf(stderr, "At snapshot %s\n", path);
@@ -803,9 +805,7 @@ int do_receive(struct btrfs_receive *r, const char *tomnt, int r_fd)
 
 	ret = subvol_uuid_search_init(r->mnt_fd, &r->sus);
 	if (ret < 0)
-		return ret;
-
-	r->write_fd = -1;
+		goto out;
 
 	while (!end) {
 		ret = btrfs_read_and_process_send_stream(r_fd, &send_ops, r);
@@ -824,7 +824,26 @@ int do_receive(struct btrfs_receive *r, const char *tomnt, int r_fd)
 	ret = 0;
 
 out:
+	if (r->write_fd != -1) {
+		close(r->write_fd);
+		r->write_fd = -1;
+	}
+	free(r->root_path);
+	r->root_path = NULL;
+	free(r->write_path);
+	r->write_path = NULL;
+	free(r->full_subvol_path);
+	r->full_subvol_path = NULL;
+	if (r->cur_subvol) {
+		free(r->cur_subvol->path);
+		free(r->cur_subvol);
+		r->cur_subvol = NULL;
+	}
 	subvol_uuid_search_finit(&r->sus);
+	if (r->mnt_fd != -1) {
+		close(r->mnt_fd);
+		r->mnt_fd = -1;
+	}
 	return ret;
 }
 
@@ -839,6 +858,8 @@ static int do_cmd_receive(int argc, char **argv)
 	int ret;
 
 	memset(&r, 0, sizeof(r));
+	r.mnt_fd = -1;
+	r.write_fd = -1;
 
 	while ((c = getopt(argc, argv, "vf:")) != -1) {
 		switch (c) {
-- 
1.8.2.1

