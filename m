Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6FC0C00449
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 08:25:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CB8E2064E
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 08:25:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9CB8E2064E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbeJEPXO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 11:23:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:35610 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727703AbeJEPXN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Oct 2018 11:23:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CCBB1AFC0
        for <linux-btrfs@vger.kernel.org>; Fri,  5 Oct 2018 08:25:34 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: volumes: Make sure no dev extent is beyond device boundary
Date:   Fri,  5 Oct 2018 16:25:25 +0800
Message-Id: <20181005082525.22441-3-wqu@suse.com>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20181005082525.22441-1-wqu@suse.com>
References: <20181005082525.22441-1-wqu@suse.com>
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
index bf0b2c16847a..9fb40e30be6a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7492,6 +7492,7 @@ int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info)
 	while (1) {
 		struct extent_buffer *leaf = path->nodes[0];
 		struct btrfs_dev_extent *dext;
+		struct btrfs_device *dev;
 		int slot = path->slots[0];
 		u64 chunk_offset;
 		u64 physical_offset;
@@ -7517,6 +7518,22 @@ int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info)
 			goto out;
 		}
 
+		/* Make sure no dev extent is beyond device bondary */
+		dev = btrfs_find_device(fs_info, devid, NULL, NULL);
+		if (!dev) {
+			btrfs_err(fs_info, "failed to find devid %llu", devid);
+			ret = -EUCLEAN;
+			goto out;
+		}
+		if (physical_offset + physical_len > dev->disk_total_bytes) {
+			btrfs_err(fs_info,
+"dev extent devid %llu physical offset %llu len %llu is beyond device boundary %llu",
+				  devid, physical_offset, physical_len,
+				  dev->disk_total_bytes);
+			ret = -EUCLEAN;
+			goto out;
+		}
+
 		ret = verify_one_dev_extent(fs_info, chunk_offset, devid,
 					    physical_offset, physical_len);
 		if (ret < 0)
-- 
2.19.0

