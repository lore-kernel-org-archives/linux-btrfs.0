Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:49799 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab3G2ShN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Jul 2013 14:37:13 -0400
Received: by mail-wg0-f43.google.com with SMTP id z12so5137868wgg.34
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jul 2013 11:37:11 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: jbacik@fusionio.com, Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs-progs: return immediately on tree search failure
Date: Mon, 29 Jul 2013 19:36:36 +0100
Message-Id: <1375122996-6665-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If the chunk tree search failed in volumes.c:btrfs_read_chunk_tree()
return immediately, rather than looping and use the invalid contents
of the path structure, causing weird errors/crash at run time.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 volumes.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/volumes.c b/volumes.c
index 0ff2283..79008de 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1727,6 +1727,8 @@ int btrfs_read_chunk_tree(struct btrfs_root *root)
 	key.type = 0;
 again:
 	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0)
+		goto error;
 	while(1) {
 		leaf = path->nodes[0];
 		slot = path->slots[0];
-- 
1.7.9.5

