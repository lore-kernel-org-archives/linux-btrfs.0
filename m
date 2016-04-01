Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:12218 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754119AbcDAGfi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Apr 2016 02:35:38 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v10 13/21] btrfs: dedupe: add a property handler for online dedupe
Date: Fri,  1 Apr 2016 14:35:04 +0800
Message-Id: <1459492512-31435-14-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1459492512-31435-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1459492512-31435-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

We use btrfs extended attribute "btrfs.dedupe" to record per-file online
dedupe status, so add a dedupe property handler.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/props.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index 3699212..a430886 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -42,6 +42,11 @@ static int prop_compression_apply(struct inode *inode,
 				  size_t len);
 static const char *prop_compression_extract(struct inode *inode);
 
+static int prop_dedupe_validate(const char *value, size_t len);
+static int prop_dedupe_apply(struct inode *inode, const char *value,
+			     size_t len);
+static const char *prop_dedupe_extract(struct inode *inode);
+
 static struct prop_handler prop_handlers[] = {
 	{
 		.xattr_name = XATTR_BTRFS_PREFIX "compression",
@@ -50,6 +55,13 @@ static struct prop_handler prop_handlers[] = {
 		.extract = prop_compression_extract,
 		.inheritable = 1
 	},
+	{
+		.xattr_name = XATTR_BTRFS_PREFIX "dedupe",
+		.validate = prop_dedupe_validate,
+		.apply = prop_dedupe_apply,
+		.extract = prop_dedupe_extract,
+		.inheritable = 1
+	},
 };
 
 void __init btrfs_props_init(void)
@@ -426,4 +438,33 @@ static const char *prop_compression_extract(struct inode *inode)
 	return NULL;
 }
 
+static int prop_dedupe_validate(const char *value, size_t len)
+{
+	if (!strncmp("disable", value, len))
+		return 0;
+
+	return -EINVAL;
+}
+
+static int prop_dedupe_apply(struct inode *inode, const char *value, size_t len)
+{
+	if (len == 0) {
+		BTRFS_I(inode)->flags &= ~BTRFS_INODE_NODEDUPE;
+		return 0;
+	}
+
+	if (!strncmp("disable", value, len)) {
+		BTRFS_I(inode)->flags |= BTRFS_INODE_NODEDUPE;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static const char *prop_dedupe_extract(struct inode *inode)
+{
+	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODEDUPE)
+		return "disable";
 
+	return NULL;
+}
-- 
2.7.4



