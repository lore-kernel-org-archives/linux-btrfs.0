Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:7891 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752325AbcBBDIF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Feb 2016 22:08:05 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v5 17/19] btrfs: dedup: add a property handler for online dedup
Date: Tue,  2 Feb 2016 11:05:49 +0800
Message-Id: <1454382351-31775-18-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1454382351-31775-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1454382351-31775-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

We use btrfs extended attribute "btrfs.dedup" to record per-file online
dedup status, so add a dedup property handler.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/props.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index f9e6023..fb82080 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -41,6 +41,10 @@ static int prop_compression_apply(struct inode *inode,
 				  size_t len);
 static const char *prop_compression_extract(struct inode *inode);
 
+static int prop_dedup_validate(const char *value, size_t len);
+static int prop_dedup_apply(struct inode *inode, const char *value, size_t len);
+static const char *prop_dedup_extract(struct inode *inode);
+
 static struct prop_handler prop_handlers[] = {
 	{
 		.xattr_name = XATTR_BTRFS_PREFIX "compression",
@@ -49,6 +53,13 @@ static struct prop_handler prop_handlers[] = {
 		.extract = prop_compression_extract,
 		.inheritable = 1
 	},
+	{
+		.xattr_name = XATTR_BTRFS_PREFIX "dedup",
+		.validate = prop_dedup_validate,
+		.apply = prop_dedup_apply,
+		.extract = prop_dedup_extract,
+		.inheritable = 1
+	},
 };
 
 void __init btrfs_props_init(void)
@@ -425,4 +436,33 @@ static const char *prop_compression_extract(struct inode *inode)
 	return NULL;
 }
 
+static int prop_dedup_validate(const char *value, size_t len)
+{
+	if (!strncmp("disable", value, len))
+		return 0;
+
+	return -EINVAL;
+}
+
+static int prop_dedup_apply(struct inode *inode, const char *value, size_t len)
+{
+	if (len == 0) {
+		BTRFS_I(inode)->flags &= ~BTRFS_INODE_NODEDUP;
+		return 0;
+	}
+
+	if (!strncmp("disable", value, len)) {
+		BTRFS_I(inode)->flags |= BTRFS_INODE_NODEDUP;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static const char *prop_dedup_extract(struct inode *inode)
+{
+	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODEDUP)
+		return "disable";
 
+	return NULL;
+}
-- 
2.7.0



