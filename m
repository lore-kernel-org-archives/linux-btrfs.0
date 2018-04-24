Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:47027 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755801AbeDXEsU (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 24 Apr 2018 00:48:20 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/4] btrfs: Add write time super block validation
Date: Tue, 24 Apr 2018 12:48:05 +0800
Message-Id: <20180424044809.29838-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset can be fetched from github:
https://github.com/adam900710/linux/tree/write_time_sb_check

We have 2 reports about corrupted btrfs super block, which has some garbage
in its super block, but otherwise it's completely fine and its csum even
matches.

This means we develop memory corruption during btrfs mount time.
It's not clear whether it's caused by btrfs or some other kernel module,
but at least let's do write time verification to catch such corruption
early.

Changelog:
v2:
  Rename btrfs_check_super_valid() to btrfs_validate_super() suggested
  by Nikolay and David.

Qu Wenruo (4):
  btrfs: Rename btrfs_check_super_valid() to btrfs_validate_super()
  btrfs: Add incompat flags check for btrfs_check_super_valid()
  btrfs: Add csum type check for btrfs_check_super_valid()
  btrfs: Do super block verification before writing it to disk

 fs/btrfs/disk-io.c | 58 ++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 51 insertions(+), 7 deletions(-)

-- 
2.17.0

