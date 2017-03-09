Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45217 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754526AbdCINzl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 9 Mar 2017 08:55:41 -0500
From: David Sterba <dsterba@suse.com>
To: clm@fb.com
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: [PULL] Btrfs updates for 4.11-rc2
Date: Thu,  9 Mar 2017 14:55:00 +0100
Message-Id: <cover.1489067273.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

there's a regression fix for the assertion failure reported by Dave Jones, the
rest of patches are minor updates. Please pull, thanks.

The following changes since commit e9f467d028cd7d8bee2a4d6c4fb806caf8cd580b:

  Merge branch 'for-chris-4.11-part2' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux into for-linus-4.11 (2017-02-28 14:35:09 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-chris-4.11-rc2

for you to fetch changes up to 94b5a2924fc0ec2bb2347ca31156be8fabe907c4:

  Btrfs: consistent usage of types in balance_args (2017-03-09 14:23:00 +0100)

----------------------------------------------------------------
Dmitry V. Levin (2):
      btrfs: remove btrfs_err_str function from uapi/linux/btrfs.h
      MAINTAINERS: add btrfs file entries for include directories

Goldwyn Rodrigues (1):
      btrfs: No need to check !(flags & MS_RDONLY) twice

Hans van Kranenburg (1):
      Btrfs: consistent usage of types in balance_args

Liu Bo (2):
      Btrfs: update comments in cache_save_setup
      Btrfs: fix regression in lock_delalloc_pages

 MAINTAINERS                |  2 ++
 fs/btrfs/extent-tree.c     |  3 ++-
 fs/btrfs/extent_io.c       |  3 ++-
 fs/btrfs/super.c           |  3 +--
 include/uapi/linux/btrfs.h | 37 +++++--------------------------------
 5 files changed, 12 insertions(+), 36 deletions(-)
