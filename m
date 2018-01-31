Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:34100 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751618AbeAaCk4 (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 30 Jan 2018 21:40:56 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH] btrfs-progs: fsck-tests: Rename tree-reloc-tree test number
Date: Wed, 31 Jan 2018 10:40:36 +0800
Message-Id: <20180131024036.23307-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are 2 fsck tests with the same number 027:
tree-reloc-tree
bad-extent-inline-ref-type

And we also have a hole in 015, so just rename tree-reloc-tree to 015,
to get rid of the duplicated test number and fill in the hole.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 .../{027-tree-reloc-tree => 015-tree-reloc-tree}/test.sh    |   0
 .../tree_reloc_for_data_reloc.img.xz                        | Bin
 .../tree_reloc_for_fs_tree.img.xz                           | Bin
 3 files changed, 0 insertions(+), 0 deletions(-)
 rename tests/fsck-tests/{027-tree-reloc-tree => 015-tree-reloc-tree}/test.sh (100%)
 rename tests/fsck-tests/{027-tree-reloc-tree => 015-tree-reloc-tree}/tree_reloc_for_data_reloc.img.xz (100%)
 rename tests/fsck-tests/{027-tree-reloc-tree => 015-tree-reloc-tree}/tree_reloc_for_fs_tree.img.xz (100%)

diff --git a/tests/fsck-tests/027-tree-reloc-tree/test.sh b/tests/fsck-tests/015-tree-reloc-tree/test.sh
similarity index 100%
rename from tests/fsck-tests/027-tree-reloc-tree/test.sh
rename to tests/fsck-tests/015-tree-reloc-tree/test.sh
diff --git a/tests/fsck-tests/027-tree-reloc-tree/tree_reloc_for_data_reloc.img.xz b/tests/fsck-tests/015-tree-reloc-tree/tree_reloc_for_data_reloc.img.xz
similarity index 100%
rename from tests/fsck-tests/027-tree-reloc-tree/tree_reloc_for_data_reloc.img.xz
rename to tests/fsck-tests/015-tree-reloc-tree/tree_reloc_for_data_reloc.img.xz
diff --git a/tests/fsck-tests/027-tree-reloc-tree/tree_reloc_for_fs_tree.img.xz b/tests/fsck-tests/015-tree-reloc-tree/tree_reloc_for_fs_tree.img.xz
similarity index 100%
rename from tests/fsck-tests/027-tree-reloc-tree/tree_reloc_for_fs_tree.img.xz
rename to tests/fsck-tests/015-tree-reloc-tree/tree_reloc_for_fs_tree.img.xz
-- 
2.16.1

