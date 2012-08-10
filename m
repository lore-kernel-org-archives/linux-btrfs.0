Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:8547 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755209Ab2HJIyW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Aug 2012 04:54:22 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q7A8sL9K011830
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Aug 2012 16:54:21 +0800
Message-ID: <5024CC11.6030905@cn.fujitsu.com>
Date: Fri, 10 Aug 2012 16:53:37 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH V2 2/3] Btrfs-progs: fix wrong leaf when checking the trees
 relationship
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The variant named 'leaf' in is_child_root() still hold old result after
we get the next leaf, it make btrfsck returns the wrong result, such as
"unresolved ref root ..", fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v2:
- just change the title of this patch.
---
 btrfsck.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/btrfsck.c b/btrfsck.c
index 088b9f4..bb1aa76 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -786,6 +786,7 @@ static int is_child_root(struct btrfs_root *root, u64 parent_root_id,
 
 			if (ret > 0)
 				break;
+			leaf = path.nodes[0];
 		}
 
 		btrfs_item_key_to_cpu(leaf, &key, path.slots[0]);
-- 
1.7.6.5
