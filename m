Return-Path: <SRS0=4n2k=37=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DCF5C35242
	for <linux-btrfs@archiver.kernel.org>; Tue, 11 Feb 2020 05:12:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F9592070A
	for <linux-btrfs@archiver.kernel.org>; Tue, 11 Feb 2020 05:12:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbgBKFMT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 11 Feb 2020 00:12:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:44616 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728124AbgBKFMT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Feb 2020 00:12:19 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A7345AF76
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Feb 2020 05:12:17 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v7 5/5] btrfs: volumes: Revert device used bytes when calc_per_profile_avail() failed
Date:   Tue, 11 Feb 2020 13:11:53 +0800
Message-Id: <20200211051153.19466-6-wqu@suse.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200211051153.19466-1-wqu@suse.com>
References: <20200211051153.19466-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

In __btrfs_alloc_chunk(), if calc_per_profile_avail() failed, it will
not update the per-profile available space array.
However since device used space is already updated, this would cause a
mismatch between them.

To fix this problem, this patch will revert device used bytes when
calc_per_profile_avail() failed, and remove the newly allocated chunk.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/volumes.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 4750255d02a8..27bd71d30e6f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5225,6 +5225,15 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 				      &trans->transaction->dev_update_list);
 	}
 	ret = calc_per_profile_avail(info);
+	if (ret < 0) {
+		for (i = 0; i < map->num_stripes; i++) {
+			struct btrfs_device *dev = map->stripes[i].dev;
+
+			btrfs_device_set_bytes_used(dev,
+					dev->bytes_used - stripe_size);
+		}
+		goto error_del_extent;
+	}
 
 	atomic64_sub(stripe_size * map->num_stripes, &info->free_chunk_space);
 
-- 
2.25.0

