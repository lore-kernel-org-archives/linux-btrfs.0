Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60958 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752235AbcANGAU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jan 2016 01:00:20 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id 24E3D41896E3
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Jan 2016 13:59:51 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v3 0/8] btrfs-progs: Support in-band de-duplication
Date: Thu, 14 Jan 2016 13:57:42 +0800
Message-ID: <1452751070-2460-1-git-send-email-quwenruo@cn.fujitsu.com>
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

v2:
  Better objectid/offset format for dedup hash items
  Output hash for dedup hash items
v3:
  Keep dedup tree objectid and ro_flag the same with kernal,
  since the tree objectid 11 and ro_flag 1 are all taken by space cache
  tree v2.
  Add dedup property support.

Qu Wenruo (7):
  btrfs-progs: Basic framework for dedup command group
  btrfs-progs: dedup: Add enable command for dedup command group
  btrfs-progs: dedup: Add disable support for inban deduplication
  btrfs-progs: dedup: Add status subcommand
  btrfs-progs: Add dedup feature for mkfs and convert
  btrfs-progs: Add show-super support for new DEDUP flag
  btrfs-progs: dedup-tree: Add dedup tree support

Wang Xiaoguang (1):
  btrfs-progs: property: add a dedup property

 Documentation/btrfs-dedup.asciidoc    | 105 +++++++++++++
 Documentation/btrfs-property.asciidoc |   2 +
 Documentation/mkfs.btrfs.asciidoc     |   9 ++
 Makefile.in                           |   2 +-
 btrfs-convert.c                       |  19 ++-
 btrfs-debug-tree.c                    |   4 +
 btrfs-show-super.c                    |  17 ++
 btrfs.c                               |   1 +
 cmds-dedup.c                          | 282 ++++++++++++++++++++++++++++++++++
 commands.h                            |   2 +
 ctree.h                               |  41 ++++-
 dedup.h                               |  39 +++++
 ioctl.h                               |  23 +++
 kerncompat.h                          |   5 +
 mkfs.c                                |   8 +-
 print-tree.c                          |  75 +++++++++
 props.c                               |  73 +++++++++
 utils.c                               |  38 +++--
 utils.h                               |   7 +-
 19 files changed, 728 insertions(+), 24 deletions(-)
 create mode 100644 Documentation/btrfs-dedup.asciidoc
 create mode 100644 cmds-dedup.c
 create mode 100644 dedup.h

-- 
2.7.0



