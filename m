Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42195 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755052AbaLJN7m (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 08:59:42 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id AAA96AD0B
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 13:59:40 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: mkfs: make skinny-metadata default
Date: Wed, 10 Dec 2014 14:59:39 +0100
Message-Id: <1418219979-13170-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

According to public poll, this is desired and deemed to be safe. Feature
introduced in kernel 3.10 (Jun 2013).

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 mkfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mkfs.c b/mkfs.c
index e10e62d2f2e3..f930a5353f75 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -46,7 +46,8 @@
 
 static u64 index_cnt = 2;
 
-#define DEFAULT_MKFS_FEATURES	(BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF)
+#define DEFAULT_MKFS_FEATURES	(BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF \
+		| BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA)
 
 #define DEFAULT_MKFS_LEAF_SIZE 16384
 
-- 
2.1.3

