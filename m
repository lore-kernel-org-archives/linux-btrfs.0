Return-Path: <SRS0=cRuQ=W6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40B43C3A5A2
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Sep 2019 15:01:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E65922D6D
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Sep 2019 15:01:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729771AbfICPBE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 3 Sep 2019 11:01:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:57514 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729702AbfICPAv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Sep 2019 11:00:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 90D89AF79;
        Tue,  3 Sep 2019 15:00:48 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v4 12/12] btrfs-progs: add test-case for mkfs with xxhash64
Date:   Tue,  3 Sep 2019 17:00:46 +0200
Message-Id: <20190903150046.14926-13-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190903150046.14926-1-jthumshirn@suse.de>
References: <20190903150046.14926-1-jthumshirn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Add test-cases for creating a file-system xxhash64 as checksumming
algorithm.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
---
 tests/mkfs-tests/001-basic-profiles/test.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tests/mkfs-tests/001-basic-profiles/test.sh b/tests/mkfs-tests/001-basic-profiles/test.sh
index 6e295274119d..3fa3c8ad42d1 100755
--- a/tests/mkfs-tests/001-basic-profiles/test.sh
+++ b/tests/mkfs-tests/001-basic-profiles/test.sh
@@ -46,6 +46,8 @@ test_mkfs_single  -d  single  -m  dup
 test_mkfs_single  -d  dup     -m  single
 test_mkfs_single  -d  dup     -m  dup
 test_mkfs_single  -d  dup     -m  dup     --mixed
+test_mkfs_single  -C xxhash64
+test_mkfs_single  -C xxhash
 
 test_mkfs_multi
 test_mkfs_multi   -d  single  -m  single
-- 
2.16.4

