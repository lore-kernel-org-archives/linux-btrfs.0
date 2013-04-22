Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:39555 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab3DVNOO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Apr 2013 09:14:14 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 46F279A0406
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Apr 2013 07:14:14 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id vbXDZ9AJYxhErLn2 (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 22 Apr 2013 07:14:13 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: deal with bad mappings in btrfs_map_block
Date: Mon, 22 Apr 2013 09:14:11 -0400
Message-ID: <1366636451-2151-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin Steigerwald reported a BUG_ON() in btrfs_map_block where we didn't find
a chunk for a particular block we were trying to map.  This happened because the
block was bogus.  We shouldn't be BUG_ON()'ing in this case, just print a
message and return an error.  This came from reada_add_block and it appears to
deal with an error fine so we should be good there.  Thanks,

Reported-by: Martin Steigerwald <Martin@lichtvoll.de>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/volumes.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 76ded9e..c8a315d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4406,10 +4406,16 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 		btrfs_crit(fs_info, "unable to find logical %llu len %llu",
 			(unsigned long long)logical,
 			(unsigned long long)*length);
-		BUG();
+		return -EINVAL;
+	}
+
+	if (em->start > logical || em->start + em->len < logical) {
+		btrfs_crit(fs_info, "found a bad mapping, wanted %Lu, "
+			   "found %Lu-%Lu\n", logical, em->start,
+			   em->start + em->len);
+		return -EINVAL;
 	}
 
-	BUG_ON(em->start > logical || em->start + em->len < logical);
 	map = (struct map_lookup *)em->bdev;
 	offset = logical - em->start;
 
-- 
1.7.7.6

