Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60520 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751382AbdFZKhe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Jun 2017 06:37:34 -0400
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <marc@merlins.org>
Subject: [PATCH v3 2/4] btrfs-progs: lowmem check: Fix false alert about referencer count mismatch
Date: Mon, 26 Jun 2017 18:37:25 +0800
Message-ID: <20170626103727.8945-2-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20170626103727.8945-1-lufq.fnst@cn.fujitsu.com>
References: <20170626103727.8945-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The normal back reference counting doesn't care about the extent referred
by the extent data in the shared leaf. The check_extent_data_backref
function need to skip the leaf that owner mismatch with the root_id.

Reported-by: Marc MERLIN <marc@merlins.org>
Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 cmds-check.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index 70d2b7f2..f42968cd 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -10692,7 +10692,8 @@ static int check_extent_data_backref(struct btrfs_fs_info *fs_info,
 		leaf = path.nodes[0];
 		slot = path.slots[0];
 
-		if (slot >= btrfs_header_nritems(leaf))
+		if (slot >= btrfs_header_nritems(leaf) ||
+		    btrfs_header_owner(leaf) != root_id)
 			goto next;
 		btrfs_item_key_to_cpu(leaf, &key, slot);
 		if (key.objectid != objectid || key.type != BTRFS_EXTENT_DATA_KEY)
-- 
2.13.1



