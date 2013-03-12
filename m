Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:55276 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab3CLOA0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Mar 2013 10:00:26 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 821209A0405
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2013 08:00:24 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id djLv7AqvrFLsloxs (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2013 08:00:24 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: alloc our super copy in btrfs-find-root
Date: Tue, 12 Mar 2013 10:07:39 -0400
Message-ID: <1363097259-1860-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dave fixed the fs_info to allocate the super copy instead of embedding it, but
he failed to notice that I open code open_ctree in btrfs-find-root so we end up
with a super that's not allocated, so we segfault whenever you try to run
btrfs-find-root.  I've fixed this up and now we don't segfault anymore.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 find-root.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/find-root.c b/find-root.c
index f99fb76..810d835 100644
--- a/find-root.c
+++ b/find-root.c
@@ -116,6 +116,7 @@ static struct btrfs_root *open_ctree_broken(int fd, const char *device)
 	}
 
 	memset(fs_info, 0, sizeof(*fs_info));
+	fs_info->super_copy = calloc(1, BTRFS_SUPER_INFO_SIZE);
 	fs_info->tree_root = tree_root;
 	fs_info->extent_root = extent_root;
 	fs_info->chunk_root = chunk_root;
-- 
1.7.7.6

