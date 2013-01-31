Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:18640 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751736Ab3AaAGi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 19:06:38 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 10/11] btrfs: ensure we don't overrun devices_info[] in __btrfs_alloc_chunk
Date: Wed, 30 Jan 2013 18:55:01 -0600
Message-Id: <1359593702-53056-11-git-send-email-sandeen@redhat.com>
In-Reply-To: <1359593702-53056-1-git-send-email-sandeen@redhat.com>
References: <1359593702-53056-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

WARN_ON isn't enough, we need to stop the loop if for any reason
we would overrun the devices_info array.

I tried to track down the connection between the length of
the alloc_devices list and the rw_devices counter but
it wasn't immediately obvious, so be defensive about it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/btrfs/volumes.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 15f6efd..09c63ac 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3630,12 +3630,16 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		if (max_avail < BTRFS_STRIPE_LEN * dev_stripes)
 			continue;
 
+		if (ndevs == fs_devices->rw_devices) {
+			WARN(1, "%s: found more than %llu devices\n",
+			     __func__, fs_devices->rw_devices);
+			break;
+		}
 		devices_info[ndevs].dev_offset = dev_offset;
 		devices_info[ndevs].max_avail = max_avail;
 		devices_info[ndevs].total_avail = total_avail;
 		devices_info[ndevs].dev = device;
 		++ndevs;
-		WARN_ON(ndevs > fs_devices->rw_devices);
 	}
 
 	/*
-- 
1.7.1

