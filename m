Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:2467 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751606AbcH3HWY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Aug 2016 03:22:24 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Lukas Lueg <lukas.lueg@gmail.com>
Subject: [PATCH 0/5] Fuzzer test fix
Date: Tue, 30 Aug 2016 15:22:12 +0800
Message-ID: <20160830072217.8599-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Cc: Lukas Lueg <lukas.lueg@gmail.com>

Thanks for the fuzz test from Lukas, quite a lot of bugs are exposed.

The full fixes can be fetched from my github:
https://github.com/adam900710/btrfs-progs/tree/fuzz_fix_160830

The branch has go through fuzz and mkfs tests.

For full low-memory mode checker, I'll push it to David first, so for
low-memory mode fuzzer test, it will need some time.

Test cases uses the same image submitted by Lukas.
Although all these root causes are pinned, it still need quite a lot of
work to make corrupt-block able to create minimal image.

So I choose to directly use his images as test cases.

And special notes for the BUG_ON fix:
The fix just fixes a small corner, while tons of BUG_ON()/abort() are
still here and there.
We need quite a lot of boring work to handle them later.

While the good news is, new low memory mode(at least for extent and
chunk tree check part) is quite safe against such things.
I can't wait to see how the full low-memory mode works under fuzzer
tests.


Lukas Lueg (2):
  btrfs-progs: fuzz-test: Add test case for invalid drop level
  btrfs-progs: fuzz-test: Add test case for unaligned extent item

Qu Wenruo (3):
  btrfs-progs: fsck: Check drop level before walking through fs tree
  btrfs-progs: fsck: Check bytenr alignment for extent item
  btrfs-progs: fsck: Avoid abort and BUG_ON in add_tree_backref

 cmds-check.c                                       |  95 ++++++++++++++++-----
 tests/fuzz-tests/images/invalid-drop-level.raw.txt |  30 +++++++
 tests/fuzz-tests/images/invalid-drop-level.raw.xz  | Bin 0 -> 3788 bytes
 .../images/unaligned-extent-item.raw.txt           |   8 ++
 .../fuzz-tests/images/unaligned-extent-item.raw.xz | Bin 0 -> 3684 bytes
 5 files changed, 111 insertions(+), 22 deletions(-)
 create mode 100644 tests/fuzz-tests/images/invalid-drop-level.raw.txt
 create mode 100644 tests/fuzz-tests/images/invalid-drop-level.raw.xz
 create mode 100644 tests/fuzz-tests/images/unaligned-extent-item.raw.txt
 create mode 100644 tests/fuzz-tests/images/unaligned-extent-item.raw.xz

-- 
2.9.3



