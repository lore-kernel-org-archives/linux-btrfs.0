Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44579 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750751AbeEKFfa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 01:35:30 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 84F40AD4D
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 05:35:29 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 0/3] btrfs: Add write time super block validation
Date: Fri, 11 May 2018 13:35:24 +0800
Message-Id: <20180511053527.28378-1-wqu@suse.com>
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

Current design is to do 2 different checks at mount time and super write
time.
And for write time check, it only checks the template super block
(fs_info->super_to_commit) other than each super blocks to be written to
disk, mostly to avoid duplicated checks.

Changelog:
v2:
  Rename btrfs_check_super_valid() to btrfs_validate_super() suggested
  by Nikolay and David.
v3:
  Add a new patch to move btrfs_check_super_valid() to avoid forward
  declaration.
  Refactor btrfs_check_super_valid() to provide better naming and
  function reusablity.
  Code style and comment update.
  Use 2 different functions, btrfs_validate_mount_super() and
  btrfs_validate_write_super(), for mount and write time super check.

Qu Wenruo (3):
  btrfs: Move btrfs_check_super_valid() to avoid forward declaration
  btrfs: Refactor btrfs_check_super_valid()
  btrfs: Do super block verification before writing it to disk

 fs/btrfs/disk-io.c | 361 ++++++++++++++++++++++++++-------------------
 1 file changed, 210 insertions(+), 151 deletions(-)

-- 
2.17.0

