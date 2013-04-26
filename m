Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37327 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898Ab3DZVGP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Apr 2013 17:06:15 -0400
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 9/9] Btrfs-progs: remove btrfs_init_path calls from ctree.c
Date: Fri, 26 Apr 2013 16:06:10 -0500
Message-Id: <1367010370-21571-10-git-send-email-sandeen@redhat.com>
In-Reply-To: <1367010370-21571-1-git-send-email-sandeen@redhat.com>
References: <1367010370-21571-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_init_path was initially used when the path objects were on the
stack.  Now all the work is done by btrfs_alloc_path and btrfs_init_path
isn't required.

This patch removes it, and just uses kmem_cache_zalloc to zero out the object.

[Eric Sandeen: port kernel commit e00f730 to userspace]

(Note, the rest of userspace has an on-path stack, so the actual
function remains for now).

Signed-off-by: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 ctree.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/ctree.c b/ctree.c
index 7257e6f..24ca6f3 100644
--- a/ctree.c
+++ b/ctree.c
@@ -42,11 +42,7 @@ inline void btrfs_init_path(struct btrfs_path *p)
 struct btrfs_path *btrfs_alloc_path(void)
 {
 	struct btrfs_path *path;
-	path = kmalloc(sizeof(struct btrfs_path), GFP_NOFS);
-	if (path) {
-		btrfs_init_path(path);
-		path->reada = 0;
-	}
+	path = kzalloc(sizeof(struct btrfs_path), GFP_NOFS);
 	return path;
 }
 
-- 
1.7.1

