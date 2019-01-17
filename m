Return-Path: <SRS0=cccy=PZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F4C4C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 10:15:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BFFC20851
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 10:15:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727504AbfAQKPg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Jan 2019 05:15:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:35950 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726029AbfAQKPg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Jan 2019 05:15:36 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1F6E2AE24
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 10:15:35 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2 1/5] btrfs: Always output error message when key/level verification fails
Date:   Thu, 17 Jan 2019 18:15:24 +0800
Message-Id: <20190117101528.8675-2-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190117101528.8675-1-wqu@suse.com>
References: <20190117101528.8675-1-wqu@suse.com>
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

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8da2f380d3c0..659bab9de03b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -425,10 +425,10 @@ static int verify_level_key(struct btrfs_fs_info *fs_info,
 	if (found_level != level) {
 #ifdef CONFIG_BTRFS_DEBUG
 		WARN_ON(1);
+#endif
 		btrfs_err(fs_info,
 "tree level mismatch detected, bytenr=%llu level expected=%u has=%u",
 			  eb->start, level, found_level);
-#endif
 		return -EIO;
 	}
 
@@ -449,9 +449,10 @@ static int verify_level_key(struct btrfs_fs_info *fs_info,
 		btrfs_item_key_to_cpu(eb, &found_key, 0);
 	ret = btrfs_comp_cpu_keys(first_key, &found_key);
 
-#ifdef CONFIG_BTRFS_DEBUG
 	if (ret) {
+#ifdef CONFIG_BTRFS_DEBUG
 		WARN_ON(1);
+#endif
 		btrfs_err(fs_info,
 "tree first key mismatch detected, bytenr=%llu parent_transid=%llu key expected=(%llu,%u,%llu) has=(%llu,%u,%llu)",
 			  eb->start, parent_transid, first_key->objectid,
@@ -459,7 +460,6 @@ static int verify_level_key(struct btrfs_fs_info *fs_info,
 			  found_key.objectid, found_key.type,
 			  found_key.offset);
 	}
-#endif
 	return ret;
 }
 
-- 
2.20.1

