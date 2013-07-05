Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:56810 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab3GEUnq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Jul 2013 16:43:46 -0400
Received: by mail-wg0-f47.google.com with SMTP id l18so2257446wgh.2
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Jul 2013 13:43:45 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v2] Btrfs-progs: remove incorrect slot decrement
Date: Fri,  5 Jul 2013 21:43:34 +0100
Message-Id: <1373057014-1424-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <20130705202718.GE2260@localhost.localdomain>
References: <20130705202718.GE2260@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs_set_block_flags() we want to check if the slot
in the leaf points to the first item in the leaf - if it
doesn't check if the previous item in the leaf is an extent
item. By removing this extra slot decrement we are indeed
checking the item right before the slot, and not the second
item before.

V2: Added Josef Bacik's review mention.

Reviewed-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 extent-tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extent-tree.c b/extent-tree.c
index f597e16..e04160b 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1596,7 +1596,7 @@ again:
 
 	if (ret > 0 && skinny_metadata) {
 		skinny_metadata = 0;
-		if (path->slots[0]--) {
+		if (path->slots[0]) {
 			path->slots[0]--;
 			btrfs_item_key_to_cpu(path->nodes[0], &key,
 					      path->slots[0]);
-- 
1.7.9.5

