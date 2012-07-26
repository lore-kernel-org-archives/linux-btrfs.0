Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.140]:36033 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758Ab2GZJki (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Jul 2012 05:40:38 -0400
Received: from pizpot.store ([192.168.43.236])
	by jorabe.store (jorabe xp3) (RZmta 29.19 OK)
	with ESMTP id p046f7o6Q23qVd for <linux-btrfs@vger.kernel.org>;
	Thu, 26 Jul 2012 11:40:35 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix a misplaced address operator in a condition
Date: Thu, 26 Jul 2012 11:40:35 +0200
Message-Id: <1343295635-3854-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This should obviously not be "if (&flag)" but "if (flag)".

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/locking.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index a44eff074..2a1762c 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -67,7 +67,7 @@ void btrfs_clear_lock_blocking_rw(struct extent_buffer *eb, int rw)
 {
 	if (eb->lock_nested) {
 		read_lock(&eb->lock);
-		if (&eb->lock_nested && current->pid == eb->lock_owner) {
+		if (eb->lock_nested && current->pid == eb->lock_owner) {
 			read_unlock(&eb->lock);
 			return;
 		}
-- 
1.7.11.3

