Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:13102 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757158AbaFSBvT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 21:51:19 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5J1pG38020925
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Jun 2014 09:51:16 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 1/4] btrfs-progs: cleanup duplicate assignment of variable leaf for btrfs-image
Date: Thu, 19 Jun 2014 09:46:00 +0800
Message-ID: <1403142363-29482-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The value of variable leaf in while loop don't have to be set
for every round. Just move it outside.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 btrfs-image.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index cf1fe2d..db5d193 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -1090,8 +1090,9 @@ static int copy_space_cache(struct btrfs_root *root,
 		return ret;
 	}
 
+	leaf = path->nodes[0];
+
 	while (1) {
-		leaf = path->nodes[0];
 		if (path->slots[0] >= btrfs_header_nritems(leaf)) {
 			ret = btrfs_next_leaf(root, path);
 			if (ret < 0) {
@@ -1157,8 +1158,9 @@ static int copy_from_extent_tree(struct metadump_struct *metadump,
 	}
 	ret = 0;
 
+	leaf = path->nodes[0];
+
 	while (1) {
-		leaf = path->nodes[0];
 		if (path->slots[0] >= btrfs_header_nritems(leaf)) {
 			ret = btrfs_next_leaf(extent_root, path);
 			if (ret < 0) {
-- 
1.8.1.4

