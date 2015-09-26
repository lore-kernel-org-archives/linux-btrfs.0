Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:37658 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbbIZJFm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Sep 2015 05:05:42 -0400
Date: Sat, 26 Sep 2015 12:05:19 +0000
From: Alexandru Moise <00moses.alexander00@gmail.com>
To: clm@fb.com
Cc: jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, 00moses.alexander00@gmail.com
Subject: [PATCH] btrfs: remove unneeded NULL initializer for struct fs_path
Message-ID: <20150926120519.GA1629@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

fs_path_alloc() either returns an alloc'ed struct fs_path
or NULL, no need to initialize the pointer to NULL.

Signed-off-by: Alexandru Moise <00moses.alexander00@gmail.com>
---
 fs/btrfs/send.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index aa72bfd..0019c90 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -2230,7 +2230,7 @@ static int get_cur_path(struct send_ctx *sctx, u64 ino, u64 gen,
 			struct fs_path *dest)
 {
 	int ret = 0;
-	struct fs_path *name = NULL;
+	struct fs_path *name;
 	u64 parent_inode = 0;
 	u64 parent_gen = 0;
 	int stop = 0;
-- 
2.5.3

