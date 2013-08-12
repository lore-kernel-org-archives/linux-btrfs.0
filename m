Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:55190 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab3HLTK5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Aug 2013 15:10:57 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 53C4F7C067D
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Aug 2013 13:10:57 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx2.fusionio.com with ESMTP id ox8FD6hkbWuLS6Cs (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 12 Aug 2013 13:10:56 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: skip subvol entries when checking if we've created a dir already V2
Date: Mon, 12 Aug 2013 15:10:54 -0400
Message-ID: <1376334654-18896-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have logic to see if we've already created a parent directory by check to see
if an inode inside of that directory has a lower inode number than the one we
are currently processing.  The logic is that if there is a lower inode number
then we would have had to made sure the directory was created at that previous
point.  The problem is that subvols inode numbers count from the lowest objectid
in the root tree, which may be less than our current progress.  So just skip if
our dir item key is a root item.  This fixes the original test and the xfstest
version I made that added an extra subvol create.  Thanks,

Reported-by: Emil Karlson <jekarlson@gmail.com>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
V1->V2: fix it properly

 fs/btrfs/send.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 0efc2e2..f8f8b1f 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -2538,7 +2538,8 @@ static int did_create_dir(struct send_ctx *sctx, u64 dir)
 		di = btrfs_item_ptr(eb, slot, struct btrfs_dir_item);
 		btrfs_dir_item_key_to_cpu(eb, di, &di_key);
 
-		if (di_key.objectid < sctx->send_progress) {
+		if (di_key.type != BTRFS_ROOT_ITEM_KEY &&
+		    di_key.objectid < sctx->send_progress) {
 			ret = 1;
 			goto out;
 		}
-- 
1.7.7.6

