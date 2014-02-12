Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:63619 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaBLPIF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Feb 2014 10:08:05 -0500
Received: by mail-we0-f178.google.com with SMTP id q59so5958397wes.23
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Feb 2014 07:08:04 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 1/2] Btrfs: remove unnecessary ref heads rb tree search
Date: Wed, 12 Feb 2014 15:07:52 +0000
Message-Id: <1392217673-11075-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we didn't find the exact ref head we were looking for, if
return_bigger != 0 we set a new search key to match either the
next node after the last one we found or the first one in the
ref heads rb tree, and then did another full tree search. For both
cases this ended up being pointless as we would end up returning
an entry we already had before repeating the search.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/delayed-ref.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index f3bff89..56cdfe9 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -205,7 +205,6 @@ find_ref_head(struct rb_root *root, u64 bytenr,
 	struct btrfs_delayed_ref_head *entry;
 	int cmp = 0;
 
-again:
 	n = root->rb_node;
 	entry = NULL;
 	while (n) {
@@ -234,9 +233,9 @@ again:
 				n = rb_first(root);
 			entry = rb_entry(n, struct btrfs_delayed_ref_head,
 					 href_node);
-			bytenr = entry->node.bytenr;
-			return_bigger = 0;
-			goto again;
+			if (last)
+				*last = entry;
+			return entry;
 		}
 		return entry;
 	}
-- 
1.7.9.5

