Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42915 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756622AbbCCPaC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Mar 2015 10:30:02 -0500
From: Quentin Casasnovas <quentin.casasnovas@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mark Fasheh <mfasheh@suse.de>,
        Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>,
        Quentin Casasnovas <quentin.casasnovas@oracle.com>
Subject: [PATCH] Btrfs:__add_inode_ref: out of bounds memory read when looking for extended ref.
Date: Tue,  3 Mar 2015 16:31:38 +0100
Message-Id: <1425396698-31009-1-git-send-email-quentin.casasnovas@oracle.com>
In-Reply-To: <1425396236.29552.2@mail.thefacebook.com>
References: <1425396236.29552.2@mail.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Improper arithmetics when calculting the address of the extended ref could
lead to an out of bounds memory read and kernel panic.

Signed-off-by: Quentin Casasnovas <quentin.casasnovas@oracle.com>
---
 fs/btrfs/tree-log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git fs/btrfs/tree-log.c fs/btrfs/tree-log.c
index 9a37f8b..c5b8ba3 100644
--- fs/btrfs/tree-log.c
+++ fs/btrfs/tree-log.c
@@ -1012,7 +1012,7 @@ again:
 		base = btrfs_item_ptr_offset(leaf, path->slots[0]);
 
 		while (cur_offset < item_size) {
-			extref = (struct btrfs_inode_extref *)base + cur_offset;
+			extref = (struct btrfs_inode_extref *)(base + cur_offset);
 
 			victim_name_len = btrfs_inode_extref_name_len(leaf, extref);
 
-- 
2.0.5

