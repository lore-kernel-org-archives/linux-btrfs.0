Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42667 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754211AbeEHGcQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 May 2018 02:32:16 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 75CA5AF68
        for <linux-btrfs@vger.kernel.org>; Tue,  8 May 2018 06:32:15 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RESEND 11/12] btrfs-progs: test/mkfs: Add test case for -R quota option
Date: Tue,  8 May 2018 14:31:55 +0800
Message-Id: <20180508063156.24665-12-wqu@suse.com>
In-Reply-To: <20180508063156.24665-1-wqu@suse.com>
References: <20180508063156.24665-1-wqu@suse.com>
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
index 6e295274119d..cb2cd472eba7 100755
--- a/tests/mkfs-tests/001-basic-profiles/test.sh
+++ b/tests/mkfs-tests/001-basic-profiles/test.sh
@@ -47,6 +47,16 @@ test_mkfs_single  -d  dup     -m  single
 test_mkfs_single  -d  dup     -m  dup
 test_mkfs_single  -d  dup     -m  dup     --mixed
 
+test_mkfs_single -R quota
+test_mkfs_single -R quota -d  single  -m  single
+test_mkfs_single -R quota -d  single  -m  single  --mixed
+test_mkfs_single -R quota -d  single  -m  dup
+test_mkfs_single -R quota -d  dup     -m  single
+test_mkfs_single -R quota -d  dup     -m  dup
+test_mkfs_single -R quota -d  dup     -m  dup     --mixed
+
+# Profile doesn't really affect quota, skip them to save some time
+
 test_mkfs_multi
 test_mkfs_multi   -d  single  -m  single
 test_mkfs_multi   -d  single  -m  single  --mixed
-- 
2.17.0

