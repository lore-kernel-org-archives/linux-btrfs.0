Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:45187 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752088AbdJ0H37 (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 27 Oct 2017 03:29:59 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 8/8] btrfs-progs: test/mkfs: Add test case for --enable-quota option
Date: Fri, 27 Oct 2017 15:29:36 +0800
Message-Id: <20171027072936.4697-9-wqu@suse.com>
In-Reply-To: <20171027072936.4697-1-wqu@suse.com>
References: <20171027072936.4697-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Only test if btrfs check (which will check qgroup by default) and kernel
mount success.

Comprehensive qgroup test cases still belongs to fstests.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/mkfs-tests/001-basic-profiles/test.sh | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tests/mkfs-tests/001-basic-profiles/test.sh b/tests/mkfs-tests/001-basic-profiles/test.sh
index 854ee0072170..a8ef01627b20 100755
--- a/tests/mkfs-tests/001-basic-profiles/test.sh
+++ b/tests/mkfs-tests/001-basic-profiles/test.sh
@@ -48,6 +48,16 @@ test_mkfs_single  -d  dup     -m  single
 test_mkfs_single  -d  dup     -m  dup
 test_mkfs_single  -d  dup     -m  dup     --mixed
 
+test_mkfs_single --enable-quota
+test_mkfs_single --enable-quota -d  single  -m  single
+test_mkfs_single --enable-quota -d  single  -m  single  --mixed
+test_mkfs_single --enable-quota -d  single  -m  dup
+test_mkfs_single --enable-quota -d  dup     -m  single
+test_mkfs_single --enable-quota -d  dup     -m  dup
+test_mkfs_single --enable-quota -d  dup     -m  dup     --mixed
+
+# Profile doesn't really affect quota, skip them to save some time
+
 test_mkfs_multi
 test_mkfs_multi   -d  single  -m  single
 test_mkfs_multi   -d  single  -m  single  --mixed
-- 
2.14.3

