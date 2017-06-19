Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46553 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753711AbdFSKzs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Jun 2017 06:55:48 -0400
Date: Mon, 19 Jun 2017 13:55:37 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chris Mason <clm@fb.com>, Christoph Hellwig <hch@lst.de>
Cc: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org,
        Jens Axboe <axboe@fb.com>, kernel-janitors@vger.kernel.org
Subject: [PATCH] btrfs: use new block error code
Message-ID: <20170619105536.GA24075@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function is supposed to return blk_status_t error codes now but
there was a stray -ENOMEM left behind.

Fixes: 4e4cbee93d56 ("block: switch bios to blk_status_t")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index e536e98fe351..2c0b7b57fcd5 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -584,7 +584,7 @@ blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 							      __GFP_HIGHMEM);
 		if (!cb->compressed_pages[pg_index]) {
 			faili = pg_index - 1;
-			ret = -ENOMEM;
+			ret = BLK_STS_RESOURCE;
 			goto fail2;
 		}
 	}
