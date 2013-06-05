Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:42887 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab3FEOMX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Jun 2013 10:12:23 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 475527C0041
	for <linux-btrfs@vger.kernel.org>; Wed,  5 Jun 2013 08:12:23 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id 7qykt9ZZLiu6ZwWr (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 05 Jun 2013 08:12:22 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: fix reference check for roots in btrfsck
Date: Wed, 5 Jun 2013 10:12:20 -0400
Message-ID: <1370441540-2034-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I noticed that I was getting these errors on a bigger file system with more
snapshots that had been removed.  This check is bogus since we won't inc
rec->found_ref if we don't find a REF_KEY _and_ a DIR_ITEM, so we only have to
worry about there being no references to a root if it actually has a root item.
If it doesn't then it's just referenced by things that will go no where anyway.
With this patch fsck no longer incorrectly complains about this file system
image I have.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 cmds-check.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 4083298..68cdd52 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -1637,6 +1637,14 @@ static int check_root_refs(struct btrfs_root *root,
 						rec->objectid);
 			if (ret == 0)
 				continue;
+
+			/*
+			 * If we don't have a root item then we likely just have
+			 * a dir item in a snapshot for this root but no actual
+			 * ref key or anything so it's meaningless.
+			 */
+			if (!rec->found_root_item)
+				continue;
 			errors++;
 			fprintf(stderr, "fs tree %llu not referenced\n",
 				(unsigned long long)rec->objectid);
-- 
1.7.7.6

