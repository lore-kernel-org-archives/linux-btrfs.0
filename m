Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:55245 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965468AbeCACsA (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 28 Feb 2018 21:48:00 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, peteryuchuang@gmail.com
Subject: [PATCH 0/4] Fix long standing -EOPNOTSUPP problem caused by
Date: Thu,  1 Mar 2018 10:47:43 +0800
Message-Id: <20180301024747.26192-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kernel doesn't support dropping range inside inline extent, and prevents
such thing happening by limiting max inline extent size to
min(max_inline, sectorsize - 1) in cow_file_range_inline().

However btrfs-progs only inherit the BTRFS_MAX_INLINE_DATA_SIZE() macro,
which doesn't have sectorsize check.
And since btrfs-progs defaults to 16K nodesize, above macro allows large
inline extent over 15K size.

This leads to unexpected kernel behavior.

The bug exists from the very beginning of btrfs-convert, dating back to
2008 when btrfs-convert is first introduced.

Qu Wenruo (4):
  btrfs-progs: Limit inline extent below page size
  btrfs-progs: check/original mode: Check inline extent size
  btrfs-progs: check/lowmem mode: Check inline extent size
  btrfs-progs: test/convert: Add test case for invalid large inline data
    extent

 check/main.c                                       |  4 ++++
 check/mode-lowmem.c                                |  8 ++++++++
 check/mode-original.h                              |  1 +
 ctree.h                                            | 11 +++++++++--
 .../016-invalid-large-inline-extent/test.sh        | 22 ++++++++++++++++++++++
 5 files changed, 44 insertions(+), 2 deletions(-)
 create mode 100755 tests/convert-tests/016-invalid-large-inline-extent/test.sh

-- 
2.16.2

