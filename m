Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:41480 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab3KPRJQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Nov 2013 12:09:16 -0500
Received: by mail-we0-f179.google.com with SMTP id q59so2602835wes.38
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Nov 2013 09:09:15 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 4/7] recursive btrfs subvol delete
Date: Sat, 16 Nov 2013 18:09:04 +0100
Message-Id: <1384621747-25441-5-git-send-email-kreijack@inwind.it>
In-Reply-To: <1384621747-25441-1-git-send-email-kreijack@inwind.it>
References: <1384621747-25441-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add the -R switch to allow to delete recursively a subvolume.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 cmds-subvolume.c | 107 +++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 89 insertions(+), 18 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 477919c..422e1fc 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -201,28 +201,15 @@ int test_issubvolume(char *path)
 	return (st.st_ino == 256) && S_ISDIR(st.st_mode);
 }
 
-static const char * const cmd_subvol_delete_usage[] = {
-	"btrfs subvolume delete <subvolume> [<subvolume>...]",
-	"Delete subvolume(s)",
-	NULL
-};
-
-static int cmd_subvol_delete(int argc, char **argv)
+static int do_subvol_delete(char *path)
 {
-	int	res, fd, len, e, cnt = 1, ret = 0;
+	int	res, fd, len, e, ret = 0;
 	struct btrfs_ioctl_vol_args	args;
 	char	*dname, *vname, *cpath;
 	char	*dupdname = NULL;
 	char	*dupvname = NULL;
-	char	*path;
 	DIR	*dirstream = NULL;
 
-	if (argc < 2)
-		usage(cmd_subvol_delete_usage);
-
-again:
-	path = argv[cnt];
-
 	res = test_issubvolume(path);
 	if (res < 0) {
 		fprintf(stderr, "ERROR: error accessing '%s'\n", path);
@@ -290,9 +277,93 @@ out:
 	free(dupvname);
 	dupdname = NULL;
 	dupvname = NULL;
-	cnt++;
-	if (cnt < argc)
-		goto again;
+
+	return ret;
+}
+
+static int do_subvol_delete_func(char *real_root, char *relative_root,
+				 char *path, void *data)
+{
+	char *dpath, *real_path;
+	int ret;
+	(void)data;		/* ignore the parameter */
+	(void)real_root;	/* ignore the parameter */
+
+	dpath = pathjoin(relative_root, path, NULL);
+	if (!dpath) {
+		fprintf(stderr, "ERROR: not enough memory\n");
+		return -1;
+	}
+	real_path = realpath(dpath, NULL);
+	if (!real_path) {
+		free(dpath);
+		fprintf(stderr, "ERROR: not enough memory\n");
+		return -1;
+	}
+
+	ret = do_subvol_delete(real_path);
+	free(real_path);
+	free(dpath);
+
+	return ret;
+}
+
+static inline int do_subvol_delete_rec(char *path)
+{
+	return traverse_list_subvol_rec(path, /* filesystem subvolume  */
+				0,    /* false = only below this path */
+				1,    /* ascending order */
+				do_subvol_delete_func, /* func to call */
+				NULL);	/* parameter to pass to func */
+}
+
+static const char * const cmd_subvol_delete_usage[] = {
+	"btrfs subvolume delete [-R] <subvolume> [<subvolume>...]",
+	"Delete subvolume(s)",
+	"",
+	"-R        delete recursively",
+	NULL
+};
+
+static int cmd_subvol_delete(int argc, char **argv)
+{
+	int	rec = 0, ret = 0, i;
+
+	optind = 1;
+	while(1) {
+		int c;
+		c = getopt_long(argc, argv, "R", NULL, NULL);
+		if (c < 0)
+			break;
+
+		switch(c) {
+		case 'R':
+			rec = 1;
+			break;
+		default:
+			ret = 2;
+			goto out;
+		}
+	}
+
+	if (check_argc_min(argc - optind, 1)) {
+		usage(cmd_subvol_delete_usage);
+		ret = 1;
+		goto out;
+	}
+
+	for ( i = optind ; i < argc ; i++ ) {
+
+		if (rec)
+			ret = do_subvol_delete_rec(argv[i]);
+		else
+			ret = do_subvol_delete(argv[i]);
+
+		if (ret)
+			break;
+
+	}
+out:
 
 	return ret;
 }
-- 
1.8.4.3

