Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51802 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932520AbaFKQAg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Jun 2014 12:00:36 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: clm@fb.com, jbacik@fb.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] btrfs: prevent RCU warning when dereferencing radix tree slot
Date: Wed, 11 Jun 2014 12:00:25 -0400
Message-Id: <1402502425-17570-1-git-send-email-sasha.levin@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mark the dereference as protected by lock. Not doing so triggers
an RCU warning since the radix tree assumed that RCU is in use.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 fs/btrfs/tests/btrfs-tests.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c
index a5dcacb..9626252 100644
--- a/fs/btrfs/tests/btrfs-tests.c
+++ b/fs/btrfs/tests/btrfs-tests.c
@@ -135,7 +135,7 @@ restart:
 	radix_tree_for_each_slot(slot, &fs_info->buffer_radix, &iter, 0) {
 		struct extent_buffer *eb;
 
-		eb = radix_tree_deref_slot(slot);
+		eb = radix_tree_deref_slot_protected(slot, &fs_info->buffer_lock);
 		if (!eb)
 			continue;
 		/* Shouldn't happen but that kind of thinking creates CVE's */
-- 
1.7.10.4

