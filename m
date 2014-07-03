Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:56580 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758125AbaGCKUv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jul 2014 06:20:51 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s63AKnMw013570
	for <linux-btrfs@vger.kernel.org>; Thu, 3 Jul 2014 18:20:49 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 8/9] Btrfs: fix unzeroed members in fs_devices when creating a fs from seed fs
Date: Thu, 3 Jul 2014 18:22:12 +0800
Message-ID: <1404382933-26672-8-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1404382933-26672-1-git-send-email-miaox@cn.fujitsu.com>
References: <1404382933-26672-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We forgot to zero some members in fs_devices when we create new fs_devices
from the one of the seed fs. It would cause the problem that we got wrong
chunk profile when allocating chunks. Fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 4731bd6..73a82e5 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1993,6 +1993,9 @@ static int btrfs_prepare_sprout(struct btrfs_root *root)
 	fs_devices->seeding = 0;
 	fs_devices->num_devices = 0;
 	fs_devices->open_devices = 0;
+	fs_devices->missing_devices = 0;
+	fs_devices->num_can_discard = 0;
+	fs_devices->rotating = 0;
 	fs_devices->seed = seed_devices;
 
 	generate_random_uuid(fs_devices->fsid);
-- 
1.9.3

