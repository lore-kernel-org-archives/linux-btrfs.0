Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:14267 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1752030AbcLOJId (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Dec 2016 04:08:33 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Cc: t-itoh@jp.fujitsu.com
Subject: [PATCH v2 3/3] btrfs-progs: convert-test: trigger chunk allocation after convert
Date: Thu, 15 Dec 2016 17:03:31 +0800
Message-Id: <20161215090331.27486-4-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161215090331.27486-1-quwenruo@cn.fujitsu.com>
References: <20161215090331.27486-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Populate fs after convert so we can trigger data chunk allocation.
This can expose too restrict old rollback condition

Reported-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/common         | 4 ++++
 tests/common.convert | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/tests/common b/tests/common
index 571118a..4a1330f 100644
--- a/tests/common
+++ b/tests/common
@@ -486,6 +486,10 @@ generate_dataset() {
 				run_check $SUDO_HELPER ln -s "$dirpath/$long_filename" "$dirpath/slow_slink.$num"
 			done
 			;;
+		large)
+			run_check $SUDO_HELPER dd if=/dev/urandom bs=32M count=1 \
+			of="$dirpath/$dataset_type" bs=32M >/dev/null 2>&1
+			;;
 	esac
 }
 
diff --git a/tests/common.convert b/tests/common.convert
index a2d3152..8c9242e 100644
--- a/tests/common.convert
+++ b/tests/common.convert
@@ -160,6 +160,9 @@ convert_test_post_checks_all() {
 	convert_test_post_check_checksums "$1"
 	convert_test_post_check_permissions "$2"
 	convert_test_post_check_acl "$3"
+
+	# Create a large file to trigger data chunk allocation
+	generate_dataset "large"
 	run_check_umount_test_dev
 }
 
-- 
2.10.2



