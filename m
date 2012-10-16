Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:23910 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754306Ab2JPLb5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Oct 2012 07:31:57 -0400
Message-ID: <507D45C2.6010803@cn.fujitsu.com>
Date: Tue, 16 Oct 2012 19:32:18 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH 1/2] Btrfs: fix wrong comment in can_overcommit()
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The comment is not coincident with the code. Fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 7563db7..2cfcce2 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3668,9 +3668,9 @@ static int can_overcommit(struct btrfs_root *root,
 		avail >>= 1;
 
 	/*
-	 * If we aren't flushing don't let us overcommit too much, say
-	 * 1/8th of the space.  If we can flush, let it overcommit up to
-	 * 1/2 of the space.
+	 * If we aren't flushing all things, let us overcommit up to
+	 * 1/2th of the space. If we can flush, don't let us overcommit
+	 * too much, let it overcommit up to 1/8 of the space.
 	 */
 	if (flush)
 		avail >>= 3;
-- 
1.7.6.5
