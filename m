Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34070 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S964930AbeF2I5M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 04:57:12 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1F15EAD66
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2018 08:57:11 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 14/14] btrfs: raid56: catch errors from full_stripe_write
Date: Fri, 29 Jun 2018 10:57:10 +0200
Message-Id: <36443b465be8eb96582313c8bf75ceeb0d717a5e.1530262400.git.dsterba@suse.com>
In-Reply-To: <cover.1530262400.git.dsterba@suse.com>
References: <cover.1530262400.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add fall-back code to catch failure of full_stripe_write. Proper error
handling from inside run_plug would need more code restructuring as it's
called at arbitrary points by io scheduler.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/raid56.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 0840b054e4b7..84889d10d5b0 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1683,8 +1683,11 @@ static void run_plug(struct btrfs_plug_cb *plug)
 		list_del_init(&cur->plug_list);
 
 		if (rbio_is_full(cur)) {
+			int ret;
+
 			/* we have a full stripe, send it down */
-			full_stripe_write(cur);
+			ret = full_stripe_write(cur);
+			BUG_ON(ret);
 			continue;
 		}
 		if (last) {
-- 
2.17.1

