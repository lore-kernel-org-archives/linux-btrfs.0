Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:40279 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751760Ab3AaAGn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 19:06:43 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 06/11] btrfs: add missing break in btrfs_print_leaf()
Date: Wed, 30 Jan 2013 18:54:57 -0600
Message-Id: <1359593702-53056-7-git-send-email-sandeen@redhat.com>
In-Reply-To: <1359593702-53056-1-git-send-email-sandeen@redhat.com>
References: <1359593702-53056-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I don't think that BTRFS_DEV_EXTENT_KEY is supposed
to fall through to BTRFS_DEV_STATS_KEY ...

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/btrfs/print-tree.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index 50d95fd..920957e 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -294,6 +294,7 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 			       btrfs_dev_extent_chunk_offset(l, dev_extent),
 			       (unsigned long long)
 			       btrfs_dev_extent_length(l, dev_extent));
+			break;
 		case BTRFS_DEV_STATS_KEY:
 			printk(KERN_INFO "\t\tdevice stats\n");
 			break;
-- 
1.7.1

