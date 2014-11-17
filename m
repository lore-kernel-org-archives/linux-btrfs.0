Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:54341 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbaKQKhP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Nov 2014 05:37:15 -0500
Received: by mail-pd0-f171.google.com with SMTP id r10so20949481pdi.2
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Nov 2014 02:37:14 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        <linux-fsdevel@vger.kernel.org>, Omar Sandoval <osandov@osandov.com>
Subject: [RFC PATCH 0/6] btrfs: implement swap file support
Date: Mon, 17 Nov 2014 02:36:53 -0800
Message-Id: <cover.1416219974.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch series, based on 3.18-rc5, implements support for swap files on
BTRFS.

The standard swap file implementation uses the filesystem's implementation of
bmap() to get a list of physical blocks on disk, which the swap file code then
does I/O on directly without going through the filesystem. This doesn't work
for BTRFS, which is copy-on-write and therefore moves disk blocks around (COW
isn't the only thing that can shuffle around disk blocks: consider
defragmentation, balancing, etc.).

Swap-over-NFS introduced an interface through which a filesystem can arbitrate
swap I/O through address space operations:

- swap_activate() is called by swapon() and informs the address space that the
  given file is going to be used for swap, so it should take adequate measures
  like reserving space on disk and pinning block lookup information in memory
- swap_deactivate() is used to clean up on swapoff()
- readpage() is used to page in (read a page from disk)
- direct_IO() is used to page out (write a page out to disk)

This patch series uses that interface to add support for swap files to BTRFS.

A few things make the implementation a bit hairier than simply adding a
btrfs_swap_activate. In particular, pages in the swap cache behave a bit
differently:

- Swapcache pages store a swp_entry_t in ->private, and the VM system
  doesn't like PG_private being set on swapcache pages. This means that the
  private field isn't available for the filesystem.
- Swapcache pages don't use the ->mapping or ->index fields; swapcache
  pages must use page_file_{mapping,index,offset} instead, which uses the
  swp_entry_t in ->private to get the same information. This calls for some
  nasty global search and replace.

A few other considerations specific to BTRFS:

- We can't do direct I/O on compressed or inline extents.
- Supporting COW swapfiles might come with some weird edge cases? This is
  something that is probably good for discussion.

This functionality is tenuously tested in a virtual machine with some
artificial workloads. I'd really appreciate any comments.

Omar Sandoval (6):
  btrfs: convert uses of ->mapping and ->index to wrappers
  btrfs: don't allow -C or +c chattrs on a swap file
  btrfs: don't set ->private on swapcache pages
  btrfs: don't check the cleancache for swapcache pages
  btrfs: don't mark extents used for swap as up to date
  btrfs: enable swap file support

 fs/btrfs/disk-io.c    |  16 ++---
 fs/btrfs/extent_io.c  | 174 ++++++++++++++++++++++++++++----------------------
 fs/btrfs/file-item.c  |   6 +-
 fs/btrfs/inode.c      | 119 +++++++++++++++++++++++++++-------
 fs/btrfs/ioctl.c      |  60 ++++++++++-------
 fs/btrfs/relocation.c |   2 +-
 fs/btrfs/scrub.c      |   4 +-
 7 files changed, 242 insertions(+), 139 deletions(-)

-- 
2.1.3

