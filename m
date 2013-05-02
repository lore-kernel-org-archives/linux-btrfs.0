Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:49113 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756874Ab3EBNR0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 May 2013 09:17:26 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id AC60B9A0425
	for <linux-btrfs@vger.kernel.org>; Thu,  2 May 2013 07:17:25 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id 7TbGdxdUaSYp62WC (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 02 May 2013 07:17:25 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: pass properly formated key to read_fs_root
Date: Thu, 2 May 2013 09:17:22 -0400
Message-ID: <1367500642-1920-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have a BUG_ON() in read_fs_root that expects key->offset == (u64)-1.  Restore
will just pass in the location it reads out of the inode if it has a subvol
reference and pass that in, which doesn't have offset == (u64)-1, so it causes
restore blow up.  This was reported in bugzilla and this patch fixed the
problem.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 cmds-restore.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index 12b2188..aada7d0 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -612,6 +612,7 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 					goto next;
 				}
 
+				location.offset = (u64)-1;
 				search_root = btrfs_read_fs_root(root->fs_info,
 								 &location);
 				if (IS_ERR(search_root)) {
-- 
1.7.7.6

