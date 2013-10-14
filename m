Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:40382 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757110Ab3JNVZB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Oct 2013 17:25:01 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 330897C06A2
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Oct 2013 15:25:01 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx2.fusionio.com with ESMTP id HkdvbMPmeB9Zgfs2 (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 14 Oct 2013 15:25:00 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix hole check in log_one_extent
Date: Mon, 14 Oct 2013 17:24:58 -0400
Message-ID: <1381785898-4076-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I added an assert to make sure we were looking up aligned offsets for csums and
I tripped it when running xfstests.  This is because log_one_extent was checking
if block_start == 0 for a hole instead of EXTENT_MAP_HOLE.  This worked out fine
in practice it seems, but it adds a lot of extra work that is uneeded.  With
this fix I'm no longer tripping my assert.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/tree-log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 849b729..1134aa4 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3373,7 +3373,7 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 		btrfs_set_token_file_extent_type(leaf, fi,
 						 BTRFS_FILE_EXTENT_REG,
 						 &token);
-		if (em->block_start == 0)
+		if (em->block_start == EXTENT_MAP_HOLE)
 			skip_csum = true;
 	}
 
-- 
1.8.3.1

