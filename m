Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:42885 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751588AbdKVJDs (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 22 Nov 2017 04:03:48 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 00/11] Lowmem mode btrfs fixes exposed by complex tree
Date: Wed, 22 Nov 2017 17:03:14 +0800
Message-Id: <20171122090325.29458-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The patchset can be fetched from github:
https://github.com/adam900710/btrfs-progs/tree/lowmem_fix

The patchset is mostly rebased to v4.14, since there is some conflicts
with lowmem repair enhancement from Su Yue.

However the lowmem repair enhancement from Su Yue caused one regression,
and the original lowmem code also has some problem handling tree reloc
tree.

The first 2 patches are newly introduced to address this.
The rest are not touched at all (except the conflicts).

As always, the 9th patch may not reach mail list due to its size.
Please use github repo to fetch that file.

Qu Wenruo (11):
  btrfs-progs: lowmem check: Fix regression which screws up extent
    allocator
  btrfs-progs: lowmem check: Fix NULL pointer access caused by large
    tree reloc tree
  btrfs-progs: lowmem check: Fix inlined data extent ref lookup
  btrfs-progs: lowmem check: Fix false backref lost warning for keyed
    extent data ref
  btrfs-progs: fsck-test: Introduce test case for false data extent
    backref lost
  btrfs-progs: backref: Allow backref walk to handle direct parent ref
  btrfs-progs: lowmem check: Fix function call stack overflow caused by
    wrong tree reloc tree detection
  btrfs-progs: lowmem check: Fix false alerts for image with shared
    block ref only backref
  btrfs-progs: fsck-test: Add new image with shared block ref only
    metadata backref
  btrfs-progs: lowmem check: Fix false alerts of referencer count
    mismatch for snapshot
  btrfs-progs: fsck-tests: Introduce test case with keyed data backref
    with shared tree blocks

 backref.c                                          |   3 +
 cmds-check.c                                       |  79 +++++++++++++++------
 .../020-extent-ref-cases/keyed_data_ref_only.img   | Bin 0 -> 4096 bytes
 .../keyed_data_ref_with_shared_leaf.img            | Bin 0 -> 19456 bytes
 .../shared_block_ref_only.raw.xz                   | Bin 0 -> 217204 bytes
 5 files changed, 61 insertions(+), 21 deletions(-)
 create mode 100644 tests/fsck-tests/020-extent-ref-cases/keyed_data_ref_only.img
 create mode 100644 tests/fsck-tests/020-extent-ref-cases/keyed_data_ref_with_shared_leaf.img
 create mode 100644 tests/fsck-tests/020-extent-ref-cases/shared_block_ref_only.raw.xz

-- 
2.15.0

