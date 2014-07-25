Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45781 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758382AbaGYGRI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jul 2014 02:17:08 -0400
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 7FC623EE0E7
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Jul 2014 15:17:06 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 6E385AC09C7
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Jul 2014 15:17:05 +0900 (JST)
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 768FF1DB8047
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Jul 2014 15:17:04 +0900 (JST)
Received: from g01jpexchkw37.g01.fujitsu.local (unknown [10.0.193.4])
	by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id C43ACBD67C3
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Jul 2014 15:17:03 +0900 (JST)
Message-ID: <53D1F65A.7030606@jp.fujitsu.com>
Date: Fri, 25 Jul 2014 15:16:58 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] btrfs-progs: introduce test_issubvolname() for simplicity
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

There are many duplicated codes to check if the given string is
correct subvolume name. Introduce test_issubvolname() for this
purpose for simplicity.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

---
 cmds-subvolume.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 639fb10..b7bfb3e 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -43,6 +43,18 @@ static const char * const subvolume_cmd_group_usage[] = {
 };
 
 /*
+ * test if name is a correct subvolume name
+ * this function return
+ * 0-> name is not a correct subvolume name
+ * 1-> name is a correct subvolume name
+ */
+static int test_issubvolname(char *name)
+{
+	return name[0] != '\0' && !strchr(name, '/') &&
+		strcmp(name, ".") && strcmp(name, "..");
+}
+
+/*
  * test if path is a directory
  * this function return
  * 0-> path exists but it is not a directory
@@ -127,8 +139,7 @@ static int cmd_subvol_create(int argc, char **argv)
 	dupdir = strdup(dst);
 	dstdir = dirname(dupdir);
 
-	if (!strcmp(newname, ".") || !strcmp(newname, "..") ||
-	     strchr(newname, '/') ){
+	if (!test_issubvolname(newname)) {
 		fprintf(stderr, "ERROR: uncorrect subvolume name ('%s')\n",
 			newname);
 		goto out;
@@ -302,8 +313,7 @@ again:
 	vname = basename(dupvname);
 	free(cpath);
 
-	if (!strcmp(vname, ".") || !strcmp(vname, "..") ||
-	     strchr(vname, '/')) {
+	if (!test_issubvolname(vname)) {
 		fprintf(stderr, "ERROR: incorrect subvolume name ('%s')\n",
 			vname);
 		ret = 1;
@@ -711,8 +721,7 @@ static int cmd_snapshot(int argc, char **argv)
 		dstdir = dirname(dupdir);
 	}
 
-	if (!strcmp(newname, ".") || !strcmp(newname, "..") ||
-	     strchr(newname, '/') ){
+	if (!test_issubvolname(newname)) {
 		fprintf(stderr, "ERROR: incorrect snapshot name ('%s')\n",
 			newname);
 		goto out;
-- 
1.9.3

