Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:28357 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754860AbcDAGhz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Apr 2016 02:37:55 -0400
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 429FD4056401
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Apr 2016 14:37:52 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v7 0/8] Inband dedupe for btrfs-progs
Date: Fri,  1 Apr 2016 14:37:42 +0800
Message-Id: <1459492670-31596-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No much change from previous version.
1) Rebased to latest devel branch

2) Update ctree.h to follow kernel structure change

3) Update print-tree to follow kernel structure change

Qu Wenruo (7):
  btrfs-progs: Basic framework for dedupe command group
  btrfs-progs: dedupe: Add enable command for dedupe command group
  btrfs-progs: dedupe: Add disable support for inband dedupelication
  btrfs-progs: dedupe: Add status subcommand
  btrfs-progs: Add dedupe feature for mkfs and convert
  btrfs-progs: Add show-super support for new DEDUPE flag
  btrfs-progs: debug-tree: Add dedupe tree support

Wang Xiaoguang (1):
  btrfs-progs: property: add a dedupe property

 Documentation/Makefile.in             |   1 +
 Documentation/btrfs-dedupe.asciidoc   | 150 ++++++++++++++++
 Documentation/btrfs-property.asciidoc |   2 +
 Documentation/btrfs.asciidoc          |   4 +
 Documentation/mkfs.btrfs.asciidoc     |   9 +
 Makefile.in                           |   3 +-
 btrfs-completion                      |   6 +-
 btrfs-convert.c                       |  19 +-
 btrfs.c                               |   1 +
 cmds-dedupe.c                         | 329 ++++++++++++++++++++++++++++++++++
 cmds-inspect-dump-super.c             |  18 ++
 cmds-inspect-dump-tree.c              |   4 +
 commands.h                            |   2 +
 ctree.h                               |  46 ++++-
 dedupe.h                              |  42 +++++
 ioctl.h                               |  23 +++
 mkfs.c                                |   8 +-
 print-tree.c                          | 118 ++++++++++++
 props.c                               |  73 ++++++++
 utils.c                               |  47 +++--
 utils.h                               |   7 +-
 21 files changed, 886 insertions(+), 26 deletions(-)
 create mode 100644 Documentation/btrfs-dedupe.asciidoc
 create mode 100644 cmds-dedupe.c
 create mode 100644 dedupe.h

-- 
2.7.4



