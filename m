Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDF3FC10F11
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 00:37:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD66A214C6
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 00:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1556152636;
	bh=LNjJNW+Ec4NB9odYh5DR8DRMNhl3WnjL1yBSwxaAd1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Hdj/Wgma7XuMqdjxQqUceD/LpNQ6SPezPFI7sP0mlMpTuWUapA6t7N/JHU/Jmm3Ag
	 VfGs03jdFH8dzJgU0k5npwGuqthPS+GgAnkLy4FaklEZPpLr+0UPtRfJwbcK89gnvr
	 CFVP6dzS9AEMsp5arRHSPesfcSZByfIKrjkq8+qE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbfDYAhQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Apr 2019 20:37:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:58294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbfDYAhP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Apr 2019 20:37:15 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68357214C6;
        Thu, 25 Apr 2019 00:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556152634;
        bh=LNjJNW+Ec4NB9odYh5DR8DRMNhl3WnjL1yBSwxaAd1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yD5pxCQea/wbBQMS18C+AbQCI6i1hSlQ+WJ7F0qUipPTVMGpJInwJABsKGii6m72Y
         jGoY8opoNRD00LyjJClrcrd847neL4gXGtoUog37xen2csAbciAPn8kHG+PO+EqGyw
         uouidjOuzhL64piXJbsgJqrBgMUrlFd4XYvISHuc=
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v2] btrfs: fix filtering of scratch device in test case 048
Date:   Thu, 25 Apr 2019 01:37:09 +0100
Message-Id: <20190425003709.28749-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190425002457.28648-1-fdmanana@kernel.org>
References: <20190425002457.28648-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

The recent commit 4529b20e1aa8f9 ("btrfs/048: amend property validation
cases"), does not properly filter the scratch device because the error
messages are sent to stderr and not to stdout, and the pipe filter only
gets input from the stdout of the btrfs utility. We need to redirect the
stderr of the btrfs utility to its stdout.

Further, the golden output had the path "/mnt/scratch" hardcoded, instead
of using SCRATCH_MNT. Fix that as well.

The test was failing on any setup where the scratch device is not mounted
at "/mnt/scratch".

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Fix the formatting of the patch, which was causing git apply / path to fail.

 tests/btrfs/048     | 10 +++++-----
 tests/btrfs/048.out | 10 +++++-----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/tests/btrfs/048 b/tests/btrfs/048
index f6de0b8c..8bb10a90 100755
--- a/tests/btrfs/048
+++ b/tests/btrfs/048
@@ -208,21 +208,21 @@ touch $SCRATCH_MNT/sv1/file2
 $BTRFS_UTIL_PROG property get $SCRATCH_MNT/sv1/file2 compression
 
 echo -e "\nTesting argument validation, should fail"
-$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'lz' | _filter_scratch
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'lz' 2>&1 | _filter_scratch
 echo "***"
-$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'zli' | _filter_scratch
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'zli' 2>&1 | _filter_scratch
 echo "***"
-$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'zst' | _filter_scratch
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'zst' 2>&1 | _filter_scratch
 
 echo -e "\nTesting if property is persistent across failed validation"
 $BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'lzo'
-$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'zli' | _filter_scratch
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'zli' 2>&1 | _filter_scratch
 $BTRFS_UTIL_PROG property get $SCRATCH_MNT compression
 
 echo -e "\nTesting generation is unchanged after failed validation"
 $BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
 $BTRFS_UTIL_PROG inspect-internal dump-super $SCRATCH_DEV | grep '^generation'
-$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'lz' | _filter_scratch
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'lz' 2>&1 | _filter_scratch
 $BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
 $BTRFS_UTIL_PROG inspect-internal dump-super $SCRATCH_DEV | grep '^generation'
 
diff --git a/tests/btrfs/048.out b/tests/btrfs/048.out
index 00f39bc0..16a785a6 100644
--- a/tests/btrfs/048.out
+++ b/tests/btrfs/048.out
@@ -78,17 +78,17 @@ compression=lzo
 compression=lzo
 
 Testing argument validation, should fail
-ERROR: failed to set compression for /mnt/scratch: Invalid argument
+ERROR: failed to set compression for SCRATCH_MNT: Invalid argument
 ***
-ERROR: failed to set compression for /mnt/scratch: Invalid argument
+ERROR: failed to set compression for SCRATCH_MNT: Invalid argument
 ***
-ERROR: failed to set compression for /mnt/scratch: Invalid argument
+ERROR: failed to set compression for SCRATCH_MNT: Invalid argument
 
 Testing if property is persistent across failed validation
-ERROR: failed to set compression for /mnt/scratch: Invalid argument
+ERROR: failed to set compression for SCRATCH_MNT: Invalid argument
 compression=lzo
 
 Testing generation is unchanged after failed validation
 generation		7
-ERROR: failed to set compression for /mnt/scratch: Invalid argument
+ERROR: failed to set compression for SCRATCH_MNT: Invalid argument
 generation		7
-- 
2.11.0

