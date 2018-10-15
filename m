Return-Path: <SRS0=Zicy=M3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88FA5C28CF8
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 09:22:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B0572086A
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 09:22:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ywj8LLs2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B0572086A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbeJORHT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Oct 2018 13:07:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbeJORHT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Oct 2018 13:07:19 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B2432054F;
        Mon, 15 Oct 2018 09:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1539595373;
        bh=+aEhUo3bBLvM5owI9kWVAtL1BbcvMxUc+5QQumQKtjg=;
        h=From:To:Cc:Subject:Date:From;
        b=Ywj8LLs2smv7v6fEBfQSXE8xGzYE4RyQ6I6rsImsJWLVWNixfkDX0XQ1gJvxwqswP
         kBxzQ6pShe0MM1CGyKOZlSPc7ejLwJdHdHO2SPqr9L48nAvN7Qj4XJvXtG7rH7vCNI
         7NUzhEYFCN9HkzYx8VxJELcOEPaRcyodVIc0+Htg=
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] btrfs: fix test btrfs/007 to not leave temporary files in /tmp
Date:   Mon, 15 Oct 2018 10:22:46 +0100
Message-Id: <20181015092246.10424-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

This test was using the "mktemp -d" command to create a temporary
directory for storing send streams and computations from fssum, without
ever deleting them when it finishes. Therefore after running it for many
times it filled up all space from /tmp.

Fix this by using a temporary directory in TEST_DEV instead, as all the
more recent send/receive tests do, to store these files, and making sure
they get deleted when the test finishes. On average the sum of the size
of those files is between 5.5Mb to 6Mb, but changing the number of
operations for fsstress makes it even bigger.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/007     | 33 +++++++++++++++++++--------------
 tests/btrfs/007.out |  1 -
 2 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/tests/btrfs/007 b/tests/btrfs/007
index 09f2f011..438f2f27 100755
--- a/tests/btrfs/007
+++ b/tests/btrfs/007
@@ -16,14 +16,14 @@ seq=`basename $0`
 seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
-tmp=`mktemp -d`
+tmp=/tmp/$$
 status=1
 
 _cleanup()
 {
-	echo "*** unmount"
-	_scratch_unmount 2>/dev/null
+	cd /
 	rm -f $tmp.*
+	rm -fr $send_files_dir
 }
 trap "_cleanup; exit \$status" 0 1 2 3 15
 
@@ -38,7 +38,11 @@ _require_scratch
 _require_fssum
 _require_seek_data_hole
 
+send_files_dir=$TEST_DIR/btrfs-test-$seq
+
 rm -f $seqres.full
+rm -fr $send_files_dir
+mkdir $send_files_dir
 
 workout()
 {
@@ -57,19 +61,20 @@ workout()
 
 	_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/incr
 
-	echo "# $BTRFS_UTIL_PROG send $SCRATCH_MNT/base > $tmp/base.snap" \
+	echo "# $BTRFS_UTIL_PROG send $SCRATCH_MNT/base > ${send_files_dir}/base.snap" \
 		>> $seqres.full
-	$BTRFS_UTIL_PROG send $SCRATCH_MNT/base > $tmp/base.snap 2>> $seqres.full \
+	$BTRFS_UTIL_PROG send $SCRATCH_MNT/base > $send_files_dir/base.snap 2>> $seqres.full \
 		|| _fail "failed: '$@'"
 	echo "# $BTRFS_UTIL_PROG send -p $SCRATCH_MNT/base\
-		$SCRATCH_MNT/incr > $tmp/incr.snap" >> $seqres.full
+		$SCRATCH_MNT/incr > ${send_files_dir}/incr.snap" >> $seqres.full
 	$BTRFS_UTIL_PROG send -p $SCRATCH_MNT/base \
-		$SCRATCH_MNT/incr > $tmp/incr.snap 2>> $seqres.full \
+		$SCRATCH_MNT/incr > $send_files_dir/incr.snap 2>> $seqres.full \
 		|| _fail "failed: '$@'"
 
-	run_check $FSSUM_PROG -A -f -w $tmp/base.fssum $SCRATCH_MNT/base
-	run_check $FSSUM_PROG -A -f -w $tmp/incr.fssum -x $SCRATCH_MNT/incr/base \
-		$SCRATCH_MNT/incr
+	run_check $FSSUM_PROG -A -f -w $send_files_dir/base.fssum \
+		$SCRATCH_MNT/base
+	run_check $FSSUM_PROG -A -f -w $send_files_dir/incr.fssum \
+		-x $SCRATCH_MNT/incr/base $SCRATCH_MNT/incr
 
 	_scratch_unmount >/dev/null 2>&1
 	echo "*** mkfs -dsize=$fsz"    >>$seqres.full
@@ -78,11 +83,11 @@ workout()
 		|| _fail "size=$fsz mkfs failed"
 	_scratch_mount "-o noatime"
 
-	_run_btrfs_util_prog receive $SCRATCH_MNT < $tmp/base.snap
-	run_check $FSSUM_PROG -r $tmp/base.fssum $SCRATCH_MNT/base
+	_run_btrfs_util_prog receive $SCRATCH_MNT < $send_files_dir/base.snap
+	run_check $FSSUM_PROG -r $send_files_dir/base.fssum $SCRATCH_MNT/base
 
-	_run_btrfs_util_prog receive $SCRATCH_MNT < $tmp/incr.snap
-	run_check $FSSUM_PROG -r $tmp/incr.fssum $SCRATCH_MNT/incr
+	_run_btrfs_util_prog receive $SCRATCH_MNT < $send_files_dir/incr.snap
+	run_check $FSSUM_PROG -r $send_files_dir/incr.fssum $SCRATCH_MNT/incr
 }
 
 echo "*** test send / receive"
diff --git a/tests/btrfs/007.out b/tests/btrfs/007.out
index 8f8cec7d..5d029ceb 100644
--- a/tests/btrfs/007.out
+++ b/tests/btrfs/007.out
@@ -1,4 +1,3 @@
 QA output created by 007
 *** test send / receive
 *** done
-*** unmount
-- 
2.11.0

