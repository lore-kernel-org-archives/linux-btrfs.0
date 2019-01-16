Return-Path: <SRS0=HC3m=PY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4099C43387
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 11:53:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF66B20657
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 11:53:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392733AbfAPLxQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 16 Jan 2019 06:53:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:58238 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392547AbfAPLxQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Jan 2019 06:53:16 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 44418ACA9;
        Wed, 16 Jan 2019 11:53:15 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Leonard Lausen <leonard@lausen.nl>
Subject: [PATCH] btrfs: Do mandatory tree block check before submitting bio
Date:   Wed, 16 Jan 2019 19:53:08 +0800
Message-Id: <20190116115308.8687-1-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There are at least 2 reports about memory bit flip sneaking into on-disk
data.

Currently we only have a relaxed check triggered at
btrfs_mark_buffer_dirty() time, as it's not mandatory, only for
CONFIG_BTRFS_FS_CHECK_INTEGRITY enabled build.

This patch will address the hole by triggering comprehensive check on
tree blocks before writing it back to disk.

The timing is set to csum_tree_block() where @verify == 0.
At that timing, we're generation csum for tree blocks before submitting
the metadata bio, so we could avoid all the unnecessary calls at
btrfs_mark_buffer_dirty(), but still catch enough error.

Reported-by: Leonard Lausen <leonard@lausen.nl>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8da2f380d3c0..45bf6be9e751 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -313,6 +313,16 @@ static int csum_tree_block(struct btrfs_fs_info *fs_info,
 			return -EUCLEAN;
 		}
 	} else {
+		/*
+		 * Here we're calculating csum before writing it to disk,
+		 * do comprenhensive check here to catch memory corruption
+		 */
+		if (btrfs_header_level(buf))
+			err = btrfs_check_node(fs_info, buf);
+		else
+			err = btrfs_check_leaf_full(fs_info, buf);
+		if (err < 0)
+			return err;
 		write_extent_buffer(buf, result, 0, csum_size);
 	}
 
-- 
2.20.1

