Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:61062 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752125Ab3DOK14 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Apr 2013 06:27:56 -0400
Message-ID: <516BD5DE.70904@cn.fujitsu.com>
Date: Mon, 15 Apr 2013 18:26:38 +0800
From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: wangshilong1991@gmail.com
Subject: [PATCH] Btrfs: do not continue if out of memory happens
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If out of memory happens, we should return -ENOMEM directly to the caller
rather than continue the work.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 fs/btrfs/backref.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index bd605c8..2fd5703 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -352,6 +352,8 @@ static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 		err = __resolve_indirect_ref(fs_info, search_commit_root,
 					     time_seq, ref, parents,
 					     extent_item_pos);
+		if (err == -ENOMEM)
+			goto out;
 		if (err)
 			continue;
 
@@ -367,7 +369,7 @@ static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 			new_ref = kmalloc(sizeof(*new_ref), GFP_NOFS);
 			if (!new_ref) {
 				ret = -ENOMEM;
-				break;
+				goto out;
 			}
 			memcpy(new_ref, ref, sizeof(*ref));
 			new_ref->parent = node->val;
@@ -377,7 +379,7 @@ static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 		}
 		ulist_reinit(parents);
 	}
-
+out:
 	ulist_free(parents);
 	return ret;
 }
-- 1.7.7.6 




