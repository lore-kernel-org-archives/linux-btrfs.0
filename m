Return-Path: <SRS0=Zicy=M3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1430C7112A
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 08:51:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 887872054F
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 08:51:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="qwCS+QGk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 887872054F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbeJOQfV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Oct 2018 12:35:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbeJOQfV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Oct 2018 12:35:21 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28BD72054F
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Oct 2018 08:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1539593462;
        bh=vqNlUJjIB9FNxjIdwEaX6N4o+M3bT9QoJmSqUWWDJRY=;
        h=From:To:Subject:Date:From;
        b=qwCS+QGkv2MDBcuiC5tWwVe9ALeF1poBpJJzHdhuyx+ZFc8J8HL+U++t4L09eD+Wp
         zRi2SrDojczyJWyfevv0lCwqMtb0W4Cr8eMh1Q6GZtmCfLaE4HTDlhNMKHk0IR56A4
         K3hw/EMQ5UEokShNg5PXDGKRXpBUzhj3jzfX63uI=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix assertion on fsync of regular file when using no-holes feature
Date:   Mon, 15 Oct 2018 09:51:00 +0100
Message-Id: <20181015085100.5720-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

When using the NO_HOLES feature and logging a regular file, we were
expecting that if we find an inline extent, that either its size in ram
(uncompressed and unenconded) matches the size of the file or if it does
not, that it matches the sector size and it represents compressed data.
This assertion does not cover a case where the length of the inline extent
is smaller then the sector size and also smaller the file's size, such
case is possible through fallocate. Example:

  $ mkfs.btrfs -f -O no-holes /dev/sdb
  $ mount /dev/sdb /mnt

  $ xfs_io -f -c "pwrite -S 0xb60 0 21" /mnt/foobar
  $ xfs_io -c "falloc 40 40" /mnt/foobar
  $ xfs_io -c "fsync" /mnt/foobar

In the abobe example we trigger the assertion because the inline extent's
length is 21 bytes while the file size is 80 bytes. The fallocate() call
merely updated the file's size and did not touch the existing inline
extent, as expected.

So fix this by adjusting the assertion so that an inline extent length
smaller then the file size is valid if the file size is smaller then the
filesystem's sector size.

A test case for fstests follows soon.

Reported-by: Anatoly Trosinenko <anatoly.trosinenko@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/CAE5jQCfRSBC7n4pUTFJcmHh109=gwyT9mFkCOL+NKfzswmR=_Q@mail.gmail.com/
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index eeeeed455dba..1673dccc76c2 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4652,7 +4652,8 @@ static int btrfs_log_trailing_hole(struct btrfs_trans_handle *trans,
 			ASSERT(len == i_size ||
 			       (len == fs_info->sectorsize &&
 				btrfs_file_extent_compression(leaf, extent) !=
-				BTRFS_COMPRESS_NONE));
+				BTRFS_COMPRESS_NONE) ||
+			       (len < i_size && i_size < fs_info->sectorsize));
 			return 0;
 		}
 
-- 
2.11.0

