Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:57370 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751785AbdK2JQS (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 29 Nov 2017 04:16:18 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 0/9] Remaining part of mkfs --rootdir rework
Date: Wed, 29 Nov 2017 17:15:55 +0800
Message-Id: <20171129091604.2194-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Can be fetched from my github repo:
https://github.com/adam900710/btrfs-progs/tree/mkfs_rootdir_rework

Based on the following commit head of David's devel branch:
------
 commit af322ba5aa1dd0b2a3422e1c4acd8082948efa7b (david/devel)
 Author: Su Yue <suy.fnst@cn.fujitsu.com>
 Date:   Tue Nov 28 17:14:48 2017 +0800

    btrfs-progs: fi defrag: clean up duplicate code if find errors
    
    In function cmd_filesystem_defrag(), lines of code for error handling
    are duplicate and hard to expand in further.
    
    Create a jump label for errors.
    
    Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
    Signed-off-by: David Sterba <dsterba@suse.com>
------

Patch 1 is split from original patch.
Patch 2~5 are the patches rebased. Only minor conflicts.

Patch 6~7 are regression fix and its test case. Which prohibits
mkfs.btrfs --rootdir from creating new file.

Patch 8~9 are fix and test case for incorrect shrink behavior, which
will shrink the fs even --shrink is not specified.

Qu Wenruo (9):
  btrfs-progs: mkfs: Cleanup temporary chunks before filling rootdir
  btrfs-progs: mkfs: Don't use custom chunk allocator for rootdir
  btrfs-progs: mkfs/rootdir: Use over-reserve method to make size
    estimate easier
  btrfs-progs: mkfs/rootdir: Shrink fs for rootdir option
  btrfs-progs: mkfs: Separate shrink from rootdir
  btrfs-progs: mkfs: Fix regression preventing --rootdir to create file
  btrfs-progs: tests/mkfs: Introduce test case to check if mkfs rootdir
    can create new file
  btrfs-progs: mkfs: Use the whole file or block device to mkfs for
    rootdir
  btrfs-progs: tests/mkfs: Introduce test case to verify if mkfs.btrfs
    rootdir shrink behaves correctly

 Documentation/mkfs.btrfs.asciidoc                |  11 +
 mkfs/main.c                                      | 231 ++++++++++-----------
 mkfs/rootdir.c                                   | 249 +++++++++++++++++++----
 mkfs/rootdir.h                                   |   7 +-
 tests/mkfs-tests/011-rootdir-create-file/test.sh |  14 ++
 tests/mkfs-tests/012-rootdir-no-shrink/test.sh   |  38 ++++
 utils.c                                          |  17 +-
 utils.h                                          |   2 +
 8 files changed, 402 insertions(+), 167 deletions(-)
 create mode 100755 tests/mkfs-tests/011-rootdir-create-file/test.sh
 create mode 100755 tests/mkfs-tests/012-rootdir-no-shrink/test.sh

-- 
2.15.0

