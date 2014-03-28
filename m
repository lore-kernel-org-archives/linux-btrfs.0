Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:32998 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbaC1Mj7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Mar 2014 08:39:59 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 731F8ABE5
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Mar 2014 12:39:58 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH v2] btrfs-progs: fix listing deleted subvolumes
Date: Fri, 28 Mar 2014 13:39:57 +0100
Message-Id: <1396010397-18255-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The real check whether to show deleted or live subvolumes was skipped if
just '-d' was specified without other filters. The 'deleted' filter was
not accounted.

It is now handled as a normal filter, that additionally sets the only_delete
global status in order to be processed before any other filters in
filter_root().

Signed-off-by: David Sterba <dsterba@suse.cz>
---
v2: previous version as wrong, the number of properly initialized filters did not
match the counter. don't make the only_deleted too quirky.

 btrfs-list.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 912b27c3deca..542dfe0c1a20 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1216,11 +1216,6 @@ int btrfs_list_setup_filter(struct btrfs_list_filter_set **filter_set,
 	BUG_ON(filter >= BTRFS_LIST_FILTER_MAX);
 	BUG_ON(set->nfilters > set->total);
 
-	if (filter == BTRFS_LIST_FILTER_DELETED) {
-		set->only_deleted = 1;
-		return 0;
-	}
-
 	if (set->nfilters == set->total) {
 		size = set->total + BTRFS_LIST_NFILTERS_INCREASE;
 		size = sizeof(*set) + size * sizeof(struct btrfs_list_filter);
@@ -1239,6 +1234,9 @@ int btrfs_list_setup_filter(struct btrfs_list_filter_set **filter_set,
 
 	BUG_ON(set->filters[set->nfilters].filter_func);
 
+	if (filter == BTRFS_LIST_FILTER_DELETED)
+		set->only_deleted = 1;
+
 	set->filters[set->nfilters].filter_func = all_filter_funcs[filter];
 	set->filters[set->nfilters].data = data;
 	set->nfilters++;
@@ -1250,7 +1248,7 @@ static int filter_root(struct root_info *ri,
 {
 	int i, ret;
 
-	if (!set || !set->nfilters)
+	if (!set)
 		return 1;
 
 	if (set->only_deleted && !ri->deleted)
-- 
1.7.9

