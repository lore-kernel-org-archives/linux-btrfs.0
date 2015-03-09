Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59462 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbbCIMUj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Mar 2015 08:20:39 -0400
Date: Mon, 9 Mar 2015 13:20:37 +0100
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs pre-release 3.19-rc3
Message-ID: <20150309122037.GE5841@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

the 3.19 release is close, rc3 should be the last one. ETA for the release is
tomorrow, please give it, we can still add minor fixups. Then, I'm hoping to
return back to the more frequent releases, ie. bi-weekly and merge features of
smaller scale, cleanups and doc updates.

The next version is going to follow the kernel versioning scheme, so it'll be
4.x based.

Hilights since rc2:
- Josef's fixes to btrfs-image
- Qu Wenruo's updates to find-root

---
Shortlog:

Augusto Mecking Caringi (1):
      btrfs-progs: Add more detailed package bdependency information to INSTALL file

David Sterba (11):
      Merge remote-tracking branch 'remotes/josef/for-kdave' into v3.19.x
      Merge branch 'qu/find-root-v3-part1' into v3.19.x
      btrfs-progs: fix typo in OPEN_CTREE flag
      btrfs-progs: autoconf: define package url manually if not set
      btrfs-progs: version.sh: simplify printing the version
      btrfs-progs: convert: show progress by default
      btrfs-progs: update INSTALL
      btrfs-progs: convert, add option to disable progress
      btrfs-progs: convert, adjust help text formatting
      btrfs-progs: tests, clean up scripts
      Btrfs progs v3.19-rc3

Fan Chengniang (1):
      btrfs-progs: use correct the return value

Josef Bacik (16):
      Btrfs-progs: let btrfs-corrupt-block specify a root
      btrfs-progs: deal with no extent info
      Btrfs-progs: handle -eagain properly
      Btrfs-progs: read super properly in btrfs-image
      Btrfs-progs: don't try to repair reloc roots
      Btrfs-progs: don't check csums for data reloc root
      btrfs-progs: fix btrfs-image overlapping chunks
      Btrfs-progs: multi-thread btrfs-image restore
      Btrfs-progs: Introduce metadump_v2
      Btrfs-progs: only build space info's for the main flags
      Btrfs-progs: remove global transaction from fsck
      Btrfs-progs: unpin excluded extents as we fix things
      Btrfs-progs: make restore update dev items
      Btrfs-progs: make debug-tree spit out full_backref flag
      Btrfs-progs: skip opening all devices with restore
      Btrfs-progs: fix bad extent flag

Qu Wenruo (15):
      btrfs-progs: Cleanup check_tree_block() function
      btrfs-progs: Add support to suppress tree block csum error output
      btrfs-progs: Add new btrfs_open_ctree_flags CHUNK_ONLY
      btrfs-progs: Add new find-root.[ch] infrastructure
      btrfs-progs: Switch btrfs-find-root to use the new open_ctree flags
      btrfs-progs: Add better search generation judgment for btrfs-find-root
      btrfs-progs: Switch btrfs-find-root to use the find-root infrastructure
      btrfs-progs: Cleanup unneeded btrfs-find-root codes
      btrfs-progs: find-root, add option to search through all the metadata extents
      btrfs-progs: Move -rdynamic linker only option to LDFLAGS
      btrfs-progs: Fix 2 extent buffer leak in btrfs-debug-tree
      btrfs-progs: Fix a infinite loop when fixing nlink if file name conflicts twice.
      btrfs-progs: Make csum tree rebuild works with extent tree rebuild.
      btrfs-progs: Move (set/clear_)extent_buffer_uptodate() to extent_io.h.
      btrfs-progs: fsck-test: Add check_sudo to check valid root/sudo privilege

Shriramana Sharma (1):
      btrfs-progs: doc: clarify toplevel subvolid

Stefan Tatschner (1):
      btrfs-progs: docs: fixed a grammar mistake
