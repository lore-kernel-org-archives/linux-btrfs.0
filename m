Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:46305 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755801AbdKCI26 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Nov 2017 04:28:58 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id E3C0448089DC
        for <linux-btrfs@vger.kernel.org>; Fri,  3 Nov 2017 16:28:49 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH RESEND 3/4] btrfs-progs: lowmem check: Fix false alert about referencer count mismatch
Date: Fri, 3 Nov 2017 16:28:05 +0800
Message-ID: <20171103082806.22448-4-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20171103082806.22448-1-lufq.fnst@cn.fujitsu.com>
References: <20171103082806.22448-1-lufq.fnst@cn.fujitsu.com>
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
index 5750bb72..a93ac2c8 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -12468,7 +12468,8 @@ static int check_extent_data_backref(struct btrfs_fs_info *fs_info,
 		leaf = path.nodes[0];
 		slot = path.slots[0];
 
-		if (slot >= btrfs_header_nritems(leaf))
+		if (slot >= btrfs_header_nritems(leaf) ||
+		    btrfs_header_owner(leaf) != root_id)
 			goto next;
 		btrfs_item_key_to_cpu(leaf, &key, slot);
 		if (key.objectid != objectid || key.type != BTRFS_EXTENT_DATA_KEY)
-- 
2.15.0



