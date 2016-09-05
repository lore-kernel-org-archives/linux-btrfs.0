Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60727 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933383AbcIEKdV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Sep 2016 06:33:21 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 4.7.2
Date: Mon,  5 Sep 2016 12:31:50 +0200
Message-Id: <1473071510-19693-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

btrfs-progs 4.7 have been released. There's one notable fix, for the false
warning from checker about backref mismatches, first reported by Chris Murphy
(https://bugzilla.kernel.org/show_bug.cgi?id=155791). Update to 4.7.2 is
required before using --repair.

The other part are current fixes resulting from fuzzing.

Changes:
  * check:
    * urgent fix: false report of backref mismatches; do not --repair
      last unaffected version 4.6.1 (code reverted to that state)
  * fuzzing and fixes
    * added more sanity checks for various structures
    * testing images added
  * build: udev compatibility: do not install .rules on version < 190
  * other:
    * dump-super: do not crash on garbage value in csum_type
    * minor improvements in messages and help strings
  * documentation:
    * filesystem features


Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

David Sterba (16):
      btrfs-progs: tests README: fuzzed images
      btrfs-progs: docs: describe filesystem features
      btrfs-progs: drop permission arg from non-creating open
      btrfs-progs: dump-super: detect invalid checksum type
      btrfs-progs: tests: add 015-dump-super-garbage
      btrfs-progs: print help test to stdout
      btrfs-progs: image: more verbose syntax erors for -t and -c
      btrfs-progs: tests: add fuzzed image for invalid sub_stripe value
      btrfs-progs: tests: add fuzzed image for invalid sys_array and stripe_len
      btrfs-progs: tests: add fuzzed image for invalid chunk sectorsize
      btrfs-progs: tests: add fuzzed image for heap overflow while checking chunk items
      btrfs-progs: build: add ASAN to debugging features
      Revert "btrfs-progs: check: switch to iterating over the backref_tree"
      Revert "btrfs-progs: check: supplement extent backref list with rbtree"
      btrfs-progs: update CHANGES for 4.7.2
      Btrfs progs v4.7.2

Jeff Mahoney (1):
      btrfs-progs: build: only install udev rules for udev >= 190

Qu Wenruo (12):
      btrfs-progs: Enhance and export print_objectid function
      btrfs-progs: Enhance and export print_key_type function
      btrfs-progs: check: ignore invalid key in invalid root
      btrfs-progs: Do extra chunk check before processing chunk item
      btrfs-progs: fuzz-test: Add image for wrong chunk item in root tree
      btrfs-progs: check: do early check for read_tree_block
      btrfs-progs: fuzz-test: Add image for unaligned tree block ptr
      btrfs-progs: fsck: Check drop level before walking through fs tree
      btrfs-progs: fuzz-test: Add test case for invalid drop level
      btrfs-progs: fsck: Check bytenr alignment for extent item
      btrfs-progs: fsck: Avoid abort and BUG_ON in add_tree_backref
      btrfs-progs: fuzz-test: Add test case for unaligned extent item

