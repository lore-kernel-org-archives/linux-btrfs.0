Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52918 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752074AbbL2IBx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Dec 2015 03:01:53 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id 014FB409256C
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Dec 2015 16:01:11 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/7] btrfs-progs: Support for in-band deduplication
Date: Tue, 29 Dec 2015 16:01:02 +0800
Message-ID: <1451376069-30414-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Preparation patchset for in-coming (aimed for 4.6) kernel in-band
de-duplication patchset.

New kernel dedup will has 2 different dedup backends and a ioctl
interface to enable/disable dedup.

The ioctl interface and on-disk format (mostly) is determined, so submit
this patchset first before de-duplication first.

Qu Wenruo (7):
  btrfs-progs: Basic framework for dedup command group
  btrfs-progs: dedup: Add enable command for dedup command group
  btrfs-progs: dedup: Add disable support for inban deduplication
  btrfs-progs: dedup: Add status subcommand
  btrfs-progs: Add dedup feature for mkfs and convert
  btrfs: dedup: Add show-super support for new DEDUP flag
  btrfs-progs: dedup-tree: Add dedup tree support

 Documentation/btrfs-dedup.asciidoc | 105 ++++++++++++++
 Documentation/mkfs.btrfs.asciidoc  |   9 ++
 Makefile.in                        |   2 +-
 btrfs-convert.c                    |  19 ++-
 btrfs-debug-tree.c                 |   4 +
 btrfs-show-super.c                 |  17 +++
 btrfs.c                            |   1 +
 cmds-dedup.c                       | 282 +++++++++++++++++++++++++++++++++++++
 commands.h                         |   2 +
 ctree.h                            |  41 +++++-
 dedup.h                            |  39 +++++
 ioctl.h                            |  23 +++
 kerncompat.h                       |   5 +
 mkfs.c                             |   8 +-
 print-tree.c                       |  52 +++++++
 utils.c                            |  38 +++--
 utils.h                            |   7 +-
 17 files changed, 630 insertions(+), 24 deletions(-)
 create mode 100644 Documentation/btrfs-dedup.asciidoc
 create mode 100644 cmds-dedup.c
 create mode 100644 dedup.h

-- 
2.6.4



