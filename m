Return-Path: <SRS0=OHkO=4B=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13ADAC3B18B
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Feb 2020 12:29:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E019B217F4
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Feb 2020 12:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581596996;
	bh=QcEUyjmXv27l3b6fj+GArNBroMTQNvrKXnrcZcrIGQ0=;
	h=From:To:Subject:Date:List-ID:From;
	b=wTi2jn/AuUze6HnmNuQOD2cPozDXc2ggwQyEA2r/FEHDXzGLrGwe3u6iLhFiihwl8
	 Wd2+sy3sXFsT282xOpZC66Q1TDVtiBM/zRlhqvS3xrpAFuhXBpZnb2Gu8TzF17Fpbp
	 Rzanb8sTh1JvL3K0wa3fBPEbghZhH9Ef6ay+G4H0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729572AbgBMM3z (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 13 Feb 2020 07:29:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:40164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729531AbgBMM3z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Feb 2020 07:29:55 -0500
Received: from debian6.Home (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73B28217F4
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Feb 2020 12:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581596994;
        bh=QcEUyjmXv27l3b6fj+GArNBroMTQNvrKXnrcZcrIGQ0=;
        h=From:To:Subject:Date:From;
        b=c3fTZfGAjCjCncAb+tyTcsfoeD9s2S0v8mwmQKuff989fE9sppolFGPabSctXnH2P
         WJVL9io3wocQvbe3Cm1Iaw4PP++9T/r3qwOz2WCpnLcFuXmzRv0xyopvL8FF7Uw5QJ
         /ZRo0eb1TksT4p6SgSwVb/kfSN5HwxIUOm9wprEs=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix btrfs_wait_ordered_range() so that it waits for all ordered extents
Date:   Thu, 13 Feb 2020 12:29:50 +0000
Message-Id: <20200213122950.12115-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

In btrfs_wait_ordered_range() once we find an ordered extent that has
finished with an error we exit the loop and don't wait for any other
ordered extents that might be still in progress.

All the users of btrfs_wait_ordered_range() expect that there are no more
ordered extents in progress after that function returns. So past fixes
such like the ones from the two following commits:

  ff612ba7849964 ("btrfs: fix panic during relocation after ENOSPC before
                   writeback happens")

  28aeeac1dd3080 ("Btrfs: fix panic when starting bg cache writeout after
                   IO error")

don't work when there are multiple ordered extents in the range.

Fix that by making btrfs_wait_ordered_range() wait for all ordered extents
even after it finds one that had an error.

Link: https://github.com/kdave/btrfs-progs/issues/228#issuecomment-569777554
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ordered-data.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 4cbb4e082800..ab3711328e7d 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -686,10 +686,15 @@ int btrfs_wait_ordered_range(struct inode *inode, u64 start, u64 len)
 		}
 		btrfs_start_ordered_extent(inode, ordered, 1);
 		end = ordered->file_offset;
+		/*
+		 * If the ordered extent had an error save the error but don't
+		 * exit without waiting first for all other ordered extents in
+		 * the range to complete.
+		 */
 		if (test_bit(BTRFS_ORDERED_IOERR, &ordered->flags))
 			ret = -EIO;
 		btrfs_put_ordered_extent(ordered);
-		if (ret || end == 0 || end == start)
+		if (end == 0 || end == start)
 			break;
 		end--;
 	}
-- 
2.11.0

