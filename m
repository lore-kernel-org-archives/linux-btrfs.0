Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:51318 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410Ab2IXCoG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Sep 2012 22:44:06 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q8O2i31U009226
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Sep 2012 02:44:04 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q8O2i3ec004478
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Sep 2012 02:44:03 GMT
Received: from abhmt114.oracle.com (abhmt114.oracle.com [141.146.116.66])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q8O2i39q016503
	for <linux-btrfs@vger.kernel.org>; Sun, 23 Sep 2012 21:44:03 -0500
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] Btrfs-progs: btrfs subvolume delete could delete subvolumes
Date: Mon, 24 Sep 2012 10:46:45 +0800
Message-Id: <1348454805-3910-1-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <20120921081447.GA1961@zambezi.lan>
References: <20120921081447.GA1961@zambezi.lan>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-subvolume.c |   36 ++++++++++++++++++++++++------------
 1 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index f4aa80f..f6c488e 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -188,31 +188,34 @@ int test_issubvolume(char *path)
 }
 
 static const char * const cmd_subvol_delete_usage[] = {
-	"btrfs subvolume delete <name>",
-	"Delete a subvolume",
+	"btrfs subvolume delete <subvolume> [<subvolume>...]",
+	"Delete subvolume(s)",
 	NULL
 };
 
 static int cmd_subvol_delete(int argc, char **argv)
 {
-	int	res, fd, len, e;
+	int	res, fd, len, e, cnt = 1, ret = 0;
 	struct btrfs_ioctl_vol_args	args;
 	char	*dname, *vname, *cpath;
 	char	*path;
 
-	if (check_argc_exact(argc, 2))
+	if (check_argc_min(argc, 2))
 		usage(cmd_subvol_delete_usage);
 
-	path = argv[1];
+again:
+	path = argv[cnt];
 
 	res = test_issubvolume(path);
 	if(res<0){
 		fprintf(stderr, "ERROR: error accessing '%s'\n", path);
-		return 12;
+		ret = 12;
+		goto out;
 	}
 	if(!res){
 		fprintf(stderr, "ERROR: '%s' is not a subvolume\n", path);
-		return 13;
+		ret = 13;
+		goto out;
 	}
 
 	cpath = realpath(path, 0);
@@ -226,21 +229,24 @@ static int cmd_subvol_delete(int argc, char **argv)
 	     strchr(vname, '/') ){
 		fprintf(stderr, "ERROR: incorrect subvolume name ('%s')\n",
 			vname);
-		return 14;
+		ret = 14;
+		goto out;
 	}
 
 	len = strlen(vname);
 	if (len == 0 || len >= BTRFS_VOL_NAME_MAX) {
 		fprintf(stderr, "ERROR: snapshot name too long ('%s)\n",
 			vname);
-		return 14;
+		ret = 14;
+		goto out;
 	}
 
 	fd = open_file_or_dir(dname);
 	if (fd < 0) {
 		close(fd);
 		fprintf(stderr, "ERROR: can't access to '%s'\n", dname);
-		return 12;
+		ret = 12;
+		goto out;
 	}
 
 	printf("Delete subvolume '%s/%s'\n", dname, vname);
@@ -254,10 +260,16 @@ static int cmd_subvol_delete(int argc, char **argv)
 	if(res < 0 ){
 		fprintf( stderr, "ERROR: cannot delete '%s/%s' - %s\n",
 			dname, vname, strerror(e));
-		return 11;
+		ret = 11;
+		goto out;
 	}
 
-	return 0;
+out:
+	cnt++;
+	if (cnt < argc)
+		goto again;
+
+	return ret;
 }
 
 static const char * const cmd_subvol_list_usage[] = {
-- 
1.7.1

