Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:40221 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab3FNSZ6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Jun 2013 14:25:58 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 78E0D7C069F
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Jun 2013 12:25:57 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id tAa2BIZk7mshaeIj (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 14 Jun 2013 12:25:56 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: commit the csum_root if we do --init-csum-tree
Date: Fri, 14 Jun 2013 14:25:54 -0400
Message-ID: <1371234354-25635-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is just an oddity with the commit stuff in btrfs-progs.  It will just
update the generation of the root you call with, which in btrfsck case would
have been the fs_root.  But because we didn't actually update the fs_root we
wouldn't have cow'ed the fs root and therefore the generation will not match the
node which will make the file system unmountable.  Fix this by calling with the
csum_root which is the one we're messing with.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 cmds-check.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 68cdd52..fa77046 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -5227,7 +5227,7 @@ int cmd_check(int argc, char **argv)
 			return -EIO;
 		}
 
-		ret = btrfs_commit_transaction(trans, root);
+		ret = btrfs_commit_transaction(trans, info->csum_root);
 		if (ret)
 			exit(1);
 		goto out;
-- 
1.7.7.6

