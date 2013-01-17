Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59937 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790Ab3AQRrY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Jan 2013 12:47:24 -0500
Date: Thu, 17 Jan 2013 18:47:21 +0100
From: David Sterba <dsterba@suse.cz>
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org
Subject: [GIT PULL] btrfs-progs: more bugfixes for 0.20-rc1
Message-ID: <20130117174721.GD22785@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

please pull a few more fixes to the 0.20-rc series. I have reviewed and
verified them where possible. There are the long awaited ARM fixes, help
updates and unsorted code fixes.

  git://repo.or.cz/btrfs-progs-unstable/devel.git for-chris

Based on top of master commit
91d9eec1ff044394f2b98ee7fcb76713dd33b994

Thanks.
david

---
 btrfs-list.c      |   69 +++++++++++++++++++++++++-----------------------------
 btrfsck.c         |    3 +-
 cmds-filesystem.c |   26 --------------------
 cmds-inspect.c    |    5 ++-
 cmds-receive.c    |    4 ++-
 cmds-scrub.c      |    4 ++-
 cmds-send.c       |    9 ++++++-
 convert.c         |    5 +++
 ctree.h           |    8 ++++--
 debug-tree.c      |   10 +++++++
 disk-io.c         |   13 ++++++++--
 kerncompat.h      |   12 +++++++++
 man/btrfs.8.in    |    4 ---
 mkfs.c            |   35 ++-------------------------
 restore.c         |    7 +++--
 utils.c           |   48 +++++++++++++++++++++++++++++++++++++
 utils.h           |    2 +
 version.sh        |    2 -
 volumes.c         |    8 +++---
 19 files changed, 159 insertions(+), 115 deletions(-)
---
Alex Lyakas (1):
      btrfs-progs: Receive: preserve ownership for symlinks, by using 'lchown'

Arne Jansen (1):
      Btrfs-progs: fix unaligned accesses

David Sterba (2):
      btrfs-progs: do not send stream into a terminal
      btrfs-progs: ignore -a option in mkfs

Goffredo Baroncelli (3):
      Move parse_size() to utils.[hc]
      parse_size(): replace atoll() with strtoull()
      parse_size(): add new suffixes

Kenji Okimoto (3):
      btrfs-progs: plug a memory leak reported by cppcheck
      btrfs-progs: check malloc() result
      btrfs-progs: plug memory leaks in btrfs_scan_one_dir() reported by cppcheck.

Lluis Batlle i Rossell (1):
      btrfs-progs: Fix getopt on arm platforms

Sergei Trofimovich (1):
      version.sh: fix version when built from tarball

Simon Xu (2):
      btrfs-progs: remove "device show" from btrfs man page
      btrfs-progs: remove '-h' from btrfs man page

Wade Cline (1):
      Btrfs-progs: Fix compiler warnings on PPC64

Wang Sheng-Hui (3):
      btrfs-progs: add -V description in print_usage
      btrfs-progs: update usage description for debug-tree.c
      btrfs-progs: print the right mount checking info in restore.c

Zach Brown (1):
      btrfs-progs: fix 32bit int/pointer cast warnings


