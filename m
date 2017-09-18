Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:61117 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751906AbdIRHV6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Sep 2017 03:21:58 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v3 08/14] btrfs-progs: tests/common: Split user xattr into its own branch for generate_dataset
Date: Mon, 18 Sep 2017 16:21:33 +0900
Message-Id: <20170918072139.6300-9-quwenruo.btrfs@gmx.com>
In-Reply-To: <20170918072139.6300-1-quwenruo.btrfs@gmx.com>
References: <20170918072139.6300-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

generate_dataset() combines file acl and file xattr into "acls" type,
since both of them are implemented by using file xattr.

However sometimes we don't want user file attr under certain case, for
example to populate files on tmpfs, which doesn't support user file
xattr.

So this patch split original "acls" type into "user_xattr" and "acls",
make it easier for us to use it on tmpfs.

Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
 tests/common         | 6 +++++-
 tests/common.convert | 2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/tests/common b/tests/common
index 08a25918..9aebe3e7 100644
--- a/tests/common
+++ b/tests/common
@@ -498,10 +498,14 @@ generate_dataset() {
 			for num in $(seq 1 "$DATASET_SIZE"); do
 				run_check $SUDO_HELPER touch "$dirpath/$dataset_type.$num"
 				run_check $SUDO_HELPER setfacl -m "u:root:x" "$dirpath/$dataset_type.$num"
+			done
+			;;
+		user_xattr)
+			for num in $(seq 1 "$DATASET_SIZE"); do
+				run_check $SUDO_HELPER touch "$dirpath/$dataset_type.$num"
 				run_check $SUDO_HELPER setfattr -n user.foo -v "bar$num" "$dirpath/$dataset_type.$num"
 			done
 			;;
-
 		fifo)
 			for num in $(seq 1 "$DATASET_SIZE"); do
 				run_check $SUDO_HELPER mkfifo "$dirpath/$dataset_type.$num"
diff --git a/tests/common.convert b/tests/common.convert
index 1be804cf..45174b7e 100644
--- a/tests/common.convert
+++ b/tests/common.convert
@@ -36,7 +36,7 @@ run_check_mount_convert_dev()
 
 populate_fs() {
 
-        for dataset_type in 'small' 'hardlink' 'fast_symlink' 'brokenlink' 'perm' 'sparse' 'acls' 'fifo' 'slow_symlink'; do
+        for dataset_type in 'small' 'hardlink' 'fast_symlink' 'brokenlink' 'perm' 'sparse' 'acls' 'user_xattr' 'fifo' 'slow_symlink'; do
 		generate_dataset "$dataset_type"
 	done
 }
-- 
2.14.1

