Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:45125 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbcFABvc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 May 2016 21:51:32 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: convert-tests: Add test for backup superblock migration
Date: Wed,  1 Jun 2016 09:51:21 +0800
Message-Id: <20160601015121.23944-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

New convert framework uses new and simpler chunk layout, while the cost
is the more complex superblock range migration logical, compared to old
convert.

Enhance the convert test script to create file which will takes up 2nd
backup superblock space, to ensure the superblock migration is working
as expected.

Suggested-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/convert-tests.sh | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tests/convert-tests.sh b/tests/convert-tests.sh
index 06d8419..d4e13d6 100755
--- a/tests/convert-tests.sh
+++ b/tests/convert-tests.sh
@@ -124,6 +124,12 @@ convert_test() {
 	# create a file to check btrfs-convert can convert regular file
 	# correct
 	run_check_mount_test_dev
+
+	# create a file inside the fs before convert, to make sure there is
+	# data covering btrfs backup superblock range (64M)
+	run_check $SUDO_HELPER dd if=/dev/zero bs=1M count=64 \
+		of=$TEST_MNT/convert_space_holder
+
 	populate_fs
 	run_check $SUDO_HELPER dd if=/dev/zero of=$TEST_MNT/test bs=$nodesize \
 		count=1 >/dev/null 2>&1
-- 
2.8.3



