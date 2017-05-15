Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49959 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S965759AbdEOPRV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 May 2017 11:17:21 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs pre-release 4.11-rc1
Date: Mon, 15 May 2017 17:16:16 +0200
Message-Id: <20170515151616.4716-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

a pre-release has been tagged. The 4.11 release is going to be a small one,
just a handful of updates. I was too busy with 4.12 kernel patches. Something
will have to change regarding btrfs-progs management, as the number of
unreviewed and unmerged patches is not decreasing. I'll write more about that
after 4.11 is out.

Changes:
  * receive: fix handling empty stream with -e (multi-stream)
  * send dump: fix printing long file names
  * stability fixes for: dump-super, print-tree, check
  * option parser updates: global opions (old xfstests will fail)
  * new and updated tests
  * documentation updates

ETA for 4.11 is in +2 days (2017-05-17).

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

Christian Brauner (3):
      btrfs-progs: fix btrfs send & receive with -e flag
      btrfs-progs: tests: misc/018-receive use receive -e to terminate on end marker
      btrfs-progs: receiv: fail on first -ENODATA only

Christophe de Dinechin (3):
      btrfs-progs: check: disambiguate between cases where add_tree_backref fails
      btrfs-progs: check: prevent attempt to insert extent record with max_size==0
      btrfs-progs: check: make max_size consistent with nr

David Sterba (10):
      btrfs-progs: docs: mount options, enhance ssd/nossd
      btrfs-progs: rework option parser to use getopt for global options
      btrfs-progs: README: sort bug reports means by preference
      btrfs-progs: docs: btrfs-replace, fix typo
      btrfs-progs: balance: minor wording adjustment for full balance warning
      btrfs-progs: docs: update formatting and wording for btrfs(5)
      btrfs-progs: fssum: fix warning, include correct header for major()
      btrfs-progs: tests: fix misc/019-receive-clones-on-munted-subvol
      btrfs-progs: update CHANGES for v4.11
      Btrfs progs v4.11-rc1

Evan Danaher (1):
      btrfs-progs: send: always print a space after path in dump

Hans van Kranenburg (2):
      btrfs-progs: docs: Fix missing newline in man 5 btrfs
      btrfs-progs: docs: Fix newlines for man btrfstune

Lakshmipathi.G (3):
      btrfs-progs: misc-tests: Superblock corruption and recovery using backup
      btrfs-progs: tests: add variable quotation to fsck-tests
      btrfs-progs: tests: add variable quotation to convert-tests

Lu Fengqi (4):
      btrfs-progs: dump-super: check array_size in print_sys_chunk_array
      btrfs-progs: print-tree: add validation to print_chunk
      btrfs-progs: tests: fssum, fix memory leak
      btrfs-progs: tests: Fix fuzz-test for bko-161821.raw.txt

Qu Wenruo (6):
      btrfs-progs: Fix memory leak when 0 sized block group item is found
      btrfs-progs: check: Fix memory leak in check_chunks_and_extents
      btrfs-progs: Use more strict check to read out tree root
      btrfs-progs: check: Avoid reading beyond item boundary for inode_ref
      btrfs-progs: check: Avoid reading beyond item boundary for dir_item and dir_index
      btrfs-progs: print-tree: Add leaf flags and backref revision output

Su Yue (1):
      btrfs-progs: check: Fix heap use after free

