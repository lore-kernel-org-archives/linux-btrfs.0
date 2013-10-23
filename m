Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:35462 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab3JWQSG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Oct 2013 12:18:06 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 2377D7C06AD
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Oct 2013 10:18:06 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx1.fusionio.com with ESMTP id ybdhsxUYmB5f8eQI (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 23 Oct 2013 10:18:05 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: just return -ENOENT if we don't find the root item
Date: Wed, 23 Oct 2013 12:18:03 -0400
Message-ID: <1382545083-10565-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We were bug_on(slot == 0), but that's just obnoxious, return -ENOENT so we can
handle the situation properly.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 root-tree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/root-tree.c b/root-tree.c
index bdc8504..858fe2f 100644
--- a/root-tree.c
+++ b/root-tree.c
@@ -40,10 +40,11 @@ int btrfs_find_last_root(struct btrfs_root *root, u64 objectid,
 	ret = btrfs_search_slot(NULL, root, &search_key, path, 0, 0);
 	if (ret < 0)
 		goto out;
+	if (path->slots[0] == 0)
+		return -ENOENT;
 
 	BUG_ON(ret == 0);
 	l = path->nodes[0];
-	BUG_ON(path->slots[0] == 0);
 	slot = path->slots[0] - 1;
 	btrfs_item_key_to_cpu(l, &found_key, slot);
 	if (found_key.objectid != objectid) {
-- 
1.8.3.1

