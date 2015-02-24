Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33495 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467AbbBXKr2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Feb 2015 05:47:28 -0500
Received: by pabkx10 with SMTP id kx10so35199881pab.0
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Feb 2015 02:47:27 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v2 0/3] btrfs: ENOMEM bugfixes
Date: Tue, 24 Feb 2015 02:47:03 -0800
Message-Id: <cover.1424773781.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, everyone,

This patch series fixes a few bugs that occur under low memory conditions.
These were exposed by a change in behavior of GFP_NOFS allocations in 3.19-rc7,
by commit 9879de7373fc ("mm: page_alloc: embed OOM killing naturally into
allocation slowpath"). While the mm people sort that out, we can fix these
issues, which are bugs no matter what the outcome there is.

Here's a quick script which reproduces these bugs. With the patches applied, the
filesystem will drop into read-only mode instead of blowing up.

----
#!/bin/sh

cgcreate -g memory:enomem
MEM=$((64 * 1024 * 1024))
echo $MEM > /sys/fs/cgroup/memory/enomem/memory.limit_in_bytes

cgexec -g memory:enomem ~/xfstests/ltp/fsstress -p128 -n999999999 -d /mnt/test &
trap "killall fsstress; exit 0" SIGINT SIGTERM

while true; do
	cgexec -g memory:enomem python -c '
l = []
while True:
    l.append(0)'
done
----

Version 2 rebases on top of 4.0-rc1, has a simpler fix for the
alloc_extent_buffer race, expands the commit messages to mention changed
comments, and adds Liu Bo's Reviewed-by.

Thanks!

Omar Sandoval (3):
  btrfs: handle ENOMEM in btrfs_alloc_tree_block
  btrfs: fix race on ENOMEM in alloc_extent_buffer
  btrfs: check io_ctl_prepare_pages return in __btrfs_write_out_cache

 fs/btrfs/extent-tree.c      | 41 ++++++++++++++++++++++++++++-------------
 fs/btrfs/extent_io.c        |  3 ++-
 fs/btrfs/free-space-cache.c | 10 ++++++----
 3 files changed, 36 insertions(+), 18 deletions(-)
-- 
2.3.0

