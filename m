Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:48275 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab3GSGqu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Jul 2013 02:46:50 -0400
Received: by mail-pa0-f54.google.com with SMTP id kx10so4101091pab.41
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jul 2013 23:46:50 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs-progs: add missing path alloc return value check
Date: Thu, 18 Jul 2013 23:46:10 -0700
Message-Id: <1374216370-18953-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 extent-tree.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/extent-tree.c b/extent-tree.c
index f597e16..8e93bab 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1577,6 +1577,8 @@ int btrfs_set_block_flags(struct btrfs_trans_handle *trans,
 				  BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA);
 
 	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
 	path->reada = 1;
 
 	key.objectid = bytenr;
-- 
1.7.9.5

