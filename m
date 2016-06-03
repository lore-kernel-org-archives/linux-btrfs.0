Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:51467 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750908AbcFCCem (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Jun 2016 22:34:42 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/2] btrfs-progs: convert-tests: Add test case for backup superblock migration
Date: Fri,  3 Jun 2016 10:34:26 +0800
Message-Id: <20160603023426.25216-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160603023426.25216-1-quwenruo@cn.fujitsu.com>
References: <20160603023426.25216-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

New convert introduced simpler chunk/extent allocation algorithm, at the
cost of complex backup superblock migration codes.

Use specially built ext2 images to test if btrfs-convert can convert and
rollback images without problem.

All these special ext2 image have blocks/holes across 2nd btrfs backup
superblock.

The naming of test image is like the following:
	|<------superblock migration range----->|
	64M					64M + 64K
|-Data--|-Data--|/Hole//|-Data--|/Hole//|-Data--|--Data--| = drdhdhdrd

These test cases should check all typical layouts and make sure new
convert works.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  Split infrastructure with test case
---
 .../drdhdhdrd.e2image.raw.xz                       | Bin 0 -> 84564 bytes
 .../drdhdhrh.e2image.raw.xz                        | Bin 0 -> 84568 bytes
 .../hrhdhdrd.e2image.raw.xz                        | Bin 0 -> 84556 bytes
 .../hrhdhrh.e2image.raw.xz                         | Bin 0 -> 84568 bytes
 .../001-ext2-backup-superblock-ranges/test.sh      |  37 +++++++++++++++++++++
 5 files changed, 37 insertions(+)
 create mode 100644 tests/convert-tests/001-ext2-backup-superblock-ranges/drdhdhdrd.e2image.raw.xz
 create mode 100644 tests/convert-tests/001-ext2-backup-superblock-ranges/drdhdhrh.e2image.raw.xz
 create mode 100644 tests/convert-tests/001-ext2-backup-superblock-ranges/hrhdhdrd.e2image.raw.xz
 create mode 100644 tests/convert-tests/001-ext2-backup-superblock-ranges/hrhdhrh.e2image.raw.xz
 create mode 100755 tests/convert-tests/001-ext2-backup-superblock-ranges/test.sh

diff --git a/tests/convert-tests/001-ext2-backup-superblock-ranges/drdhdhdrd.e2image.raw.xz b/tests/convert-tests/001-ext2-backup-superblock-ranges/drdhdhdrd.e2image.raw.xz
new file mode 100644
index 0000000000000000000000000000000000000000..73e2309c4bd6991424962c3bc53ad74171b52268
GIT binary patch
literal 84564
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

literal 0
HcmV?d00001

diff --git a/tests/convert-tests/001-ext2-backup-superblock-ranges/drdhdhrh.e2image.raw.xz b/tests/convert-tests/001-ext2-backup-superblock-ranges/drdhdhrh.e2image.raw.xz
new file mode 100644
index 0000000000000000000000000000000000000000..0d5442fffcd8106ed1fda52b317d0f4c3612fbe5
GIT binary patch
literal 84568
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
E1zNjcN&o-=

literal 0
HcmV?d00001

diff --git a/tests/convert-tests/001-ext2-backup-superblock-ranges/hrhdhdrd.e2image.raw.xz b/tests/convert-tests/001-ext2-backup-superblock-ranges/hrhdhdrd.e2image.raw.xz
new file mode 100644
index 0000000000000000000000000000000000000000..a1a304295f8c894a5db4b63dacbd3eb2fbc8420f
GIT binary patch
literal 84556
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
L?e`FPJ^lXx9Ozyg

literal 0
HcmV?d00001

diff --git a/tests/convert-tests/001-ext2-backup-superblock-ranges/hrhdhrh.e2image.raw.xz b/tests/convert-tests/001-ext2-backup-superblock-ranges/hrhdhrh.e2image.raw.xz
new file mode 100644
index 0000000000000000000000000000000000000000..ac0dbc60ee6b0f8c374066c822b65d827c4a4da6
GIT binary patch
literal 84568
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
G{l5S!=1U#`

literal 0
HcmV?d00001

diff --git a/tests/convert-tests/001-ext2-backup-superblock-ranges/test.sh b/tests/convert-tests/001-ext2-backup-superblock-ranges/test.sh
new file mode 100755
index 0000000..5d1bce3
--- /dev/null
+++ b/tests/convert-tests/001-ext2-backup-superblock-ranges/test.sh
@@ -0,0 +1,37 @@
+#!/bin/bash
+
+# Specially created e2image dump to test backup superblock migration for
+# new convert.
+# These images will cause the following problems if convert doesn't handle
+# backup superblock migration well:
+# 1) Assert while building free space tree
+# 2) Error copying inodes
+# 3) Discontinuous file extents after convert
+# 4) Overlap file extents
+# 5) Unable to rollback
+
+source $TOP/tests/common
+
+check_prereq btrfs-convert
+check_prereq btrfs
+check_prereq btrfs-show-super
+check_global_prereq e2fsck
+check_global_prereq xzcat
+
+prepare_test_dev 512M
+for src in $(find . -iname "*.e2image.raw.xz"); do
+	extracted=$(extract_image "$src")
+	run_check $SUDO_HELPER e2fsck -n -f $extracted
+	run_check $SUDO_HELPER $TOP/btrfs-convert $extracted
+	run_check $SUDO_HELPER $TOP/btrfs check $extracted
+	run_check $SUDO_HELPER $TOP/btrfs-show-super $extracted
+
+	run_check $SUDO_HELPER mount -o loop $extracted $TEST_MNT
+	run_check $SUDO_HELPER e2fsck -n -f $TEST_MNT/ext2_saved/image
+	run_check $SUDO_HELPER umount $TEST_MNT
+
+	run_check $SUDO_HELPER $TOP/btrfs check $extracted
+	run_check $SUDO_HELPER $TOP/btrfs-convert -r $extracted
+	run_check $SUDO_HELPER e2fsck -n -f $extracted
+	rm -f $extracted
+done
-- 
2.8.3



