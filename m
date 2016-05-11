Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37527 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbcEKOsD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 May 2016 10:48:03 -0400
Date: Wed, 11 May 2016 16:47:39 +0200
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 4.5.3
Message-ID: <20160511144739.GF29353@suse.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

btrfs-progs 4.5.2 have been released. A bugfix release.

Changes:
  * ioctl: fix unaligned access in buffer from TREE_SEARCH; might cause SIGBUS
    on architectures that do not support unaligned access and do not performa
    any fixups
  * improved validation checks of superblock and chunk-related structures
  * subvolume sync: fix handling of -s option
  * balance: adjust timing of safety delay countdown with --full-balance
  * rescue super-recover: fix reversed condition check
  * check: fix bytes_used accounting
  * documentation updates: mount options, scrub, send, receive, select-super,
    check, mkfs
  * testing: new fuzzed images, for superblock and chunks

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:
David Sterba (18):
      btrfs-progs: check: pass a template to add_extent_rec_nolookup
      btrfs-progs: check: simplify assignments in add_extent_rec_nolookup
      btrfs-progs: check: reduce size of extent_record
      btrfs-progs: check: refactor add_extent_rec, reduce argument count
      btrfs-progs: check: check stripe crossing against nodesize
      btrfs-progs: fi du: switch to negative error codes
      btrfs-progs: kerncompat: introduce get_unaligned helpers
      btrfs-progs: add getters for ioctl search_header
      btrfs-progs: use ioctl search headers everywhere
      btrfs-progs: docs: update btrfs-man5
      btrfs-progs: docs: update btrfs-scrub
      btrfs-progs: docs: update btrfs-send
      btrfs-progs: docs: update btrfs-receive
      btrfs-progs: docs: update btrfs-select-super
      btrfs-progs: docs: update btrfs-check
      btrfs-progs: docs: clarify why mkfs selects single for SSDs
      btrfs-progs: update CHANGES for 4.5.3
      Btrfs progs v4.5.3

Liu Bo (5):
      btrfs-progs: fix incorrect flag check while recovering super
      btrfs-progs: add validation checks for chunk loading
      btrfs-progs: add three more validation checks for superblock
      btrfs-progs: replace printf with message helpers in check_super
      btrfs-progs: add fuzzed testing images, superblock and chunks

Marek Rusinowski (1):
      btrfs-progs: subvolume sync: fix handling of -s option

Noah Massey (1):
      btrfs-progs: Adjust timing of safety delay countdown

Qu Wenruo (1):
      btrfs-progs: check: fix found bytes accounting error

Satoru Takeuchi (1):
      btrfs-progs: prop: convert error messages to use error()

