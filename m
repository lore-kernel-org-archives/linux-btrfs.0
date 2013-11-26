Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:33017 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518Ab3KZPBn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Nov 2013 10:01:43 -0500
Received: by mail-wi0-f173.google.com with SMTP id hm4so5300961wib.12
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Nov 2013 07:01:42 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: add missing extent state caching calls
Date: Tue, 26 Nov 2013 15:01:34 +0000
Message-Id: <1385478094-11984-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we didn't find a matching extent state, we inserted a new one
but didn't cache it in the **cached_state parameter, which makes a
subsequent call do a tree lookup to get it.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/extent_io.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index cb9ce69..b8e7e41 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -817,6 +817,7 @@ again:
 		if (err)
 			extent_io_tree_panic(tree, err);
 
+		cache_state(prealloc, cached_state);
 		prealloc = NULL;
 		goto out;
 	}
@@ -1040,9 +1041,10 @@ again:
 			goto out;
 		}
 		err = insert_state(tree, prealloc, start, end, &bits);
-		prealloc = NULL;
 		if (err)
 			extent_io_tree_panic(tree, err);
+		cache_state(prealloc, cached_state);
+		prealloc = NULL;
 		goto out;
 	}
 	state = rb_entry(node, struct extent_state, rb_node);
-- 
1.7.9.5

