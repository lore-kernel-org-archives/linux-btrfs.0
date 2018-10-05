Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F243C65BA7
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 08:25:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A54B2064E
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 08:25:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4A54B2064E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbeJEPXL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 11:23:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:35604 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727703AbeJEPXL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Oct 2018 11:23:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5342FAFC0
        for <linux-btrfs@vger.kernel.org>; Fri,  5 Oct 2018 08:25:32 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: volumes: Make sure there is no overlap dev extents at mount time
Date:   Fri,  5 Oct 2018 16:25:24 +0800
Message-Id: <20181005082525.22441-2-wqu@suse.com>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20181005082525.22441-1-wqu@suse.com>
References: <20181005082525.22441-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Enhance btrfs_verify_dev_extents() to remember previous checked dev
extents, so it can check if one dev extent overlaps with previous dev extent.

Reported-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/volumes.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index da86706123ff..bf0b2c16847a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7462,6 +7462,8 @@ int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info)
 	struct btrfs_path *path;
 	struct btrfs_root *root = fs_info->dev_root;
 	struct btrfs_key key;
+	u64 prev_devid = 0;
+	u64 prev_dev_ext_end = 0;
 	int ret = 0;
 
 	key.objectid = 1;
@@ -7506,10 +7508,22 @@ int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info)
 		chunk_offset = btrfs_dev_extent_chunk_offset(leaf, dext);
 		physical_len = btrfs_dev_extent_length(leaf, dext);
 
+		/* Check if this dev extent over lap with previous one */
+		if (devid == prev_devid && physical_offset < prev_dev_ext_end) {
+			btrfs_err(fs_info,
+"dev extent devid %llu physical offset %llu overlap with previous dev extent end %llu",
+				  devid, physical_offset, prev_dev_ext_end);
+			ret = -EUCLEAN;
+			goto out;
+		}
+
 		ret = verify_one_dev_extent(fs_info, chunk_offset, devid,
 					    physical_offset, physical_len);
 		if (ret < 0)
 			goto out;
+		prev_devid = devid;
+		prev_dev_ext_end = physical_offset + physical_len;
+
 		ret = btrfs_next_item(root, path);
 		if (ret < 0)
 			goto out;
-- 
2.19.0

