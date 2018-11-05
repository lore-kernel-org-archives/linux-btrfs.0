Return-Path: <SRS0=ibH9=NQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C00DC46475
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 11:14:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44FEA20825
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 11:14:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="h4N6dO17"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 44FEA20825
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729409AbeKEUdc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 5 Nov 2018 15:33:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:50016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727337AbeKEUdc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Nov 2018 15:33:32 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B733B20825
        for <linux-btrfs@vger.kernel.org>; Mon,  5 Nov 2018 11:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1541416460;
        bh=V8tVuDG6O1ETbB974h8QaVf8QPcO4qgEnU5B4iXia30=;
        h=From:To:Subject:Date:From;
        b=h4N6dO17rk5+2pw1+cVQFkY+xhDLGrSTrocg/dnNQ9CV72EOj/Bk8XUaIPKDOzAw8
         GxQwXIAxCgVsrEV09pEzT4yvcXWQKbcI99lZGzb0ygbrpo8MFaUaFs8f16tas0hgYH
         SuT/sK8oBp5vzejRP4LJnH74AWMe2ustqYF5IC0Y=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix data corruption due to cloning of eof block
Date:   Mon,  5 Nov 2018 11:14:17 +0000
Message-Id: <20181105111417.11808-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

We currently allow cloning a range from a file which includes the last
block of the file even if the file's size is not aligned to the block
size. This is fine and useful when the destination file has the same size,
but when it does not and the range ends somewhere in the middle of the
destination file, it leads to corruption because the bytes between the EOF
and the end of the block have undefined data (when there is support for
discard/trimming they have a value of 0x00).

Example:

 $ mkfs.btrfs -f /dev/sdb
 $ mount /dev/sdb /mnt

 $ export foo_size=$((256 * 1024 + 100))
 $ xfs_io -f -c "pwrite -S 0x3c 0 $foo_size" /mnt/foo
 $ xfs_io -f -c "pwrite -S 0xb5 0 1M" /mnt/bar

 $ xfs_io -c "reflink /mnt/foo 0 512K $foo_size" /mnt/bar

 $ od -A d -t x1 /mnt/bar
 0000000 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5
 *
 0524288 3c 3c 3c 3c 3c 3c 3c 3c 3c 3c 3c 3c 3c 3c 3c 3c
 *
 0786528 3c 3c 3c 3c 00 00 00 00 00 00 00 00 00 00 00 00
 0786544 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
 0790528 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5
 *
 1048576

The bytes in the range from 786532 (512Kb + 256Kb + 100 bytes) to 790527
(512Kb + 256Kb + 4Kb - 1) got corrupted, having now a value of 0x00 instead
of 0xb5.

This is similar to the problem we had for deduplication that got recently
fixed by commit de02b9f6bb65 ("Btrfs: fix data corruption when
deduplicating between different files").

Fix this by not allowing such operations to be performed and return the
errno -EINVAL to user space. This is what XFS is doing as well at the VFS
level. This change however now makes us return -EINVAL instead of
-EOPNOTSUPP for cases where the source range maps to an inline extent and
the destination range's end is smaller then the destination file's size,
since the detection of inline extents is done during the actual process of
dropping file extent items (at __btrfs_drop_extents()). Returning the
-EINVAL error is done early on and solely based on the input parameters
(offsets and length) and destination file's size. This makes us consistent
with XFS and anyone else supporting cloning since this case is now checked
at a higher level in the VFS and is where the -EINVAL will be returned
from starting with kernel 4.20 (the VFS changed was introduced in 4.20-rc1
by commit 07d19dc9fbe9 ("vfs: avoid problematic remapping requests into
partial EOF block"). So this change is more geared towards stable kernels,
as it's unlikely the new VFS checks get removed intentionally.

A test case for fstests follows soon, as well as an update to filter
existing tests that expect -EOPNOTSUPP to accept -EINVAL as well.

CC: <stable@vger.kernel.org> # 4.4+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ioctl.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f3134fc69880..30e098970063 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4277,9 +4277,17 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
 		goto out_unlock;
 	if (len == 0)
 		olen = len = src->i_size - off;
-	/* if we extend to eof, continue to block boundary */
-	if (off + len == src->i_size)
+	/*
+	 * If we extend to eof, continue to block boundary if and only if the
+	 * destination end offset matches the destination file's size, otherwise
+	 * we would be corrupting data by placing the eof block into the middle
+	 * of a file.
+	 */
+	if (off + len == src->i_size) {
+		if (!IS_ALIGNED(len, bs) && destoff + len < inode->i_size)
+			goto out_unlock;
 		len = ALIGN(src->i_size, bs) - off;
+	}
 
 	if (len == 0) {
 		ret = 0;
-- 
2.11.0

