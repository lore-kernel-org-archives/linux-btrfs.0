Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:29702 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751036AbcKIEoh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Nov 2016 23:44:37 -0500
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 8CD70AC0187
        for <linux-btrfs@vger.kernel.org>; Wed,  9 Nov 2016 13:44:31 +0900 (JST)
Message-Id: <201611090444.AA00014@WIN-5MHF4RKU941.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Wed, 09 Nov 2016 13:44:15 +0900
To: dsterba@suse.cz, quwenruo@cn.fujitsu.com
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH v3] btrfs-progs: send-test: add checking of clone-src option
In-Reply-To: <201611040835.AA00012@WIN-5MHF4RKU941.jp.fujitsu.com>
References: <201611040835.AA00012@WIN-5MHF4RKU941.jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sending stream size of clone-src(-c) option is checked.
Fixed by "btrfs-progs: send: fix handling of -c option".

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
V2: old sending stream image is used
V3: image file has been compressed by gzip
---
 .../016-send-clone-src/send-stream-v4.8.2.img.gz   | Bin 0 -> 11826 bytes
 tests/misc-tests/016-send-clone-src/test.sh        |  50 +++++++++++++++++++++
 2 files changed, 50 insertions(+)
 create mode 100644 tests/misc-tests/016-send-clone-src/send-stream-v4.8.2.img.gz
 create mode 100755 tests/misc-tests/016-send-clone-src/test.sh

diff --git a/tests/misc-tests/016-send-clone-src/send-stream-v4.8.2.img.gz b/tests/misc-tests/016-send-clone-src/send-stream-v4.8.2.img.gz
new file mode 100644
index 0000000000000000000000000000000000000000..f49c5cba1a8307f99732530ab8613f4a22902b9d
GIT binary patch
literal 11826
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

literal 0
HcmV?d00001

diff --git a/tests/misc-tests/016-send-clone-src/test.sh b/tests/misc-tests/016-send-clone-src/test.sh
new file mode 100755
index 0000000..3a61db7
--- /dev/null
+++ b/tests/misc-tests/016-send-clone-src/test.sh
@@ -0,0 +1,50 @@
+#!/bin/bash
+#
+# test for sending stream size of clone-src option
+
+source $TOP/tests/common
+
+check_prereq mkfs.btrfs
+check_prereq btrfs
+
+setup_root_helper
+prepare_test_dev 1g
+
+run_check $TOP/mkfs.btrfs -f $IMAGE
+run_check_mount_test_dev
+
+here=`pwd`
+cd "$TEST_MNT" || _fail "cannot chdir to TEST_MNT"
+
+run_check $SUDO_HELPER $TOP/btrfs subvolume create subv-parent1
+for i in 1 2 3; do
+	run_check $SUDO_HELPER dd if=/dev/zero of=subv-parent1/file1_$i bs=1M count=1
+	run_check $SUDO_HELPER $TOP/btrfs subvolume snapshot -r subv-parent1 subv-snap1_$i
+done
+
+run_check $SUDO_HELPER $TOP/btrfs subvolume create subv-parent2
+for i in 1 2 3; do
+	run_check $SUDO_HELPER dd if=/dev/zero of=subv-parent2/file2_$i bs=1M count=1
+	run_check $SUDO_HELPER $TOP/btrfs subvolume snapshot -r subv-parent2 subv-snap2_$i
+done
+
+truncate -s0 "$here"/send-stream.img
+chmod a+w "$here"/send-stream.img
+run_check $SUDO_HELPER $TOP/btrfs send -f "$here"/send-stream.img \
+	-c subv-snap1_1 -c subv-snap2_1 subv-snap1_[23] subv-snap2_[23]
+
+gunzip -c "$here"/send-stream-v4.8.2.img.gz > "$here"/old-send-stream.img
+old_stream_size=`stat --format=%s "$here"/old-send-stream.img`
+stream_size=`stat --format=%s "$here"/send-stream.img`
+
+if [ $old_stream_size -lt $stream_size ]; then
+	run_check ls -l "$here"/old-send-stream.img "$here"/send-stream.img
+	_fail "sending stream size is bigger than old stream"
+fi
+
+run_check rm -f "$here"/old-send-stream.img "$here"/send-stream.img
+
+cd "$here" || _fail "cannot chdir back to test directory"
+
+run_check_umount_test_dev
+
-- 
2.9.3
