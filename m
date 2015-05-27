Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50125 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751488AbbE0Rvn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 May 2015 13:51:43 -0400
Received: from pps.filterd (m0004077 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id t4RHm9R2026630
	for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2015 10:51:32 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0b-00082601.pphosted.com with ESMTP id 1ungdj0h18-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2015 10:51:32 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: specify mountpoint for recieve
Date: Wed, 27 May 2015 13:51:29 -0400
Message-ID: <1432749089-14663-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In a chroot environment we may not have /proc mounted, which makes btrfs receive
freak out since it wants to know the base directory where are are mounted for
things like clone and such.  Give an option to specify where the mountpoint is
in these cases so you can still do a btrfs receive in a chroot.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 cmds-receive.c | 47 +++++++++++++++++++++++++++++++----------------
 1 file changed, 31 insertions(+), 16 deletions(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index b7cf3f9..28ae8e9 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -813,8 +813,8 @@ static struct btrfs_send_ops send_ops = {
 	.utimes = process_utimes,
 };
 
-static int do_receive(struct btrfs_receive *r, const char *tomnt, int r_fd,
-		      u64 max_errors)
+static int do_receive(struct btrfs_receive *r, const char *tomnt,
+		      char *realmnt, int r_fd, u64 max_errors)
 {
 	int ret;
 	char *dest_dir_full_path;
@@ -836,20 +836,24 @@ static int do_receive(struct btrfs_receive *r, const char *tomnt, int r_fd,
 		goto out;
 	}
 
-	ret = find_mount_root(dest_dir_full_path, &r->root_path);
-	if (ret < 0) {
-		fprintf(stderr,
-			"ERROR: failed to determine mount point for %s: %s\n",
-			dest_dir_full_path, strerror(-ret));
-		ret = -EINVAL;
-		goto out;
-	}
-	if (ret > 0) {
-		fprintf(stderr,
+	if (realmnt) {
+		r->root_path = realmnt;
+	} else {
+		ret = find_mount_root(dest_dir_full_path, &r->root_path);
+		if (ret < 0) {
+			fprintf(stderr,
+				"ERROR: failed to determine mount point for %s: %s\n",
+				dest_dir_full_path, strerror(-ret));
+			ret = -EINVAL;
+			goto out;
+		}
+		if (ret > 0) {
+			fprintf(stderr,
 			"ERROR: %s doesn't belong to btrfs mount point\n",
 			dest_dir_full_path);
-		ret = -EINVAL;
-		goto out;
+			ret = -EINVAL;
+			goto out;
+		}
 	}
 	r->mnt_fd = open(r->root_path, O_RDONLY | O_NOATIME);
 	if (r->mnt_fd < 0) {
@@ -943,6 +947,7 @@ int cmd_receive(int argc, char **argv)
 {
 	char *tomnt = NULL;
 	char *fromfile = NULL;
+	char *realmnt = NULL;
 	struct btrfs_receive r;
 	int receive_fd = fileno(stdin);
 	u64 max_errors = 1;
@@ -962,7 +967,7 @@ int cmd_receive(int argc, char **argv)
 			{ NULL, 0, NULL, 0 }
 		};
 
-		c = getopt_long(argc, argv, "Cevf:", long_opts, NULL);
+		c = getopt_long(argc, argv, "Cevf:m:", long_opts, NULL);
 		if (c < 0)
 			break;
 
@@ -982,6 +987,13 @@ int cmd_receive(int argc, char **argv)
 		case 'E':
 			max_errors = arg_strtou64(optarg);
 			break;
+		case 'm':
+			realmnt = strdup(optarg);
+			if (!realmnt) {
+				fprintf(stderr, "ERROR: couldn't allocate realmnt.\n");
+				return 1;
+			}
+			break;
 		case '?':
 		default:
 			fprintf(stderr, "ERROR: receive args invalid.\n");
@@ -1002,7 +1014,7 @@ int cmd_receive(int argc, char **argv)
 		}
 	}
 
-	ret = do_receive(&r, tomnt, receive_fd, max_errors);
+	ret = do_receive(&r, tomnt, realmnt, receive_fd, max_errors);
 
 	return !!ret;
 }
@@ -1032,5 +1044,8 @@ const char * const cmd_receive_usage[] = {
 	"--max-errors <N> Terminate as soon as N errors happened while",
 	"                 processing commands from the send stream.",
 	"                 Default value is 1. A value of 0 means no limit.",
+	"-m <mountpoint>  The root mount point of the destination fs.",
+	"                 If you do not have /proc use this to tell us where ",
+	"                 this file system is mounted.",
 	NULL
 };
-- 
1.8.3.1

