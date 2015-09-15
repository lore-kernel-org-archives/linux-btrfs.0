Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:35373 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbbIOC4m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Sep 2015 22:56:42 -0400
Received: by pacfv12 with SMTP id fv12so164841579pac.2
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2015 19:56:42 -0700 (PDT)
Date: Mon, 14 Sep 2015 19:56:39 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 0/9] Btrfs: free space B-tree
Message-ID: <20150915025639.GB4677@mew>
References: <cover.1442209006.git.osandov@osandov.com>
 <55F6E54C.8040404@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55F6E54C.8040404@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 14, 2015 at 11:18:36AM -0400, Austin S Hemmelgarn wrote:
> On 2015-09-14 02:04, Omar Sandoval wrote:
> >Hi, everyone,
> >
> >I went back and fixed the issues that came up since v2. Changes below. I
> >removed Josef's Reviewed-by on patch 9 because it was completely
> >rewritten to change the mount options like Dave suggested. These are
> >still based on 4.2
> >
> >Thanks!
> >
> >Changes from v2->v3:
> >
> >- Fixed a warning in the free space tree sanity tests caught by Zhao Lei.
> >- Moved the addition of a block group to the free space tree to occur either on
> >   the first attempt to modify the free space for the block group or in
> >   btrfs_create_pending_block_groups(), whichever happens first. This avoids a
> >   deadlock (lock recursion) when modifying the free space tree requires
> >   allocating a new block group. In order to do this, it was simpler to change
> >   the on-disk semantics: the superblock stripes will now appear to be free space
> >   according to the free space tree, but load_free_space_tree() will still
> >   exclude them when building the in-memory free space cache.
> >- Changed the free_space_tree option to space_cache=v2 and made clear_cache
> >   clear the free space tree. If the free space tree has been created,
> >   the mount will fail unless space_cache=v2 or nospace_cache,clear_cache
> >   is given because we cannot allow the free space tree to get out of
> >   date.
> >- Did a once-over of the code and caught a couple of error handling typos.
> >
> >v2: http://www.spinics.net/lists/linux-btrfs/msg46796.html
> >
> >Changes from v1->v2:
> >
> >- Cleaned up a bunch of unnecessary instances of "if (ret) goto out; ret = 0"
> >- Added aborts in the free space tree code closer to the site the error is
> >   encountered: where we add or remove block groups, add or remove free space,
> >   and also when we convert formats
> >- Moved loading of the free space tree into caching_thread() and added a new
> >   patch 3 in preparation for it
> >- Commented a bunch of stuff in the extent buffer bitmap operations and
> >   refactored some of the complicated logic
> >
> >v1: http://www.spinics.net/lists/linux-btrfs/msg46713.html
> >
> >Omar Sandoval (9):
> >   Btrfs: add extent buffer bitmap operations
> >   Btrfs: add extent buffer bitmap sanity tests
> >   Btrfs: add helpers for read-only compat bits
> >   Btrfs: refactor caching_thread()
> >   Btrfs: introduce the free space B-tree on-disk format
> >   Btrfs: implement the free space B-tree
> >   Btrfs: add free space tree sanity tests
> >   Btrfs: wire up the free space tree to the extent tree
> >   Btrfs: add free space tree mount option
> >
> >  fs/btrfs/Makefile                      |    5 +-
> >  fs/btrfs/ctree.h                       |  157 +++-
> >  fs/btrfs/disk-io.c                     |   38 +
> >  fs/btrfs/extent-tree.c                 |   98 +-
> >  fs/btrfs/extent_io.c                   |  183 +++-
> >  fs/btrfs/extent_io.h                   |   10 +-
> >  fs/btrfs/free-space-tree.c             | 1581 ++++++++++++++++++++++++++++++++
> >  fs/btrfs/free-space-tree.h             |   72 ++
> >  fs/btrfs/super.c                       |   56 +-
> >  fs/btrfs/tests/btrfs-tests.c           |   52 ++
> >  fs/btrfs/tests/btrfs-tests.h           |   10 +
> >  fs/btrfs/tests/extent-io-tests.c       |  138 ++-
> >  fs/btrfs/tests/free-space-tests.c      |   35 +-
> >  fs/btrfs/tests/free-space-tree-tests.c |  571 ++++++++++++
> >  fs/btrfs/tests/qgroup-tests.c          |   20 +-
> >  include/trace/events/btrfs.h           |    3 +-
> >  16 files changed, 2922 insertions(+), 107 deletions(-)
> >  create mode 100644 fs/btrfs/free-space-tree.c
> >  create mode 100644 fs/btrfs/free-space-tree.h
> >  create mode 100644 fs/btrfs/tests/free-space-tree-tests.c
> >
> I've tested this in a couple of different VM's and got noticeable
> performance improvements in both general usage and mount times.  I also
> threw everything I can think of at it (short of attempting to craft
> filesystem images specifically to break it), and nothing broke, so:
> 
> Tested-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
> 

Thank you for trying this out, I really appreciate it.

-- 
Omar
