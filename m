Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50093 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbcCaPUp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Mar 2016 11:20:45 -0400
Date: Thu, 31 Mar 2016 17:20:08 +0200
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 4.5.1
Message-ID: <20160331152008.GC6230@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

btrfs-progs 4.5.1 have been released.  A bugfix release, several build
fixes, a few minor fixes, improvements or preparatory work that do not
need to be delayed.

There's one user visible change:

* mkfs: allow DUP on multi-device filesystem

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

Anand Jain (6):
      btrfs-progs: rearrange subvolume functions together
      btrfs-progs: move test_issubvolume() to utils.c
      btrfs-progs: remove duplicate function __is_subvol()
      btrfs-progs: move get_subvol_name() to utils.c
      btrfs-progs: create get_subvol_info()
      btrfs-progs: rename get_subvol_name() to subvol_strip_mountpoint()

Austin S. Hemmelgarn (1):
      btrfs-progs: fix fi du so it works in more cases

David Sterba (14):
      btrfs-progs: fragments: fix build
      btrfs-progs: utils: make more arguments const
      btrfs-progs: cleanup block group helpers types
      btrfs-progs: fix build of standalone utilities after clean
      btrfs-progs: tests: introduce mustfail helper
      btrfs-progs: tests: add misc 014-filesystem-label
      btrfs-progs: make error message from add_clone_source more generic
      btrfs-progs: mkfs: allow DUP on multidev fs, only warn
      btrfs-progs: rename __strncpy__null  to __strncpy_null
      btrfs-progs: use safe copy for label buffer everywhere
      btrfs-progs: fix fd leak in get_subvol_info
      btrfs-progs: tests: update 001-basic-profiles, dup on multidev fs
      btrfs-progs: docs: update mkfs page for dup on multidev fs
      Btrfs progs v4.5.1

Julio Montes (1):
      btrfs-progs: fix unknown type name 'u64' in gccgo

Noah Massey (1):
      btrfs-progs: build: fix static standalone utilities

Petros Angelatos (1):
      btrfs-progs: utils: make sure set_label_mounted uses correct length buffers

Satoru Takeuchi (1):
      btrfs-progs: mkfs: fix an error when using DUP on multidev fs

Tsutomu Itoh (1):
      btrfs-progs: send: fix handling of multiple snapshots
