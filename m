Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57721 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753762AbdGSR54 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Jul 2017 13:57:56 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B9BA2AC6B
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Jul 2017 17:57:55 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: account that we're waiting for IO in scrub_submit_raid56_bio_wait
Date: Wed, 19 Jul 2017 19:56:40 +0200
Message-Id: <20170719175640.1820-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Correctly account for IO when waiting for a submitted bio in scrub. This
only for the accounting purposes and should not change other behaviour.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/scrub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 0cebeb5eb5d0..0e6daf0582a1 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1704,7 +1704,7 @@ static int scrub_submit_raid56_bio_wait(struct btrfs_fs_info *fs_info,
 	if (ret)
 		return ret;
 
-	wait_for_completion(&done.event);
+	wait_for_completion_io(&done.event);
 	if (done.error)
 		return -EIO;
 
-- 
2.13.0

