Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:34775 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751161AbbIKBVR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Sep 2015 21:21:17 -0400
Subject: Re: [PATCH v2 0/9] free space B-tree
To: Omar Sandoval <osandov@osandov.com>, <linux-btrfs@vger.kernel.org>
References: <cover.1441131625.git.osandov@fb.com>
 <cover.1441309178.git.osandov@fb.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55F22C89.7060502@cn.fujitsu.com>
Date: Fri, 11 Sep 2015 09:21:13 +0800
MIME-Version: 1.0
In-Reply-To: <cover.1441309178.git.osandov@fb.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Omar,

Thanks for your patchset.
Quite a nice one, and debug-tree can give better output on space cache.
With current implement, space cache is near a black box in debug-tree 
output.

And current on disk format is not quite easy to understand.(In fact, 
space cache is restored in tree root, as a NODATACOW inode, quite wired)

Also, it should provide a quite good base for rework inode cache for 
future development.


But I'm still a little concerned about the performance.

One of the problem using b-tree is, now we need to use 
btrfs_search_slot() to do modification, that means we will do 
level-based tree lock and COW.
Personally speaking, I'd like to blame that for the slow metadata 
performance of btrfs.
(Yeah personal experience, may be wrong again)

So with the new implement every space cache operation will causing tree 
lock and cow.
Unlike the old wired structure, which is done in a NODATACOW fashion.

Hopes I'm wrong about it (and it seems I'm always wrong about all these 
assumption based performance thing).

Thanks,
Qu


Omar Sandoval wrote on 2015/09/03 12:44 -0700:
> Here's version 2 of the the free space B-tree patches, addressing
> Josef's review from the last round, which you can find here:
> http://www.spinics.net/lists/linux-btrfs/msg46713.html
>
> Changes from v1->v2:
>
> - Cleaned up a bunch of unnecessary instances of "if (ret) goto out; ret = 0"
> - Added aborts in the free space tree code closer to the site the error
>    is encountered: where we add or remove block groups, add or remove
>    free space, and also when we convert formats
> - Moved loading of the free space tree into caching_thread() and added a
>    new patch 4 in preparation for it
> - Commented a bunch of stuff in the extent buffer bitmap operations and
>    refactored some of the complicated logic
> - Added sanity tests for the extent buffer bitmap operations and free
>    space tree (patches 2 and 6)
> - Added Josef's Reviewed-by tags
>
> Omar Sandoval (9):
>    Btrfs: add extent buffer bitmap operations
>    Btrfs: add extent buffer bitmap sanity tests
>    Btrfs: add helpers for read-only compat bits
>    Btrfs: refactor caching_thread()
>    Btrfs: introduce the free space B-tree on-disk format
>    Btrfs: implement the free space B-tree
>    Btrfs: add free space tree sanity tests
>    Btrfs: wire up the free space tree to the extent tree
>    Btrfs: add free space tree mount option
>
>   fs/btrfs/Makefile                      |    5 +-
>   fs/btrfs/ctree.h                       |  107 ++-
>   fs/btrfs/disk-io.c                     |   26 +
>   fs/btrfs/extent-tree.c                 |  112 ++-
>   fs/btrfs/extent_io.c                   |  183 +++-
>   fs/btrfs/extent_io.h                   |   10 +-
>   fs/btrfs/free-space-tree.c             | 1501 ++++++++++++++++++++++++++++++++
>   fs/btrfs/free-space-tree.h             |   71 ++
>   fs/btrfs/super.c                       |   24 +-
>   fs/btrfs/tests/btrfs-tests.c           |   52 ++
>   fs/btrfs/tests/btrfs-tests.h           |   10 +
>   fs/btrfs/tests/extent-io-tests.c       |  138 ++-
>   fs/btrfs/tests/free-space-tests.c      |   35 +-
>   fs/btrfs/tests/free-space-tree-tests.c |  570 ++++++++++++
>   fs/btrfs/tests/qgroup-tests.c          |   20 +-
>   include/trace/events/btrfs.h           |    3 +-
>   16 files changed, 2763 insertions(+), 104 deletions(-)
>   create mode 100644 fs/btrfs/free-space-tree.c
>   create mode 100644 fs/btrfs/free-space-tree.h
>   create mode 100644 fs/btrfs/tests/free-space-tree-tests.c
>
