From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] btrfs: Fix memory leak in btrfs_read_fs_root_no_radix()
Date: Mon, 27 Dec 2010 15:53:10 +0900
Message-ID: <4D1837D6.4080901@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs_read_fs_root_no_radix(), 'root' is not freed if
btrfs_search_slot() returns error.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 disk-io.c |    1 +
 1 file changed, 1 insertion(+)

diff -urNp linux-2.6.37-rc7/fs/btrfs/disk-io.c linux-2.6.37-rc7.new/fs/btrfs/disk-io.c
--- linux-2.6.37-rc7/fs/btrfs/disk-io.c 2010-12-22 04:26:40.000000000 +0900
+++ linux-2.6.37-rc7.new/fs/btrfs/disk-io.c     2010-12-27 15:21:19.000000000 +0900
@@ -1145,6 +1145,7 @@ struct btrfs_root *btrfs_read_fs_root_no
 	}
 	btrfs_free_path(path);
 	if (ret) {
+		kfree(root);
 		if (ret > 0)
 			ret = -ENOENT;
 		return ERR_PTR(ret);


