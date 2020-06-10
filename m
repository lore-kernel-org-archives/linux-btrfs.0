Return-Path: <SRS0=J01l=7X=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D363C433E0
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Jun 2020 00:58:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22727206C3
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Jun 2020 00:58:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgFJA6E (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Jun 2020 20:58:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:33434 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbgFJA6C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Jun 2020 20:58:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1A031ACBD
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jun 2020 00:58:05 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/5] btrfs: file: reserve qgroup space after the hole punch range locked
Date:   Wed, 10 Jun 2020 08:57:49 +0800
Message-Id: <20200610005751.10645-4-wqu@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200610005751.10645-1-wqu@suse.com>
References: <20200610005751.10645-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The incoming qgroup reserved space timing will move the data reserve to
ordered extent completely.

However in btrfs_punch_hole_lock_range() will call
btrfs_invalidate_page(), which will clear QGROUP_RESERVED bit for the
range.

In current stage it's OK, but if we're making ordered extents to handle
the reserved space, then btrfs_punch_hole_lock_range() can clear the
QGROUP_RESERVED bit before we submit ordered extent, leading to qgroup
reserved space leakage.

So here change the timing to make reserve data space after
btrfs_punch_hole_lock_range().
The new timing is fine for either current code or the new code.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/file.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index fde125616687..3f4b8f7666a9 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3188,14 +3188,14 @@ static int btrfs_zero_range(struct inode *inode,
 		if (ret < 0)
 			goto out;
 		space_reserved = true;
-		ret = btrfs_qgroup_reserve_data(inode, &data_reserved,
-						alloc_start, bytes_to_reserve);
-		if (ret)
-			goto out;
 		ret = btrfs_punch_hole_lock_range(inode, lockstart, lockend,
 						  &cached_state);
 		if (ret)
 			goto out;
+		ret = btrfs_qgroup_reserve_data(inode, &data_reserved,
+						alloc_start, bytes_to_reserve);
+		if (ret)
+			goto out;
 		ret = btrfs_prealloc_file_range(inode, mode, alloc_start,
 						alloc_end - alloc_start,
 						i_blocksize(inode),
-- 
2.26.2

