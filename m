Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail2.unitix.de ([176.9.2.175]:52905 "EHLO mail2.unitix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549Ab2GIVSi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Jul 2012 17:18:38 -0400
From: Arnd Hannemann <arnd@arndnet.de>
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com, Arnd Hannemann <arnd@arndnet.de>
Subject: [PATCH] btrfs-progs: btrfs-image: don't segfault if no root is found
Date: Mon,  9 Jul 2012 23:18:28 +0200
Message-Id: <1341868709-7411-1-git-send-email-arnd@arndnet.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Error reporting is already done, so just return if root is NULL,
instead of segfaulting:

Program received signal SIGSEGV, Segmentation fault.
0x000000000042cd34 in create_metadump (input=0x7fffffffe847 "/usr/share", out=0x63e010, num_threads=0, compress_level=0)
    at btrfs-image.c:494
494		BUG_ON(root->nodesize != root->leafsize);
    at btrfs-image.c:494

Signed-off-by: Arnd Hannemann <arnd@arndnet.de>
---
 btrfs-image.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/btrfs-image.c b/btrfs-image.c
index f2bbcc8..fec51d8 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -491,6 +491,8 @@ static int create_metadump(const char *input, FILE *out, int num_threads,
 	int ret;
 
 	root = open_ctree(input, 0, 0);
+	if (!root)
+		return 1;
 	BUG_ON(root->nodesize != root->leafsize);
 
 	ret = metadump_init(&metadump, root, out, num_threads,
-- 
1.7.9.5

