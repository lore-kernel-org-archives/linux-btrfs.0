Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39263 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750895AbbDUGVk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Apr 2015 02:21:40 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t3L6KPxB025371
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Apr 2015 14:20:25 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 01/18] btrfs: backref: Don't merge refs which are not for same block.
Date: Tue, 21 Apr 2015 14:21:17 +0800
Message-ID: <1429597294-11875-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1429597294-11875-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1429597294-11875-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Old __merge_refs() in backref.c will even merge refs whose root_id are
different, which makes qgroup gives wrong result.

Fix it by checking ref_for_same_block() before any mode specific works.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/backref.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index f55721f..7f14275 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -507,7 +507,7 @@ static int __add_missing_keys(struct btrfs_fs_info *fs_info,
 }
 
 /*
- * merge two lists of backrefs and adjust counts accordingly
+ * merge backrefs and adjust counts accordingly
  *
  * mode = 1: merge identical keys, if key is set
  *    FIXME: if we add more keys in __add_prelim_ref, we can merge more here.
@@ -535,9 +535,9 @@ static void __merge_refs(struct list_head *head, int mode)
 
 			ref2 = list_entry(pos2, struct __prelim_ref, list);
 
+			if (!ref_for_same_block(ref1, ref2))
+				continue;
 			if (mode == 1) {
-				if (!ref_for_same_block(ref1, ref2))
-					continue;
 				if (!ref1->parent && ref2->parent) {
 					xchg = ref1;
 					ref1 = ref2;
-- 
2.3.5

