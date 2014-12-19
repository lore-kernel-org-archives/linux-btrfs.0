Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43121 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbaLSQGn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 11:06:43 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 147E3AC19
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 16:06:42 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 6/6] btrfs-progs: let btrfs_free_path accept NULL
Date: Fri, 19 Dec 2014 17:06:41 +0100
Message-Id: <b0dc8fd2b3473c0daddde7e2bc59cd13e1963907.1419005022.git.dsterba@suse.cz>
In-Reply-To: <cover.1419005022.git.dsterba@suse.cz>
References: <cover.1419005022.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Same in kernel and matches semantics of free().

Resolves-Coverity-CID: 1054881
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 ctree.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/ctree.c b/ctree.c
index bd6cb125b2a2..589efa3db17e 100644
--- a/ctree.c
+++ b/ctree.c
@@ -48,6 +48,8 @@ struct btrfs_path *btrfs_alloc_path(void)
 
 void btrfs_free_path(struct btrfs_path *p)
 {
+	if (!p)
+		return;
 	btrfs_release_path(p);
 	kfree(p);
 }
-- 
2.1.3

