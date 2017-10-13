Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:12814 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751589AbdJMJSD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Oct 2017 05:18:03 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 72D5247F13B3
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Oct 2017 17:17:58 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: subvol list: don't print deleted subvol as TOPLEVEL
Date: Fri, 13 Oct 2017 17:17:22 +0800
Message-ID: <20171013091722.2988-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We should use entry->root_id instead of top_id to determine whether it is
the toplevel subvolume.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 btrfs-list.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 6f2d8774..4ea8edfd 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1279,7 +1279,7 @@ static void filter_and_sort_subvol(struct root_lookup *all_subvols,
 
 		ret = resolve_root(all_subvols, entry, top_id);
 		if (ret == -ENOENT) {
-			if (top_id != BTRFS_FS_TREE_OBJECTID) {
+			if (entry->root_id != BTRFS_FS_TREE_OBJECTID) {
 				entry->full_path = strdup("DELETED");
 				entry->deleted = 1;
 			} else {
-- 
2.14.2



