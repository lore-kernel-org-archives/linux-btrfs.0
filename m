Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52958 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932177AbcBZRfU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Feb 2016 12:35:20 -0500
Date: Fri, 26 Feb 2016 18:35:07 +0100
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 4.4.1
Message-ID: <20160226173507.GS23746@suse.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

btrfs-progs 4.4.1 have been released, minor bugfixes.

Changes:

* find-root: don't skip the first chunk
* free-space-tree compat bits fix
* build: target symlinks
* documentation updates
* test updates

Not much updates for the pending patchset. I've tried to merge the mkfs feature
guessing patches but had to write them from scratch. The other pending
patchsets are in the integration branch. As my kernel works for next
merge window are almost done I hopefully will spend more time on progs
during next weeks.

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

David Sterba (4):
      btrfs-progs: fix compat_ro mask for free space tree
      btrfs-progs: tests: store checksums in /tmp
      btrfs-progs: tests: use common variables and helpers
      Btrfs progs v4.4.1

Hongxu Jia (1):
      btrfs-progs: fix symlink creation multiple times

Lakshmipathi.G (1):
      btrfs-progs: tests: do checksum verification with convert-tests

Mark Fasheh (1):
      btrfs-progs: Import interval tree implemenation from Linux v4.0-rc7.

Mike Gilbert (1):
      btrfs-progs: Makefile.in: Simplify/correct install-static

Qu Wenruo (5):
      btrfs-progs: volume: Fix a bug causing btrfs-find-root to skip first chunk
      btrfs-progs: Allow open_ctree to return fs_info even chunk tree is corrupted
      btrfs-progs: Add support for tree block operations on fs_info without roots
      btrfs-progs: find-root: Allow btrfs-find-root to search chunk root even chunk root is corrupted
      btrfs-progs: misc-test: Add regression test for find-root gives empty result

Satoru Takeuchi (3):
      btrfs-progs: Fix self-reference of man btrfs-subvolume
      btrfs-progs: describe btrfs-send requires read-only subvolume
      btrfs-progs: write down the meaning of BTRFS_ARG_BLKDEV

Tsutomu Itoh (2):
      btrfs-progs: doc: fix typo of some documents
      btrfs-progs: doc: fix size suffix in mkfs.btrfs

