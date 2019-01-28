Return-Path: <SRS0=GbvB=QE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66C34C282CF
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 17:39:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D3102147A
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 17:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548697192;
	bh=L72q0sXFpHqz3P0a9KMLYZwWjigbUy86A70gzUvyUb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=YtXcyiffQvZHok3xB9RXfMJx5A2fPn+7sbLwlb+t82/l4e9A2y7k1YkhVVCRwimZK
	 4zLfRkZNT2HeR+pLzjxG4PCrWOmot0kKj4zuT1xBt1UjP9fzYe7aixFpPjUlIzCsVc
	 vQxmuIc2z0jtI+WyQ+bGqqGHkIxeQQtxCIIbe26w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729392AbfA1PxH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 28 Jan 2019 10:53:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:39532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727444AbfA1PxH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Jan 2019 10:53:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B35720880;
        Mon, 28 Jan 2019 15:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548690786;
        bh=L72q0sXFpHqz3P0a9KMLYZwWjigbUy86A70gzUvyUb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KvEWkDn6AlSqnnOiuAfuQ4qXT+5ZWR5TnmrC4kIrX/BNMeHyabkJMNEhd9edkI8vb
         ueGRVpCbQkOUpQJhuq7UsYzbmOMqDCytD0oqGvlQJMZr7gQT8C39AoMAqE6l+hNc2Q
         58sN9FdzmZxx53Ot8vwz+Q1IZVjy/MeO9Up3xEMw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>, Sasha Levin <sashal@kernel.org>,
        linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.20 192/304] btrfs: reada: reorder dev-replace locks before radix tree preload
Date:   Mon, 28 Jan 2019 10:41:49 -0500
Message-Id: <20190128154341.47195-192-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190128154341.47195-1-sashal@kernel.org>
References: <20190128154341.47195-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: David Sterba <dsterba@suse.com>

[ Upstream commit ceb21a8db48559fd0809e03c4df9eb37743d9170 ]

The device-replace read lock is going to use rw semaphore in followup
commits. The semaphore might sleep which is not possible in the radix
tree preload section. The lock nesting is now:

* device replace
  * radix tree preload
    * readahead spinlock

Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/reada.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index dec14b739b10..6f81f3e88b6d 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -376,26 +376,28 @@ static struct reada_extent *reada_find_extent(struct btrfs_fs_info *fs_info,
 		goto error;
 	}
 
+	/* Insert extent in reada tree + all per-device trees, all or nothing */
+	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
 	ret = radix_tree_preload(GFP_KERNEL);
-	if (ret)
+	if (ret) {
+		btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
 		goto error;
+	}
 
-	/* insert extent in reada_tree + all per-device trees, all or nothing */
-	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
 	spin_lock(&fs_info->reada_lock);
 	ret = radix_tree_insert(&fs_info->reada_tree, index, re);
 	if (ret == -EEXIST) {
 		re_exist = radix_tree_lookup(&fs_info->reada_tree, index);
 		re_exist->refcnt++;
 		spin_unlock(&fs_info->reada_lock);
-		btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
 		radix_tree_preload_end();
+		btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
 		goto error;
 	}
 	if (ret) {
 		spin_unlock(&fs_info->reada_lock);
-		btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
 		radix_tree_preload_end();
+		btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
 		goto error;
 	}
 	radix_tree_preload_end();
-- 
2.19.1

