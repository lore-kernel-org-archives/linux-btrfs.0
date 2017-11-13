Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:57467 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751562AbdKMHfB (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Mon, 13 Nov 2017 02:35:01 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, chris@colorremedies.com
Subject: [PATCH 0/4] Lowmem mode btrfs fixes exposed by complex tree
Date: Mon, 13 Nov 2017 15:34:49 +0800
Message-Id: <20171113073453.29198-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The patchset (along with "backref lost" bug fixes and test cases) can be
fetched from github:
https://github.com/adam900710/btrfs-progs/tree/lowmem_fix

Despite the backref lost false alerts reported by Chris Murphy, there
are still some other bugs to be fixed.

One is also exposed by Chris Murphy, where btrfs-progs backref can't
handle shared block ref for metadata. Fix by 1st patch.

And 2 more bugs exposed by the test image which is originally designed
for the bug fixed by 1st patch.

Last but not the least, here comes the test image.
Which is an image with a lot of metadata and under a relocation.
It is definitely a bomb for old lowmem check.

Qu Wenruo (4):
  btrfs-progs: backref: Allow backref walk to handle direct parent ref
  btrfs-progs: lowmem check: Fix function call stack overflow caused by
    wrong tree reloc tree detection
  btrfs-progs: lowmem check: Fix false alerts for image with shared
    block ref only backref
  btrfs-progs: fsck-test: Add new image with shared block ref only
    metadata backref

 backref.c                                          |   3 ++
 cmds-check.c                                       |  35 +++++++++++++++++----
 .../020-extent-ref-cases/shared_block_ref_only.img | Bin 0 -> 304128 bytes
 3 files changed, 32 insertions(+), 6 deletions(-)
 create mode 100644 tests/fsck-tests/020-extent-ref-cases/shared_block_ref_only.img

-- 
2.15.0

