Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:12829 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754026AbaLII1p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Dec 2014 03:27:45 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sB98RMse013490
	for <linux-btrfs@vger.kernel.org>; Tue, 9 Dec 2014 16:27:22 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v4 09/13] btrfs-progs: Add helper function find_file_name/type for nlink and inode_item repair.
Date: Tue, 9 Dec 2014 16:27:28 +0800
Message-ID: <1418113652-25088-10-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1418113652-25088-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1418113652-25088-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add find_file_name() and find_file_type() function for later nlink and
inode_item repair.

Later nlink repair will use both function and and inode_item repair will
use find_file_type().

They are done by searching the backref list, dir_item/index for type
search and dir_item/index or inode_ref for name search.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
Changelog:
v4:
   Newly introduced to replace the old find_file_name_type(),
   which doesn't make full use of the backref list and does a poor job
   in case of leaf corruption.
---
 cmds-check.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 53557b6..3ec619f 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -1874,6 +1874,47 @@ static int repair_inode_backrefs(struct btrfs_root *root,
 	return ret ? ret : repaired;
 }
 
+/*
+ * To determine the file type for nlink/inode_item repair
+ *
+ * Return 0 if file type is found and BTRFS_FT_* is stored into type.
+ * Return -ENOENT if file type is not found.
+ */
+static int find_file_type(struct inode_record *rec, u8 *type)
+{
+	struct inode_backref *backref;
+
+	list_for_each_entry(backref, &rec->backrefs, list) {
+		if (backref->found_dir_index || backref->found_dir_item) {
+			*type = backref->filetype;
+			return 0;
+		}
+	}
+	return -ENOENT;
+}
+
+/*
+ * To determine the file name for nlink repair
+ *
+ * Return 0 if file name is found, set name and namelen.
+ * Return -ENOENT if file name is not found.
+ */
+static int find_file_name(struct inode_record *rec,
+			  char *name, int *namelen)
+{
+	struct inode_backref *backref;
+
+	list_for_each_entry(backref, &rec->backrefs, list) {
+		if (backref->found_dir_index || backref->found_dir_item ||
+		    backref->found_inode_ref) {
+			memcpy(name, backref->name, backref->namelen);
+			*namelen = backref->namelen;
+			return 0;
+		}
+	}
+	return -ENOENT;
+}
+
 static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
 {
 	struct btrfs_trans_handle *trans;
-- 
2.1.3

