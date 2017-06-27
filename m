Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36086 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751561AbdF0HCc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Jun 2017 03:02:32 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 884EEAE5A
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Jun 2017 07:02:31 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 3/3] btrfs: Be explicit about usage of min()
Date: Tue, 27 Jun 2017 10:02:26 +0300
Message-Id: <1498546946-6853-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1498546946-6853-1-git-send-email-nborisov@suse.com>
References: <1498546946-6853-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

__btrfs_alloc_chunk contains code which boils down to:

    ndevs = min(ndevs, devs_max)

It's conditional upon devs_max not being 0. However, it cannot really be 0
since it's always set to either BTRFS_MAX_DEVS_SYS_CHUNK or
BTRFS_MAX_DEVS(fs_info->chunk_root). So eliminate the condition check and use
min explicitly. This has no functional changes

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/volumes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 07cfcc507ba6..12d4e3c4bd2b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4759,8 +4759,8 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		goto error;
 	}
 
-	if (devs_max && ndevs > devs_max)
-		ndevs = devs_max;
+	ndevs = min(ndevs, devs_max);
+
 	/*
 	 * the primary goal is to maximize the number of stripes, so use as many
 	 * devices as possible, even if the stripes are not maximum sized.
-- 
2.7.4

