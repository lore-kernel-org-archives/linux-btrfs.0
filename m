Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0EF8C433F5
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Feb 2022 10:06:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232686AbiBPKGZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 16 Feb 2022 05:06:25 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:40830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232662AbiBPKGY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Feb 2022 05:06:24 -0500
Received: from localhost (ip5886566d.dynamic.kabel-deutschland.de [88.134.86.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 27A932B73F8;
        Wed, 16 Feb 2022 02:05:55 -0800 (PST)
Received: by localhost (Postfix, from userid 0)
        id 17AA1AD3E; Wed, 16 Feb 2022 11:05:52 +0100 (CET)
From:   Gabriel Niebler <gniebler@suse.com>
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Gabriel Niebler <gniebler@suse.com>
Subject: [PATCH] fstests: fix btrfs/255 to fail on deadlock
Date:   Wed, 16 Feb 2022 11:05:35 +0100
Message-Id: <20220216100535.4231-1-gniebler@suse.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

In its current implementation, the test btrfs/255 would hang forever
on any kernel w/o patch "btrfs: fix deadlock between quota disable
and qgroup rescan worker", rather than failing, as it should.
Fix this by introducing generous timeouts.

Signed-off-by: Gabriel Niebler <gniebler@suse.com>
---
 tests/btrfs/255 | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/tests/btrfs/255 b/tests/btrfs/255
index 7e70944a..4c779458 100755
--- a/tests/btrfs/255
+++ b/tests/btrfs/255
@@ -14,6 +14,7 @@ _begin_fstest auto qgroup balance
 
 # real QA test starts here
 _supported_fs btrfs
+_require_command "$TIMEOUT_PROG" timeout
 _require_scratch
 
 _scratch_mkfs >> $seqres.full 2>&1
@@ -37,15 +38,23 @@ done
 _btrfs_stress_balance $SCRATCH_MNT >> $seqres.full &
 balance_pid=$!
 echo $balance_pid >> $seqres.full
+timeout=$((30 * 60))
 for ((i = 0; i < 20; i++)); do
-	$BTRFS_UTIL_PROG quota enable $SCRATCH_MNT
-	$BTRFS_UTIL_PROG quota disable $SCRATCH_MNT
+	$TIMEOUT_PROG -s KILL ${timeout}s $BTRFS_UTIL_PROG quota enable $SCRATCH_MNT
+	[ $? -eq 0 ] || _fail "quota enable timed out"
+	$TIMEOUT_PROG -s KILL ${timeout}s $BTRFS_UTIL_PROG quota disable $SCRATCH_MNT
+	[ $? -eq 0 ] || _fail "quota disable timed out"
 done
 kill $balance_pid &> /dev/null
-wait
+
 # wait for the balance operation to finish
+elapsed=0
 while ps aux | grep "balance start" | grep -qv grep; do
+	if [ $elapsed -gt $timeout ]; then
+		_fail "balance not finished after $timeout seconds"
+	fi
 	sleep 1
+	elapsed=$(( ++elapsed ))
 done
 
 echo "Silence is golden"
-- 
2.35.1

