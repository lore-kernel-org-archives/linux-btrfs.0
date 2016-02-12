Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34751 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbcBLQX0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Feb 2016 11:23:26 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id AF74520221
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Feb 2016 16:23:25 +0000 (UTC)
Received: from debian3.lan (bl8-199-62.dsl.telepac.pt [85.241.199.62])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 83157201F2
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Feb 2016 16:23:24 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix extent_same allowing destination offset beyond i_size
Date: Fri, 12 Feb 2016 16:23:22 +0000
Message-Id: <1455294202-8996-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

When using the same file as the source and destination for a dedup
(extent_same ioctl) operation we were allowing it to dedup to a
destination offset beyond the file's size, which doesn't make sense and
it's not allowed for the case where the source and destination files are
not the same file. This made de deduplication operation successful only
when the source range corresponded to a hole, a prealloc extent or an
extent with all bytes having a value of 0x00. This was also leaving a
file hole (between i_size and destination offset) without the
corresponding file extent items, which can be reproduced with the
following steps for example:

  $ mkfs.btrfs -f /dev/sdi
  $ mount /dev/sdi /mnt/sdi

  $ xfs_io -f -c "pwrite -S 0xab 304457 404990" /mnt/sdi/foobar
  wrote 404990/404990 bytes at offset 304457
  395 KiB, 99 ops; 0.0000 sec (31.150 MiB/sec and 7984.5149 ops/sec)

  $ /git/hub/duperemove/btrfs-extent-same 24576 /mnt/sdi/foobar 28672 /mnt/sdi/foobar 929792
  Deduping 2 total files
  (28672, 24576): /mnt/sdi/foobar
  (929792, 24576): /mnt/sdi/foobar
  1 files asked to be deduped
  i: 0, status: 0, bytes_deduped: 24576
  24576 total bytes deduped in this operation

  $ umount /mnt/sdi
  $ btrfsck /dev/sdi
  Checking filesystem on /dev/sdi
  UUID: 98c528aa-0833-427d-9403-b98032ffbf9d
  checking extents
  checking free space cache
  checking fs roots
  root 5 inode 257 errors 100, file extent discount
  Found file extent holes:
          start: 712704, len: 217088
  found 540673 bytes used err is 1
  total csum bytes: 400
  total tree bytes: 131072
  total fs tree bytes: 32768
  total extent tree bytes: 16384
  btree space waste bytes: 123675
  file data blocks allocated: 671744
    referenced 671744
  btrfs-progs v4.2.3

So fix this by not allowing the destination to go beyond the file's size,
just as we do for the same where the source and destination files are not
the same.

A test for xfstests follows.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ioctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index ce99799..f132740 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3071,6 +3071,9 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 		ret = extent_same_check_offsets(src, loff, &len, olen);
 		if (ret)
 			goto out_unlock;
+		ret = extent_same_check_offsets(src, dst_loff, &len, olen);
+		if (ret)
+			goto out_unlock;
 
 		/*
 		 * Single inode case wants the same checks, except we
-- 
2.7.0.rc3

