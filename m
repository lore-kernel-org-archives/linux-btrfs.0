Return-Path: <SRS0=9BDA=W2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 889ACC3A5A4
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Aug 2019 11:32:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6453B2186A
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Aug 2019 11:32:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728067AbfH3Lcu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 07:32:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:48884 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727958AbfH3Lcl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Aug 2019 07:32:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5AD9BB0BF;
        Fri, 30 Aug 2019 11:32:39 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v3 12/12] btrfs-progs: add test-case for mkfs with xxhash64
Date:   Fri, 30 Aug 2019 13:32:34 +0200
Message-Id: <20190830113234.16615-13-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190830113234.16615-1-jthumshirn@suse.de>
References: <20190830113234.16615-1-jthumshirn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Add test-cases for creating a file-system xxhash64 as checksumming
algorithm.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
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

