Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33116 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933810AbeALO1t (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Jan 2018 09:27:49 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6D769ADEC
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Jan 2018 14:27:48 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: remove stale reada_lock from device
Date: Fri, 12 Jan 2018 15:25:39 +0100
Message-Id: <20180112142539.9891-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We the global readahead lock in fs_info, the per-device has been unused
since the initial commit 90519d66abbccc ("btrfs: state information for
readahead").

Reported-by: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 15216fed918b..28c28eeadff3 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -137,7 +137,6 @@ struct btrfs_device {
 	struct rcu_head rcu;
 
 	/* readahead state */
-	spinlock_t reada_lock;
 	atomic_t reada_in_flight;
 	u64 reada_next;
 	struct reada_zone *reada_curr_zone;
-- 
2.15.1

