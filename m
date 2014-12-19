Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43116 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762AbaLSQGg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 11:06:36 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 7154DAC19
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 16:06:35 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 4/6] btrfs-progs: check result of first_cache_extent
Date: Fri, 19 Dec 2014 17:06:34 +0100
Message-Id: <813550c84636f7d570c541c22eee60b11346b4f3.1419005022.git.dsterba@suse.cz>
In-Reply-To: <cover.1419005022.git.dsterba@suse.cz>
References: <cover.1419005022.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If the tree's empty, we'll get NULL and dereference it.

Resolves-Coverity-CID: 1248828
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 cmds-check.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 6eea36c2f52c..3e7a4ebdce44 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -8075,6 +8075,8 @@ static void free_roots_info_cache(void)
 		struct root_item_info *rii;
 
 		entry = first_cache_extent(roots_info_cache);
+		if (!entry)
+			break;
 		remove_cache_extent(roots_info_cache, entry);
 		rii = container_of(entry, struct root_item_info, cache_extent);
 		free(rii);
-- 
2.1.3

