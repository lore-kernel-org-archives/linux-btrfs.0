Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43466 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752086AbdEPRSc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 May 2017 13:18:32 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DFE91AB5F
        for <linux-btrfs@vger.kernel.org>; Tue, 16 May 2017 17:18:30 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/4] btrfs: remove unused members dir_path from recorded_ref
Date: Tue, 16 May 2017 19:17:34 +0200
Message-Id: <933d449c0a147d6a382bf8298e7df4df2b9c66c9.1494954874.git.dsterba@suse.com>
In-Reply-To: <cover.1494954874.git.dsterba@suse.com>
References: <cover.1494954874.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The two members do not seem to be used since the initial commit.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/send.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index fc496a6f842a..e8185c83f667 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -2769,12 +2769,10 @@ static int send_create_inode_if_needed(struct send_ctx *sctx)
 
 struct recorded_ref {
 	struct list_head list;
-	char *dir_path;
 	char *name;
 	struct fs_path *full_path;
 	u64 dir;
 	u64 dir_gen;
-	int dir_path_len;
 	int name_len;
 };
 
@@ -2798,12 +2796,6 @@ static int __record_ref(struct list_head *head, u64 dir,
 
 	ref->name = (char *)kbasename(ref->full_path->start);
 	ref->name_len = ref->full_path->end - ref->name;
-	ref->dir_path = ref->full_path->start;
-	if (ref->name == ref->full_path->start)
-		ref->dir_path_len = 0;
-	else
-		ref->dir_path_len = ref->full_path->end -
-				ref->full_path->start - 1 - ref->name_len;
 
 	list_add_tail(&ref->list, head);
 	return 0;
-- 
2.12.0

