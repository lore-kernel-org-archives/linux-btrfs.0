Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37934 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbaGYGRd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jul 2014 02:17:33 -0400
Received: from kw-mxauth.gw.nic.fujitsu.com (unknown [10.0.237.134])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id A9FCA3EE0B6
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Jul 2014 15:17:31 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 9DB6CAC08AE
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Jul 2014 15:17:30 +0900 (JST)
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 4D7CB1DB803B
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Jul 2014 15:17:30 +0900 (JST)
Received: from g01jpexchkw37.g01.fujitsu.local (unknown [10.0.193.4])
	by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id 499D7BD67D5
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Jul 2014 15:17:29 +0900 (JST)
Message-ID: <53D1F661.1030504@jp.fujitsu.com>
Date: Fri, 25 Jul 2014 15:17:05 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] btrfs-progs: Unify the messy error message formats
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

- There are many format to show snapshot name in error messages,
  "'%s'", "'%s", "%s", "('%s')", and "('%s)". Since it's messy,
  unify these to "'%s'" format.
- Fix a type: s/uncorrect/incorrect/

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

---
 cmds-subvolume.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index b7bfb3e..ce38503 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -140,14 +140,14 @@ static int cmd_subvol_create(int argc, char **argv)
 	dstdir = dirname(dupdir);
 
 	if (!test_issubvolname(newname)) {
-		fprintf(stderr, "ERROR: uncorrect subvolume name ('%s')\n",
+		fprintf(stderr, "ERROR: incorrect subvolume name '%s'\n",
 			newname);
 		goto out;
 	}
 
 	len = strlen(newname);
 	if (len == 0 || len >= BTRFS_VOL_NAME_MAX) {
-		fprintf(stderr, "ERROR: subvolume name too long ('%s)\n",
+		fprintf(stderr, "ERROR: subvolume name too long '%s'\n",
 			newname);
 		goto out;
 	}
@@ -314,7 +314,7 @@ again:
 	free(cpath);
 
 	if (!test_issubvolname(vname)) {
-		fprintf(stderr, "ERROR: incorrect subvolume name ('%s')\n",
+		fprintf(stderr, "ERROR: incorrect subvolume name '%s'\n",
 			vname);
 		ret = 1;
 		goto out;
@@ -322,7 +322,7 @@ again:
 
 	len = strlen(vname);
 	if (len == 0 || len >= BTRFS_VOL_NAME_MAX) {
-		fprintf(stderr, "ERROR: snapshot name too long ('%s)\n",
+		fprintf(stderr, "ERROR: too long snapshot name '%s'\n",
 			vname);
 		ret = 1;
 		goto out;
@@ -722,14 +722,14 @@ static int cmd_snapshot(int argc, char **argv)
 	}
 
 	if (!test_issubvolname(newname)) {
-		fprintf(stderr, "ERROR: incorrect snapshot name ('%s')\n",
+		fprintf(stderr, "ERROR: incorrect snapshot name '%s'\n",
 			newname);
 		goto out;
 	}
 
 	len = strlen(newname);
 	if (len == 0 || len >= BTRFS_VOL_NAME_MAX) {
-		fprintf(stderr, "ERROR: snapshot name too long ('%s)\n",
+		fprintf(stderr, "ERROR: snapshot name too long '%s'\n",
 			newname);
 		goto out;
 	}
@@ -778,7 +778,7 @@ static int cmd_snapshot(int argc, char **argv)
 	res = ioctl(fddst, BTRFS_IOC_SNAP_CREATE_V2, &args);
 
 	if (res < 0) {
-		fprintf( stderr, "ERROR: cannot snapshot %s - %s\n",
+		fprintf( stderr, "ERROR: cannot snapshot '%s' - %s\n",
 			subvol_descr, strerror(errno));
 		goto out;
 	}
@@ -991,7 +991,7 @@ static int cmd_subvol_show(int argc, char **argv)
 
 	ret = find_mount_root(fullpath, &mnt);
 	if (ret < 0) {
-		fprintf(stderr, "ERROR: find_mount_root failed on %s: "
+		fprintf(stderr, "ERROR: find_mount_root failed on '%s': "
 				"%s\n", fullpath, strerror(-ret));
 		goto out;
 	}
-- 
1.9.3

