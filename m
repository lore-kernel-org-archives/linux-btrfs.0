Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tty0.vserver.softronics.ch ([91.214.169.36]:32826 "EHLO
        fe1.digint.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726819AbeILTvD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Sep 2018 15:51:03 -0400
Received: from mail.tty0.ch (hermes.tty0.ch [172.21.1.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by fe1.digint.ch (Postfix) with ESMTPS id D80D530966
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2018 16:47:08 +0200 (CEST)
From: Axel Burri <axel@tty0.ch>
To: linux-btrfs@vger.kernel.org
Cc: Axel Burri <axel@tty0.ch>
Subject: [RFC PATCH v2 0/4] btrfs-progs: build distinct binaries for specific btrfs subcommands
Date: Wed, 12 Sep 2018 16:46:00 +0200
Message-Id: <20180912144604.6178-1-axel@tty0.ch>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch allows to build distinct binaries for specific btrfs
subcommands, e.g. "btrfs-subvolume-show" which would be identical to
"btrfs subvolume show".

Changes from v1 [1]:

 - No more need of generated c-file for each separated commands (all
   functionality has moved to Makefile).

 - More generic approach: match entry point declarations as well as
   additional tage in all "cmds-*.c" files.

 - Change naming: use "separated" instead of "splitcmd".


Motivation:

While btrfs-progs offer the all-inclusive "btrfs" command, it gets
pretty cumbersome to restrict privileges to the subcommands [2].
Common approaches are to either setuid root for "/sbin/btrfs" (which
is not recommended at all), or to write sudo rules for each
subcommand.

Separating the subcommands into distinct binaries makes it easy to set
elevated privileges using capabilities(7) or setuid. A typical use
case where this is needed is when it comes to automated scripts,
e.g. btrbk [3] [4] creating snapshots and send/receive them via ssh.


Description:

Patch 1 adds a minimal, non-invasive framework for building separated
binaries. Note that some subcommands fail to build ("make -k separated").

Patches 2,3 fix build dependencies: make all subcommands build
correctly, with smaller binary size. Probably to be squashed into
patch 1 for final commit.

Patch 4 adds configuration options -enable-setcap-install,
--enable-setuid-install, --enable-btrfs-separated.


Notes:

 - This patchset is available on github [5].

 - A gentoo ebuild "sys-fs/btrfs-progs-separated" is available on
   github [6], as well as in the digint-overlay [7]:

    USE=filecaps emerge -av sys-fs/btrfs-progs-separated


References:

  [1] https://www.spinics.net/lists/linux-btrfs/msg81451.html
  [2] https://www.spinics.net/lists/linux-btrfs/msg75736.html
  [3] https://github.com/digint/btrbk
  [4] https://github.com/digint/btrfs-progs-btrbk
  [5] https://github.com/digint/btrfs-progs/tree/cmds-separated-fscaps-v2
  [6] https://github.com/digint/gentoo/tree/btrfs-progs-separated/sys-fs/btrfs-progs-separated
  [7] https://dev.tty0.ch/portage/digint-overlay.git


Axel Burri (4):
  btrfs-progs: Makefile: create separated binaries for "btrfs"
    subcommands; add fscaps declarations
  btrfs-progs: remove unneeded dependencies on separated build
    (-DBTRFS_SEPARATED_BUILD)
  btrfs-progs: Makefile: add extra objects definitions for separated
    binaries
  btrfs-progs: build: add --enable-setcap-install,
    --enable-setuid-install, --enable-btrfs-separated

 .gitignore        |  1 +
 Makefile          | 99 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 Makefile.inc.in   |  6 ++++
 cmds-balance.c    |  2 ++
 cmds-device.c     |  2 ++
 cmds-fi-usage.c   |  1 +
 cmds-filesystem.c |  2 ++
 cmds-inspect.c    |  2 ++
 cmds-property.c   |  2 ++
 cmds-qgroup.c     |  3 ++
 cmds-quota.c      |  2 ++
 cmds-receive.c    |  1 +
 cmds-replace.c    |  2 ++
 cmds-rescue.c     |  2 ++
 cmds-scrub.c      |  2 ++
 cmds-send.c       |  1 +
 cmds-subvolume.c  |  6 ++++
 commands.h        | 37 +++++++++++++++++++++
 configure.ac      | 40 ++++++++++++++++++++++
 19 files changed, 212 insertions(+), 1 deletion(-)

-- 
2.16.4
