Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:8827 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbcGTF7S (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jul 2016 01:59:18 -0400
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, jbacik@fb.com, holger@applied-asynchrony.com
Subject: [PATCH 3/4] btrfs: introduce new EXTENT_CLEAR_DATA_RESV flag
Date: Wed, 20 Jul 2016 13:56:36 +0800
Message-Id: <20160720055637.7275-4-wangxg.fnst@cn.fujitsu.com>
In-Reply-To: <20160720055637.7275-1-wangxg.fnst@cn.fujitsu.com>
References: <20160720055637.7275-1-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In next patch, btrfs_clear_bit_hook() will not call
btrfs_free_reserved_data_space_noquota() to update btrfs_space_info's
bytes_may_use unless it has EXTENT_DO_ACCOUNTING or EXTENT_CLEAR_DATA_RESV,
as for the reason, please see the next patch for detailed info.

As we know, usually EXTENT_DO_ACCOUNTING is used for error path. In
run_delalloc_nocow(), for inode marked as NODATACOW or extent marked as
PREALLOC, we also need to update bytes_may_use, but can not pass
EXTENT_DO_ACCOUNTING, because it also clears metadata reservation, so here
we introduce EXTENT_CLEAR_DATA_RESV flag to indicate btrfs_clear_bit_hook()
to update btrfs_space_info's bytes_may_use.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/extent_io.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index c0c1c4f..b52ca5d 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -20,6 +20,7 @@
 #define EXTENT_DAMAGED		(1U << 14)
 #define EXTENT_NORESERVE	(1U << 15)
 #define EXTENT_QGROUP_RESERVED	(1U << 16)
+#define EXTENT_CLEAR_DATA_RESV	(1U << 17)
 #define EXTENT_IOBITS		(EXTENT_LOCKED | EXTENT_WRITEBACK)
 #define EXTENT_CTLBITS		(EXTENT_DO_ACCOUNTING | EXTENT_FIRST_DELALLOC)
 
-- 
2.9.0



