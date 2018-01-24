Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:52268 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752043AbeAXCin (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 23 Jan 2018 21:38:43 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 2/2] btrfs-progs: test-mkfs: Output minimal device size
Date: Wed, 24 Jan 2018 10:38:30 +0800
Message-Id: <20180124023830.26184-2-wqu@suse.com>
In-Reply-To: <20180124023830.26184-1-wqu@suse.com>
References: <20180124023830.26184-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To make debugging a little easier.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/mkfs-tests/010-minimal-size/test.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/mkfs-tests/010-minimal-size/test.sh b/tests/mkfs-tests/010-minimal-size/test.sh
index f75a22d8ff8d..f33b8aa399f4 100755
--- a/tests/mkfs-tests/010-minimal-size/test.sh
+++ b/tests/mkfs-tests/010-minimal-size/test.sh
@@ -18,6 +18,7 @@ do_test()
 	good_size=$(echo "$output" | grep -oP "(?<=is )\d+")
 
 	prepare_test_dev "$good_size"
+	echo "Minimal device size is $good_size" >> "$RESULTS"
 	run_check $TOP/mkfs.btrfs -f $@ "$TEST_DEV"
 	run_check_mount_test_dev
 	run_check_umount_test_dev
-- 
2.15.1

