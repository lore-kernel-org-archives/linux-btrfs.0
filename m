Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50335 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752072AbcJCRTa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 3 Oct 2016 13:19:30 -0400
From: David Sterba <dsterba@suse.com>
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: [PULl] Btrfs, free-space-tree fixes for 4.9
Date: Mon,  3 Oct 2016 19:19:24 +0200
Message-Id: <cover.1475513880.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

this pull contains the important fixes to the bitmap handling when the
free-space-tree feature is enabled on bigendian machines. Patches were tested
on various arches, we still might need more testing on sparc64 as there were
some problems unrelated to this patchset. Please pull, thanks.

----------------------------------------------------------------
The following changes since commit 08895a8b6b06ed2323cd97a36ee40a116b3db8ed:

  Linux 4.8-rc8 (2016-09-25 18:47:13 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git fst-fixes

for you to fetch changes up to 0e6757859efea6ed919fc37e4ee468634220b2d2:

  btrfs: tests: uninline member definitions in free_space_extent (2016-10-03 18:52:15 +0200)

----------------------------------------------------------------
David Sterba (2):
      btrfs: tests: constify free space extent specs
      btrfs: tests: uninline member definitions in free_space_extent

Omar Sandoval (5):
      Btrfs: fix free space tree bitmaps on big-endian systems
      Btrfs: fix mount -o clear_cache,space_cache=v2
      Btrfs: catch invalid free space trees
      Btrfs: fix extent buffer bitmap tests on big-endian systems
      Btrfs: expand free space tree sanity tests to catch endianness bug

 fs/btrfs/ctree.h                       |   3 +-
 fs/btrfs/disk-io.c                     |  33 +++---
 fs/btrfs/extent_io.c                   |  64 +++++++----
 fs/btrfs/extent_io.h                   |  22 ++++
 fs/btrfs/free-space-tree.c             |  19 ++--
 fs/btrfs/tests/extent-io-tests.c       |  87 ++++++++-------
 fs/btrfs/tests/free-space-tree-tests.c | 189 +++++++++++++++++++--------------
 include/uapi/linux/btrfs.h             |  12 ++-
 8 files changed, 272 insertions(+), 157 deletions(-)
