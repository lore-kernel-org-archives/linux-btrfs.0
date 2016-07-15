Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:62256 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbcGOPEJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jul 2016 11:04:09 -0400
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@intel.com>
To: linux-btrfs@vger.kernel.org
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
        =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@intel.com>,
        Mike Christie <mchristi@redhat.com>, Jens Axboe <axboe@fb.com>
Subject: [PATCH next] Btrfs: fix comparison in __btrfs_map_block()
Date: Fri, 15 Jul 2016 17:03:21 +0200
Message-Id: <1468595001-4270-1-git-send-email-vincent.stehle@intel.com>
In-Reply-To: <1465155145-10812-14-git-send-email-mchristi@redhat.com>
References: <1465155145-10812-14-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add missing comparison to op in expression, which was forgotten when doing
the REQ_OP transition.

Fixes: b3d3fa519905 ("btrfs: update __btrfs_map_block for REQ_OP transition")
Signed-off-by: Vincent Stehlé <vincent.stehle@intel.com>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Jens Axboe <axboe@fb.com>
---


Hi,

I saw that issue in linux next.

Not sure if it is too late to squash the fix with commit b3d3fa519905 or
not...

Best regards,

Vincent.


 fs/btrfs/volumes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a69203a..6ee1e36 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5533,7 +5533,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int op,
 		}
 
 	} else if (map->type & BTRFS_BLOCK_GROUP_DUP) {
-		if (op == REQ_OP_WRITE || REQ_OP_DISCARD ||
+		if (op == REQ_OP_WRITE || op == REQ_OP_DISCARD ||
 		    op == REQ_GET_READ_MIRRORS) {
 			num_stripes = map->num_stripes;
 		} else if (mirror_num) {
-- 
2.8.1

