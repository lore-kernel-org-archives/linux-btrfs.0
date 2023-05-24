Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6487C77B7A
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 May 2023 23:10:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237374AbjEXXKo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 May 2023 19:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjEXXKn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 May 2023 19:10:43 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD4299
        for <linux-btrfs@vger.kernel.org>; Wed, 24 May 2023 16:10:43 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 6968A1FE3A;
        Wed, 24 May 2023 23:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1684969841; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1812IciJRijXg6iewz9AsySIigE8KxRDsCmBXB+4sc8=;
        b=l3eAQc/Fi0f2IX3kZka70kdJDlXnbpVZEjX+tDfdj2I8bGvQGhnd12Fkn2okZgkzRNyj59
        KMPTZzWH7X5xzulH152g9wM9M8MywCVRKBUHWrcL6fZVHPTMjea3tHSRsdgA7gL25rrOSu
        sRTXxsYcOK3Puz6LVz30eMrfWliHOaI=
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 57A5D2C141;
        Wed, 24 May 2023 23:10:41 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E9AF8DA85B; Thu, 25 May 2023 01:04:34 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 7/9] btrfs: drop NOFAIL from set_extent_bit allocation masks
Date:   Thu, 25 May 2023 01:04:34 +0200
Message-Id: <232abb666a6901f909aeb21dc6f5998f0250e073.1684967923.git.dsterba@suse.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1684967923.git.dsterba@suse.com>
References: <cover.1684967923.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The __GFP_NOFAIL passed to set_extent_bit first appeared in 2010
(commit f0486c68e4bd9a ("Btrfs: Introduce contexts for metadata
reservation")), without any explanation why it would be needed.

Meanwhile we've updated the semantics of set_extent_bit to handle failed
allocations and do unlock, sleep and retry if needed.  The use of the
NOFAIL flag is also an outlier, we never want any of the set/clear
extent bit helpers to fail, they're used for many critical changes like
extent locking, besides the extent state bit changes.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/block-group.c | 3 +--
 fs/btrfs/extent-tree.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index ec463f8d83ec..202e2aa949c5 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -3523,8 +3523,7 @@ int btrfs_update_block_group(struct btrfs_trans_handle *trans,
 
 			set_extent_bit(&trans->transaction->pinned_extents,
 				       bytenr, bytenr + num_bytes - 1,
-				       EXTENT_DIRTY, NULL,
-				       GFP_NOFS | __GFP_NOFAIL);
+				       EXTENT_DIRTY, NULL, GFP_NOFS);
 		}
 
 		spin_lock(&trans->transaction->dirty_bgs_lock);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 03b2a7c508b9..6e319100e3a3 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2508,8 +2508,7 @@ static int pin_down_extent(struct btrfs_trans_handle *trans,
 	spin_unlock(&cache->space_info->lock);
 
 	set_extent_bit(&trans->transaction->pinned_extents, bytenr,
-		       bytenr + num_bytes - 1, EXTENT_DIRTY, NULL,
-		       GFP_NOFS | __GFP_NOFAIL);
+		       bytenr + num_bytes - 1, EXTENT_DIRTY, NULL, GFP_NOFS);
 	return 0;
 }
 
-- 
2.40.0

