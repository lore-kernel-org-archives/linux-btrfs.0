Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF91FC00449
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 09:46:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79ADA20652
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 09:46:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 79ADA20652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbeJEQoF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 12:44:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:55840 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727036AbeJEQoF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Oct 2018 12:44:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E8563AEAD
        for <linux-btrfs@vger.kernel.org>; Fri,  5 Oct 2018 09:46:05 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/2] btrfs: volumes: Make sure no dev extent is beyond device boundary
Date:   Fri,  5 Oct 2018 17:45:55 +0800
Message-Id: <20181005094555.31177-3-wqu@suse.com>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20181005094555.31177-1-wqu@suse.com>
References: <20181005094555.31177-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Add extra dev extent end check against device boundary.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/volumes.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index bf0b2c16847a..bc3ac4715694 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7371,6 +7371,7 @@ static int verify_one_dev_extent(struct btrfs_fs_info *fs_info,
 	struct extent_map_tree *em_tree = &fs_info->mapping_tree.map_tree;
 	struct extent_map *em;
 	struct map_lookup *map;
+	struct btrfs_device *dev;
 	u64 stripe_len;
 	bool found = false;
 	int ret = 0;
@@ -7420,6 +7421,22 @@ static int verify_one_dev_extent(struct btrfs_fs_info *fs_info,
 			physical_offset, devid);
 		ret = -EUCLEAN;
 	}
+
+	/* Make sure no dev extent is beyond device bondary */
+	dev = btrfs_find_device(fs_info, devid, NULL, NULL);
+	if (!dev) {
+		btrfs_err(fs_info, "failed to find devid %llu", devid);
+		ret = -EUCLEAN;
+		goto out;
+	}
+	if (physical_offset + physical_len > dev->disk_total_bytes) {
+		btrfs_err(fs_info,
+"dev extent devid %llu physical offset %llu len %llu is beyond device boundary %llu",
+			  devid, physical_offset, physical_len,
+			  dev->disk_total_bytes);
+		ret = -EUCLEAN;
+		goto out;
+	}
 out:
 	free_extent_map(em);
 	return ret;
-- 
2.19.0

