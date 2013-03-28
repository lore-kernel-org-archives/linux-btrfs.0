Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:55956 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126Ab3C1OUW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Mar 2013 10:20:22 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 252D09A0405
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Mar 2013 08:20:22 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id 9u72Ztt9WTMH6OHS (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 28 Mar 2013 08:20:21 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: fix segfault in fsck if the chunk tree is bogus
Date: Thu, 28 Mar 2013 10:27:46 -0400
Message-ID: <1364480866-17240-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I made open_ctree fail if the chunk tree couldn't be open, which means that fsck
now segfaults if it can't open the chunk tree.  So fix fsck to check the fs_info
we get back from open_ctree_fsinfo to make sure it's valid and exit if it's not
instead of segfaulting.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 cmds-check.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 35e9177..eef959e 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -3642,6 +3642,11 @@ int cmd_check(int argc, char **argv)
 	}
 
 	info = open_ctree_fs_info(argv[optind], bytenr, rw, 1);
+	if (!info) {
+		fprintf(stderr, "Couldn't open file system\n");
+		return -EIO;
+	}
+
 	uuid_unparse(info->super_copy.fsid, uuidbuf);
 	printf("Checking filesystem on %s\nUUID: %s\n", argv[optind], uuidbuf);
 
-- 
1.7.7.6

