Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:35450 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933329AbaLJVFo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 16:05:44 -0500
Received: from mail-in-12-z2.arcor-online.net (mail-in-12-z2.arcor-online.net [151.189.8.29])
	by mx.arcor.de (Postfix) with ESMTP id 9119DE3B72
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 22:05:43 +0100 (CET)
From: mwilck@arcor.de
To: linux-btrfs@vger.kernel.org
Cc: mwilck@arcor.de
Subject: [PATCH 17/18] btrfs-progs: ctree.c: make bin_search non-static
Date: Wed, 10 Dec 2014 21:51:47 +0100
Message-Id: <1418244708-7087-18-git-send-email-mwilck@arcor.de>
In-Reply-To: <1418244708-7087-1-git-send-email-mwilck@arcor.de>
References: <1418244708-7087-1-git-send-email-mwilck@arcor.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Martin Wilck <mwilck@arcor.de>

I need it in btrfs-search-metadata

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 ctree.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/ctree.c b/ctree.c
index 23399e2..1137312 100644
--- a/ctree.c
+++ b/ctree.c
@@ -602,8 +602,8 @@ static int generic_bin_search(struct extent_buffer *eb, unsigned long p,
  * simple bin_search frontend that does the right thing for
  * leaves vs nodes
  */
-static int bin_search(struct extent_buffer *eb, struct btrfs_key *key,
-		      int level, int *slot)
+int bin_search(struct extent_buffer *eb, struct btrfs_key *key,
+	       int level, int *slot)
 {
 	if (level == 0)
 		return generic_bin_search(eb,
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
