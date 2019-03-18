Return-Path: <SRS0=8Q4i=RV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C164C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:49:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC53E20854
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:49:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727753AbfCRQte (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Mar 2019 12:49:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:56062 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727442AbfCRQte (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Mar 2019 12:49:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3F3EDADD4
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2019 16:49:33 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7AC73DA8A7; Mon, 18 Mar 2019 17:50:49 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 19/22] btrfs: tests: use SZ_ constants everywhere
Date:   Mon, 18 Mar 2019 17:50:49 +0100
Message-Id: <2fbbd741e61c64b94f0257e30ef61ea0cdd14d92.1552927639.git.dsterba@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1552927639.git.dsterba@suse.com>
References: <cover.1552927639.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There are a few unconverted constants that are not powers of two and
haven't been converted.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/tests/extent-map-tests.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/tests/extent-map-tests.c b/fs/btrfs/tests/extent-map-tests.c
index 9bf75f7d2c26..a09783f19011 100644
--- a/fs/btrfs/tests/extent-map-tests.c
+++ b/fs/btrfs/tests/extent-map-tests.c
@@ -297,7 +297,7 @@ static int test_case_3(struct btrfs_fs_info *fs_info,
 	ret = __test_case_3(fs_info, em_tree, SZ_8K);
 	if (ret)
 		return ret;
-	ret = __test_case_3(fs_info, em_tree, (12 * 1024ULL));
+	ret = __test_case_3(fs_info, em_tree, (12 * SZ_1K));
 
 	return ret;
 }
@@ -336,9 +336,9 @@ static int __test_case_4(struct btrfs_fs_info *fs_info,
 
 	/* Add [8K, 24K) */
 	em->start = SZ_8K;
-	em->len = 24 * 1024ULL;
+	em->len = 24 * SZ_1K;
 	em->block_start = SZ_16K; /* avoid merging */
-	em->block_len = 24 * 1024ULL;
+	em->block_len = 24 * SZ_1K;
 	ret = add_extent_mapping(em_tree, em, 0);
 	if (ret < 0) {
 		test_err("cannot add extent range [8K, 32K)");
-- 
2.21.0

