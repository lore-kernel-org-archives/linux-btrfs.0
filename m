Return-Path: <SRS0=Bqu+=B3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD2F9C433E1
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Aug 2020 10:37:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8A882078A
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Aug 2020 10:37:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgHQKhW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 06:37:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:39392 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbgHQKhV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Aug 2020 06:37:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6B0FDADD5;
        Mon, 17 Aug 2020 10:37:45 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/3] btrfs/024: Remove no longer valid test
Date:   Mon, 17 Aug 2020 13:37:16 +0300
Message-Id: <20200817103718.10239-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Kernel commit "btrfs: add missing check for nocow and compression inode
flags" invalidates the "file compressed, fs mounted with nodatacow"
mode due to doing more rigorous flags validation, just remove the test.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 tests/btrfs/024 | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/tests/btrfs/024 b/tests/btrfs/024
index 0c2ffd7389ab..bcb9048da636 100755
--- a/tests/btrfs/024
+++ b/tests/btrfs/024
@@ -42,13 +42,6 @@ __workout()
 	$XFS_IO_PROG -f -c "pwrite 0 1M" -c "fsync" $work_file | _filter_xfs_io
 }
 
-echo "*** test nodatacow"
-_scratch_mkfs > /dev/null 2>&1
-_scratch_mount "-o nodatacow"
-__workout
-_scratch_unmount
-_check_scratch_fs
-
 echo "*** test compress=no"
 _scratch_mkfs > /dev/null 2>&1
 _scratch_mount "-o compress=no"
-- 
2.17.1

