Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:2437 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751514Ab3DKHEo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Apr 2013 03:04:44 -0400
Message-ID: <51666187.2010602@cn.fujitsu.com>
Date: Thu, 11 Apr 2013 15:08:55 +0800
From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH V2 2/2] Btrfs: make __merge_refs() return type be void
Content-Type: text/plain; charset=GB2312
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

__merge_refs() always return 0, it is unnecessary
for the caller to check the return value.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
Changelog v1->v2:
- don't make __add_missing_keys() return type to be void
  so that makes people aware of unhandled BUG_ON() from read_tree
  block().
- rename title to be more accurate
---
 fs/btrfs/backref.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index dc200f6..13720d4 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -443,7 +443,7 @@ static int __add_missing_keys(struct btrfs_fs_info *fs_info,
  *           having a parent).
  * mode = 2: merge identical parents
  */
-static int __merge_refs(struct list_head *head, int mode)
+static void __merge_refs(struct list_head *head, int mode)
 {
 	struct list_head *pos1;
 
@@ -489,7 +489,6 @@ static int __merge_refs(struct list_head *head, int mode)
 		}
 
 	}
-	return 0;
 }
 
 /*
@@ -884,18 +883,14 @@ again:
 	if (ret)
 		goto out;
 
-	ret = __merge_refs(&prefs, 1);
-	if (ret)
-		goto out;
+	__merge_refs(&prefs, 1);
 
 	ret = __resolve_indirect_refs(fs_info, search_commit_root, time_seq,
 				      &prefs, extent_item_pos);
 	if (ret)
 		goto out;
 
-	ret = __merge_refs(&prefs, 2);
-	if (ret)
-		goto out;
+	__merge_refs(&prefs, 2);
 
 	while (!list_empty(&prefs)) {
 		ref = list_first_entry(&prefs, struct __prelim_ref, list);
-- 
1.7.7.6





