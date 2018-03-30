Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:42329 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750967AbeC3Hfo (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 30 Mar 2018 03:35:44 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs-progs: disk-io: Fix read_extent_data() error handler for missing device
Date: Fri, 30 Mar 2018 15:35:26 +0800
Message-Id: <20180330073528.20650-2-wqu@suse.com>
In-Reply-To: <20180330073528.20650-1-wqu@suse.com>
References: <20180330073528.20650-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When device is missing, read_extent_data() (function exported from old
btrfs check code) has the following problems:

1) Modify @len parameter if device is missing
   If device returned in @multi is missing, @len can be larger than
   @max_len (originl length).

   This could confusing caller and underflow the read loop.

2) Still return 0 for missing device
   It only handles read error, missing device is not handled and 0 is
   returned.

3) Wrong check for device->fd
   In fact, 0 is also a valid fd.
   Although not possible under most case, it's still need fix.

Fix them all.

Fixes: 1bad2f2f2dfe ("Btrfs-progs: fsck: add an option to check data csums")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 disk-io.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 610963357675..310ab19cf099 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -395,10 +395,12 @@ int read_extent_data(struct btrfs_fs_info *fs_info, char *data, u64 logical,
 	}
 	device = multi->stripes[0].dev;
 
-	if (device->fd <= 0)
-		goto err;
 	if (*len > max_len)
 		*len = max_len;
+	if (device->fd < 0) {
+		ret = -EIO;
+		goto err;
+	}
 
 	ret = pread64(device->fd, data, *len, multi->stripes[0].physical);
 	if (ret != *len)
-- 
2.16.3

