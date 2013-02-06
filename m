Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729Ab3BFAtu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Feb 2013 19:49:50 -0500
Date: Tue, 5 Feb 2013 16:49:07 -0800
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Eric Sandeen <sandeen@redhat.com>
Subject: btrfs-progs pull request for coverity fixes
Message-ID: <20130206004907.GN14246@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi gang,

Eric and I went through the warnings that a Coverity scan raised against
the reasonably recent btrfs-progs that's in Fedora.  We tried to tackle
the lowest hanging fruit: these are the most obvious and least risky
fixes.

We got up to 40 patches before running out of steam.  I was going to
bomb the list with them but figured I'd first try not to annoy everyone
and just send this pull request.  I can send all the patches if people
want them in the archives, etc.

I've only compile tested these.  What do people use for btrfs-progs unit
tests?

Most of the bugs fixed are tiny and boring: leaking fds and memory,
using closed or uninitialized fds, clobbering paths with long arguments,
that sort of thing.

But there are two interesting bugs worth mentioning:

 7d365c5 btrfs-progs: don't write memory after sb to disk
 9e4ad99 btrfs-progs: use ftw() unstead of system("du")

The first is more of a curiousity.  There's nothing valuable in the mkfs
heap that can get leaked into the unused end of the super block, but
it's worth fixing.  The second is a real piece of work.  It's good that
it was hiding off in mkfs in some weird option.

David, I rebased these on the integration branch because.. well, it was
easy and seemed like where they'll end up.  There were only a handful of
things to fix when rebasing from Chris' current master.

Anyway, holler if we've done anything dim.  I'm happy to clean these up
and resend as needed.

- z

The following changes since commit 2161e1b6f35d1c084fda49b479951219117c86e9:

  Btrfs-progs: use btrfs_lookup_first_block_group when fixing accounting (2013-02-01 17:56:42 +0100)

are available in the git repository at:

  http://git.zabbo.net/cgit/btrfs-progs.git cov-fixes-v1-integration-20130201

for you to fetch changes up to 2986545ccd655273658e0e4463a669bb1893ba68:

  btrfs-progs: initialize pipefd[] for error path (2013-02-05 16:09:41 -0800)

----------------------------------------------------------------
Eric Sandeen (9):
      btrfs-progs: don't double-close prg_fd
      btrfs-progs: don't use closed fd
      btrfs-progs: zero out inspect ioctl args
      btrfs-progs: fix mdresotre typo in function names
      btrfs-progs: remove duplicate __setup_root
      btrfs-progs: fix name lengths in cmd_subvol_create
      btrfs-progs: simplify ioctl name copy and null termination
      btrfs-progs: fix overflows of ioctl name args
      btrfs-progs: initialize pipefd[] for error path

Zach Brown (31):
      btrfs-progs: treat super.magic as an le64
      btrfs-progs: return error from commit_tree_roots()
      btrfs-progs: more carefully check eb backrefs
      btrfs-progs: use ftw() unstead of system("du")
      btrfs-progs: remove unused info_fd
      btrfs-progs: fix copy-n-paste error checking
      btrfs-progs: remove dead code that checks null eb
      btrfs-progs: don't free null path
      btrfs-progs: break after printing FREE_INO
      btrfs-progs: don't close(-1)
      btrfs-progs: don't return -EBUSY from main()
      btrfs-progs: don't close(<0) in subvol create
      btrfs-progs: check for open failure, don't close
      btrfs-progs: impossible BUG_ON meant to test empty
      btrfs-progs: don't write memory after sb to disk
      btrfs-progs: array indexes must be < ARRAY_SIZE()
      btrfs-progs: free path on read_chunk_tree error
      btrfs-progs: fix overflow in btrfs_scan_one_dir()
      btrfs-progs: don't leak in set_extent_bits
      btrfs-progs: fix scrub socket leak
      btrfs-progs: scrub can leak fd 0
      btrfs-progs: remove unused arguments
      btrfs-progs: free bits in check_extents()
      btrfs-progs: close fd in qgroup show
      btrfs-progs: free path before returning
      btrfs-progs: don't leak fd in resize
      btrfs-progs: close ioctl fd in find new
      btrfs-progs: don't leak inherit on errors
      btrfs-progs: don't leak multi-bio in find_root()
      btrfs-progs: close fd in inode resolve
      btrfs-progs: don't leak fds in logical resolve

 btrfs-image.c      |  8 ++++----
 btrfs-show-super.c |  2 +-
 btrfs-vol.c        |  2 +-
 btrfsck.c          | 28 +++++++++++++++-------------
 btrfsctl.c         |  7 +++----
 cmds-device.c      | 12 ++++--------
 cmds-filesystem.c  | 14 +++++++-------
 cmds-inspect.c     | 20 ++++++++++++++++----
 cmds-qgroup.c      |  3 +--
 cmds-receive.c     |  8 +++-----
 cmds-scrub.c       | 14 +++++++++-----
 cmds-send.c        |  6 +++---
 cmds-subvolume.c   | 19 ++++++++-----------
 ctree.c            |  8 +-------
 ctree.h            |  2 +-
 disk-io.c          | 27 ++++++++++++++++++---------
 disk-io.h          |  4 ++++
 extent_io.c        |  8 +++++---
 find-root.c        | 27 +--------------------------
 kerncompat.h       | 10 ++++++++++
 mkfs.c             | 47 +++++++++++++++++++++++++++--------------------
 print-tree.c       |  1 +
 restore.c          | 10 ++++------
 utils.c            | 37 +++++++++++++++++++++++++++----------
 utils.h            |  5 +++++
 volumes.c          |  4 ++--
 26 files changed, 181 insertions(+), 152 deletions(-)
