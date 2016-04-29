Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58089 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657AbcD2JU1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Apr 2016 05:20:27 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com
Subject: [PATCH 00/16] Minor cleanups in GFP_NOFS flags use
Date: Fri, 29 Apr 2016 11:20:13 +0200
Message-Id: <cover.1461920675.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

the first part of patchset mostly moves the GFP_NOFS flags from several
callsites into the callers. The point is to move all GFP_NOFS to the actual
point of use. If all the callers pass the same flag, there's no point in doing
that, which as a small benefit saves a few bytes on the stack.

The second part tries to improve extent_state preallocation logic in the
set/clear/convert functions. Depending on the internal state, we might not need
the allocation at all, the actual failure is left to the place where we really
need the memory, that's done in a locked section with GFP_ATOMIC. If we leave this
section, we speculatively try to allocate new extent state unless we already have
one spare.

I'd like to get this to 4.7, the patchset has low functionality impact but helps
me to continue in the NOFS crusade. 

David Sterba (16):
  btrfs: sink gfp parameter to set_extent_bits
  btrfs: sink gfp parameter to clear_extent_bits
  btrfs: sink gfp parameter to clear_record_extent_bits
  btrfs: sink gfp parameter to clear_extent_dirty
  btrfs: sink gfp parameter to set_extent_delalloc
  btrfs: sink gfp parameter to set_extent_defrag
  btrfs: sink gfp parameter to set_extent_new
  btrfs: sink gfp parameter to set_record_extent_bits
  btrfs: untangle gotos a bit in __set_extent_bit
  btrfs: untangle gotos a bit in __clear_extent_bit
  btrfs: untangle gotos a bit in convert_extent_bit
  btrfs: make state preallocation more speculative in __set_extent_bit
  btrfs: __set_extent_bit, try preallocation out of locked section with
    lighter gfp flags
  btrfs: __clear_extent_bit, try preallocation out of locked section
    with lighter gfp flags
  btrfs: convert_extent_bit, try preallocation out of locked section
    with lighter gfp flags
  btrfs: sink gfp parameter to convert_extent_bit

 fs/btrfs/disk-io.c               |   4 +-
 fs/btrfs/extent-tree.c           |  16 +++---
 fs/btrfs/extent_io.c             | 105 +++++++++++++++++++++++----------------
 fs/btrfs/extent_io.h             |  34 ++++++-------
 fs/btrfs/file-item.c             |   2 +-
 fs/btrfs/inode.c                 |   5 +-
 fs/btrfs/ioctl.c                 |   2 +-
 fs/btrfs/qgroup.c                |   8 ++-
 fs/btrfs/relocation.c            |   7 ++-
 fs/btrfs/scrub.c                 |   4 +-
 fs/btrfs/tests/extent-io-tests.c |   8 +--
 fs/btrfs/transaction.c           |   2 +-
 fs/btrfs/tree-log.c              |   2 +-
 13 files changed, 108 insertions(+), 91 deletions(-)

-- 
2.7.1

