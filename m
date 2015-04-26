Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:36004 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbbDZKM4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Apr 2015 06:12:56 -0400
Received: by lagv1 with SMTP id v1so61617338lag.3
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Apr 2015 03:12:54 -0700 (PDT)
From: =?UTF-8?q?Lauri=20V=C3=B5sandi?= <lauri.vosandi@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: =?UTF-8?q?Lauri=20V=C3=B5sandi?= <lauri.vosandi@gmail.com>
Subject: [PATCH] btrfs-progs: receive explicit parent support
Date: Sun, 26 Apr 2015 12:12:45 +0200
Message-Id: <1430043165-20641-1-git-send-email-lauri.vosandi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds command-line flag -p to btrfs receive
which makes it possible to disable automatic parent
search for incremental snapshots and use explicitly
specified path instead.

Signed-off-by: Lauri Võsandi <lauri.vosandi@gmail.com>
---
 cmds-receive.c | 34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index b7cf3f9..391d281 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -61,6 +61,7 @@ struct btrfs_receive
 	char *root_path;
 	char *dest_dir_path; /* relative to root_path */
 	char *full_subvol_path;
+	char *explicit_parent_path;
 	int dest_dir_chroot;
 
 	struct subvol_info *cur_subvol;
@@ -220,20 +221,32 @@ static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
 		fprintf(stderr, "receiving snapshot %s uuid=%s, "
 				"ctransid=%llu ", path, uuid_str,
 				r->cur_subvol->stransid);
-		uuid_unparse(parent_uuid, uuid_str);
-		fprintf(stderr, "parent_uuid=%s, parent_ctransid=%llu\n",
-				uuid_str, parent_ctransid);
 	}
 
 	memset(&args_v2, 0, sizeof(args_v2));
 	strncpy_null(args_v2.name, path);
 
-	parent_subvol = subvol_uuid_search(&r->sus, 0, parent_uuid,
-			parent_ctransid, NULL, subvol_search_by_received_uuid);
-	if (!parent_subvol) {
+	if (r->explicit_parent_path) {
+		if (g_verbose) {
+			fprintf(stderr, "using explicit parent %s\n",
+					r->explicit_parent_path);
+		}
+		parent_subvol = subvol_uuid_search(&r->sus, 0, NULL,
+			0, r->explicit_parent_path, subvol_search_by_path);
+	} else {
+		if (g_verbose) {
+			uuid_unparse(parent_uuid, uuid_str);
+			fprintf(stderr, "parent_uuid=%s, parent_ctransid=%llu\n",
+					uuid_str, parent_ctransid);
+		}
 		parent_subvol = subvol_uuid_search(&r->sus, 0, parent_uuid,
-				parent_ctransid, NULL, subvol_search_by_uuid);
+			parent_ctransid, NULL, subvol_search_by_received_uuid);
+		if (!parent_subvol) {
+			parent_subvol = subvol_uuid_search(&r->sus, 0, parent_uuid,
+					parent_ctransid, NULL, subvol_search_by_uuid);
+		}
 	}
+
 	if (!parent_subvol) {
 		ret = -ENOENT;
 		fprintf(stderr, "ERROR: could not find parent subvolume\n");
@@ -962,11 +975,14 @@ int cmd_receive(int argc, char **argv)
 			{ NULL, 0, NULL, 0 }
 		};
 
-		c = getopt_long(argc, argv, "Cevf:", long_opts, NULL);
+		c = getopt_long(argc, argv, "Cevf:p:", long_opts, NULL);
 		if (c < 0)
 			break;
 
 		switch (c) {
+		case 'p':
+			r.explicit_parent_path = optarg;
+			break;
 		case 'v':
 			g_verbose++;
 			break;
@@ -1028,6 +1044,8 @@ const char * const cmd_receive_usage[] = {
 	"                 in the data stream. Without this option,",
 	"                 the receiver terminates only if an error",
 	"                 is recognized or on EOF.",
+	"-p <subvol>      Disables the automatic searching for parents",
+	"                 if incremental streams are received.",
 	"-C|--chroot      confine the process to <mount> using chroot",
 	"--max-errors <N> Terminate as soon as N errors happened while",
 	"                 processing commands from the send stream.",
-- 
1.9.1

