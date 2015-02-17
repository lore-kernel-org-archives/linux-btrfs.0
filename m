Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:34814 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756809AbbBQKvZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Feb 2015 05:51:25 -0500
Received: by pabrd3 with SMTP id rd3so5496478pab.1
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Feb 2015 02:51:25 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Omar Sandoval <osandov@osandov.com>
Subject: [PATCH 0/3] btrfs: ENOMEM bugfixes
Date: Tue, 17 Feb 2015 02:51:06 -0800
Message-Id: <cover.1424168589.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

As it turns out, running with low memory is a really easy way to shake
out undesirable behavior in Btrfs. This can be especially bad when
considering that a memory limit is really easy to hit in a container
(e.g., by using cgroup memory.limit_in_bytes). Here's a simple script
that can hit several problems:

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

Ignoring for now the cases that drop the filesystem into read-only mode
with relatively little fuss, here are a few patches that fix some of the
low-hanging fruit. They apply to Linus' tree as of today.

Thanks!

Omar Sandoval (3):
  btrfs: handle ENOMEM in btrfs_alloc_tree_block
  btrfs: handle race on ENOMEM in alloc_extent_buffer
  btrfs: check io_ctl_prepare_pages return in __btrfs_write_out_cache

 fs/btrfs/extent-tree.c      | 41 ++++++++++++++++++++++++++++-------------
 fs/btrfs/extent_io.c        | 20 ++++++++++++++++----
 fs/btrfs/free-space-cache.c | 10 ++++++----
 3 files changed, 50 insertions(+), 21 deletions(-)

-- 
2.3.0

