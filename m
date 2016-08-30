Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:3446 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754185AbcH3CQA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Aug 2016 22:16:00 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Lukas Lueg <lukas.lueg@gmail.com>
Subject: [PATCH] btrfs-progs: fuzz-test: Add image for wrong chunk item in root tree
Date: Tue, 30 Aug 2016 10:15:50 +0800
Message-ID: <20160830021550.11502-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Lukas Lueg <lukas.lueg@gmail.com>

Reported by Lukas and the same image from him.

DATA_RELOC tree's key type is modifed to CHUNK_ITEM, causing btrfsck
interpret it as CHUNK_ITEM and cause 0 num_stripes.

Add the image to fuzz-test.

Signed-off-by: Lukas Lueg <lukas.lueg@gmail.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 .../images/wrong-chunk-item-in-root-tree.raw.txt   |  35 +++++++++++++++++++++
 .../images/wrong-chunk-item-in-root-tree.raw.xz    | Bin 0 -> 3696 bytes
 2 files changed, 35 insertions(+)
 create mode 100644 tests/fuzz-tests/images/wrong-chunk-item-in-root-tree.raw.txt
 create mode 100644 tests/fuzz-tests/images/wrong-chunk-item-in-root-tree.raw.xz

diff --git a/tests/fuzz-tests/images/wrong-chunk-item-in-root-tree.raw.txt b/tests/fuzz-tests/images/wrong-chunk-item-in-root-tree.raw.txt
new file mode 100644
index 0000000..9097e49
--- /dev/null
+++ b/tests/fuzz-tests/images/wrong-chunk-item-in-root-tree.raw.txt
@@ -0,0 +1,35 @@
+URL: https://bugzilla.kernel.org/show_bug.cgi?id=155201
+Lukas Lueg 2016-08-28 19:15:53 UTC 
+
+Created attachment 230921 [details]
+Image causing SIGFPE in btrfsck
+
+News from the fuzzer. See the attached image to reproduce using btrfs-progs
+v4.7-42-g56e9586.
+
+
+[Thread debugging using libthread_db enabled]
+Using host libthread_db library "/lib64/libthread_db.so.1".
+checking extents
+Chunk[0, 4194304] existed.
+Chunk[18446744073709551607, 228, 0]: length(1), offset(0), type(4160) mismatch
+with block group[0, 192, 4194304]: offset(4194304), objectid(0), flags(2)
+
+Program received signal SIGFPE, Arithmetic exception.
+0x000000000042b178 in calc_stripe_length (type=4160, length=1, num_stripes=0)
+at cmds-check.c:8018
+8018			stripe_size /= num_stripes;
+#0  0x000000000042b178 in calc_stripe_length (type=4160, length=1,
+num_stripes=0) at cmds-check.c:8018
+#1  0x000000000042b56d in check_chunk_refs (silent=0,
+dev_extent_cache=0x7fffffffdd30, block_group_cache=0x7fffffffdd60,
+chunk_rec=0x6b92c0) at cmds-check.c:8101
+#2  check_chunks (chunk_cache=chunk_cache@entry=0x7fffffffdd80,
+block_group_cache=block_group_cache@entry=0x7fffffffdd60,
+dev_extent_cache=dev_extent_cache@entry=0x7fffffffdd30, good=good@entry=0x0,
+bad=bad@entry=0x0, rebuild=rebuild@entry=0x0, silent=0) at cmds-check.c:8165
+#3  0x000000000042bbdd in check_chunks_and_extents (root=root@entry=0x6b2cf0)
+at cmds-check.c:8524
+#4  0x000000000042e3cb in cmd_check (argc=<optimized out>, argv=<optimized
+out>) at cmds-check.c:11430
+#5  0x000000000040a416 in main (argc=2, argv=0x7fffffffe218) at btrfs.c:243
diff --git a/tests/fuzz-tests/images/wrong-chunk-item-in-root-tree.raw.xz b/tests/fuzz-tests/images/wrong-chunk-item-in-root-tree.raw.xz
new file mode 100644
index 0000000000000000000000000000000000000000..5bc2d3b9741f79e097303f04db138fd4187c776d
GIT binary patch
literal 3696
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
P`*ZpJ^;ZG{IQQQHY9%Vq

literal 0
HcmV?d00001

-- 
2.9.3



