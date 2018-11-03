Return-Path: <SRS0=HXCT=NO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A76E5C0044C
	for <linux-btrfs@archiver.kernel.org>; Sat,  3 Nov 2018 09:25:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 453732082D
	for <linux-btrfs@archiver.kernel.org>; Sat,  3 Nov 2018 09:25:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 453732082D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbeKCSfk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 3 Nov 2018 14:35:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:46230 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726632AbeKCSfk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 3 Nov 2018 14:35:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4D1FFAEC7
        for <linux-btrfs@vger.kernel.org>; Sat,  3 Nov 2018 09:24:57 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: tests: Use BTRFS_MAX_EXTENT_SIZE to replace the intermediate number
Date:   Sat,  3 Nov 2018 17:24:52 +0800
Message-Id: <20181103092452.14572-1-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

In extent-io self test, we need 2 ordered extents at its maximum size to
do the test.

Instead of using the intermediate numbers, use BTRFS_MAX_EXTENT_SIZE for
@max_bytes, and twice @max_bytes for @total_dirty.
This should explain why we need all these magic numbers and prevent
people to modify them by accident.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/tests/extent-io-tests.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index 9e0f4a01be14..c0ad9bc48f6b 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -62,8 +62,9 @@ static int test_find_delalloc(u32 sectorsize)
 	struct page *page;
 	struct page *locked_page = NULL;
 	unsigned long index = 0;
-	u64 total_dirty = SZ_256M;
-	u64 max_bytes = SZ_128M;
+	/* In this test we need at least 2 file extents at its maximum size */
+	u64 max_bytes = BTRFS_MAX_EXTENT_SIZE;
+	u64 total_dirty = 2 * max_bytes;
 	u64 start, end, test_start;
 	u64 found;
 	int ret = -EINVAL;
-- 
2.19.1

