Return-Path: <SRS0=EUcM=33=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E58AEC35247
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Feb 2020 02:00:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5D8B20715
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Feb 2020 02:00:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727631AbgBGCAA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 6 Feb 2020 21:00:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:35110 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727600AbgBGB76 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Feb 2020 20:59:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 42270AC79;
        Fri,  7 Feb 2020 01:59:56 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] fstests: btrfs/022: Add debug output
Date:   Fri,  7 Feb 2020 09:59:42 +0800
Message-Id: <20200207015942.9079-4-wqu@suse.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200207015942.9079-1-wqu@suse.com>
References: <20200207015942.9079-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

When btrfs/022 fails, its $seqres.full doesn't contain much useful info
to debug.

This patch will add extra debug, including subvolid and full "btrfs
qgroup show" output.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/btrfs/022 | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/tests/btrfs/022 b/tests/btrfs/022
index 3e729852..aaa27aaa 100755
--- a/tests/btrfs/022
+++ b/tests/btrfs/022
@@ -35,6 +35,7 @@ rm -f $seqres.full
 # Test to make sure we can actually turn it on and it makes sense
 _basic_test()
 {
+	echo "=== basic test ===" >> $seqres.full
 	_run_btrfs_util_prog subvolume create $SCRATCH_MNT/a
 	_run_btrfs_util_prog quota enable $SCRATCH_MNT/a
 	_run_btrfs_util_prog quota rescan -w $SCRATCH_MNT
@@ -51,9 +52,12 @@ _basic_test()
 	# match
 	a_shared=$($BTRFS_UTIL_PROG qgroup show $units $SCRATCH_MNT | grep "0/$subvolid")
 	a_shared=$(echo $a_shared | awk '{ print $2 }')
+	echo "subvol a id=$subvolid" >> $seqres.full
 	subvolid=$(_btrfs_get_subvolid $SCRATCH_MNT b)
+	echo "subvol b id=$subvolid" >> $seqres.full
 	b_shared=$($BTRFS_UTIL_PROG qgroup show $units $SCRATCH_MNT | grep "0/$subvolid")
 	b_shared=$(echo $b_shared | awk '{ print $2 }')
+	$BTRFS_UTIL_PROG qgroup show $units $SCRATCH_MNT >> $seqres.full
 	[ $b_shared -eq $a_shared ] || _fail "shared values don't match"
 }
 
@@ -61,6 +65,7 @@ _basic_test()
 #come up with the same answer
 _rescan_test()
 {
+	echo "=== rescan test ===" >> $seqres.full
 	# first with a blank subvol
 	_run_btrfs_util_prog subvolume create $SCRATCH_MNT/a
 	_run_btrfs_util_prog quota enable $SCRATCH_MNT/a
@@ -69,12 +74,12 @@ _rescan_test()
 		$FSSTRESS_AVOID
 	sync
 	output=$($BTRFS_UTIL_PROG qgroup show $units $SCRATCH_MNT | grep "0/$subvolid")
-	echo $output >> $seqres.full
+	echo "qgroup values before rescan: $output" >> $seqres.full
 	refer=$(echo $output | awk '{ print $2 }')
 	excl=$(echo $output | awk '{ print $3 }')
 	_run_btrfs_util_prog quota rescan -w $SCRATCH_MNT
 	output=$($BTRFS_UTIL_PROG qgroup show $units $SCRATCH_MNT | grep "0/$subvolid")
-	echo $output >> $seqres.full
+	echo "qgroup values after rescan: $output" >> $seqres.full
 	[ $refer -eq $(echo $output | awk '{ print $2 }') ] || \
 		_fail "reference values don't match after rescan"
 	[ $excl -eq $(echo $output | awk '{ print $3 }') ] || \
@@ -84,6 +89,7 @@ _rescan_test()
 #basic exceed limit testing
 _limit_test_exceed()
 {
+	echo "=== limit exceed test ===" >> $seqres.full
 	_run_btrfs_util_prog subvolume create $SCRATCH_MNT/a
 	_run_btrfs_util_prog quota enable $SCRATCH_MNT
 	subvolid=$(_btrfs_get_subvolid $SCRATCH_MNT a)
@@ -95,6 +101,7 @@ _limit_test_exceed()
 #basic noexceed limit testing
 _limit_test_noexceed()
 {
+	echo "=== limit not exceed test ===" >> $seqres.full
 	_run_btrfs_util_prog subvolume create $SCRATCH_MNT/a
 	_run_btrfs_util_prog quota enable $SCRATCH_MNT
 	subvolid=$(_btrfs_get_subvolid $SCRATCH_MNT a)
-- 
2.23.0

