Return-Path: <SRS0=Imwo=WB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BD26C0650F
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Aug 2019 11:45:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 192E820856
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Aug 2019 11:45:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbfHELp0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 5 Aug 2019 07:45:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:34708 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727259AbfHELp0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Aug 2019 07:45:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id ED357B627
        for <linux-btrfs@vger.kernel.org>; Mon,  5 Aug 2019 11:45:24 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs-progs: Check for metadata uuid feature in misc-tests/034-metadata-uuid
Date:   Mon,  5 Aug 2019 14:45:22 +0300
Message-Id: <20190805114522.12151-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Instead of checking the kernel version, explicitly check for the
presence of metadata_uuid file in sysfs. This allows the test to be run
on older kernels that might have this feature backported.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 tests/misc-tests/034-metadata-uuid/test.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/misc-tests/034-metadata-uuid/test.sh b/tests/misc-tests/034-metadata-uuid/test.sh
index 3ef110cda823..6ac55b1cacfa 100755
--- a/tests/misc-tests/034-metadata-uuid/test.sh
+++ b/tests/misc-tests/034-metadata-uuid/test.sh
@@ -10,8 +10,8 @@ check_prereq btrfs-image
 setup_root_helper
 prepare_test_dev
 
-if ! check_min_kernel_version 5.0; then
-	_not_run "kernel too old, METADATA_UUID support needed"
+if [ ! -f /sys/fs/btrfs/features/metadata_uuid ] ; then
+	_not_run "METADATA_UUID feature not supported"
 fi
 
 read_fsid() {
-- 
2.17.1

