Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:13746 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757173Ab3BYVzQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 16:55:16 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 01/17] btrfs-progs: Unify size-parsing
Date: Mon, 25 Feb 2013 16:54:34 -0600
Message-Id: <1361832890-40921-2-git-send-email-sandeen@redhat.com>
In-Reply-To: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
References: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

cmds-qgroup.c contained a parse_limit() function which
duplicates much of the functionality of parse_size.
The only unique behavior is to handle "none"; then we
can just pass it off to parse_size().

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 cmds-qgroup.c |   44 ++++++--------------------------------------
 utils.c       |    8 +++++++-
 utils.h       |    2 +-
 3 files changed, 14 insertions(+), 40 deletions(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 26f0ab0..ce013c8 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -198,43 +198,13 @@ done:
 	return ret;
 }
 
-static int parse_limit(const char *p, unsigned long long *s)
+static u64 parse_limit(const char *p)
 {
-	char *endptr;
-	unsigned long long size;
-
-	if (strcasecmp(p, "none") == 0) {
-		*s = 0;
-		return 1;
-	}
-	size = strtoull(p, &endptr, 10);
-	switch (*endptr) {
-	case 'T':
-	case 't':
-		size *= 1024;
-	case 'G':
-	case 'g':
-		size *= 1024;
-	case 'M':
-	case 'm':
-		size *= 1024;
-	case 'K':
-	case 'k':
-		size *= 1024;
-		++endptr;
-		break;
-	case 0:
-		break;
-	default:
-		return 0;
-	}
-
-	if (*endptr)
+	if (strcasecmp(p, "none") == 0)
 		return 0;
 
-	*s = size;
-
-	return 1;
+	/* parse_size() will exit() on any error */
+	return parse_size(p);
 }
 
 static const char * const cmd_qgroup_assign_usage[] = {
@@ -364,10 +334,8 @@ static int cmd_qgroup_limit(int argc, char **argv)
 	if (check_argc_min(argc - optind, 2))
 		usage(cmd_qgroup_limit_usage);
 
-	if (!parse_limit(argv[optind], &size)) {
-		fprintf(stderr, "Invalid size argument given\n");
-		return 1;
-	}
+	/* parse_limit will exit on any error */
+	size = parse_limit(argv[optind]);
 
 	memset(&args, 0, sizeof(args));
 	if (size) {
diff --git a/utils.c b/utils.c
index d660507..bc6d5fe 100644
--- a/utils.c
+++ b/utils.c
@@ -1251,7 +1251,7 @@ scan_again:
 	return 0;
 }
 
-u64 parse_size(char *s)
+u64 parse_size(const char *s)
 {
 	int i;
 	char c;
@@ -1268,16 +1268,22 @@ u64 parse_size(char *s)
 		switch (c) {
 		case 'e':
 			mult *= 1024;
+			/* Fallthrough */
 		case 'p':
 			mult *= 1024;
+			/* Fallthrough */
 		case 't':
 			mult *= 1024;
+			/* Fallthrough */
 		case 'g':
 			mult *= 1024;
+			/* Fallthrough */
 		case 'm':
 			mult *= 1024;
+			/* Fallthrough */
 		case 'k':
 			mult *= 1024;
+			/* Fallthrough */
 		case 'b':
 			break;
 		default:
diff --git a/utils.h b/utils.h
index 60a0fea..dcdf475 100644
--- a/utils.h
+++ b/utils.h
@@ -47,7 +47,7 @@ char *pretty_sizes(u64 size);
 int check_label(char *input);
 int get_mountpt(char *dev, char *mntpt, size_t size);
 int btrfs_scan_block_devices(int run_ioctl);
-u64 parse_size(char *s);
+u64 parse_size(const char *s);
 int open_file_or_dir(const char *fname);
 int get_device_info(int fd, u64 devid,
 		    struct btrfs_ioctl_dev_info_args *di_args);
-- 
1.7.1

