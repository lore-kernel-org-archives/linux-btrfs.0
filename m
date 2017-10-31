Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:56567 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751798AbdJaGIH (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 31 Oct 2017 02:08:07 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 1/2] btrfs-progs: test/fsck: Introduce test images containing tree reloc tree
Date: Tue, 31 Oct 2017 14:07:57 +0800
Message-Id: <20171031060758.531-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tree reloc tree is a special tree with very short life spawn.
It acts as a special snapshot for any tree, with related nodes/leaves or
EXTENT_DATA modified to point to new position.

Considering the short life spawn and its specialness, it should be quite
reasonable to keep them as both corner case for fsck and educational
dump for anyone interested in relocation.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/fsck-tests/027-tree-reloc-tree/test.sh       |  22 +++++++++++++++++++++
 .../tree_reloc_for_data_reloc.img.xz               | Bin 0 -> 2112 bytes
 .../tree_reloc_for_fs_tree.img.xz                  | Bin 0 -> 2424 bytes
 3 files changed, 22 insertions(+)
 create mode 100755 tests/fsck-tests/027-tree-reloc-tree/test.sh
 create mode 100644 tests/fsck-tests/027-tree-reloc-tree/tree_reloc_for_data_reloc.img.xz
 create mode 100644 tests/fsck-tests/027-tree-reloc-tree/tree_reloc_for_fs_tree.img.xz

diff --git a/tests/fsck-tests/027-tree-reloc-tree/test.sh b/tests/fsck-tests/027-tree-reloc-tree/test.sh
new file mode 100755
index 000000000000..559c4bc700bd
--- /dev/null
+++ b/tests/fsck-tests/027-tree-reloc-tree/test.sh
@@ -0,0 +1,22 @@
+#!/bin/bash
+# Make sure btrfs check won't report any false alert for valid image with
+# tree reloc tree.
+#
+# Also due to the short life spawn of tree reloc tree, save them as dump
+# example for later usage.
+
+source "$TOP/tests/common"
+
+check_prereq btrfs
+
+for img in *.img.xz
+do
+	image=$(extract_image "$img")
+	run_check_stdout "$TOP/btrfs" check "$image" 2>&1 |
+		grep -q "Errors found in extent allocation tree or chunk allocation"
+	if [ $? -eq 0 ]; then
+		rm -f "$image"
+		_fail "unexpected error occurred when checking $img"
+	fi
+	rm -f "$image"
+done
diff --git a/tests/fsck-tests/027-tree-reloc-tree/tree_reloc_for_data_reloc.img.xz b/tests/fsck-tests/027-tree-reloc-tree/tree_reloc_for_data_reloc.img.xz
new file mode 100644
index 0000000000000000000000000000000000000000..66d8bde6b7a6c451eb7b3b6f4dbc6a919144d1f5
GIT binary patch
literal 2112
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

literal 0
HcmV?d00001

diff --git a/tests/fsck-tests/027-tree-reloc-tree/tree_reloc_for_fs_tree.img.xz b/tests/fsck-tests/027-tree-reloc-tree/tree_reloc_for_fs_tree.img.xz
new file mode 100644
index 0000000000000000000000000000000000000000..22af324b95f61902ef6d3afa4b4930b7de3da41f
GIT binary patch
literal 2424
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

literal 0
HcmV?d00001

-- 
2.14.3

