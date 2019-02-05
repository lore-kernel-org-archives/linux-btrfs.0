Return-Path: <SRS0=OwrN=QM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65F1AC282CB
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Feb 2019 06:53:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32D0420811
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Feb 2019 06:53:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727497AbfBEGxU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Feb 2019 01:53:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:53944 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726416AbfBEGxT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Feb 2019 01:53:19 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 41241AFC7
        for <linux-btrfs@vger.kernel.org>; Tue,  5 Feb 2019 06:53:18 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs-progs: Unify metadata chunk size with kernel
Date:   Tue,  5 Feb 2019 14:53:12 +0800
Message-Id: <20190205065312.19743-2-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190205065312.19743-1-wqu@suse.com>
References: <20190205065312.19743-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Mkfs tends to create pretty large metadata chunk compared to kernel:
  Node size:          16384
  Sector size:        4096
  Filesystem size:    10.00GiB
  Block group profiles:
    Data:             single            8.00MiB
    Metadata:         DUP               1.00GiB
    System:           DUP               8.00MiB

While kernel only tends to create 256MiB metadata chunk:
		/* for larger filesystems, use larger metadata chunks */
		if (fs_devices->total_rw_bytes > 50ULL * SZ_1G)
			max_stripe_size = SZ_1G;
		else
			max_stripe_size = SZ_256M;

This won't cause problems in real world, but it's still better to make
the behavior unified.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 volumes.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/volumes.c b/volumes.c
index 2611a932c01c..3a91b43b378b 100644
--- a/volumes.c
+++ b/volumes.c
@@ -989,8 +989,12 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 			min_stripe_size = SZ_64M;
 			max_stripes = BTRFS_MAX_DEVS(info);
 		} else if (type & BTRFS_BLOCK_GROUP_METADATA) {
-			calc_size = SZ_1G;
-			max_chunk_size = 4 * calc_size;
+			/* for larger filesystems, use larger metadata chunks */
+			if (info->fs_devices->total_rw_bytes > 50ULL * SZ_1G)
+				max_chunk_size = SZ_1G;
+			else
+				max_chunk_size = SZ_256M;
+			calc_size = max_chunk_size;
 			min_stripe_size = SZ_32M;
 			max_stripes = BTRFS_MAX_DEVS(info);
 		}
-- 
2.20.1

