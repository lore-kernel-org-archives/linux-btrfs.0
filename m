Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:50372 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751164AbeACHNX (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 3 Jan 2018 02:13:23 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 2/5] btrfs-progs: volumes: Make find_free_dev_extent_start static
Date: Wed,  3 Jan 2018 15:13:03 +0800
Message-Id: <20180103071306.11500-3-wqu@suse.com>
In-Reply-To: <20180103071306.11500-1-wqu@suse.com>
References: <20180103071306.11500-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The function is not used by anyone else outside of volumes.c, make it
static.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 volumes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/volumes.c b/volumes.c
index ce3a540578fd..0e50e1d5833e 100644
--- a/volumes.c
+++ b/volumes.c
@@ -457,7 +457,7 @@ out:
 	return ret;
 }
 
-int find_free_dev_extent(struct btrfs_trans_handle *trans,
+static int find_free_dev_extent(struct btrfs_trans_handle *trans,
 			 struct btrfs_device *device, u64 num_bytes,
 			 u64 *start)
 {
-- 
2.15.1

