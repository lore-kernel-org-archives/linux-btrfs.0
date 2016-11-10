Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38184 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933808AbcKJPBz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Nov 2016 10:01:55 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AA299ACB2
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Nov 2016 15:01:54 +0000 (UTC)
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH] Return best entry, if it is the first one
Date: Thu, 10 Nov 2016 09:01:46 -0600
Message-Id: <20161110150147.19766-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The find_most_right_entry() tends to miss on the best entry if it
is the first one on the list and there are only two entries in the list.
So, we assign both prev and best to entry.

To do this, the selection process (rather the rejection) has to be
performed earlier to skip on broken==count.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 cmds-check.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 368c1c5..779870a 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -8184,11 +8184,6 @@ static struct extent_entry *find_most_right_entry(struct list_head *entries)
 	struct extent_entry *entry, *best = NULL, *prev = NULL;
 
 	list_for_each_entry(entry, entries, list) {
-		if (!prev) {
-			prev = entry;
-			continue;
-		}
-
 		/*
 		 * If there are as many broken entries as entries then we know
 		 * not to trust this particular entry.
@@ -8196,6 +8191,12 @@ static struct extent_entry *find_most_right_entry(struct list_head *entries)
 		if (entry->broken == entry->count)
 			continue;
 
+		if (!prev) {
+			best = entry;
+			prev = entry;
+			continue;
+		}
+
 		/*
 		 * If our current entry == best then we can't be sure our best
 		 * is really the best, so we need to keep searching.
-- 
2.10.0

