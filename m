Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34606 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756966AbcJ2INx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 29 Oct 2016 04:13:53 -0400
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Ming Lei <tom.leiming@gmail.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org (open list:BTRFS FILE SYSTEM)
Subject: [PATCH 26/60] btrfs: set NO_MP for request queues behind BTRFS
Date: Sat, 29 Oct 2016 16:08:25 +0800
Message-Id: <1477728600-12938-27-git-send-email-tom.leiming@gmail.com>
In-Reply-To: <1477728600-12938-1-git-send-email-tom.leiming@gmail.com>
References: <1477728600-12938-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are lots of direct access to .bi_vcnt & .bi_io_vec
of bio, and it isn't ready to support multipage bvecs
for BTRFS, so set NO_MP for these request queues.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 fs/btrfs/volumes.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 71a60cc01451..2e7237a3b84d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1011,6 +1011,9 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 		if (blk_queue_discard(q))
 			device->can_discard = 1;
 
+		/* BTRFS isn't ready to support multipage bvecs */
+		set_bit(QUEUE_FLAG_NO_MP, &q->queue_flags);
+
 		device->bdev = bdev;
 		device->in_fs_metadata = 0;
 		device->mode = flags;
-- 
2.7.4

