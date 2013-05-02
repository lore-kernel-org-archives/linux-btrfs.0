Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:34540 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757234Ab3EBCsT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 May 2013 22:48:19 -0400
Received: by mail-pd0-f173.google.com with SMTP id v10so90034pde.4
        for <linux-btrfs@vger.kernel.org>; Wed, 01 May 2013 19:48:19 -0700 (PDT)
Received: from localhost.localdomain ([220.248.17.187])
        by mx.google.com with ESMTPSA id be7sm6101800pad.20.2013.05.01.19.48.16
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Wed, 01 May 2013 19:48:18 -0700 (PDT)
From: Lin Ming <mlin@kernel.org>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: fix segfault in walk_down_tree
Date: Thu,  2 May 2013 10:46:43 +0800
Message-Id: <1367462803-6630-1-git-send-email-mlin@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

walk_down_tree will fault when read_tree_block fails with NULL returned.

Signed-off-by: Lin Ming <mlin@kernel.org>
---
 cmds-check.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 12192fa..e4435d5 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -1256,6 +1256,8 @@ static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
 			reada_walk_down(root, cur, path->slots[*level]);
 			next = read_tree_block(root, bytenr, blocksize,
 					       ptr_gen);
+			if (!next)
+				goto out;
 		}
 
 		*level = *level - 1;
-- 
1.7.2.5

