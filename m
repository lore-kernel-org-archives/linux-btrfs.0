Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:38690 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755920AbbKRQII (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Nov 2015 11:08:08 -0500
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] fstests: fix btrfs/091 failure due to not found _require_cp_reflink
Date: Wed, 18 Nov 2015 16:07:56 +0000
Message-Id: <1447862876-18701-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Commit 20d7bfad2d38 ("reflink: add test support routines to a separate
file") moved the function _require_cp_reflink to the new file
common/reflink but forgot to make btrfs/091 source that file, leading
to the following failure:

$ ./check btrfs/091
FSTYP         -- btrfs
PLATFORM      -- Linux/x86_64 debian3 4.3.0-rc5-btrfs-next-17+
MKFS_OPTIONS  -- /dev/sdc
MOUNT_OPTIONS -- /dev/sdc /home/fdmanana/btrfs-tests/scratch_1

btrfs/091 1s ... - output mismatch (see .../results//btrfs/091.out.bad)
    --- tests/btrfs/091.out	2015-05-03 01:19:42.128976975 +0100
    +++ .../results/btrfs/091.out.bad	2015-11-18 15:56:35.332745132 +0000
    @@ -1,4 +1,5 @@
     QA output created by 091
    +./tests/btrfs/091: line 49: _require_cp_reflink: command not found
     wrote 262144/262144 bytes at offset 0
     XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
     65536 65536
    ...
    (Run 'diff -u tests/btrfs/091.out .../results/btrfs/091.out.bad'  \
        to see the entire diff)

So just make btrfs/091 source common/reflink in order to know the
definition of _require_cp_reflink.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/091 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/btrfs/091 b/tests/btrfs/091
index dfbba81..feac551 100755
--- a/tests/btrfs/091
+++ b/tests/btrfs/091
@@ -39,6 +39,7 @@ _cleanup()
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
+. ./common/reflink
 
 # real QA test starts here
 
-- 
2.1.3

