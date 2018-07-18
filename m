Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53596 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726258AbeGRNI2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jul 2018 09:08:28 -0400
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 4.18-rc5
Date: Wed, 18 Jul 2018 14:30:35 +0200
Message-Id: <cover.1531916500.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

please pull the following branch with 3 regression fixes. They're
few-liners and fixing some corner cases missed in the origial patches.
Thanks.

----------------------------------------------------------------
The following changes since commit e4e7ede739f7fb468686dfffa2d1e35dca35bacd:

  Btrfs: fix mount failure when qgroup rescan is in progress (2018-06-28 11:30:57 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.18-rc5-tag

for you to fetch changes up to 665d4953cde6d9e75c62a07ec8f4f8fd7d396ade:

  btrfs: scrub: Don't use inode page cache in scrub_handle_errored_block() (2018-07-17 13:56:30 +0200)

----------------------------------------------------------------
David Sterba (1):
      btrfs: restore uuid_mutex in btrfs_open_devices

Naohiro Aota (1):
      btrfs: fix use-after-free of cmp workspace pages

Qu Wenruo (1):
      btrfs: scrub: Don't use inode page cache in scrub_handle_errored_block()

 fs/btrfs/ioctl.c   |  2 ++
 fs/btrfs/scrub.c   | 17 +++++++++--------
 fs/btrfs/volumes.c |  2 ++
 3 files changed, 13 insertions(+), 8 deletions(-)
