Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 7.mo4.mail-out.ovh.net ([178.33.253.54]:37035 "EHLO
	7.mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbcBUX0y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Feb 2016 18:26:54 -0500
Received: from mail178.ha.ovh.net (b9.ovh.net [213.186.33.59])
	by mo4.mail-out.ovh.net (Postfix) with SMTP id 593C61114053
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Feb 2016 00:26:53 +0100 (CET)
From: Philippe Loctaux <phil@philippeloctaux.com>
To: clm@fb.com
Cc: jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Philippe Loctaux <phil@philippeloctaux.com>
Subject: [PATCH] Btrfs: compression: added line after variable declaration
Date: Mon, 22 Feb 2016 00:26:49 +0100
Message-Id: <1456097209-3916-1-git-send-email-phil@philippeloctaux.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Added line after variable declaration, fixing checkpatch warning.

Signed-off-by: Philippe Loctaux <phil@philippeloctaux.com>
---
 fs/btrfs/compression.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 3346cd8..5194b6f 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -522,6 +522,7 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 
 			if (zero_offset) {
 				int zeros;
+
 				zeros = PAGE_CACHE_SIZE - zero_offset;
 				userpage = kmap_atomic(page);
 				memset(userpage + zero_offset, 0, zeros);
-- 
2.7.1

