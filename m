Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D55DAC10F11
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 00:25:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FA4120643
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 00:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1556151922;
	bh=y1s/p9Q95WVyoV/00G2bE4wx2YA55Os5PlothV+nViM=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=OoLpWg9f3ykpgUCA38ISI5qx6NcBTLGv4CpyDa4If2QmrKi9CQpG7ZNG8Jc/eeybd
	 B7y1Ag00u70tBGkOTFBGcFxWQ5Hc6VRT9QWx8Zw4sg8jWadWoh48Z1TWTa5sknBilB
	 bEkUzsHBLB52fH2ogTqGLr+VbnGR27q/4uVpXFVo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728644AbfDYAZV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Apr 2019 20:25:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728605AbfDYAZV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Apr 2019 20:25:21 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00D9120643;
        Thu, 25 Apr 2019 00:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556151919;
        bh=y1s/p9Q95WVyoV/00G2bE4wx2YA55Os5PlothV+nViM=;
        h=From:To:Cc:Subject:Date:From;
        b=A4r9bIHhUJiSHnD6AgBannW0uZulI0e9bcIu4FrRJAPresuIi70idDqGufH05E7Cz
         G9cApeccxyQt2XTLkjRupBOQ1VbXnRoRwE2eEy7FVUXEAh0cFgyHE+QWv5gPv2Yj8e
         Le4taAHgWtgS7fATTAoHGIyV7ysm9EgxfAxDJ3PQ=
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] btrfs: fix filtering of scratch device in test case 048
Date:   Thu, 25 Apr 2019 01:24:57 +0100
Message-Id: <20190425002457.28648-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
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
at "/mnt/scratch", like this:

$ ./check btrfs/048
FSTYP         -- btrfs
PLATFORM      -- Linux/x86_64 debian5 5.0.0-btrfs-next-46
MKFS_OPTIONS  -- /dev/sdc
MOUNT_OPTIONS -- /dev/sdc /home/fdmanana/btrfs-tests/scratch_1

btrfs/048 1s ... - output mismatch (see /home/fdmanana/git/hub/xfstests/results//btrfs/048.out.bad)
    --- tests/btrfs/048.out	2019-04-22 12:52:00.937610318 +0100
    +++ /home/fdmanana/git/hub/xfstests/results//btrfs/048.out.bad	2019-04-25 01:14:43.077297630 +0100
    @@ -78,17 +78,17 @@
     compression=lzo

     Testing argument validation, should fail
    -ERROR: failed to set compression for /mnt/scratch: Invalid argument
    +ERROR: failed to set compression for /home/fdmanana/btrfs-tests/scratch_1: Invalid argument
     ***
    -ERROR: failed to set compression for /mnt/scratch: Invalid argument
    ...
    (Run 'diff -u /home/fdmanana/git/hub/xfstests/tests/btrfs/048.out /home/fdmanana/git/hub/xfstests/results//btrfs/048.out.bad'  to see the entire diff)
Ran: btrfs/048
Failures: btrfs/048
Failed 1 of 1 tests

$ diff -u /home/fdmanana/git/hub/xfstests/tests/btrfs/048.out /home/fdmanana/git/hub/xfstests/results//btrfs/048.out.bad
--- /home/fdmanana/git/hub/xfstests/tests/btrfs/048.out	2019-04-22 12:52:00.937610318 +0100
+++ /home/fdmanana/git/hub/xfstests/results//btrfs/048.out.bad	2019-04-25 01:14:43.077297630 +0100
@@ -78,17 +78,17 @@
 compression=lzo

 Testing argument validation, should fail
-ERROR: failed to set compression for /mnt/scratch: Invalid argument
+ERROR: failed to set compression for /home/fdmanana/btrfs-tests/scratch_1: Invalid argument
 ***
-ERROR: failed to set compression for /mnt/scratch: Invalid argument
+ERROR: failed to set compression for /home/fdmanana/btrfs-tests/scratch_1: Invalid argument
 ***
-ERROR: failed to set compression for /mnt/scratch: Invalid argument
+ERROR: failed to set compression for /home/fdmanana/btrfs-tests/scratch_1: Invalid argument

 Testing if property is persistent across failed validation
-ERROR: failed to set compression for /mnt/scratch: Invalid argument
+ERROR: failed to set compression for /home/fdmanana/btrfs-tests/scratch_1: Invalid argument
 compression=lzo

 Testing generation is unchanged after failed validation
 generation		7
-ERROR: failed to set compression for /mnt/scratch: Invalid argument
+ERROR: failed to set compression for /home/fdmanana/btrfs-tests/scratch_1: Invalid argument
 generation		7

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
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

