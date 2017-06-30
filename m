Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55761 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751581AbdF3QiK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Jun 2017 12:38:10 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 4.11.1
Date: Fri, 30 Jun 2017 18:36:56 +0200
Message-Id: <20170630163656.2443-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

btrfs-progs version 4.11.1 have been released. It's a small release with
handful of fixes and minor other updates.

Changes:
  * image: restoring from multiple devices
  * dev stats: make --check option work
  * check: fix false alert with extent hole on a NO_HOLE filesystem
  * check: lowmem mode, fix false alert in case of mixed inline and compressed
    extent
  * convert: work with large filesystems (many TB)
  * convert: fix overwriting of eb header flags
  * convert: do not clear NODATASUM flag in inodes when run with --no-datasum
  * docs updates
  * build: sync Android.mk with Makefile
  * tests:
    * new tests
    * fix 008 and 009, shell quotation mistake

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

David Sterba (7):
      btrfs-progs: docs: update formatting of btrfs-rescue
      btrfs-progs: docs: update formatting of btrfs-property
      btrfs-progs: docs: fix sentence for no-dump file attribute
      btrfs-progs: docs: update note about device deletion
      btrfs-progs: build: sync recent makefile changes to android.mk
      btrfs-progs: update CHANGES for v4.11.1
      Btrfs progs v4.11.1

Filipe Manana (2):
      btrfs-progs: Fix restoring image from multi devices fs into single device
      btrfs-progs: test for restoring multiple devices fs into a single device

Hans van Kranenburg (1):
      btrfs-progs: send operates on ro snapshots only

Kasijjuf (3):
      btrfs-progs: docs: Expand confusing abbreviation in documentation
      btrfs-progs: docs: Wrong section in ref to manpage
      btrfs-progs: docs: replace <dev> with <device>

Lakshmipathi.G (3):
      btrfs-progs: Fix 'btrfs device stats --check' cli option
      btrfs-progs: convert: widen int types in convert context
      btrfs-progs: convert: Add larger device support

Liu Bo (3):
      Btrfs-progs: man: nodesize must be power of 2 now
      Btrfs-progs: convert: do not clear nodatasum flag in inode item
      Btrfs-progs: convert: do not clear header rev

Lu Fengqi (1):
      btrfs-progs: lowmem check: Fix false alert about file extent interrupt

Qu Wenruo (2):
      btrfs-progs: check: Fix false alert about EXTENT_DATA that shouldn't be a hole
      btrfs-progs: tests: Add test case to check file hole extents with NO_HOLES flag

Tsutomu Itoh (1):
      btrfs-progs: tests: remove variable quotation from convert-tests

