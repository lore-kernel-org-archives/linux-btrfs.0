Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:30422 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754747AbcFQBDD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jun 2016 21:03:03 -0400
Received: from adam-work.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id D12E14056401
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Jun 2016 09:02:44 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v8 0/4] Inband dedupe for btrfs-progs
Date: Fri, 17 Jun 2016 09:02:40 +0800
Message-Id: <20160617010244.6996-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Patchset can be fetched from github:
https://github.com/adam900710/btrfs-progs.git dedupe_20160606

Inband dedupe(in-memory backend only) ioctl support for btrfs-progs.

User/reviewer/tester can still use previous btrfs-progs patchset to test,
this update is just cleanuping unsupported functions, like on-disk
backend and any on-disk format change.

V8 changes:
   Move dedup props and on-disk backend support out of the patchset
   Change command group name to "dedupe-inband", to avoid confusion with
   possible out-of-band dedupe. Suggested by Mark.
   Rebase to latest devel branch.
v7 changes:
   Update ctree.h to follow kernel structure change
   Update print-tree to follow kernel structure change

Qu Wenruo (4):
  btrfs-progs: Basic framework for dedupe-inband command group
  btrfs-progs: dedupe: Add enable command for dedupe command group
  btrfs-progs: dedupe: Add disable support for inband dedupelication
  btrfs-progs: dedupe: Add status subcommand

 Documentation/Makefile.in                  |   1 +
 Documentation/btrfs-dedupe-inband.asciidoc | 152 ++++++++++++++
 Documentation/btrfs.asciidoc               |   4 +
 Makefile.in                                |   3 +-
 btrfs-completion                           |   6 +-
 btrfs.c                                    |   2 +
 cmds-dedupe-ib.c                           | 319 +++++++++++++++++++++++++++++
 commands.h                                 |   2 +
 ioctl.h                                    |  23 +++
 9 files changed, 510 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/btrfs-dedupe-inband.asciidoc
 create mode 100644 cmds-dedupe-ib.c

-- 
2.8.3



