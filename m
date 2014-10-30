Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:51131 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756515AbaJ3CqO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Oct 2014 22:46:14 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s9U2k4Bw032459
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Oct 2014 10:46:04 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 2/2] btrfs-progs: skip mounted fs when deal with umounted ones for fi show
Date: Thu, 30 Oct 2014 10:44:50 +0800
Message-ID: <1414637090-4476-2-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1414637090-4476-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1414637090-4476-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Stalling problems may happen when exec balance & fi show cmds concurrently.

With the following commit:
        commit 915902c500
        btrfs-progs: fix device missing of btrfs fi show with seed devices

The fi show cmd will bother the mounted fs when only umounted fs should
be handled after @btrfs_can_kernel() has finished showing all mounted ones.

We could skip the mounted fs after @btrfs_can_kernel() is done, then tasks
keeps going on mounted fs while fi show continues on umounted ones separately.

Reported-by: Petr Janecek <janecek@ucw.cz>
Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 cmds-filesystem.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 6437e57..67fe52b 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -53,6 +53,15 @@ struct seen_fsid {
 
 static struct seen_fsid *seen_fsid_hash[SEEN_FSID_HASH_SIZE] = {NULL,};
 
+static int is_seen_fsid(u8 *fsid)
+{
+	u8 hash = fsid[0];
+	int slot = hash % SEEN_FSID_HASH_SIZE;
+	struct seen_fsid *seen = seen_fsid_hash[slot];
+
+	return seen ? 1 : 0;
+}
+
 static int add_seen_fsid(u8 *fsid)
 {
 	u8 hash = fsid[0];
@@ -763,6 +772,10 @@ static int search_umounted_fs_uuids(struct list_head *all_uuids,
 			ret = 1;
 		}
 
+		/* skip all fs already shown as mounted fs */
+		if (is_seen_fsid(cur_fs->fsid))
+			continue;
+
 		fs_copy = malloc(sizeof(*fs_copy));
 		if (!fs_copy) {
 			ret = -ENOMEM;
-- 
1.8.1.4

