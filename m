Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:36159 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754912AbbB0I0n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Feb 2015 03:26:43 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1R8PnQU019921
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Feb 2015 16:25:49 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/7] btrfs-progs: Move parse_qgroupid() to utils.c
Date: Fri, 27 Feb 2015 16:26:35 +0800
Message-ID: <1425025599-30048-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1425025599-30048-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1425025599-30048-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 qgroup.c | 28 ----------------------------
 qgroup.h |  1 -
 utils.c  | 28 ++++++++++++++++++++++++++++
 utils.h  |  1 +
 4 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/qgroup.c b/qgroup.c
index 62f8777..7288365 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -1248,34 +1248,6 @@ int btrfs_qgroup_parse_sort_string(char *opt_arg,
 	return 0;
 }
 
-u64 parse_qgroupid(char *p)
-{
-	char *s = strchr(p, '/');
-	char *ptr_src_end = p + strlen(p);
-	char *ptr_parse_end = NULL;
-	u64 level;
-	u64 id;
-
-	if (!s) {
-		id = strtoull(p, &ptr_parse_end, 10);
-		if (ptr_parse_end != ptr_src_end)
-			goto err;
-		return id;
-	}
-	level = strtoull(p, &ptr_parse_end, 10);
-	if (ptr_parse_end != s)
-		goto err;
-
-	id = strtoull(s+1, &ptr_parse_end, 10);
-	if (ptr_parse_end != ptr_src_end)
-		goto  err;
-
-	return (level << 48) | id;
-err:
-	fprintf(stderr, "ERROR:invalid qgroupid\n");
-	exit(-1);
-}
-
 int qgroup_inherit_size(struct btrfs_qgroup_inherit *p)
 {
 	return sizeof(*p) + sizeof(p->qgroups[0]) *
diff --git a/qgroup.h b/qgroup.h
index 6e65ef7..22737fa 100644
--- a/qgroup.h
+++ b/qgroup.h
@@ -93,7 +93,6 @@ void btrfs_qgroup_free_comparer_set(struct btrfs_qgroup_comparer_set *comp_set);
 int btrfs_qgroup_setup_comparer(struct btrfs_qgroup_comparer_set **comp_set,
 				enum btrfs_qgroup_comp_enum comparer,
 				int is_descending);
-u64 parse_qgroupid(char *p);
 int qgroup_inherit_size(struct btrfs_qgroup_inherit *p);
 int qgroup_inherit_add_group(struct btrfs_qgroup_inherit **inherit, char *arg);
 int qgroup_inherit_add_copy(struct btrfs_qgroup_inherit **inherit, char *arg,
diff --git a/utils.c b/utils.c
index 6228c7f..fc2791b 100644
--- a/utils.c
+++ b/utils.c
@@ -1795,6 +1795,34 @@ u64 parse_size(char *s)
 	return ret;
 }
 
+u64 parse_qgroupid(char *p)
+{
+	char *s = strchr(p, '/');
+	char *ptr_src_end = p + strlen(p);
+	char *ptr_parse_end = NULL;
+	u64 level;
+	u64 id;
+
+	if (!s) {
+		id = strtoull(p, &ptr_parse_end, 10);
+		if (ptr_parse_end != ptr_src_end)
+			goto err;
+		return id;
+	}
+	level = strtoull(p, &ptr_parse_end, 10);
+	if (ptr_parse_end != s)
+		goto err;
+
+	id = strtoull(s+1, &ptr_parse_end, 10);
+	if (ptr_parse_end != ptr_src_end)
+		goto  err;
+
+	return (level << BTRFS_QGROUP_LEVEL_SHIFT) | id;
+err:
+	fprintf(stderr, "ERROR:invalid qgroupid\n");
+	exit(-1);
+}
+
 int open_file_or_dir3(const char *fname, DIR **dirstream, int open_flags)
 {
 	int ret;
diff --git a/utils.h b/utils.h
index 82ab5e8..97f3eee 100644
--- a/utils.h
+++ b/utils.h
@@ -113,6 +113,7 @@ int pretty_size_snprintf(u64 size, char *str, size_t str_bytes, unsigned unit_mo
 int get_mountpt(char *dev, char *mntpt, size_t size);
 int btrfs_scan_block_devices(int run_ioctl);
 u64 parse_size(char *s);
+u64 parse_qgroupid(char *p);
 u64 arg_strtou64(const char *str);
 int open_file_or_dir(const char *fname, DIR **dirstream);
 int open_file_or_dir3(const char *fname, DIR **dirstream, int open_flags);
-- 
2.3.0

