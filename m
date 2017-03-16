Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:27871 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751151AbdCPBuR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Mar 2017 21:50:17 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id A95B9477AE90
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Mar 2017 09:50:00 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v10 0/5] In-band de-duplication for btrfs-progs
Date: Thu, 16 Mar 2017 09:49:51 +0800
Message-ID: <20170316014956.19916-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Patchset can be fetched from github:
https://github.com/adam900710/btrfs-progs.git dedupe_20170306

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

v10 changes:
   Rebase to v4.10.
   Add BUILD_ASSERT for btrfs_ioctl_dedupe_args

Qu Wenruo (5):
  btrfs-progs: Basic framework for dedupe-inband command group
  btrfs-progs: dedupe: Add enable command for dedupe command group
  btrfs-progs: dedupe: Add disable support for inband dedupelication
  btrfs-progs: dedupe: Add status subcommand
  btrfs-progs: dedupe: introduce reconfigure subcommand

 Documentation/Makefile.in                  |   1 +
 Documentation/btrfs-dedupe-inband.asciidoc | 167 +++++++++++
 Documentation/btrfs.asciidoc               |   4 +
 Makefile                                   |   2 +-
 btrfs-completion                           |   6 +-
 btrfs.c                                    |   2 +
 cmds-dedupe-ib.c                           | 437 +++++++++++++++++++++++++++++
 commands.h                                 |   2 +
 dedupe-ib.h                                |  41 +++
 ioctl.h                                    |  38 +++
 10 files changed, 698 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/btrfs-dedupe-inband.asciidoc
 create mode 100644 cmds-dedupe-ib.c
 create mode 100644 dedupe-ib.h

-- 
2.12.0



