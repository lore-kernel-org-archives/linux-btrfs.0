Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36602 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752546AbdLKOiw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Dec 2017 09:38:52 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0E9BBABF6
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Dec 2017 14:38:51 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Remove pair of bio_get/put in btrfs_schedule_bio
Date: Mon, 11 Dec 2017 16:38:48 +0200
Message-Id: <1513003128-15489-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This code was added in 492bb6deee34 ("Btrfs: Hold a reference on bios
during submit_bio, add some extra bio checks"). However, holding a
reference on a bio is necessary only if it's going to be referenced
after the submit_bio returns and the bio is completed. In this
particular instance this is not the case so there is no need to hold
an extra reference since we directly return.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/volumes.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 49810b70afd3..13827ff648ec 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6069,9 +6069,7 @@ static noinline void btrfs_schedule_bio(struct btrfs_device *device,
 
 	/* don't bother with additional async steps for reads, right now */
 	if (bio_op(bio) == REQ_OP_READ) {
-		bio_get(bio);
 		btrfsic_submit_bio(bio);
-		bio_put(bio);
 		return;
 	}
 
-- 
2.7.4

