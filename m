Return-Path: <SRS0=Q7pU=SY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28D7DC10F11
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Apr 2019 15:44:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3FFF20881
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Apr 2019 15:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555947864;
	bh=q2AE9esWA7Ruok01xecvfNGFyep3Z3DxaddSwvkwfhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ivAn0v5ilmFRp84bI6rY6AKSEWsT1cpizsJ+wbzpW5iOWQDTaf/cWQA5jlNz6JE/f
	 Oakn29Nnp53yeqaZPyHn4PxtmUOHCI2x/OomjD9b6NNNPskFdCGn5y2mKaVzLyOXlf
	 lAOXuUUY7xdsEBQnYLl66PNkkLETHw7f7WaeU3F0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727527AbfDVPoW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 22 Apr 2019 11:44:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:49230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726132AbfDVPoW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Apr 2019 11:44:22 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7550520674;
        Mon, 22 Apr 2019 15:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555947861;
        bh=q2AE9esWA7Ruok01xecvfNGFyep3Z3DxaddSwvkwfhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F4JgEkY5Xx56wJSk1qvO4CEzkvxdX8u0s4+ci4BE+tqEk27pAQ58q34EsYJu75Ooi
         EDbDOZMBkLfxnl9gEatXIpNVf9UlQXJe2zyletnjKG5RmhSLlhB4da6r5w+KrcAYnt
         KrXauC0syOYb3Kr0B8BZktV1FKLjz1LJIZ5craTc=
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v2] btrfs: stress send with deduplication and balance running in parallel
Date:   Mon, 22 Apr 2019 16:44:16 +0100
Message-Id: <20190422154416.17249-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190415083121.2338-1-fdmanana@kernel.org>
References: <20190415083121.2338-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Stress send running in parallel with balance and deduplication against
files that belong to the snapshots used by send. The goal is to verify
that these operations running in parallel do not lead to send crashing
(trigger assertion failures and BUG_ONs), or send finding an inconsistent
snapshot that leads to a failure (reported in dmesg/syslog). The test
needs big trees (snapshots) with large differences between the parent and
send snapshots in order to hit such issues with a good probability.

This currently fails on btrfs, hitting a BUG_ON() often, and with btrfs
error messages in dmesg/syslog. The problem has always existed and it is
not new, but probably unnoticed due to lack of test cases that exercise
these btrfs features running in parallel.

The following patches for btrfs fix the problems:

 "Btrfs: fix race between send and deduplication that lead to failures and
  crashes"

 "Btrfs: prevent send failures and crashes due to concurrent relocation"

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Updated test to stress send with balance as well, since it triggers the
    same problems as with concurrent deduplication and avoid writing a new
    test case that would be very similar.
    Renamed patch subject (was "btrfs: test send with deduplication running
    concurrently") to reflect that balance is tested as well.

 tests/btrfs/187     | 226 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/187.out |   3 +
 tests/btrfs/group   |   1 +
 3 files changed, 230 insertions(+)
 create mode 100755 tests/btrfs/187
 create mode 100644 tests/btrfs/187.out

diff --git a/tests/btrfs/187 b/tests/btrfs/187
new file mode 100755
index 00000000..0744797e
--- /dev/null
+++ b/tests/btrfs/187
@@ -0,0 +1,226 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019 SUSE Linux Products GmbH. All Rights Reserved.
+#
+# FSQA Test No. 187
+#
+# Stress send running in parallel with balance and deduplication against files
+# that belong to the snapshots used by send. The goal is to verify that these
+# operations running in parallel do not lead to send crashing (trigger assertion
+# failures and BUG_ONs), or send finding an inconsistent snapshot that leads to
+# a failure (reported in dmesg/syslog). The test needs big trees (snapshots)
+# with large differences between the parent and send snapshots in order to hit
+# such issues with a good probability.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/attr
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch_dedupe
+_require_attrs
+
+rm -f $seqres.full
+
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+
+dedupe_two_files()
+{
+	trap "wait; exit" SIGTERM
+
+	local f1=$(find $SCRATCH_MNT/snap1 -type f | shuf -n 1)
+	local f2=$(find $SCRATCH_MNT/snap2 -type f | shuf -n 1)
+
+	if (( RANDOM % 2 )); then
+		local tmp=$f1
+		f1=$f2
+		f2=$tmp
+	fi
+
+	# Ignore errors from dedupe. We just want to test for crashes and
+	# deadlocks.
+	$XFS_IO_PROG -r -c "dedupe $f1 0 0 64K" $f2 &> /dev/null
+}
+
+dedupe_files_loop()
+{
+	trap "wait; exit" SIGTERM
+
+	while true; do
+		for ((i = 1; i <= 5; i++)); do
+			dedupe_two_files &
+		done
+		wait
+	done
+}
+
+balance_loop()
+{
+	trap "wait; exit" SIGTERM
+
+	while true; do
+		# Balance only metadata block groups, since this is makes it
+		# easier to hit problems (crashes and errors) in send.
+		# Ignore errors from balance. We just want to test for crashes
+		# and deadlocks.
+		$BTRFS_UTIL_PROG balance start -f -m $SCRATCH_MNT &> /dev/null
+		sleep $((RANDOM % 3))
+	done
+}
+
+full_send_loop()
+{
+	trap "wait; exit" SIGTERM
+
+	local count=$1
+
+	for ((i = 1; i <= $count; i++)); do
+		# Ignore errors from send. We will check for errors later in
+		# dmesg/syslog.
+		$BTRFS_UTIL_PROG send -f /dev/null \
+			$SCRATCH_MNT/snap1 &> /dev/null
+		sleep $((RANDOM % 3))
+	done
+}
+
+inc_send_loop()
+{
+	trap "wait; exit" SIGTERM
+
+	local count=$1
+
+	for ((i = 1; i <= $count; i++)); do
+		# Ignore errors from send. We will check for errors later in
+		# dmesg/syslog.
+		$BTRFS_UTIL_PROG send -f /dev/null \
+			-p $SCRATCH_MNT/snap1 $SCRATCH_MNT/snap2 &> /dev/null
+		sleep $((RANDOM % 3))
+	done
+}
+
+write_files_loop()
+{
+	local count=$1
+	local offset=$2
+
+	for ((i = 1; i <= $count; i++)); do
+		$XFS_IO_PROG -f -c "pwrite -S 0xea 0 64K" \
+			$SCRATCH_MNT/file_$((i + offset)) >/dev/null
+	done
+}
+
+set_xattrs_loop()
+{
+	local count=$1
+	local offset=$2
+
+	for ((i = 1; i <= $count; i++)); do
+		$SETFATTR_PROG -n 'user.x1' -v $xattr_value \
+			$SCRATCH_MNT/file_$((i + offset))
+	done
+}
+
+# Number of files created before first snapshot. Must be divisable by 4.
+nr_initial_files=40000
+# Number of files created after the first snapshot. Must be divisable by 4.
+nr_more_files=40000
+
+# Create initial files.
+step=$((nr_initial_files / 4))
+for ((n = 0; n < 4; n++)); do
+	offset=$((step * $n))
+	write_files_loop $step $offset &
+	create_pids[$n]=$!
+done
+wait ${create_pids[@]}
+
+$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/snap1 \
+	| _filter_scratch
+
+# Add some more files, so that that are substantial differences between the
+# two test snapshots used for an incremental send later.
+
+# Create more files.
+step=$((nr_more_files / 4))
+for ((n = 0; n < 4; n++)); do
+	offset=$((nr_initial_files + step * $n))
+	write_files_loop $step $offset &
+	create_pids[$n]=$!
+done
+wait ${create_pids[@]}
+
+# Add some xattrs to all files, so that every leaf and node of the fs tree is
+# COWed. Adding more files does only adds leafs and nodes to the tree's right
+# side, since inode numbers are based on a counter and form the first part
+# (objectid) of btree keys (we only modifying the right most leaf of the tree).
+# Use large values for the xattrs to quickly increase the height of the tree.
+xattr_value=$(printf '%0.sX' $(seq 1 3800))
+
+# Split the work into 4 workers working on consecutive ranges to avoid contention
+# on the same leafs as much as possible.
+step=$(((nr_more_files + nr_initial_files) / 4))
+for ((n = 0; n < 4; n++)); do
+	offset=$((step * $n))
+	set_xattrs_loop $step $offset &
+	setxattr_pids[$n]=$!
+done
+wait ${setxattr_pids[@]}
+
+$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/snap2 \
+	| _filter_scratch
+
+full_send_loop 5 &
+full_send_pid=$!
+
+inc_send_loop 10 &
+inc_send_pid=$!
+
+dedupe_files_loop &
+dedupe_pid=$!
+
+balance_loop &
+balance_pid=$!
+
+wait $full_send_pid
+wait $inc_send_pid
+
+kill $dedupe_pid
+wait $dedupe_pid
+
+kill $balance_pid
+wait $balance_pid
+
+# Check for errors messages that happen due to inconsistent snapshot caused by
+# deduplication and balance running in parallel with send, causing btree nodes
+# and leafs to disappear and getting reused while send is using them.
+#
+# Example messages:
+#
+# BTRFS error (device sdc): did not find backref in send_root. inode=63292, \
+#     offset=0, disk_byte=5228134400 found extent=5228134400
+#
+# BTRFS error (device sdc): parent transid verify failed on 32243712 wanted 24 \
+#     found 27
+#
+_dmesg_since_test_start | egrep -e '\bBTRFS error \(device .*?\):'
+
+status=0
+exit
diff --git a/tests/btrfs/187.out b/tests/btrfs/187.out
new file mode 100644
index 00000000..ab522cfe
--- /dev/null
+++ b/tests/btrfs/187.out
@@ -0,0 +1,3 @@
+QA output created by 187
+Create a readonly snapshot of 'SCRATCH_MNT' in 'SCRATCH_MNT/snap1'
+Create a readonly snapshot of 'SCRATCH_MNT' in 'SCRATCH_MNT/snap2'
diff --git a/tests/btrfs/group b/tests/btrfs/group
index b6bd1a7d..44ee0dd9 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -189,3 +189,4 @@
 184 auto quick volume
 185 volume
 186 auto quick send volume
+187 auto send dedupe clone balance
-- 
2.11.0

