Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:56169 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbbAMOJI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Jan 2015 09:09:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Mason <clm@fb.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Btrfs: avoid build warning on 32-bit
Date: Tue, 13 Jan 2015 15:09:03 +0100
Message-ID: <4264141.3m7C7LgF5c@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A recent change introduced a type cast from a private 64-bit
value to a pointer, which works fine on 64-bit architectures,
but not on 32-bit ones, where it produces a harmless compiler
warning:

fs/btrfs/extent_io.c: In function 'btrfs_free_io_failure_record':
fs/btrfs/extent_io.c:2193:13: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]

This adds an intermediate cast to 'unsigned long', which tells
the compiler to ignore the type mismatch.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: f612496bca664 ("Btrfs: cleanup the read failure record after write
			or when the inode is freeing")

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 4ebabd237153..790dbae3343c 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2190,7 +2190,7 @@ void btrfs_free_io_failure_record(struct inode *inode, u64 start, u64 end)
 
 		next = next_state(state);
 
-		failrec = (struct io_failure_record *)state->private;
+		failrec = (struct io_failure_record *)(unsigned long)state->private;
 		free_extent_state(state);
 		kfree(failrec);
 

