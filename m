Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53744 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726951AbeHGKdN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Aug 2018 06:33:13 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5B871ADB4
        for <linux-btrfs@vger.kernel.org>; Tue,  7 Aug 2018 08:20:00 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 10/11] btrfs-progs: test/mkfs: Add test case for -Q|--quota option
Date: Tue,  7 Aug 2018 16:19:37 +0800
Message-Id: <20180807081938.21348-11-wqu@suse.com>
In-Reply-To: <20180807081938.21348-1-wqu@suse.com>
References: <20180807081938.21348-1-wqu@suse.com>
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
index 6e295274119d..9ce9f7f0b3c2 100755
--- a/tests/mkfs-tests/001-basic-profiles/test.sh
+++ b/tests/mkfs-tests/001-basic-profiles/test.sh
@@ -47,6 +47,16 @@ test_mkfs_single  -d  dup     -m  single
 test_mkfs_single  -d  dup     -m  dup
 test_mkfs_single  -d  dup     -m  dup     --mixed
 
+test_mkfs_single -Q
+test_mkfs_single -Q -d  single  -m  single
+test_mkfs_single -Q -d  single  -m  single  --mixed
+test_mkfs_single -Q -d  single  -m  dup
+test_mkfs_single -Q -d  dup     -m  single
+test_mkfs_single -Q -d  dup     -m  dup
+test_mkfs_single -Q -d  dup     -m  dup     --mixed
+
+# Profile doesn't really affect quota, skip them to save some time
+
 test_mkfs_multi
 test_mkfs_multi   -d  single  -m  single
 test_mkfs_multi   -d  single  -m  single  --mixed
-- 
2.18.0

