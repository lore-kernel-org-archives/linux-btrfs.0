Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:48948 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751835AbeBFHb5 (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 6 Feb 2018 02:31:57 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH] btrfs-progs: fsck-tests: Cleanup the restored image for 028
Date: Tue,  6 Feb 2018 15:31:42 +0800
Message-Id: <20180206073142.3221-1-wqu@suse.com>
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

