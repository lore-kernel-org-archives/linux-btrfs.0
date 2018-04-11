Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53313 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751854AbeDKIVZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Apr 2018 04:21:25 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 972CFAF6E
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Apr 2018 08:21:24 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/4] btrfs: Fix lock release order
Date: Wed, 11 Apr 2018 11:21:18 +0300
Message-Id: <1523434880-7799-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1523434880-7799-1-git-send-email-nborisov@suse.com>
References: <1523434880-7799-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Locks should generally be released in the oppposite order they are
acquired. Generally lock acquisiton ordering is used to ensure
deadlocks don't happen. However, as becomes more complicated it's
best to also maintain proper unlock order so as to avoid possible dead
locks. This was found by code inspection and doesn't necessarily lead
to a deadlock scenario.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3ae6394f9265..5e0c987e8fa8 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2609,8 +2609,8 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
 	delayed_refs->num_heads--;
 	rb_erase(&head->href_node, &delayed_refs->href_root);
 	RB_CLEAR_NODE(&head->href_node);
-	spin_unlock(&delayed_refs->lock);
 	spin_unlock(&head->lock);
+	spin_unlock(&delayed_refs->lock);
 	atomic_dec(&delayed_refs->num_entries);
 
 	trace_run_delayed_ref_head(fs_info, head, 0);
-- 
2.7.4

