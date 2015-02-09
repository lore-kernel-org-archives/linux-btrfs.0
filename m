Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58694 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760761AbbBIUDg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Feb 2015 15:03:36 -0500
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 05/16] Btrfs-progs: don't try to repair reloc roots
Date: Mon, 9 Feb 2015 15:03:08 -0500
Message-ID: <1423512199-16552-6-git-send-email-jbacik@fb.com>
In-Reply-To: <1423512199-16552-1-git-send-email-jbacik@fb.com>
References: <1423512199-16552-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have logic to fix the root locations for roots in response to a corruption
bug we had earlier.  However this work doesn't apply to reloc roots and can
screw things up worse, so make sure we skip any reloc roots that we find.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 cmds-check.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index e74fa0f..2b08c64 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -8886,6 +8886,8 @@ again:
 
 		if (found_key.type != BTRFS_ROOT_ITEM_KEY)
 			goto next;
+		if (found_key.objectid == BTRFS_TREE_RELOC_OBJECTID)
+			goto next;
 
 		ret = maybe_repair_root_item(info, path, &found_key,
 					     trans ? 0 : 1);
-- 
1.8.3.1

