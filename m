Return-Path: <SRS0=Ghwh=BB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC44DC433E8
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 Jul 2020 08:09:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF40720717
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 Jul 2020 08:09:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729894AbgGVIJb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 22 Jul 2020 04:09:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:45726 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728780AbgGVIJ2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Jul 2020 04:09:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 86AA5AFF5;
        Wed, 22 Jul 2020 08:09:34 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 3/4] btrfs: Remove redundant code from btrfs_free_stale_devices
Date:   Wed, 22 Jul 2020 11:09:24 +0300
Message-Id: <20200722080925.6802-4-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200722080925.6802-1-nborisov@suse.com>
References: <20200722080925.6802-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Following the refactor of btrfs_free_stale_devices in
7bcb8164ad94 ("btrfs: use device_list_mutex when removing stale devices")
fs_devices are freed after they have been iterated by the inner
list_for_each so the UAF fixed by introducing the break in
fd649f10c3d2 ("btrfs: Fix use-after-free when cleaning up fs_devs with
a single stale device") is no longer necessary. Just remove it
altogether. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/volumes.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 384614fe0e2a..17047c118969 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -588,8 +588,6 @@ static int btrfs_free_stale_devices(const char *path,
 			btrfs_free_device(device);
 
 			ret = 0;
-			if (fs_devices->num_devices == 0)
-				break;
 		}
 		mutex_unlock(&fs_devices->device_list_mutex);
 
-- 
2.17.1

