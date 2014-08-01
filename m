Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50861 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaHAC62 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jul 2014 22:58:28 -0400
Received: from kw-mxq.gw.nic.fujitsu.com (unknown [10.0.237.131])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 949DF3EE1E0
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Aug 2014 11:58:26 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 970B9AC0879
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Aug 2014 11:58:25 +0900 (JST)
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 2C0091DB803C
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Aug 2014 11:58:25 +0900 (JST)
Message-ID: <53DB0238.90103@jp.fujitsu.com>
Date: Fri, 1 Aug 2014 11:58:00 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: David Sterba <dsterba@suse.cz>,
        Mike Fleetwood <mike.fleetwood@googlemail.com>
Subject: [PATCH 2/2] btrfs-progs: move test_isdir() to utils.c
References: <53DAFF05.9000205@jp.fujitsu.com>
In-Reply-To: <53DAFF05.9000205@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Since test_isdir() is a utility function, it's better to
move it to utils.c. In addition, "const char *" is
more appropriate type as its "path" argument because
this argument is not changed in this function.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: David Sterba <dsterba@suse.cz>
Cc: Mike Fleetwood <mike.fleetwood@googlemail.com>

---
 cmds-subvolume.c | 19 -------------------
 utils.c          | 19 +++++++++++++++++++
 utils.h          |  1 +
 3 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index c075fb2..e420bba 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -42,25 +42,6 @@ static const char * const subvolume_cmd_group_usage[] = {
 	NULL
 };
 
-/*
- * test if path is a directory
- * this function return
- * 0-> path exists but it is not a directory
- * 1-> path exists and it is  a directory
- * -1 -> path is unaccessible
- */
-static int test_isdir(char *path)
-{
-	struct stat	st;
-	int		res;
-
-	res = stat(path, &st);
-	if(res < 0 )
-		return -1;
-
-	return S_ISDIR(st.st_mode);
-}
-
 static const char * const cmd_subvol_create_usage[] = {
 	"btrfs subvolume create [-i <qgroupid>] [<dest>/]<name>",
 	"Create a subvolume",
diff --git a/utils.c b/utils.c
index d98aac8..059ed34 100644
--- a/utils.c
+++ b/utils.c
@@ -2697,3 +2697,22 @@ int test_issubvolname(const char *name)
 	return name[0] != '\0' && !strchr(name, '/') &&
 		strcmp(name, ".") && strcmp(name, "..");
 }
+
+/*
+ * test if path is a directory
+ * this function return
+ * 0-> path exists but it is not a directory
+ * 1-> path exists and it is a directory
+ * -1 -> path is unaccessible
+ */
+int test_isdir(const char *path)
+{
+	struct stat	st;
+	int		res;
+
+	res = stat(path, &st);
+	if(res < 0 )
+		return -1;
+
+	return S_ISDIR(st.st_mode);
+}
diff --git a/utils.h b/utils.h
index dad7d41..90fc1fe 100644
--- a/utils.h
+++ b/utils.h
@@ -134,6 +134,7 @@ int fsid_to_mntpt(__u8 *fsid, char *mntpt, int *mnt_cnt);
 
 int test_minimum_size(const char *file, u32 leafsize);
 int test_issubvolname(const char *name);
+int test_isdir(const char *path);
 
 /*
  * Btrfs minimum size calculation is complicated, it should include at least:
-- 
1.9.3

