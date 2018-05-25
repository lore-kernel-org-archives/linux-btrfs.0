Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54887 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935329AbeEYEn3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 May 2018 00:43:29 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BD01FAC42
        for <linux-btrfs@vger.kernel.org>; Fri, 25 May 2018 04:43:27 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4 0/3] btrfs: Add write time super block validation
Date: Fri, 25 May 2018 12:43:22 +0800
Message-Id: <20180525044325.3365-1-wqu@suse.com>
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
v4:
  Change the timing of btrfs_validate_write_super() to handle seed
  sprout case, where the original superblock can be from seed device,
  which has a different fsid. Thanks Anand for exposing this bug.
  Only the last patch is affected.

Qu Wenruo (3):
  btrfs: Move btrfs_check_super_valid() to avoid forward declaration
  btrfs: Refactor btrfs_check_super_valid()
  btrfs: Do super block verification before writing it to disk

 fs/btrfs/disk-io.c | 365 ++++++++++++++++++++++++++-------------------
 1 file changed, 214 insertions(+), 151 deletions(-)

-- 
2.17.0

