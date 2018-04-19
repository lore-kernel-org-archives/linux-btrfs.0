Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55246 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753761AbeDSQfm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 12:35:42 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5AE4AAC76
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Apr 2018 16:35:41 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH v2 00/16] Kill fs_info::volume_mutex
Date: Thu, 19 Apr 2018 18:33:09 +0200
Message-Id: <cover.1524146555.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This series gets rid of the volume mutex because it's redundant. Updated
branch: git://github.com/kdave/btrfs-devel dev/remove-volume-mutex

Changes for v2:
- sanity check in balance resume is only a warning
- read-only check in balance cancel remains and is only moved
- typo fixes

The fstests seem to pass all relevant tests now and qualifies for
conditional addition to for-next.

David Sterba (16):
  btrfs: squeeze btrfs_dev_replace_continue_on_mount to its caller
  btrfs: make success path out of btrfs_init_dev_replace_tgtdev more clear
  btrfs: export and rename free_device
  btrfs: move btrfs_init_dev_replace_tgtdev to dev-replace.c and make static
  btrfs: move volume_mutex to callers of btrfs_rm_device
  btrfs: move clearing of EXCL_OP out of __cancel_balance
  btrfs: add proper safety check before resuming dev-replace
  btrfs: add sanity check when resuming balance after mount
  btrfs: cleanup helpers that reset balance state
  btrfs: remove wrong use of volume_mutex from btrfs_dev_replace_start
  btrfs: kill btrfs_fs_info::volume_mutex
  btrfs: track running balance in a simpler way
  btrfs: move and comment read-only check in btrfs_cancel_balance
  btrfs: drop lock parameter from update_ioctl_balance_args and rename
  btrfs: use mutex in btrfs_resume_balance_async
  btrfs: open code set_balance_control

 fs/btrfs/ctree.h       |   9 +-
 fs/btrfs/dev-replace.c | 135 +++++++++++++++++++++----
 fs/btrfs/disk-io.c     |   2 -
 fs/btrfs/extent-tree.c |   2 +-
 fs/btrfs/ioctl.c       |  41 +++-----
 fs/btrfs/volumes.c     | 263 +++++++++++++++----------------------------------
 fs/btrfs/volumes.h     |   5 +-
 7 files changed, 216 insertions(+), 241 deletions(-)

-- 
2.16.2

