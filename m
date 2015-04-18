Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:36500 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbbDROxC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 18 Apr 2015 10:53:02 -0400
Received: by wgsk9 with SMTP id k9so138629149wgs.3
        for <linux-btrfs@vger.kernel.org>; Sat, 18 Apr 2015 07:53:00 -0700 (PDT)
From: =?UTF-8?q?Lauri=20V=C3=B5sandi?= <lauri.vosandi@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: =?UTF-8?q?Lauri=20V=C3=B5sandi?= <lauri.vosandi@gmail.com>
Subject: [PATCH] btrfs-progs: optionally enforce chroot for btrfs receive
Date: Sat, 18 Apr 2015 17:52:53 +0300
Message-Id: <1429368773-4632-1-git-send-email-lauri.vosandi@gmail.com>
In-Reply-To: <1429365545-2419-1-git-send-email-lauri.vosandi@gmail.com>
References: <1429365545-2419-1-git-send-email-lauri.vosandi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch forces btrfs receive to issue chroot before
parsing the btrfs stream using command-line flag -C
to confine the process and minimize damage that could
be done via malicious btrfs stream.

Signed-off-by: Lauri Võsandi <lauri.vosandi@gmail.com>
---
 cmds-receive.c | 37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index a1c72f9..366a63a 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -61,6 +61,7 @@ struct btrfs_receive
 	char *root_path;
 	char *dest_dir_path; /* relative to root_path */
 	char *full_subvol_path;
+	int dest_dir_chroot;
 
 	struct subvol_info *cur_subvol;
 
@@ -858,14 +859,27 @@ static int do_receive(struct btrfs_receive *r, const char *tomnt, int r_fd,
 		goto out;
 	}
 
-	/*
-	 * find_mount_root returns a root_path that is a subpath of
-	 * dest_dir_full_path. Now get the other part of root_path,
-	 * which is the destination dir relative to root_path.
-	 */
-	r->dest_dir_path = dest_dir_full_path + strlen(r->root_path);
-	while (r->dest_dir_path[0] == '/')
-		r->dest_dir_path++;
+	if (r->dest_dir_chroot) {
+		if (chroot(dest_dir_full_path)) {
+			ret = -errno;
+			fprintf(stderr,
+				"ERROR: failed to chroot to %s, %s\n",
+				dest_dir_full_path,
+				strerror(-ret));
+			goto out;
+		}
+		if(chdir("/")) {
+			ret = -errno;
+			fprintf(stderr,
+				"ERROR: failed to chdir to /, %s\n",
+				strerror(-ret));
+		}
+		if (g_verbose >= 1) {
+			fprintf(stderr, "chrooted to %s\n",
+				dest_dir_full_path);
+		}
+		r->root_path = r->dest_dir_path = strdup("/");
+	}
 
 	ret = subvol_uuid_search_init(r->mnt_fd, &r->sus);
 	if (ret < 0)
@@ -930,6 +944,7 @@ int cmd_receive(int argc, char **argv)
 	r.mnt_fd = -1;
 	r.write_fd = -1;
 	r.dest_dir_fd = -1;
+	r.dest_dir_chroot = 0;
 
 	while (1) {
 		int c;
@@ -938,7 +953,7 @@ int cmd_receive(int argc, char **argv)
 			{ NULL, 0, NULL, 0 }
 		};
 
-		c = getopt_long(argc, argv, "evf:", long_opts, NULL);
+		c = getopt_long(argc, argv, "Cevf:", long_opts, NULL);
 		if (c < 0)
 			break;
 
@@ -952,6 +967,9 @@ int cmd_receive(int argc, char **argv)
 		case 'e':
 			r.honor_end_cmd = 1;
 			break;
+		case 'C':
+			r.dest_dir_chroot = 1;
+			break;
 		case 'E':
 			max_errors = arg_strtou64(optarg);
 			break;
@@ -1001,6 +1019,7 @@ const char * const cmd_receive_usage[] = {
 	"                 in the data stream. Without this option,",
 	"                 the receiver terminates only if an error",
 	"                 is recognized or on EOF.",
+	"-C               Confine the process to <mount> using chroot",
 	"--max-errors <N> Terminate as soon as N errors happened while",
 	"                 processing commands from the send stream.",
 	"                 Default value is 1. A value of 0 means no limit.",
-- 
1.9.1

