Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:57662 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753163AbcH3HWb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Aug 2016 03:22:31 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Lukas Lueg <lukas.lueg@gmail.com>
Subject: [PATCH 2/5] btrfs-progs: fuzz-test: Add test case for invalid drop level
Date: Tue, 30 Aug 2016 15:22:14 +0800
Message-ID: <20160830072217.8599-3-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160830072217.8599-1-quwenruo@cn.fujitsu.com>
References: <20160830072217.8599-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Lukas Lueg <lukas.lueg@gmail.com>

Signed-off-by: Lukas Lueg <lukas.lueg@gmail.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/fuzz-tests/images/invalid-drop-level.raw.txt |  30 +++++++++++++++++++++
 tests/fuzz-tests/images/invalid-drop-level.raw.xz  | Bin 0 -> 3788 bytes
 2 files changed, 30 insertions(+)
 create mode 100644 tests/fuzz-tests/images/invalid-drop-level.raw.txt
 create mode 100644 tests/fuzz-tests/images/invalid-drop-level.raw.xz

diff --git a/tests/fuzz-tests/images/invalid-drop-level.raw.txt b/tests/fuzz-tests/images/invalid-drop-level.raw.txt
new file mode 100644
index 0000000..dab91dc
--- /dev/null
+++ b/tests/fuzz-tests/images/invalid-drop-level.raw.txt
@@ -0,0 +1,30 @@
+URL: https://bugzilla.kernel.org/show_bug.cgi?id=154021
+Lukas Lueg 2016-08-26 22:53:42 UTC
+
+Created attachment 230361 [details]
+Image triggering btrfsck to segv
+
+The fuzzer hit again:
+
+==32522==ERROR: AddressSanitizer: SEGV on unknown address 0x00027fff801c (pc
+0x0000004a952e bp 0x7fff5222ce70 sp 0x7fff5222c600 T0)
+    #0 0x4a952d in __asan_memcpy
+(/home/lukas/dev/btrfsfuzz/bin-asan/bin/btrfs+0x4a952d)
+    #1 0x66a323 in read_extent_buffer
+/home/lukas/dev/btrfsfuzz/src-asan/extent_io.c:867:2
+    #2 0x55ad25 in btrfs_node_key
+/home/lukas/dev/btrfsfuzz/src-asan/./ctree.h:1668:2
+    #3 0x58573b in check_fs_root
+/home/lukas/dev/btrfsfuzz/src-asan/cmds-check.c:3748:3
+    #4 0x544136 in check_fs_roots
+/home/lukas/dev/btrfsfuzz/src-asan/cmds-check.c:3896:10
+    #5 0x53d8c5 in cmd_check
+/home/lukas/dev/btrfsfuzz/src-asan/cmds-check.c:11470:8
+    #6 0x4f105f in main /home/lukas/dev/btrfsfuzz/src-asan/btrfs.c:243:8
+    #7 0x7fea1bcb7730 in __libc_start_main (/lib64/libc.so.6+0x20730)
+    #8 0x421238 in _start
+(/home/lukas/dev/btrfsfuzz/bin-asan/bin/btrfs+0x421238)
+
+
+See the attached image to reproduce using btrfs-progs btrfs-progs
+v4.7-42-g56e9586.
diff --git a/tests/fuzz-tests/images/invalid-drop-level.raw.xz b/tests/fuzz-tests/images/invalid-drop-level.raw.xz
new file mode 100644
index 0000000000000000000000000000000000000000..76c58dce433dc6939c35d25cd4c2f2165be3c94c
GIT binary patch
literal 3788
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

literal 0
HcmV?d00001

-- 
2.9.3



