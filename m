Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37434 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753637AbaBCSXh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Feb 2014 13:23:37 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 24920AAD1
	for <linux-btrfs@vger.kernel.org>; Mon,  3 Feb 2014 18:23:37 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 2/6] btrfs: send: remove virtual_mem member from fs_path
Date: Mon,  3 Feb 2014 19:23:33 +0100
Message-Id: <69346f7e70562dc836fd2ebf6241d0b2f46c65b5.1391447200.git.dsterba@suse.cz>
In-Reply-To: <cover.1391447200.git.dsterba@suse.cz>
References: <cover.1391447200.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We don't need to keep track of that, it's available via is_vmalloc_addr.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/send.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 524086a882f9..ea427624e842 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -55,7 +55,6 @@ struct fs_path {
 			char *buf;
 			int buf_len;
 			unsigned int reversed:1;
-			unsigned int virtual_mem:1;
 			char inline_buf[];
 		};
 		char pad[PAGE_SIZE];
@@ -241,7 +240,6 @@ static struct fs_path *fs_path_alloc(void)
 	if (!p)
 		return NULL;
 	p->reversed = 0;
-	p->virtual_mem = 0;
 	p->buf = p->inline_buf;
 	p->buf_len = FS_PATH_INLINE_SIZE;
 	fs_path_reset(p);
@@ -265,7 +263,7 @@ static void fs_path_free(struct fs_path *p)
 	if (!p)
 		return;
 	if (p->buf != p->inline_buf) {
-		if (p->virtual_mem)
+		if (is_vmalloc_addr(p->buf))
 			vfree(p->buf);
 		else
 			kfree(p->buf);
@@ -299,13 +297,12 @@ static int fs_path_ensure_buf(struct fs_path *p, int len)
 			tmp_buf = vmalloc(len);
 			if (!tmp_buf)
 				return -ENOMEM;
-			p->virtual_mem = 1;
 		}
 		memcpy(tmp_buf, p->buf, p->buf_len);
 		p->buf = tmp_buf;
 		p->buf_len = len;
 	} else {
-		if (p->virtual_mem) {
+		if (is_vmalloc_addr(p->buf)) {
 			tmp_buf = vmalloc(len);
 			if (!tmp_buf)
 				return -ENOMEM;
@@ -319,7 +316,6 @@ static int fs_path_ensure_buf(struct fs_path *p, int len)
 					return -ENOMEM;
 				memcpy(tmp_buf, p->buf, p->buf_len);
 				kfree(p->buf);
-				p->virtual_mem = 1;
 			}
 		}
 		p->buf = tmp_buf;
-- 
1.7.9

