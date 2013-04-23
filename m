Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:51290 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898Ab3DWOy7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Apr 2013 10:54:59 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 206359A033F
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Apr 2013 08:54:56 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id SRCgqvKeItvm0CXS (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 23 Apr 2013 08:54:55 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: don't BUG_ON() in btrfs_num_copies
Date: Tue, 23 Apr 2013 10:54:53 -0400
Message-ID: <1366728893-1529-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A user sent me a btrfs-image that was panicing because of some corruption.  This
is because we pass in a bogus value to btrfs_num_copies, and it panics.  Instead
just return 1.  We only call btrfs_num_copies to see if there are other copies
to try and read for things, so if we just return 1 it will make the callers exit
out with an appropriate error value.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/volumes.c |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c8a315d..c1a2217 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4232,9 +4232,25 @@ int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
 	read_lock(&em_tree->lock);
 	em = lookup_extent_mapping(em_tree, logical, len);
 	read_unlock(&em_tree->lock);
-	BUG_ON(!em);
 
-	BUG_ON(em->start > logical || em->start + em->len < logical);
+	/*
+	 * We could return errors for these cases, but that could get ugly and
+	 * we'd probably do the same thing which is just not do anything else
+	 * and exit, so return 1 so the callers don't try to use other copies.
+	 */
+	if (!em) {
+		btrfs_emerg(fs_info, "No mapping for %Lu-%Lu\n", logical,
+			    logical+len);
+		return 1;
+	}
+
+	if (em->start > logical || em->start + em->len < logical) {
+		btrfs_emerg(fs_info, "Invalid mapping for %Lu-%Lu, got "
+			    "%Lu-%Lu\n", logical, logical+len, em->start,
+			    em->start + em->len);
+		return 1;
+	}
+
 	map = (struct map_lookup *)em->bdev;
 	if (map->type & (BTRFS_BLOCK_GROUP_DUP | BTRFS_BLOCK_GROUP_RAID1))
 		ret = map->num_stripes;
-- 
1.7.7.6

