Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21890 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S933598AbcIGCy1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Sep 2016 22:54:27 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH] btrfs-progs: qgroup: Fix regression leads to corrupted qgroup status
Date: Wed, 7 Sep 2016 10:54:19 +0800
Message-ID: <20160907025419.23284-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 93dabf211d74daf6e3de642bdd887a90a00f7b49
Author: Mark Fasheh <mfasheh@suse.de>
Date:   Fri Jun 17 13:37:48 2016 -0700

    btrfs-progs: check: verify qgroups above level 0

This commit introduced a new regression which corrupts
read_qgroup_status, since it iterate leaf with manually specified slot,
not correct path->slot[0].

This leads to wrong slot[0] and read_qgroup_status() will read out wrong
flags, leading to regression.

Fix read_qgroup_status() by using eb and slot instread of wrong path
strucutre.

Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 qgroup-verify.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/qgroup-verify.c b/qgroup-verify.c
index 66eb870..f6df12d 100644
--- a/qgroup-verify.c
+++ b/qgroup-verify.c
@@ -874,15 +874,14 @@ static int add_qgroup_relation(u64 memberid, u64 parentid)
 	return 0;
 }
 
-static void read_qgroup_status(struct btrfs_path *path,
+static void read_qgroup_status(struct extent_buffer *eb, int slot,
 			      struct counts_tree *counts)
 {
 	struct btrfs_qgroup_status_item *status_item;
 	u64 flags;
 
-	status_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
-				     struct btrfs_qgroup_status_item);
-	flags = btrfs_qgroup_status_flags(path->nodes[0], status_item);
+	status_item = btrfs_item_ptr(eb, slot, struct btrfs_qgroup_status_item);
+	flags = btrfs_qgroup_status_flags(eb, status_item);
 	/*
 	 * Since qgroup_inconsist/rescan_running is just one bit,
 	 * assign value directly won't work.
@@ -946,7 +945,7 @@ loop:
 			}
 
 			if (key.type == BTRFS_QGROUP_STATUS_KEY) {
-				read_qgroup_status(&path, &counts);
+				read_qgroup_status(leaf, i, &counts);
 				continue;
 			}
 
-- 
2.9.3



