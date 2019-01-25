Return-Path: <SRS0=6jfg=QB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DBEDC282C0
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 05:09:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AB77218D2
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 05:09:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbfAYFJd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 25 Jan 2019 00:09:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:56130 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725300AbfAYFJc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Jan 2019 00:09:32 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B9535ADF5
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Jan 2019 05:09:31 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v4 01/12] btrfs: Always output error message when key/level verification fails
Date:   Fri, 25 Jan 2019 13:09:14 +0800
Message-Id: <20190125050925.30754-2-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190125050925.30754-1-wqu@suse.com>
References: <20190125050925.30754-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We have internal report of strange transaction abort due to EUCLEAN
without any error message.

Since error message inside verify_level_key() is only enabled for
CONFIG_BTRFS_DEBUG, the error message won't output for most distro.

This patch will make the error message mandatory, so when problem
happens we know what's causing the problem.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/disk-io.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8da2f380d3c0..794d5bb7fe33 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -423,12 +423,11 @@ static int verify_level_key(struct btrfs_fs_info *fs_info,
 
 	found_level = btrfs_header_level(eb);
 	if (found_level != level) {
-#ifdef CONFIG_BTRFS_DEBUG
-		WARN_ON(1);
+		WARN(IS_ENABLED(CONFIG_BTRFS_DEBUG),
+		     KERN_ERR "BTRFS: tree level check failed\n");
 		btrfs_err(fs_info,
 "tree level mismatch detected, bytenr=%llu level expected=%u has=%u",
 			  eb->start, level, found_level);
-#endif
 		return -EIO;
 	}
 
@@ -449,9 +448,9 @@ static int verify_level_key(struct btrfs_fs_info *fs_info,
 		btrfs_item_key_to_cpu(eb, &found_key, 0);
 	ret = btrfs_comp_cpu_keys(first_key, &found_key);
 
-#ifdef CONFIG_BTRFS_DEBUG
 	if (ret) {
-		WARN_ON(1);
+		WARN(IS_ENABLED(CONFIG_BTRFS_DEBUG),
+		     KERN_ERR "BTRFS: tree first key check failed\n");
 		btrfs_err(fs_info,
 "tree first key mismatch detected, bytenr=%llu parent_transid=%llu key expected=(%llu,%u,%llu) has=(%llu,%u,%llu)",
 			  eb->start, parent_transid, first_key->objectid,
@@ -459,7 +458,6 @@ static int verify_level_key(struct btrfs_fs_info *fs_info,
 			  found_key.objectid, found_key.type,
 			  found_key.offset);
 	}
-#endif
 	return ret;
 }
 
-- 
2.20.1

