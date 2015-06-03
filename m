Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:63401 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752302AbbFCHPv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jun 2015 03:15:51 -0400
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <fstests@vger.kernel.org>, <linux-btrfs@vger.kernel.org>,
        <fdmanana@gmail.com>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH] xfstests: btrfs: 022: add a quota rescan -w to wait rescan finished.
Date: Wed, 3 Jun 2015 15:10:55 +0800
Message-ID: <1433315455-814-1-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <CAL3q7H7yZyUXAsK41e1ZAwVsV3WB8_XNJR_sQ4p8UZLfEM5hDA@mail.gmail.com>
References: <CAL3q7H7yZyUXAsK41e1ZAwVsV3WB8_XNJR_sQ4p8UZLfEM5hDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we enable quota, btrfs will rescan quota numbers. We need
to wait the rescan finished before any more operations on btrfs
qgroups. Otherwith, the new btrfs-progs would WARN out:

WARNING: Rescan is running, qgroup data may be incorrect.

It would make btrfs/022 failed.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 tests/btrfs/022 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/btrfs/022 b/tests/btrfs/022
index 5c1a82d..56d4f3d 100755
--- a/tests/btrfs/022
+++ b/tests/btrfs/022
@@ -51,6 +51,7 @@ _basic_test()
 {
 	_run_btrfs_util_prog subvolume create $SCRATCH_MNT/a
 	_run_btrfs_util_prog quota enable $SCRATCH_MNT/a
+	_run_btrfs_util_prog quota rescan -w $SCRATCH_MNT
 	subvolid=$(_btrfs_get_subvolid $SCRATCH_MNT a)
 	$BTRFS_UTIL_PROG qgroup show $units $SCRATCH_MNT | grep $subvolid >> \
 		$seqres.full 2>&1
-- 
1.8.4.2

