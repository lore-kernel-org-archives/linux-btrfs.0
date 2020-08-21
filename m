Return-Path: <SRS0=Zefw=B7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0DE6C433E4
	for <linux-btrfs@archiver.kernel.org>; Fri, 21 Aug 2020 17:11:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C00FD20656
	for <linux-btrfs@archiver.kernel.org>; Fri, 21 Aug 2020 17:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598029911;
	bh=jUkxIfMy8Y73M1KRZQz6fQti+P06LWsHaph/CRw6DYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=vn8N/uAH5ARKtPq8MGlXPWb4oqblmAgWeAwRKRuXwIG5BsSEsVC5VSO2HZ2ouJyon
	 nvF+ePsvt6yqtv7b2ZnXvL6ZIgB5rf6p2KS9pPI67o/pJ+m2ngTg717jiozD6jgzvV
	 w+/wNiPvUp0pHlhBLGrSyS8IUu7C+cRddgdDmz+8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729028AbgHURLv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 21 Aug 2020 13:11:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728133AbgHUQRA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Aug 2020 12:17:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FC4522CAD;
        Fri, 21 Aug 2020 16:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026609;
        bh=jUkxIfMy8Y73M1KRZQz6fQti+P06LWsHaph/CRw6DYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EFKn1L6oWGp4nDaxBsaoJGhIYM6gRhTMLhtYGPs9xD3NwpUo+UHBaYAxwxAzZjcTF
         Jdd8DS4vgCh05IbDTeiEbdaJve7eKnGq296bt58FLmKVPMQpBFmuivTg2zW+ha0qqT
         Y9d6yK+G6YQvRwtCfV72hoJFLnl0NzVtMDscTsL8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qu Wenruo <wqu@suse.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 51/61] btrfs: file: reserve qgroup space after the hole punch range is locked
Date:   Fri, 21 Aug 2020 12:15:35 -0400
Message-Id: <20200821161545.347622-51-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161545.347622-1-sashal@kernel.org>
References: <20200821161545.347622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit a7f8b1c2ac21bf081b41264c9cfd6260dffa6246 ]

The incoming qgroup reserved space timing will move the data reservation
to ordered extent completely.

However in btrfs_punch_hole_lock_range() will call
btrfs_invalidate_page(), which will clear QGROUP_RESERVED bit for the
range.

In current stage it's OK, but if we're making ordered extents handle the
reserved space, then btrfs_punch_hole_lock_range() can clear the
QGROUP_RESERVED bit before we submit ordered extent, leading to qgroup
reserved space leakage.

So here change the timing to make reserve data space after
btrfs_punch_hole_lock_range().
The new timing is fine for either current code or the new code.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/file.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 1e1af0ce70771..5a8d93bf9b8b7 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3184,14 +3184,14 @@ static int btrfs_zero_range(struct inode *inode,
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
2.25.1

