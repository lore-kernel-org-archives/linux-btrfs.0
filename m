Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:47833 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751135Ab2H2GAE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Aug 2012 02:00:04 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q7T5Re3e002919
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Aug 2012 13:27:41 +0800
Message-ID: <503DA836.3060804@cn.fujitsu.com>
Date: Wed, 29 Aug 2012 13:27:18 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: fix wrong return value of check_owner_ref()
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we find the block by seach corresponding fs tree, we should return 0,
and tell the caller we pass the check. Or btrfsck will fail to read the
fs/file tree and report many error message by mistake.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Several days ago, I sent this patch as a reply. Now I send it as a independent
patch mail.
---
 btrfsck.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/btrfsck.c b/btrfsck.c
index 4e91769..57e7b57 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -1954,7 +1954,7 @@ static int check_owner_ref(struct btrfs_root *root,
 
 	if (buf->start == btrfs_node_blockptr(path.nodes[level + 1],
 					      path.slots[level + 1]))
-		rec->owner_ref_checked = 1;
+		found = 1;
 
 	btrfs_release_path(ref_root, &path);
 	return found ? 0 : 1;
-- 
1.7.6.5
