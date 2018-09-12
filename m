Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34739 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbeILQZq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Sep 2018 12:25:46 -0400
Received: by mail-pg1-f196.google.com with SMTP id d19-v6so914235pgv.1
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2018 04:21:40 -0700 (PDT)
From: damenly.su@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: suy.fnst@cn.fujitsu.com
Subject: [PATCH 7/7] btrfs-progs: fsck-tests: add test case inode_extref without dir_item and dir_index
Date: Wed, 12 Sep 2018 19:20:46 +0000
Message-Id: <20180912192046.5861-10-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180912192046.5861-1-suy.fnst@cn.fujitsu.com>
References: <20180912192046.5861-1-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Su Yue <suy.fnst@cn.fujitsu.com>

This case contains an inode_extref:
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
       'btrfs-progs: lowmem: improve check_inode_extref()'.

And rename default_case.img to inode_ref_without_dir_item_index.img.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 .../inode_extref_without_dir_item_index.img     | Bin 0 -> 10240 bytes
 ...=> inode_ref_without_dir_item_and_index.img} | Bin
 2 files changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 tests/fsck-tests/009-no-dir-item-or-index/inode_extref_without_dir_item_index.img
 rename tests/fsck-tests/009-no-dir-item-or-index/{default_case.img => inode_ref_without_dir_item_and_index.img} (100%)

diff --git a/tests/fsck-tests/009-no-dir-item-or-index/inode_extref_without_dir_item_index.img b/tests/fsck-tests/009-no-dir-item-or-index/inode_extref_without_dir_item_index.img
new file mode 100644
index 0000000000000000000000000000000000000000..85f7a8211fe66dfa9b2b1f3a98e72f54cd402616
GIT binary patch
literal 10240
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

literal 0
HcmV?d00001

diff --git a/tests/fsck-tests/009-no-dir-item-or-index/default_case.img b/tests/fsck-tests/009-no-dir-item-or-index/inode_ref_without_dir_item_and_index.img
similarity index 100%
rename from tests/fsck-tests/009-no-dir-item-or-index/default_case.img
rename to tests/fsck-tests/009-no-dir-item-or-index/inode_ref_without_dir_item_and_index.img
-- 
2.18.0
