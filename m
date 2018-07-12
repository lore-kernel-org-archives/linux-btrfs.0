Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:43299 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726686AbeGLKut (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jul 2018 06:50:49 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 323DC4B43D51
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Jul 2018 18:41:30 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [v10.4 0/5] In-band de-duplication for btrfs-progs
Date: Thu, 12 Jul 2018 18:41:18 +0800
Message-ID: <20180712104123.5999-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Patchset can be fetched from github:
https://github.com/littleroad/btrfs-progs.git dedupe_latest

Inband dedupe(in-memory backend only) ioctl support for btrfs-progs.

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
v10 changes:
   Rebase to v4.10.
   Add BUILD_ASSERT for btrfs_ioctl_dedupe_args
v10.1 changes:
   Rebase to v4.14.
v10.2 changes:
   Rebase to v4.16.1.
v10.3 changes:
   Rebase to v4.17.
v10.4 changes:
   Deal with offline reviews from Misono Tomohiro.
   1. s/btrfs-dedupe/btrfs-dedupe-inband
   2. Replace strerror(errno) with %m
   3. Use SZ_* instead of intermedia number
   4. update btrfs-completion for reconfigure subcommand

Qu Wenruo (5):
  btrfs-progs: Basic framework for dedupe-inband command group
  btrfs-progs: dedupe: Add enable command for dedupe command group
  btrfs-progs: dedupe: Add disable support for inband dedupelication
  btrfs-progs: dedupe: Add status subcommand
  btrfs-progs: dedupe: introduce reconfigure subcommand

 Documentation/Makefile.in                  |   1 +
 Documentation/btrfs-dedupe-inband.asciidoc | 167 ++++++++
 Documentation/btrfs.asciidoc               |   4 +
 Makefile                                   |   3 +-
 btrfs-completion                           |   6 +-
 btrfs.c                                    |   2 +
 cmds-dedupe-ib.c                           | 437 +++++++++++++++++++++
 commands.h                                 |   2 +
 dedupe-ib.h                                |  28 ++
 ioctl.h                                    |  38 ++
 10 files changed, 686 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/btrfs-dedupe-inband.asciidoc
 create mode 100644 cmds-dedupe-ib.c
 create mode 100644 dedupe-ib.h

-- 
2.18.0



