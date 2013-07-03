Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:43307 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202Ab3GCQdE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jul 2013 12:33:04 -0400
Received: by mail-we0-f173.google.com with SMTP id x54so309026wes.32
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Jul 2013 09:33:02 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs-progs: fix check in btrfs_lookup_extent_info()
Date: Wed,  3 Jul 2013 17:32:53 +0100
Message-Id: <1372869173-15043-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We want to test if path->slots[0] is greater than zero.
Testing for path->slots was a logical error, as it corresponds
to a memory address (start of fixed array) and therefore is
always non-zero.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 extent-tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extent-tree.c b/extent-tree.c
index b0cfe0a..f094266 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1515,7 +1515,7 @@ again:
 	 * to make sure.
 	 */
 	if (ret > 0 && metadata) {
-		if (path->slots) {
+		if (path->slots[0]) {
 			path->slots[0]--;
 			btrfs_item_key_to_cpu(path->nodes[0], &key,
 					      path->slots[0]);
-- 
1.7.9.5

