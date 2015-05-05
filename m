Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39754 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754765AbbEECWY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 May 2015 22:22:24 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <fdmanana@gmail.com>, <sandeen@redhat.com>
Subject: [PATCH] btrfs-progs: fsck: Fix a shallow copy which will leads to segfault.
Date: Tue, 5 May 2015 10:20:19 +0800
Message-ID: <1430792419-12528-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In copy_inode_rec(), a shallow copy happens on rec->holes rb_root.
So for shared inode case, new rec->holes still points to old rb_root,
and when the old inode record is freed, the new inode_rec->holes will
points to garbage and cause segfault when we try to free new
inode_rec->holes.

Fix it by calling copy_file_extent_holes() to do deep copy.

Reported-by: Eric Sandeen <sandeen@redhat.com>
Reported-by: Filipe David Manana <fdmanana@gmail.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 60ef48e..db121b1 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -516,12 +516,14 @@ static struct inode_record *clone_inode_rec(struct inode_record *orig_rec)
 	struct orphan_data_extent *src_orphan;
 	struct orphan_data_extent *dst_orphan;
 	size_t size;
+	int ret;
 
 	rec = malloc(sizeof(*rec));
 	memcpy(rec, orig_rec, sizeof(*rec));
 	rec->refs = 1;
 	INIT_LIST_HEAD(&rec->backrefs);
 	INIT_LIST_HEAD(&rec->orphan_extents);
+	rec->holes = RB_ROOT;
 
 	list_for_each_entry(orig, &orig_rec->backrefs, list) {
 		size = sizeof(*orig) + orig->namelen + 1;
@@ -536,6 +538,9 @@ static struct inode_record *clone_inode_rec(struct inode_record *orig_rec)
 		memcpy(dst_orphan, src_orphan, sizeof(*src_orphan));
 		list_add_tail(&dst_orphan->list, &rec->orphan_extents);
 	}
+	ret = copy_file_extent_holes(&rec->holes, &orig_rec->holes);
+	BUG_ON(ret < 0);
+
 	return rec;
 }
 
-- 
2.3.7

