Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56606 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525AbaBYSdB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 13:33:01 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id A5F5175012
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Feb 2014 18:33:00 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/2] btrfs: send: fix old buffer length in fs_path_ensure_buf
Date: Tue, 25 Feb 2014 19:32:59 +0100
Message-Id: <6bb080ca89f018139b4cb6d515f93a2f23ed9b46.1393352970.git.dsterba@suse.cz>
In-Reply-To: <cover.1393352970.git.dsterba@suse.cz>
References: <cover.1393352970.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In "btrfs: send: lower memory requirements in common case" the code to
save the old_buf_len was incorrectly moved to a wrong place and broke
the original logic.

Reported-by: Filipe David Manana <fdmanana@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/send.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index b6d416ce6b3b..613f4bc93571 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -288,6 +288,9 @@ static int fs_path_ensure_buf(struct fs_path *p, int len)
 	if (p->buf_len >= len)
 		return 0;
 
+	path_len = p->end - p->start;
+	old_buf_len = p->buf_len;
+
 	/*
 	 * First time the inline_buf does not suffice
 	 */
@@ -310,9 +313,6 @@ static int fs_path_ensure_buf(struct fs_path *p, int len)
 		p->buf_len = ksize(p->buf);
 	}
 
-	path_len = p->end - p->start;
-	old_buf_len = p->buf_len;
-
 	if (p->reversed) {
 		tmp_buf = p->buf + old_buf_len - path_len - 1;
 		p->end = p->buf + p->buf_len - 1;
-- 
1.7.9

