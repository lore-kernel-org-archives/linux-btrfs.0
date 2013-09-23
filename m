Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:34641 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab3IWJXa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Sep 2013 05:23:30 -0400
Received: by mail-wi0-f176.google.com with SMTP id cb5so1967443wib.3
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Sep 2013 02:23:29 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v2] Btrfs: fix sync fs to actually wait for all data to be persisted
Date: Mon, 23 Sep 2013 10:23:20 +0100
Message-Id: <1379928200-21566-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1379883353-7358-1-git-send-email-fdmanana@gmail.com>
References: <1379883353-7358-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently the fs sync function (super.c:btrfs_sync_fs()) doesn't
wait for delayed work to finish before returning success to the
caller. This change fixes this, ensuring that there's no data loss
if a power failure happens right after fs sync returns success to
the caller and before the next commit happens.

Steps to reproduce the data loss issue:

$ mkfs.btrfs -f /dev/sdb3
$ mount /dev/sdb3 /mnt/btrfs
$ perl -e '$d = ("\x41" x 6001); open($f,">","/mnt/btrfs/foobar"); print $f $d; close($f);' && btrfs fi sync /mnt/btrfs

Right after the btrfs fi sync command (a second or 2 for example), power
off the machine and reboot it. The file will be empty, as it can be verified
after mounting the filesystem and through btrfs-debug-tree:

$ btrfs-debug-tree /dev/sdb3 | egrep '\(257 INODE_ITEM 0\) itemoff' -B 3 -A 8
        item 3 key (256 DIR_INDEX 2) itemoff 3751 itemsize 36
                location key (257 INODE_ITEM 0) type FILE
                namelen 6 datalen 0 name: foobar
        item 4 key (257 INODE_ITEM 0) itemoff 3591 itemsize 160
                inode generation 7 transid 7 size 0 block group 0 mode 100644 links 1
        item 5 key (257 INODE_REF 256) itemoff 3575 itemsize 16
                inode ref index 2 namelen 6 name: foobar
checksum tree key (CSUM_TREE ROOT_ITEM 0)
leaf 29429760 items 0 free space 3995 generation 7 owner 7
fs uuid 6192815c-af2a-4b75-b3db-a959ffb6166e
chunk uuid b529c44b-938c-4d3d-910a-013b4700bcae
uuid tree key (UUID_TREE ROOT_ITEM 0)

After this patch, the data loss no longer happens after a power failure and
btrfs-debug-tree shows:

$ btrfs-debug-tree /dev/sdb3 | egrep '\(257 INODE_ITEM 0\) itemoff' -B 3 -A 8
	item 3 key (256 DIR_INDEX 2) itemoff 3751 itemsize 36
		location key (257 INODE_ITEM 0) type FILE
		namelen 6 datalen 0 name: foobar
	item 4 key (257 INODE_ITEM 0) itemoff 3591 itemsize 160
		inode generation 6 transid 6 size 6001 block group 0 mode 100644 links 1
	item 5 key (257 INODE_REF 256) itemoff 3575 itemsize 16
		inode ref index 2 namelen 6 name: foobar
	item 6 key (257 EXTENT_DATA 0) itemoff 3522 itemsize 53
		extent data disk byte 12845056 nr 8192
		extent data offset 0 nr 8192 ram 8192
		extent compression 0
checksum tree key (CSUM_TREE ROOT_ITEM 0)

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Use writeback_inodes_sb() instead of btrfs_start_all_delalloc_inodes(), as
    suggested by Miao Xie.

 fs/btrfs/super.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 6ab0df5..38b4392 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -921,6 +921,7 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
 		return 0;
 	}
 
+	writeback_inodes_sb(sb, WB_REASON_SYNC);
 	btrfs_wait_all_ordered_extents(fs_info);
 
 	trans = btrfs_attach_transaction_barrier(root);
-- 
1.7.9.5

