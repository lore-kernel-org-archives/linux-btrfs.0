Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51496 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903AbaGBVgi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Jul 2014 17:36:38 -0400
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>
Subject: [PATCH 0/3] btrfs: qgroup fixes for btrfs_drop_snapshot
Date: Wed,  2 Jul 2014 14:35:16 -0700
Message-Id: <1404336919-26766-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, the following patches try to fix a long outstanding issue with qgroups
and snapshot deletion. The core problem is that btrfs_drop_snapshot will
skip shared extents during it's tree walk. This results in an inconsistent
qgroup state once the drop is processed.

The first patch adds some tracing which I found very useful in debugging
qgroup operations. The second patch is an actual fix to the problem. A third
patch, from Josef is also added. We need this because it fixes at least one
set of inconsistencies qgroups can get to via drop_snapshot.

Even with this patch series, we still have some inconsistency in qgroups
when a snapshot is deleted. It's to early to tell where these are coming
from but since this series gets us even further along than ever before I
feel it's worth sending out for upstream acceptance.

Changes from last time:

- remove extra extent_buffer_uptodate call from account_shared_subtree()

- catch return values for the accounting calls now and do the right thing
  (log an error and tell the user to rescan)

- remove the loop on roots in qgroup_subtree_accounting and just use the
  nnodes member to make our first decision.

- Don't queue up the subtree root for a change (the code in drop_snapshot
  handkles qgroup updates for this block).

- only walk subtrees if we're actually in DROP_REFERENCE stage and we're
  going to call free_extent

- account leaf items for level zero blocks that we are dropping in
  walk_up_proc


TODO:

So while this fixes a *lot* of the qgroup inconsistency we've been seeing
from drop_snapshot, there's still a few items left before it's completely
ready IMHO.

- Obviously there's still some updates we're missing so that's the first
  thing I want to get to.

- We need an xfstest for this, otherwise I'm concerned that we can easily
  regress from bugs introduced via seemingly unrelated patches. This stuff
  can be fragile.
   - I already have a script that creates and removes a level 1 tree to
     introduce an inconsistency. I think adapting that is probably a good
     first step. The script can be found at:

     http://zeniv.linux.org.uk/~mfasheh/create-btrfs-trees.sh

     Please don't make fun of my poor shell scripting skills  :)

- qgroup items are not deleted after drop_snapshot. They stay orphaned, on
  disk, often with nonzero values in their count fields. This is something
  for another patch. Josef and I have some ideas for how to deal with this:
   - Just zero them out at the end of drop_snapshot (maybe in the future we
     could actually then delete them from disk?)
   - update btrfs_subtree_accounting() to remove bytes from the
     being-deleted qgroups so they wind up as zero on disk (this is
     preferable but might not be practical)

- we need at least a rescan to be kicked off when adding parent qgroups.
  otherwise, the newly added groups start with the wrong information. Quite
  possible the rescan itself might need to be updated (I haven't tested this
  enough).

- qgroup heirarchies in general don't seem quite implemented yet. Once we
  fix the previous items the code to update their counts for them will
  probably need some love.

Please review, thanks. Diffstat follows,
	--Mark

 fs/btrfs/ctree.c             |   20 +--
 fs/btrfs/ctree.h             |    4 
 fs/btrfs/extent-tree.c       |  285 +++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/qgroup.c            |  159 +++++++++++++++++++++++
 fs/btrfs/qgroup.h            |    1 
 fs/btrfs/super.c             |    1 
 include/trace/events/btrfs.h |   57 ++++++++
 7 files changed, 496 insertions(+), 31 deletions(-)
