Return-Path: <SRS0=cccy=PZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EB00C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 07:49:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 154C920855
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 07:49:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbfAQHtM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Jan 2019 02:49:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:54860 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725954AbfAQHtL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Jan 2019 02:49:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9E764AE83
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 07:49:10 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 4/5] btrfs: disk-io: Show the timing of corrupted tree block explicitly
Date:   Thu, 17 Jan 2019 15:48:54 +0800
Message-Id: <20190117074855.24818-5-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190117074855.24818-1-wqu@suse.com>
References: <20190117074855.24818-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Just add one extra line to show when the corruption is detected.
Currently only read time detection is possible.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 659bab9de03b..bc2379cb2091 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -652,11 +652,14 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 	 */
 	if (found_level == 0 && btrfs_check_leaf_full(fs_info, eb)) {
 		set_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags);
+		btrfs_err(fs_info, "read time tree block corruption detected");
 		ret = -EIO;
 	}
 
-	if (found_level > 0 && btrfs_check_node(fs_info, eb))
+	if (found_level > 0 && btrfs_check_node(fs_info, eb)) {
+		btrfs_err(fs_info, "read time tree block corruption detected");
 		ret = -EIO;
+	}
 
 	if (!ret)
 		set_extent_buffer_uptodate(eb);
-- 
2.20.1

