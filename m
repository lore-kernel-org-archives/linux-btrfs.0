Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43453 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752086AbdEPRS0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 May 2017 13:18:26 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BADB7AB5F
        for <linux-btrfs@vger.kernel.org>; Tue, 16 May 2017 17:18:24 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/4] btrfs: remove unused member err from reada_extent
Date: Tue, 16 May 2017 19:17:28 +0200
Message-Id: <29a42c2794fb075b04affe940b6fbeb4020c1404.1494954874.git.dsterba@suse.com>
In-Reply-To: <cover.1494954874.git.dsterba@suse.com>
References: <cover.1494954874.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Seems to be unused since the initial commit, we ignore readahead errors
anyway, the full read will handle that if necessary.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/reada.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index a17e775a4a89..ab852b8e3e37 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -66,7 +66,6 @@ struct reada_extctl {
 struct reada_extent {
 	u64			logical;
 	struct btrfs_key	top;
-	int			err;
 	struct list_head	extctl;
 	int 			refcnt;
 	spinlock_t		lock;
-- 
2.12.0

