Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:5639 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752375AbbJ2Jdj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Oct 2015 05:33:39 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t9T9X3Y1015819
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2015 17:33:03 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 2/6] btrfs-progs: Fix negative eb's ref_cnt in btrfs-calc-size
Date: Thu, 29 Oct 2015 17:31:44 +0800
Message-ID: <8e1a2c10dd36c558d8f0b4818f48bca5bb780b9b.1446111097.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <e9288021adac2924ce1fdb637f61b9b924eff954.1446111097.git.zhaolei@cn.fujitsu.com>
References: <e9288021adac2924ce1fdb637f61b9b924eff954.1446111097.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs-calc-size show following warning:
 # btrfs-calc-size /dev/sda6
 Calculating size of root tree
 ...
 extent_io.c:582: free_extent_buffer: Assertion `eb->refs < 0` failed.
 ./btrfs-calc-size[0x41d642]
 ./btrfs-calc-size(free_extent_buffer+0x70)[0x41e1c1]
 ./btrfs-calc-size(btrfs_free_fs_root+0x11)[0x40e1e8]
 ./btrfs-calc-size[0x40e215]
 ./btrfs-calc-size(rb_free_nodes+0x1d)[0x4326fe]
 ./btrfs-calc-size(close_ctree+0x3f3)[0x40f9ea]
 ./btrfs-calc-size(main+0x200)[0x431b4e]
 /lib64/libc.so.6(__libc_start_main+0xf5)[0x3858621d65]
 ./btrfs-calc-size[0x407009]

Reason:
 path in calc_root_size() is only used to save node data,
 it don't hold ref_cnt for each eb in.
 Using btrfs_free_path() to free path will reduce these eb
 again, and cause many problems, as negative ref_cnt or
 invalid memory access.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 btrfs-calc-size.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/btrfs-calc-size.c b/btrfs-calc-size.c
index 17d44ae..b84cda9 100644
--- a/btrfs-calc-size.c
+++ b/btrfs-calc-size.c
@@ -417,7 +417,14 @@ out:
 		free(seek);
 	}
 
-	btrfs_free_path(path);
+	/*
+	 * We only use path to save node data in iterating,
+	 * without holding eb's ref_cnt in path.
+	 * Don't use btrfs_free_path() here, it will free these
+	 * eb again, and cause many problems, as negative ref_cnt
+	 * or invalid memory access.
+	 */
+	free(path);
 	return ret;
 }
 
-- 
1.8.5.1

