Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51438 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbaG3DZ6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jul 2014 23:25:58 -0400
Received: from kw-mxauth.gw.nic.fujitsu.com (unknown [10.0.237.134])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id F29583EE0BD
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 12:25:56 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id F1FA4AC0630
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 12:25:55 +0900 (JST)
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 8F1ADE18004
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 12:25:55 +0900 (JST)
Message-ID: <53D865B7.8040307@jp.fujitsu.com>
Date: Wed, 30 Jul 2014 12:25:43 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Subject: [PATCH v2] btrfs-progs: introduce test_issubvolname() for simplicity
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

There are many duplicated codes to check if the given string is
correct subvolume name. Introduce test_issubvolname() for this
purpose for simplicity.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: David Sterba <dsterba@suse.cz>

---
changelog:
v2: Move test_issubvolname() to utils.c.
    Change the target branch to integ-20140729.
---
 cmds-subvolume.c |  9 +++------
 utils.c          | 12 ++++++++++++
 utils.h          |  1 +
 3 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 8bdc447..c075fb2 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -127,8 +127,7 @@ static int cmd_subvol_create(int argc, char **argv)
 	dupdir = strdup(dst);
 	dstdir = dirname(dupdir);
 
-	if (!strcmp(newname, ".") || !strcmp(newname, "..") ||
-	     strchr(newname, '/') ){
+	if (!test_issubvolname(newname)) {
 		fprintf(stderr, "ERROR: incorrect subvolume name '%s'\n",
 			newname);
 		goto out;
@@ -302,8 +301,7 @@ again:
 	vname = basename(dupvname);
 	free(cpath);
 
-	if (!strcmp(vname, ".") || !strcmp(vname, "..") ||
-	     strchr(vname, '/')) {
+	if (!test_issubvolname(vname)) {
 		fprintf(stderr, "ERROR: incorrect subvolume name '%s'\n",
 			vname);
 		ret = 1;
@@ -711,8 +709,7 @@ static int cmd_snapshot(int argc, char **argv)
 		dstdir = dirname(dupdir);
 	}
 
-	if (!strcmp(newname, ".") || !strcmp(newname, "..") ||
-	     strchr(newname, '/') ){
+	if (!test_issubvolname(newname)) {
 		fprintf(stderr, "ERROR: incorrect snapshot name '%s'\n",
 			newname);
 		goto out;
diff --git a/utils.c b/utils.c
index d61cbec..e2a2acd 100644
--- a/utils.c
+++ b/utils.c
@@ -2685,3 +2685,15 @@ int btrfs_read_sysfs(char path[PATH_MAX])
 	close(fd);
 	return atoi((const char *)&val);
 }
+
+/*
+ * test if name is a correct subvolume name
+ * this function return
+ * 0-> name is not a correct subvolume name
+ * 1-> name is a correct subvolume name
+ */
+int test_issubvolname(char *name)
+{
+	return name[0] != '\0' && !strchr(name, '/') &&
+		strcmp(name, ".") && strcmp(name, "..");
+}
diff --git a/utils.h b/utils.h
index 0c9b65f..d635c84 100644
--- a/utils.h
+++ b/utils.h
@@ -133,6 +133,7 @@ int get_fslist(struct btrfs_ioctl_fslist **out_fslist, u64 *out_count);
 int fsid_to_mntpt(__u8 *fsid, char *mntpt, int *mnt_cnt);
 
 int test_minimum_size(const char *file, u32 leafsize);
+int test_issubvolname(char *name);
 
 /*
  * Btrfs minimum size calculation is complicated, it should include at least:
-- 
1.9.3

