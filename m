Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:55067 "EHLO
        mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752238AbdJ3IPK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Oct 2017 04:15:10 -0400
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 96306AC00C9
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Oct 2017 17:15:01 +0900 (JST)
Received: from g01jpexchkw35.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id C30ED328646
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Oct 2017 17:15:00 +0900 (JST)
Subject: [PATCH 2/2] btrfs-progs: show: allow fi show -u for FS_TREE
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <c5cfe661-fb6a-8346-874b-b20cd9cf0d90@jp.fujitsu.com>
Message-ID: <e0900f28-84cf-469e-f35f-7b59decf21ab@jp.fujitsu.com>
Date: Mon, 30 Oct 2017 17:14:57 +0900
MIME-Version: 1.0
In-Reply-To: <c5cfe661-fb6a-8346-874b-b20cd9cf0d90@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Allow "fi show -u" for uuid of top-level subvolume too for consistency.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 btrfs-list.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index b6d7658..91fdab8 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1594,9 +1594,15 @@ int btrfs_get_subvol(int fd, struct root_info *the_ri)
 		ri = rb_entry(rbn, struct root_info, rb_node);
 		rr = resolve_root(&rl, ri, root_id);
 		if (rr == -ENOENT) {
-			ret = -ENOENT;
-			rbn = rb_next(rbn);
-			continue;
+			if (ri->root_id == BTRFS_FS_TREE_OBJECTID) {
+				ri->path = strdup("/");
+				ri->name = strdup("<FS_TREE>");
+				ri->full_path = strdup("/");
+			} else {
+				ret = -ENOENT;
+				rbn = rb_next(rbn);
+				continue;
+			}
 		}
 
 		if (!comp_entry_with_rootid(the_ri, ri, 0) ||
-- 
2.9.5

