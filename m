Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:41348 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753117AbeBGJSE (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 7 Feb 2018 04:18:04 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Cc: ralphgauges@googlemail.com
Subject: [PATCH] btrfs-progs: fsck-tests: Cleanup the restored image for 028
Date: Wed,  7 Feb 2018 17:17:46 +0800
Message-Id: <20180207091746.10039-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/fsck-tests/028-unaligned-super-dev-sizes/test.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tests/fsck-tests/028-unaligned-super-dev-sizes/test.sh b/tests/fsck-tests/028-unaligned-super-dev-sizes/test.sh
index 3928f548c3f9..4bbcfbae662e 100755
--- a/tests/fsck-tests/028-unaligned-super-dev-sizes/test.sh
+++ b/tests/fsck-tests/028-unaligned-super-dev-sizes/test.sh
@@ -21,3 +21,5 @@ run_check "$TOP/btrfs" check "$TEST_DEV"
 # mount test
 run_check_mount_test_dev
 run_check_umount_test_dev "$TEST_MNT"
+# don't forget to clean it up
+rm "$TEST_DEV"
-- 
2.16.1

