Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64893 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab2HNE57 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Aug 2012 00:57:59 -0400
Received: by mail-ob0-f174.google.com with SMTP id uo13so7967018obb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Aug 2012 21:57:59 -0700 (PDT)
Message-ID: <5029DAD2.4020805@gmail.com>
Date: Tue, 14 Aug 2012 12:57:54 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: remove redundant value set to path->reada in
 ctree.c/btrfs_alloc_path
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_init_path has init the path to 0s.
No need to set ->reada 0 after path init.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 ctree.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/ctree.c b/ctree.c
index 2d86b1e..a04e0da 100644
--- a/ctree.c
+++ b/ctree.c
@@ -43,10 +43,9 @@ struct btrfs_path *btrfs_alloc_path(void)
 {
 	struct btrfs_path *path;
 	path = kmalloc(sizeof(struct btrfs_path), GFP_NOFS);
-	if (path) {
+	if (path)
 		btrfs_init_path(path);
-		path->reada = 0;
-	}
+
 	return path;
 }
 
-- 1.7.1 
