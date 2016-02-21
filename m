Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 15.mo4.mail-out.ovh.net ([91.121.62.11]:34055 "EHLO
	15.mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbcBUWvi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Feb 2016 17:51:38 -0500
Received: from mail178.ha.ovh.net (b9.ovh.net [213.186.33.59])
	by mo4.mail-out.ovh.net (Postfix) with SMTP id CB9B31054041
	for <linux-btrfs@vger.kernel.org>; Sun, 21 Feb 2016 23:34:08 +0100 (CET)
From: Philippe Loctaux <phil@philippeloctaux.com>
To: clm@fb.com
Cc: jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Philippe Loctaux <phil@philippeloctaux.com>
Subject: [PATCH] Btrfs: check-integrity: fixed a comment block coding style issue
Date: Sun, 21 Feb 2016 23:33:52 +0100
Message-Id: <1456094032-12447-1-git-send-email-phil@philippeloctaux.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Makes the comment block start with /* on a separate line, and end
with */ on a separate line as well.

Signed-off-by: Philippe Loctaux <phil@philippeloctaux.com>
---
 fs/btrfs/check-integrity.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 861d472..92436c7 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -226,8 +226,10 @@ struct btrfsic_block_data_ctx {
 	void *mem_to_free;
 };
 
-/* This structure is used to implement recursion without occupying
- * any stack space, refer to btrfsic_process_metablock() */
+/*
+ * This structure is used to implement recursion without occupying
+ * any stack space, refer to btrfsic_process_metablock()
+ */
 struct btrfsic_stack_frame {
 	u32 magic;
 	u32 nr;
-- 
2.7.1

