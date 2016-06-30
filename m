Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:49843 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbcF3Jal (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jun 2016 05:30:41 -0400
Received: from adam-work.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id F34CA4056401
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Jun 2016 17:24:31 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH V9 0/5] In-band de-duplication for btrfs-progs
Date: Thu, 30 Jun 2016 17:24:26 +0800
Message-Id: <20160630092431.27636-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Patchset can be fetched from github:
https://github.com/adam900710/btrfs-progs.git dedupe_20160630

Inband dedupe(in-memory backend only) ioctl support for btrfs-progs.

User/reviewer/tester can still use previous btrfs-progs patchset to test,
this update is just cleanuping unsupported functions, like on-disk
backend and any on-disk format change.

v7 changes:
   Update ctree.h to follow kernel structure change
   Update print-tree to follow kernel structure change
V8 changes:
   Move dedup props and on-disk backend support out of the patchset
   Change command group name to "dedupe-inband", to avoid confusion with
   possible out-of-band dedupe. Suggested by Mark.
   Rebase to latest devel branch.
V9 changes:
   Follow kernels ioctl change to support FORCE flag, new reconf ioctl,
   and more precious error reporting.

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
 cmds-dedupe-ib.c                           | 435 +++++++++++++++++++++++++++++
 commands.h                                 |   2 +
 dedupe-ib.h                                |  41 +++
 ioctl.h                                    |  37 +++
 10 files changed, 696 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/btrfs-dedupe-inband.asciidoc
 create mode 100644 cmds-dedupe-ib.c
 create mode 100644 dedupe-ib.h

-- 
2.9.0



