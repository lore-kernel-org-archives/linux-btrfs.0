Return-Path: <SRS0=xnYl=RX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B06DBC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 06:27:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 802A42184E
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 06:27:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbfCTG15 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Mar 2019 02:27:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:39744 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726749AbfCTG14 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Mar 2019 02:27:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2A71DAC3B
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Mar 2019 06:27:55 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v5.3 01/11] btrfs: Always output error message when key/level verification fails
Date:   Wed, 20 Mar 2019 14:27:39 +0800
Message-Id: <20190320062749.30953-2-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190320062749.30953-1-wqu@suse.com>
References: <20190320062749.30953-1-wqu@suse.com>
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
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 fs/btrfs/disk-io.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6fe9197f6ee4..6a7a1e168169 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -424,12 +424,11 @@ static int verify_level_key(struct btrfs_fs_info *fs_info,
 
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
 
@@ -450,9 +449,9 @@ static int verify_level_key(struct btrfs_fs_info *fs_info,
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
@@ -460,7 +459,6 @@ static int verify_level_key(struct btrfs_fs_info *fs_info,
 			  found_key.objectid, found_key.type,
 			  found_key.offset);
 	}
-#endif
 	return ret;
 }
 
-- 
2.21.0

