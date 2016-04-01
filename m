Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34091 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531AbcDAUOj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Apr 2016 16:14:39 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 82EF2AC32
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Apr 2016 20:14:37 +0000 (UTC)
From: Jeff Mahoney <jeffm@suse.com>
To: Btrfs Development List <linux-btrfs@vger.kernel.org>
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 0/8] btrfs: uapi migration for user-visible API components
Date: Fri,  1 Apr 2016 16:14:22 -0400
Message-Id: <1459541670-4097-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

commit 55e301fd57a (Btrfs: move fs/btrfs/ioctl.h to
include/uapi/linux/btrfs.h) was intended to make the ioctl definitions
available to userspace.  Unfortunately, moving just that file wasn't
enough and many of the ioctls aren't actually usable without the
userspace programmer filling in the gaps.  Specifically, for the routine
ioctls like BTRFS_IOC_SETLABEL, BTRFS_LABEL_SIZE wasn't defined so the
ioctl definition would be incomplete.  We were also missing
the argument structure for defrag.  Beyond that, many of the ioctl
structures have a flags field that may or may not be independent of
the btrfs internals.  Lastly, the SEARCH_TREE ioctl exposes all of the
internal items of the tree to userspace programmers so the item
structures should be exposed so that they can be parsed properly.

So, to make all this more convenient for consumers of these APIs, I've
moved the flags used by the ioctl structures into btrfs.h and
moved the item definitions, key IDs, tree root objectids, and other
well-known objectids into a new btrfs_tree.h.  ctree.h includes this
new header directly, so there aren't any changes to .c files at all.

The only part of this set that isn't just a direct cut-and-paste is
the last one which converts u8 and u64 values to __u8 and __u64 since
the former aren't exported via include/uapi.

The goal is that everything required to use the btrfs ioctls for a
particular kernel release should be made available by exporting the uapi
headers for that release.

I intend to use these for the strace ioctl decoding patch I've been
working on so that I don't need to duplicate of the definitions in the
code I send upstream as the final version of the patch.  Prior to this
patchset, I had to duplicate nearly 100 defines and several structures --
and that's without doing any item decoding at all.

I do expect there might be some discussion here. :)

-Jeff

Jeff Mahoney (8):
  btrfs: uapi/linux/btrfs.h migration, move BTRFS_LABEL_SIZE
  btrfs: uapi/linux/btrfs.h migration, qgroup limit flags
  btrfs: uapi/linux/btrfs.h migration, document subvol flags
  btrfs: uapi/linux/btrfs.h migration, move feature flags
  btrfs: uapi/linux/btrfs.h migration, move balance flags
  btrfs: uapi/linux/btrfs.h migration, move struct
    btrfs_ioctl_defrag_range_args
  btrfs: uapi/linux/btrfs_tree.h migration, item types and defines
  btrfs: uapi/linux/btrfs_tree.h, use __u8 and __u64

 fs/btrfs/ctree.h                | 1014 +--------------------------------------
 fs/btrfs/volumes.h              |   46 --
 include/uapi/linux/btrfs.h      |  173 ++++++-
 include/uapi/linux/btrfs_tree.h |  966 +++++++++++++++++++++++++++++++++++++
 4 files changed, 1135 insertions(+), 1064 deletions(-)
 create mode 100644 include/uapi/linux/btrfs_tree.h

-- 
2.7.1

