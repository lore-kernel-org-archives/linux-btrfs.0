Return-Path: <SRS0=cRuQ=W6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3F64C3A5A2
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Sep 2019 12:27:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F9B82087E
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Sep 2019 12:27:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728854AbfICM1Y (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 3 Sep 2019 08:27:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:51874 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726631AbfICM1Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Sep 2019 08:27:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 42713AB91;
        Tue,  3 Sep 2019 12:27:23 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] btrfs-progs: fix zstd compression test on a kernel without ztsd support
Date:   Tue,  3 Sep 2019 14:27:21 +0200
Message-Id: <20190903122721.9865-1-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The test-case 'misc-tests/025-zstd-compression' is failing on a kernel
without zstd compression support.

Check if zstd compression is supported by the kernel and if not skip the
test-case.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 tests/misc-tests/025-zstd-compression/test.sh | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tests/misc-tests/025-zstd-compression/test.sh b/tests/misc-tests/025-zstd-compression/test.sh
index 22795d27500e..f9ff1d089fd5 100755
--- a/tests/misc-tests/025-zstd-compression/test.sh
+++ b/tests/misc-tests/025-zstd-compression/test.sh
@@ -6,6 +6,11 @@ source "$TEST_TOP/common"
 check_prereq btrfs
 check_global_prereq md5sum
 
+if ! [ -f "/sys/fs/btrfs/features/compress_zstd" ]; then
+       _not_run "kernel does not support zstd compression feature"
+       exit
+fi
+
 # Extract the test image
 image=$(extract_image compress.raw.xz)
 
-- 
2.16.4

