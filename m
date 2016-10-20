Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:26469 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1756927AbcJTCHH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Oct 2016 22:07:07 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH v9.1 0/5] In-band de-duplication for btrfs-progs
Date: Thu, 20 Oct 2016 10:06:59 +0800
Message-Id: <20161020020659.21803-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Patchset can be fetched from github:
https://github.com/adam900710/btrfs-progs.git dedupe_latest

Inband dedupe(in-memory backend only) ioctl support for btrfs-progs.

User/reviewer/tester can still use previous btrfs-progs patchset to test,
this update is just cleanuping unsupported functions, like on-disk
backend and any on-disk format change.

v7:
   Update ctree.h to follow kernel structure change
   Update print-tree to follow kernel structure change
V8:
   Move dedup props and on-disk backend support out of the patchset
   Change command group name to "dedupe-inband", to avoid confusion with
   possible out-of-band dedupe. Suggested by Mark.
   Rebase to latest devel branch.
V9:
   Follow kernels ioctl change to support FORCE flag, new reconf ioctl,
   and more precious error reporting.
v9.1:
   Rebased to v4.8.1.


Qu Wenruo (5):
  btrfs-progs: Basic framework for dedupe-inband command group
  btrfs-progs: dedupe: Add enable command for dedupe command group
  btrfs-progs: dedupe: Add disable support for inband dedupelication
  btrfs-progs: dedupe: Add status subcommand
  btrfs-progs: dedupe: introduce reconfigure subcommand

 Documentation/Makefile.in                  |   1 +
 Documentation/btrfs-dedupe-inband.asciidoc | 167 +++++++++++
 Documentation/btrfs.asciidoc               |   4 +
 Makefile.in                                |   3 +-
 btrfs-completion                           |   6 +-
 btrfs.c                                    |   2 +
 cmds-dedupe-ib.c                           | 436 +++++++++++++++++++++++++++++
 commands.h                                 |   2 +
 dedupe-ib.h                                |  41 +++
 ioctl.h                                    |  37 +++
 10 files changed, 697 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/btrfs-dedupe-inband.asciidoc
 create mode 100644 cmds-dedupe-ib.c
 create mode 100644 dedupe-ib.h

-- 
2.10.0



