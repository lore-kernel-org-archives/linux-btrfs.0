Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:17617 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728291AbeIQMsS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Sep 2018 08:48:18 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id A16154B6EC9A
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Sep 2018 15:22:03 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v3 7/7] btrfs-progs: fsck-tests: add test case inode_extref without dir_item and dir_index
Date: Mon, 17 Sep 2018 15:28:52 +0800
Message-ID: <20180917072852.25831-8-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180917072852.25831-1-suy.fnst@cn.fujitsu.com>
References: <20180917072852.25831-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Inode 257 is only with inode_extref without inode_ref.
And This case contains an inode_extref:
==========================================
...
   item 1 key (257 INODE_EXTREF 3460996356) itemoff 3947 itemsize 24
                index 257 parent 256 namelen 6 name: foo255
...
==========================================
The related dir_item and dir_index are missing.

Add the case to ensure both original and lowmem mode check can handle
the case of inode_extref.

Lowmem part is supported since patch named
'btrfs-progs: lowmem: optimization and repair for check_inode_extref()'.

Rename default_case.img to inode_ref_without_dir_item_and_index.img.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 .../inode_extref_without_dir_item_and_index.img  | Bin 0 -> 4096 bytes
 ... => inode_ref_without_dir_item_and_index.img} | Bin
 2 files changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 tests/fsck-tests/009-no-dir-item-or-index/inode_extref_without_dir_item_and_index.img
 rename tests/fsck-tests/009-no-dir-item-or-index/{default_case.img => inode_ref_without_dir_item_and_index.img} (100%)

diff --git a/tests/fsck-tests/009-no-dir-item-or-index/inode_extref_without_dir_item_and_index.img b/tests/fsck-tests/009-no-dir-item-or-index/inode_extref_without_dir_item_and_index.img
new file mode 100644
index 0000000000000000000000000000000000000000..769dabe9bdeff9b9582a49b6de9a7ff14be9b389
GIT binary patch
literal 4096
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
G9QY4={DzYN

literal 0
HcmV?d00001

diff --git a/tests/fsck-tests/009-no-dir-item-or-index/default_case.img b/tests/fsck-tests/009-no-dir-item-or-index/inode_ref_without_dir_item_and_index.img
similarity index 100%
rename from tests/fsck-tests/009-no-dir-item-or-index/default_case.img
rename to tests/fsck-tests/009-no-dir-item-or-index/inode_ref_without_dir_item_and_index.img
-- 
2.17.1
