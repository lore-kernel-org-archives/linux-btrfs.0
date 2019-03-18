Return-Path: <SRS0=8Q4i=RV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3A54C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:48:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 837D720854
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:48:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbfCRQs4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Mar 2019 12:48:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:55856 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727130AbfCRQsz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Mar 2019 12:48:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 10462ACFA
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2019 16:48:54 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 422A5DA8A7; Mon, 18 Mar 2019 17:50:10 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 02/22] btrfs: tests: don't leak fs_info in extent_io bitmap tests
Date:   Mon, 18 Mar 2019 17:50:10 +0100
Message-Id: <54d7d7c312949878596ecf74f17a6340f91f6896.1552927639.git.dsterba@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1552927639.git.dsterba@suse.com>
References: <cover.1552927639.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The fs_info is not freed at the end of the function and leaks. The
function is called twice so there can be up to 2x sizeof(struct
btrfs_fs_info) of leaked memory.  Fortunatelly this affects only testing
builds, the size could be 16k with several debugging features enabled.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/tests/extent-io-tests.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index c444243f3fdd..af3309e51876 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -374,8 +374,8 @@ static int test_eb_bitmaps(u32 sectorsize, u32 nodesize)
 {
 	struct btrfs_fs_info *fs_info;
 	unsigned long len;
-	unsigned long *bitmap;
-	struct extent_buffer *eb;
+	unsigned long *bitmap = NULL;
+	struct extent_buffer *eb = NULL;
 	int ret;
 
 	test_msg("running extent buffer bitmap tests");
@@ -396,14 +396,15 @@ static int test_eb_bitmaps(u32 sectorsize, u32 nodesize)
 	bitmap = kmalloc(len, GFP_KERNEL);
 	if (!bitmap) {
 		test_err("couldn't allocate test bitmap");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out;
 	}
 
 	eb = __alloc_dummy_extent_buffer(fs_info, 0, len);
 	if (!eb) {
 		test_err("couldn't allocate test extent buffer");
-		kfree(bitmap);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out;
 	}
 
 	ret = __test_eb_bitmaps(bitmap, eb, len);
@@ -415,14 +416,15 @@ static int test_eb_bitmaps(u32 sectorsize, u32 nodesize)
 	eb = __alloc_dummy_extent_buffer(NULL, nodesize / 2, len);
 	if (!eb) {
 		test_err("couldn't allocate test extent buffer");
-		kfree(bitmap);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out;
 	}
 
 	ret = __test_eb_bitmaps(bitmap, eb, len);
 out:
 	free_extent_buffer(eb);
 	kfree(bitmap);
+	btrfs_free_dummy_fs_info(fs_info);
 	return ret;
 }
 
-- 
2.21.0

