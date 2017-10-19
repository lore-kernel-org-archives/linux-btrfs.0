Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:40251 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751118AbdJSFlp (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Thu, 19 Oct 2017 01:41:45 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, nborisov@suse.com
Subject: [PATCH v2 0/6] Rootdir refactor and small bug fixes
Date: Thu, 19 Oct 2017 13:41:32 +0800
Message-Id: <20171019054138.13965-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry for the v2 patchset, just added a new 3-line patch.
But since it can screw up bisect, I re-send the whole patchset, to make
the new patch just before mkfs return value fix, so bisect will work as
it used to do.


First 4 patches are small bug fixes which can be applied even we don't
touch the functionality of --rootdir.

The last two patches will refactor --rootdir related functions ,mainly
size_sourcedir() and make_image(), to mkfs/rootdir.[ch].
And rename them to btrfs_mkfs_size_dir() and btrfs_mkfs_fill_dir()
respectively.
Functionality is not changed at all, so it will still shrink the device
or using the first 1M reserved space.

This moved about 700 lines, which reduced about 1/3 of original mkfs.c.

And by moving this ancient code to its own files, I also fixed several
small nits exposed by checkpatch script.

This provides a clean environment for later rootdir rework.

changelog:
v2:
  Add a new fix, to avoid mkfs return 1. The rest doesn't change.
  Add reviewed-by tag.

Qu Wenruo (6):
  btrfs-progs: Avoid BUG_ON for chunk allocation when ENOSPC happens
  btrfs-progs: mkfs: Avoid positive return value from
    cleanup_temp_chunks
  btrfs-progs: mkfs: Fix overwritten return value for mkfs
  btrfs-progs: mkfs: Error out gracefully for --rootdir
  btrfs-progs: mkfs: Move image creation of rootdir to its own files
  btrfs-progs: mkfs: Move source dir size calculation to its own files

 Makefile       |   4 +-
 extent-tree.c  |   3 +-
 mkfs/main.c    | 713 +------------------------------------------------------
 mkfs/rootdir.c | 735 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 mkfs/rootdir.h |  32 +++
 volumes.c      |  18 +-
 6 files changed, 795 insertions(+), 710 deletions(-)
 create mode 100644 mkfs/rootdir.c
 create mode 100644 mkfs/rootdir.h

-- 
2.14.2

