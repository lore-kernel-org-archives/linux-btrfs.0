Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58807 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755176AbeDTOYQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Apr 2018 10:24:16 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5946FAEAC
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Apr 2018 14:24:15 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/6] Add ioctl to clear unused space
Date: Fri, 20 Apr 2018 16:21:43 +0200
Message-Id: <cover.1524233244.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset adds new ioctl similar to TRIM, that provides several
other ways how to clear the unused space.  The changelogs are
incomplete, for preview not for inclusion yet.

It compiles and has been tested lightly, the clearing modes depend on hw
capabilities (secure discard, sector unmapping instead of zeros), so
I've tested only zeroing and discard.

I personally think the zeroing has a usecase and the other modes were
easy to add. Further extensions can be considered, eg. WRITE_SAME,
overwriting with a randomly generated pattern, or some filesystem canary
patterns that can be used to report unused block read as metadata.

As this is modelled after the generic FITRIM ioctl, so this could be a
new generic ioctl too. However, last time somebody wanted such ioctl,
there was a pushback. I'll consider making a generic version and send it
for comments to fsdevel eventually.

git://github.com/kdave/btrfs-devel dev/zero-free


David Sterba (6):
  btrfs: extend trim callchain to pass the operation type
  btrfs: add wrapper to switch clearing operation
  btrfs: add zeroing clear operation
  btrfs: add new ioctl BTRFS_IOC_CLEAR_FREE
  btrfs: add discard secure to clear unused space
  btrfs: add more zeroout modes for clearing unused space

 fs/btrfs/ctree.h            |   5 +-
 fs/btrfs/extent-tree.c      | 130 ++++++++++++++++++++++++++++++++++++++------
 fs/btrfs/free-space-cache.c |  22 +++++---
 fs/btrfs/free-space-cache.h |   3 +-
 fs/btrfs/ioctl.c            |  42 ++++++++++++++
 include/uapi/linux/btrfs.h  |  26 +++++++++
 6 files changed, 199 insertions(+), 29 deletions(-)

-- 
2.16.2

