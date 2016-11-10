Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37942 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933875AbcKJPBJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Nov 2016 10:01:09 -0500
From: David Sterba <dsterba@suse.com>
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: [PULL] Btrfs fixes for 4.9-rc5
Date: Thu, 10 Nov 2016 16:00:57 +0100
Message-Id: <cover.1478789584.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

two minor error handling fixes and one fix for balance sttus item that goes
back to 4.4.

The branch continues from my last pull that went to Linus' tree, so it would
be a good idea to do the same as before. I've added a signed tag for branch.

----------------------------------------------------------------
The following changes since commit 9d1032cc49a8a1065e79ee323de66bcb4fdbd535:

  btrfs: fix WARNING in btrfs_select_ref_head() (2016-10-24 18:20:29 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.9-rc5

for you to fetch changes up to 3ed73b672c8707cab47ef0caf5d0c2a377ad70f2:

  btrfs: Call kunmap if zlib_inflateInit2 fails (2016-11-07 18:07:03 +0100)

----------------------------------------------------------------
Christophe JAILLET (1):
      btrfs: remove redundant check of btrfs_iget return value

David Sterba (1):
      btrfs: store and load values of stripes_min/stripes_max in balance status item

Nick Terrell (1):
      btrfs: Call kunmap if zlib_inflateInit2 fails

 fs/btrfs/ctree.h            | 4 ++++
 fs/btrfs/free-space-cache.c | 2 --
 fs/btrfs/zlib.c             | 1 +
 3 files changed, 5 insertions(+), 2 deletions(-)
