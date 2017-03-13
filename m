Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49410 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751361AbdCMHhu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Mar 2017 03:37:50 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, quwenruo@cn.fujitsu.com
Subject: [PATCH 2/4] btrfs: Communicate back ENOMEM when it occurs
Date: Mon, 13 Mar 2017 15:42:12 +0800
Message-Id: <20170313074214.24123-3-anand.jain@oracle.com>
In-Reply-To: <20170313074214.24123-1-anand.jain@oracle.com>
References: <20170313074214.24123-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The only error that write dev flush (send) will fail is due
to the ENOMEM then, as its not a device specific error and
rather a system wide issue, we should rather stop further
iterations and perpetuate the -ENOMEM error to the caller.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 08b74daf35d0..ee3e601da511 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3592,7 +3592,7 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 
 		ret = write_dev_flush(dev, 0);
 		if (ret)
-			errors_send++;
+			return ret;
 	}
 
 	/* wait for all the barriers */
-- 
2.10.0

