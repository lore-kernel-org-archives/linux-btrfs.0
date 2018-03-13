Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:38596 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751397AbeCMB42 (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Mon, 12 Mar 2018 21:56:28 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 0/7] Fix long standing -EOPNOTSUPP problem caused by large inline extent
Date: Tue, 13 Mar 2018 09:56:09 +0800
Message-Id: <20180313015616.6574-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The patch is based on v4.15.1, and is designed to replace the old patch
in devel branch.

Kernel doesn't support dropping range inside inline extent, and prevents
such thing happening by limiting max inline extent size to
min(max_inline, sectorsize - 1) in cow_file_range_inline().

However btrfs-progs only inherit the BTRFS_MAX_INLINE_DATA_SIZE() macro,
which doesn't have sectorsize check.
And since btrfs-progs defaults to 16K nodesize, above macro allows large
inline extent over 15K size.

This leads to unexpected kernel behavior.

The bug exists in several parts of btrfs-progs, any tool which creates
file extent is involved, including:
1) btrfs-convert
2) mkfs --rootdir

This patchset fixes the problems in convert (both ext2 and reiserfs),
mkfs --rootdir, then add check support for both original and lowmem
mode, and finally adds 2 test cases, one for mkfs and one for convert.

For mkfs test case, it can already be exposed by misc/002, but a
pin-point test case will be much better.

Tested with test-convert, test-fsck, test-misc and test-mkfs.

Qu Wenruo (7):
  btrfs-progs: convert/ext2: Fix inline extent creation check
  btrfs-progs: convert/reiserfs: Fix inline file extent creation check
  btrfs-progs: mkfs/rootdir: Fix inline extent creation check
  btrfs-progs: check/original mode: Check inline extent size
  btrfs-progs: check/lowmem mode: Check inline extent size
  btrfs-progs: test/convert: Add test case for invalid large inline data
    extent
  btrfs-progs: test/mkfs: Add test case for rootdir inline extent size

 check/main.c                                       | 16 +++++
 check/mode-lowmem.c                                | 28 ++++++++
 check/mode-original.h                              |  1 +
 convert/source-ext2.c                              |  2 +-
 convert/source-reiserfs.c                          |  3 +-
 mkfs/rootdir.c                                     |  6 +-
 .../016-invalid-large-inline-extent/test.sh        | 22 ++++++
 tests/mkfs-tests/014-rootdir-inline-extent/test.sh | 81 ++++++++++++++++++++++
 8 files changed, 155 insertions(+), 4 deletions(-)
 create mode 100755 tests/convert-tests/016-invalid-large-inline-extent/test.sh
 create mode 100755 tests/mkfs-tests/014-rootdir-inline-extent/test.sh

-- 
2.16.2

