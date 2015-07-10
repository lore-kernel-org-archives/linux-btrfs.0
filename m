Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60573 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932209AbbGJNnt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jul 2015 09:43:49 -0400
Date: Fri, 10 Jul 2015 15:43:48 +0200
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 4.1.1
Message-ID: <20150710134348.GB15535@suse.cz>
Reply-To: dsterba@suse.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

btrfs-progs 4.1.1 have been released, a few bugfixes and enhancements.

* bugfixes
  - defrag: threshold overflow fix
  - fsck:
    - check if items fit into the leaf space
    - fix wrong nbytes
  - mkfs:
    - create only desired block groups for single device
    - preparatory work for fix on multiple devices

* enhancements
  - new alias for 'device delete': 'device remove'

* other
  - fix compilation on old gcc (4.3)
  - documentation updates
  - debug-tree: print nbytes
  - test: image for corrupted nbytes
  - corupt-block: let it kill nbytes

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

Adam Borowski (1):
      btrfs-progs: doc: mkfs.btrfs: document -O^

David Sterba (15):
      btrfs-progs: defrag, check target extent earlier
      btrfs-progs: doc: update defrag page
      btrfs-progs: no extra newline between aliased commands in help text
      btrfs-progs: drop argument from attribute deprecated
      btrfs-progs: check for item end outside of leaf
      btrfs-progs: add 'device remove' alias to completion
      btrfs-progs: move make_btrfs arguments to a struct
      btrfs-progs: drop unused parameter from make_btrfs
      btrfs-progs: split metadata group creation out of make_root_dir
      btrfs-progs: move transaction start/commit out of make_root_dir
      btrfs-progs: split data block group creation out of make_root_dir
      btrfs-progs: drop unused argument from create_raid_groups
      btrfs-progs: mkfs: create only desired block groups for single device
      btrfs-progs: let corrupt-block kill nbytes
      Btrfs progs v4.1.1

Omar Sandoval (2):
      btrfs-progs: replace struct cmd_group->hidden with flags
      btrfs-progs: alias btrfs device delete to btrfs device remove

Patrik Lundquist (2):
      btrfs-progs: fix defrag threshold overflow
      btrfs-progs: inspect: Fix out of bounds string termination.

Qu Wenruo (9):
      btrfs-progs: Add nbytes output for print-tree and reformat inode output
      btrfs-progs: fsck: Add repair function for I_ERR_FILE_WRONG_NBYTES
      btrfs-progs: tests: Add test case for I_ERR_FILE_WRONG_NBYTES repair
      btrfs-progs: disk-io: Support commit transaction on chunk tree
      btrfs-progs: extent-tree: Introduce free_block_group_item function
      btrfs-progs: extent-tree: Introduce functions to free dev extents in a chunk
      btrfs-progs: extent-tree: Introduce functions to free chunk items
      btrfs-progs: extent-tree: Introduce functions to free in-memory block group cache
      btrfs-progs: extent-tree: Introduce btrfs_free_block_group function

Tsutomu Itoh (1):
      btrfs-progs: doc: fix short explanation of restore in btrfs
