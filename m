From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: [PATCH v2 0/9] btrfs-progs: some fixes for bugs spotted by valgrind
Date: Sat,  4 Jun 2011 11:19:15 +0300
Message-ID: <1307175564-25355-1-git-send-email-slyfox@gentoo.org>
Cc: linux-btrfs@vger.kernel.org, Sergei Trofimovich <slyfox@gentoo.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

tmp branch recently got very nice feature: 'mkfs.btrfs -r /some/directory'.

It's very useful, when you need to creare minimal root: /bin/sh and fs_mark.

But there is another hidden feature! As '-r' can create whole filesystem
we can effectively valgrind a lot of code paths in btrfs and pick bugs.

This patch series is mostly (with one exception) dumb obvous holes plugs
(sometimes they are backports from kernel).

Patchset based on
    git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git#tmp

    commit e6bd18d8938986c997c45f0ea95b221d4edec095
    Author: Christoph Hellwig <hch@lst.de>
    Date:   Thu Apr 21 16:24:07 2011 -0400

First off the exception:

In order to make --mixed produce proper filesystems with meta+data only
blocks (and not meta+data/data ones, which confused space_cache and led
to an oops for me) I ask to consider for pulling Arne's patch:
> Subject: [PATCH v2 1/9] btrfs progs: fix extra metadata chunk allocation in --mixed case

The rest of patches should be obvoius. They don't fix all the fair valgrind
compaints, but reduce them severely.

Changes since v1:
  - "[PATCH 8/9] mkfs.btrfs: fix memory leak caused by 'scandir()' calls":
    'free_namelist()' now works correctly if 'count == -1'. It happens
    when 'free_namelist()' is called right after 'scandir()' returning
    an error.

Some stats:

    convert.c     |    2 +-
    extent-tree.c |    7 ++++---
    extent_io.c   |    1 +
    file-item.c   |    1 +
    mkfs.c        |   39 ++++++++++++++++++++++++++++++++++++---
    5 files changed, 43 insertions(+), 7 deletions(-)

Arne Jansen (1):
      btrfs progs: fix extra metadata chunk allocation in --mixed case

Sergei Trofimovich (8):
      btrfs-convert: fix typo: 'all inode' -> 'all inodes'
      mkfs.btrfs: fail on scandir error (-r mode)
      mkfs.btrfs: return some defined value instead of garbage when lookup checksum
      mkfs.btrfs: fix symlink names writing
      mkfs.btrfs: write zeroes instead on uninitialized data.
      mkfs.btrfs: free buffers allocated by pretty_sizes
      mkfs.btrfs: fix memory leak caused by 'scandir()' calls
      mkfs.btrfs: fix error text in '-r' mode
