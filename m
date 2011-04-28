From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] Btrfs: check return value of btrfs_inc_extent_ref()
Date: Thu, 28 Apr 2011 18:18:21 +0900
Message-ID: <201104280918.AA00019@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If return value of btrfs_inc_extent_ref() is not 0, BUG() is called.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/tree-log.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index f997ec0..23fb42d 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -590,6 +590,7 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 						ins.objectid, ins.offset,
 						0, root->root_key.objectid,
 						key->objectid, offset);
+				BUG_ON(ret);
 			} else {
 				/*
 				 * insert the extent pointer in the extent

