Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56607 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753545AbaBYSdK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 13:33:10 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 3369675012
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Feb 2014 18:33:10 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 2/2] btrfs: send: simplify allocation code in fs_path_ensure_buf
Date: Tue, 25 Feb 2014 19:33:08 +0100
Message-Id: <dfda9aeaad160e6ac90a2678451c12fe6ff5b103.1393352970.git.dsterba@suse.cz>
In-Reply-To: <cover.1393352970.git.dsterba@suse.cz>
References: <cover.1393352970.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/send.c |   30 ++++++++++++------------------
 1 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 613f4bc93571..31b9c59eb087 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -294,24 +294,18 @@ static int fs_path_ensure_buf(struct fs_path *p, int len)
 	/*
 	 * First time the inline_buf does not suffice
 	 */
-	if (p->buf == p->inline_buf) {
-		p->buf = kmalloc(len, GFP_NOFS);
-		if (!p->buf)
-			return -ENOMEM;
-		/*
-		 * The real size of the buffer is bigger, this will let the
-		 * fast path happen most of the time
-		 */
-		p->buf_len = ksize(p->buf);
-	} else {
-		char *tmp;
-
-		tmp = krealloc(p->buf, len, GFP_NOFS);
-		if (!tmp)
-			return -ENOMEM;
-		p->buf = tmp;
-		p->buf_len = ksize(p->buf);
-	}
+	if (p->buf == p->inline_buf)
+		tmp_buf = kmalloc(len, GFP_NOFS);
+	else
+		tmp_buf = krealloc(p->buf, len, GFP_NOFS);
+	if (!tmp_buf)
+		return -ENOMEM;
+	p->buf = tmp_buf;
+	/*
+	 * The real size of the buffer is bigger, this will let the fast path
+	 * happen most of the time
+	 */
+	p->buf_len = ksize(p->buf);
 
 	if (p->reversed) {
 		tmp_buf = p->buf + old_buf_len - path_len - 1;
-- 
1.7.9

