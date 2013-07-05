Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:56691 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab3GENfX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Jul 2013 09:35:23 -0400
Received: by mail-wg0-f46.google.com with SMTP id c11so1963688wgh.13
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Jul 2013 06:35:22 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs-progs: remove incorrect slot decrement
Date: Fri,  5 Jul 2013 14:35:07 +0100
Message-Id: <1373031307-22590-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs_set_block_flags() we want to check if the slot
in the leaf points to the first item in the leaf - if it
doesn't check if the previous item in the leaf is an extent
item. By removing this extra slot decrement we are indeed
checking the item right before the slot, and not the second
item before.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 extent-tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extent-tree.c b/extent-tree.c
index 381572d..5b6c7aa 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1609,7 +1609,7 @@ again:
 
 	if (ret > 0 && skinny_metadata) {
 		skinny_metadata = 0;
-		if (path->slots[0]--) {
+		if (path->slots[0]) {
 			path->slots[0]--;
 			btrfs_item_key_to_cpu(path->nodes[0], &key,
 					      path->slots[0]);
-- 
1.7.9.5

