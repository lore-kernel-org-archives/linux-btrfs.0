Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51512 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbbCNQyC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Mar 2015 12:54:02 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: <stable@vger.kernel.org>
Subject: [PATCH v2] Btrfs: fix comp_oper to get right order
Date: Sun, 15 Mar 2015 00:53:53 +0800
Message-Id: <1426352033-18071-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Case (oper1->seq > oper2->seq) should differ with case (oper1->seq < oper2->seq).

Cc: <stable@vger.kernel.org> #linux-3.18.y and afterwards
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.cz>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
---
v2: add "cc stable".

 fs/btrfs/qgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 97159a8..058c79e 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1259,7 +1259,7 @@ static int comp_oper(struct btrfs_qgroup_operation *oper1,
 	if (oper1->seq < oper2->seq)
 		return -1;
 	if (oper1->seq > oper2->seq)
-		return -1;
+		return 1;
 	if (oper1->ref_root < oper2->ref_root)
 		return -1;
 	if (oper1->ref_root > oper2->ref_root)
-- 
1.8.1.4

