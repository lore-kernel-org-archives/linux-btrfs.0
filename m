Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60574 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730017AbeGMTCe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Jul 2018 15:02:34 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 64F79AD0C
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Jul 2018 18:46:43 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/4] 3- and 4- copy RAID1
Date: Fri, 13 Jul 2018 20:46:28 +0200
Message-Id: <cover.1531503452.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have some goodies that go into the RAID56 problem, although not
implementing all the remaining features, it can be useful independently.

This time my hackweek project

https://hackweek.suse.com/17/projects/do-something-about-btrfs-and-raid56

aimed to implement the fix for the write hole problem but I spent more
time with analysis and design of the solution and don't have a working
prototype for that yet.

This patchset brings a feature that will be used by the raid56 log, the
log has to be on the same redundancy level and thus we need a 3-copy
replication for raid6. As it was easy to extend to higher replication,
I've added a 4-copy replication, that would allow triple copy raid (that
does not have a standardized name).

The number of copies is fixed, so it's not N-copy for an arbitrary N.
This would complicate the implementation too much, though I'd be willing
to add a 5-copy replication for a small bribe.

The new raid profiles and covered by an incompatibility bit, called
extended_raid, the (idealistic) plan is to stuff as many new
raid-related features as possible. The patch 4/4 mentions the 3- 4- copy
raid1, configurable stripe length, write hole log and triple parity.
If the plan turns out to be too ambitious, the ready and implemented
features will be split and merged.

An interesting question is the naming of the extended profiles. I picked
something that can be easily understood but it's not a final proposal.
Years ago, Hugo proposed a naming scheme that described the
non-standard raid varieties of the btrfs flavor:

https://marc.info/?l=linux-btrfs&m=136286324417767

Switching to this naming would be a good addition to the extended raid.

Regarding the missing raid56 features, I'll continue working on them as
time permits in the following weeks/months, as I'm not aware of anybody
working on that actively enough so to speak.

Anyway, git branches with the patches:

kernel: git://github.com/kdave/btrfs-devel dev/extended-raid-ncopies
progs:  git://github.com/kdave/btrfs-progs dev/extended-raid-ncopies

David Sterba (4):
  btrfs: refactor block group replication factor calculation to a helper
  btrfs: add support for 3-copy replication (raid1c3)
  btrfs: add support for 4-copy replication (raid1c4)
  btrfs: add incompatibility bit for extended raid features

 fs/btrfs/ctree.h                |  1 +
 fs/btrfs/extent-tree.c          | 45 +++++++-----------
 fs/btrfs/relocation.c           |  1 +
 fs/btrfs/scrub.c                |  4 +-
 fs/btrfs/super.c                | 17 +++----
 fs/btrfs/sysfs.c                |  2 +
 fs/btrfs/volumes.c              | 84 ++++++++++++++++++++++++++++++---
 fs/btrfs/volumes.h              |  6 +++
 include/uapi/linux/btrfs.h      | 12 ++++-
 include/uapi/linux/btrfs_tree.h |  6 +++
 10 files changed, 134 insertions(+), 44 deletions(-)

-- 
2.18.0

