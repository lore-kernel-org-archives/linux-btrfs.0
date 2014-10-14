Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39247 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755562AbaJOA4m (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Oct 2014 20:56:42 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id D3135AB07
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Oct 2014 00:56:40 +0000 (UTC)
Date: Tue, 14 Oct 2014 14:17:17 +0200
From: David Sterba <dsterba@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs-progs pre-release 3.17
Message-ID: <20141014121717.GQ22943@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

the 3.17 release is almost ready, I've updated the git repositories at

http://repo.or.cz/w/btrfs-progs-unstable/devel.git
https://github.com/kdave/btrfs-progs

tagged as 3.17-rc3 (7fd6d933528f30a). Please give it some testing, I'm about to
do a release in 1-2 days.

Among other fixes and updates, there are many fsck improvements.

User visible changes:
* check: --init-csum-tree acutally does something useful, rebuilds the whole
  csum tree
* /dev scanning for btrfs devices is gone
* /proc/partitions scanning is gone, blkid is used exclusively
* new subcommand 'subvolume sync'
* filesystem df: new options to set unit format
* convert: allow to copy label from the origin, or specify a new one

I don't have concrete plans for .1 release, only that it'll happen ~two weeks
from now, fixups, cleanups, doc updates and small-sized changes will be merged.

There are 55 patches in total, shortlog:

Adam Buchbinder (1):
      btrfs-progs: Remove extra 'const' modifiers; they don't do anything.

Alexandre Oliva (2):
      btrfs-progs: repair: remove recowed entry from the to-recow list
      btrfs-progs: check: do not dereference tree_refs as data_refs

Anand Jain (5):
      btrfs-progs: force overwrite should wipe stale SB
      btrfs-progs: remove BTRFS_SCAN_PROC scan method
      btrfs-progs: remove scan_for_btrfs()
      btrfs-progs: do a separate probe for transient replacing device
      btrfs-progs: fix uninitialized warning in btrfs_calc_stripe_index

David Sterba (9):
      btrfs-progs: wait until all subvolumes are cleaned
      btrfs-progs: make free space checker work on non-4k sectorsize filesystems
      btrfs-progs: scrub, detect stale information in the status file
      btrfs-progs: debug: print more info about inode
      btrfs-progs: print B for bytes
      btrfs-progs: extend pretty printers with unit mode
      btrfs-progs: add options to tune units for fi df output
      btrfs-progs: convert: set label or copy from origin
      btrfs-progs: document the limit balance filter

Eric Sandeen (3):
      btrfs-progs: scan /proc/partitions not all of /dev with "-d"
      btrfs-progs: don't fall back to recursive /dev scan
      btrfs-progs: remove BTRFS_SCAN_DEV and btrfs_scan_one_dir

Eryu Guan (1):
      btrfs-progs: return error when canonicalize_path failed

Filipe David Borba Manana (1):
      btrfs-progs: check, fix csum check in the presence of non-inlined refs

Gui Hecheng (2):
      btrfs-progs: fix BUG_ON when all devices under seed fs are missing
      btrfs-progs: fix device missing of btrfs fi show with seed devices

Gustavo Zacarias (1):
      btrfs-progs: add option to disable backtrace usage

Josef Bacik (18):
      btrfs-progs: rebuild the crc tree with --init-csum-tree
      btrfs-progs: skip extent rebuild test if no testdev
      Btrfs-progs: repair missing dir index
      Btrfs-progs: pull back backref.c and fix it up
      Btrfs-progs: break out rbtree util functions
      Btrfs-progs: update rbtree libs
      Btrfs-progs: reset chunk state if we restart check
      Btrfs-progs: re-search tree root if it changes
      Btrfs-progs: delete bogus dir indexes
      Btrfs-progs: add a dummy backref if our location is wrong
      Btrfs-progs: deal with mismatch index between dir index and inode ref
      Btrfs-progs: add ability to corrupt dir items
      btrfs-progs: corrupt btrfs items in btrfs-corrup-block
      btrfs-progs: add shift_items to btrfs-corrupt-block
      btrfs-progs: add the ability to fix shifted item offsets
      btrfs-progs: check blocks when checking fs roots
      btrfs-progs: make fsck deal with bogus items
      Btrfs-progs: lookup all roots that point to a corrupt block

Naohiro Aota (1):
      btrfs-progs: do not reclaim extent buffer

Qu Wenruo (2):
      btrfs-progs: Fix malloc size for superblock.
      btrfs-progs: Check the consistence between the parent node and child node/leaf.

Wang Shilong (9):
      btrfs-progs: fsck: avoid pinning same block several times
      btrfs-progs: fsck: clear out log tree in repair mode
      btrfs-progs: fsck: remove unfriendly BUG_ON() for searching tree failure
      btrfs-progs: fsck: finish transaction commit if repair error out
      btrfs-progs: fsck: add ability to check reloc roots
      btrfs-progs: super-recover: fix double free fs_devices memory
      Btrfs-progs: fsck: disallow partial opening if critical roots corrupted
      Btrfs-progs: fsck: only allow partial opening under repair mode
      Btrfs-progs: fsck: deal with corrupted csum root

