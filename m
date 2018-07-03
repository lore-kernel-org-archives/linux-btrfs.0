Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:4663 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933016AbeGCHwl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jul 2018 03:52:41 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 159C74B4436B
        for <linux-btrfs@vger.kernel.org>; Tue,  3 Jul 2018 15:52:31 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 2/2] btrfs-progs: fsck-tests: add test case with keyed data backref with reloc tree blocks
Date: Tue, 3 Jul 2018 15:58:51 +0800
Message-ID: <20180703075851.8346-2-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180703075851.8346-1-suy.fnst@cn.fujitsu.com>
References: <20180703075851.8346-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For trees have been balanced, leaves are with flag BTRFS_HEADER_FLAG_RELOC and
extent data backrefs are shared. Like:
=====================
       item 0 key (11927552 EXTENT_ITEM 524288) itemoff 3932 itemsize 63
                refs 129 gen 7 flags DATA
                shared data backref parent 35897344 count 41
                shared data backref parent 35426304 count 37
                shared data backref parent 35422208 count 51
=====================

Then make the leaf which owns the extent data cowed. The shared data
backref was to transferred to keyed data ref, but remaining backrefs are
still shared. Like:
=====================
        item 0 key (11927552 EXTENT_ITEM 524288) itemoff 3887 itemsize 108
                refs 129 gen 7 flags DATA
                extent data backref root 5 objectid 258 offset 0 count 40
                extent data backref root 5 objectid 257 offset 0 count 1
                shared data backref parent 35426304 count 37
                shared data backref parent 35422208 count 51
=====================

However lowmem mode used to iterate the whole inode to find all
references, and doesn't care if a reference is already counted by the
shared tree block.

Add the test case to check it.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 .../keyed_data_ref_with_reloc_leaf.img          | Bin 0 -> 16384 bytes
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 tests/fsck-tests/020-extent-ref-cases/keyed_data_ref_with_reloc_leaf.img

diff --git a/tests/fsck-tests/020-extent-ref-cases/keyed_data_ref_with_reloc_leaf.img b/tests/fsck-tests/020-extent-ref-cases/keyed_data_ref_with_reloc_leaf.img
new file mode 100644
index 0000000000000000000000000000000000000000..80345cf9498f296f001b8b63e230bcfb9293300d
GIT binary patch
literal 16384
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

literal 0
HcmV?d00001

-- 
2.17.1



