Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:55059 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932466Ab3COVFx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Mar 2013 17:05:53 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id DCFA87C0402
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Mar 2013 15:05:52 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id 6XLb4GR3L6HU1ikD (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 15 Mar 2013 15:05:52 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: fix segfault when using tools fs with tree log
Date: Fri, 15 Mar 2013 17:13:08 -0400
Message-ID: <1363381988-2544-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We just free the log root after we set it up when we open a ctree in the tools.
This isn't nice, it makes double free's and leaks eb's, makes segfaults with
btrfs-image.  So fix this to be correct, and fix the cleanup if the buffer is
not uptodate.  With this fix I no longer segfault trying to do btrfs-image on a
file system with a log tree.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 disk-io.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 5aa9aa3..da7086f 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -656,11 +656,12 @@ static int find_and_setup_log_root(struct btrfs_root *tree_root,
 	fs_info->log_root_tree = log_root;
 
 	if (!extent_buffer_uptodate(log_root->node)) {
+		free_extent_buffer(log_root->node);
 		free(log_root);
+		fs_info->log_root_tree = NULL;
 		return -EIO;
 	}
 
-	free(log_root);
 	return 0;
 }
 
-- 
1.7.7.6

