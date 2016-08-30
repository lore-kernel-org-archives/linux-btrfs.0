Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46487 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756271AbcH3D3t (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Aug 2016 23:29:49 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Lukas Lueg <lukas.lueg@gmail.com>
Subject: [PATCH 2/2] btrfs-progs: fuzz-test: Add image for unaligned tree block ptr
Date: Tue, 30 Aug 2016 11:29:33 +0800
Message-ID: <20160830032933.22194-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160830032933.22194-1-quwenruo@cn.fujitsu.com>
References: <20160830032933.22194-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Lukas Lueg <lukas.lueg@gmail.com>

Add test case image for unaligned tree block ptr.
It should lead to BUG_ON in free_extent_buffer().

Signed-off-by: Lukas Lueg <lukas.lueg@gmail.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 .../images/unaligned-tree-block-bytenr.raw.txt     |  33 +++++++++++++++++++++
 .../images/unaligned-tree-block-bytenr.raw.xz      | Bin 0 -> 3852 bytes
 2 files changed, 33 insertions(+)
 create mode 100644 tests/fuzz-tests/images/unaligned-tree-block-bytenr.raw.txt
 create mode 100644 tests/fuzz-tests/images/unaligned-tree-block-bytenr.raw.xz

diff --git a/tests/fuzz-tests/images/unaligned-tree-block-bytenr.raw.txt b/tests/fuzz-tests/images/unaligned-tree-block-bytenr.raw.txt
new file mode 100644
index 0000000..05cf392
--- /dev/null
+++ b/tests/fuzz-tests/images/unaligned-tree-block-bytenr.raw.txt
@@ -0,0 +1,33 @@
+URL: https://bugzilla.kernel.org/show_bug.cgi?id=153641
+Lukas Lueg 2016-08-23 19:54:45 UTC
+
+Created attachment 229941 [details]
+Image triggering btrfsck into asan error
+
+The filesystem-image attached to this bug drives btrfsck from btrfs-progs
+v4.7-42-g56e9586 into a heap-use-after-free. The src was from kdave's mirror,
+devel branch. CFLAGS='-DNDEBUG -O1 -g -fsanitize=address
+-fno-omit-frame-pointer -fno-optimize-sibling-calls'
+
+
+The juicy parts:
+==32639==ERROR: AddressSanitizer: heap-use-after-free on address
+0x621000019170 at pc 0x0000005c046e bp 0x7fff631e48d0 sp 0x7fff631e48c8
+READ of size 4 at 0x621000019170 thread T0
+    #0 0x5c046d in free_extent_buffer
+/home/lukas/dev/btrfsprogs_fuzz/src/extent_io.c:579:10
+    #1 0x59356c in btrfs_release_all_roots
+/home/lukas/dev/btrfsprogs_fuzz/src/disk-io.c:1084:3
+    #2 0x5949a7 in __open_ctree_fd
+/home/lukas/dev/btrfsprogs_fuzz/src/disk-io.c:1325:2
+    #3 0x594325 in open_ctree_fs_info
+/home/lukas/dev/btrfsprogs_fuzz/src/disk-io.c:1363:9
+    #4 0x51e717 in cmd_check
+/home/lukas/dev/btrfsprogs_fuzz/src/cmds-check.c:11320:9
+    #5 0x4f0f81 in main /home/lukas/dev/btrfsprogs_fuzz/src/btrfs.c:243:8
+    #6 0x7f5ce75ee730 in __libc_start_main (/lib64/libc.so.6+0x20730)
+    #7 0x4213f8 in _start (/home/lukas/dev/btrfsfuzz/bin/bin/btrfs+0x4213f8)
+
+
+Note that the bug happens within core itself. The kernel may be vulnerable as
+well, I didn't check, though.
diff --git a/tests/fuzz-tests/images/unaligned-tree-block-bytenr.raw.xz b/tests/fuzz-tests/images/unaligned-tree-block-bytenr.raw.xz
new file mode 100644
index 0000000000000000000000000000000000000000..d37b1a2d3f00d15f26d42a1f149a537e9c5810fe
GIT binary patch
literal 3852
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
Rj@@&1OX6QYFCc~U{}b+FcFX_(

literal 0
HcmV?d00001

-- 
2.9.3



