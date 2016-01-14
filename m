Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60958 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751957AbcANGAM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jan 2016 01:00:12 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id 9E72541896DD
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Jan 2016 13:59:47 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v4 17/18] btrfs: dedup: add a property handler for online dedup
Date: Thu, 14 Jan 2016 13:57:33 +0800
Message-ID: <1452751054-2365-18-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1452751054-2365-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1452751054-2365-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
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
index f9e6023..ae8b76d 100644
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
+	if (BTRFS_I(inode)->flags | BTRFS_INODE_NODEDUP)
+		return "disable";
 
+	return NULL;
+}
-- 
2.7.0



