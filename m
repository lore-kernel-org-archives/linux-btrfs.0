Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37834 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751323AbdJFPgW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 6 Oct 2017 11:36:22 -0400
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 4.14-rc4
Date: Fri,  6 Oct 2017 17:34:36 +0200
Message-Id: <cover.1507303159.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

we have two more fixes for bugs introduced in 4.13. The sector_t problem with
32bit architecture and !LBDAF config seems serious but the number of affected
deployments is hopefully low.  The clashing status bits could lead to a
confusing in-memory state of the whole-filesystem operations if used with the
quota override sysfs knob.

Please pull, thanks.

The following changes since commit 8c6c592831a09a28428448e68fb08c6bbb8b9b8b:

  btrfs: log csums for all modified extents (2017-09-26 14:54:16 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.14-rc4

for you to fetch changes up to 69ad59767d094752c23c0fc180a79532fde073d0:

  Btrfs: fix overlap of fs_info::flags values (2017-10-04 16:44:18 +0200)

----------------------------------------------------------------
Goffredo Baroncelli (1):
      btrfs: avoid overflow when sector_t is 32 bit

Tsutomu Itoh (1):
      Btrfs: fix overlap of fs_info::flags values

 fs/btrfs/ctree.h     | 2 +-
 fs/btrfs/extent_io.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
