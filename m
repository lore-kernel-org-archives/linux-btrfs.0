From: Thomas Meyer <thomas@m3y3r.de>
Subject: [PATCH] Btrfs: Use kcalloc instead of kzalloc to allocate array
Date: Tue, 29 Nov 2011 22:08:00 +0100
Message-ID: <1322600880.1534.343.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The advantage of kcalloc is, that will prevent integer overflows which could
result from the multiplication of number of elements and size and it is also
a bit nicer to read.

The semantic patch that makes this change is available
in https://lkml.org/lkml/2011/11/25/107

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
--- a/fs/btrfs/volumes.c 2011-11-28 19:36:48.113451068 +0100
+++ b/fs/btrfs/volumes.c 2011-11-28 19:48:10.374677247 +0100
@@ -2450,7 +2450,7 @@ static int __btrfs_alloc_chunk(struct bt
 	max_chunk_size = min(div_factor(fs_devices->total_rw_bytes, 1),
 			     max_chunk_size);
 
-	devices_info = kzalloc(sizeof(*devices_info) * fs_devices->rw_devices,
+	devices_info = kcalloc(fs_devices->rw_devices, sizeof(*devices_info),
 			       GFP_NOFS);
 	if (!devices_info)
 		return -ENOMEM;
