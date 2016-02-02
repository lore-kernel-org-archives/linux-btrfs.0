Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:38492 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbcBBDBc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Feb 2016 22:01:32 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 3DBC4413CD7C
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Feb 2016 11:01:24 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4 0/8] btrfs-progs: Support in-band de-duplication
Date: Tue,  2 Feb 2016 10:59:05 +0800
Message-Id: <1454381953-29676-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Preparation patchset for in-coming (aimed for 4.6) kernel in-band
de-duplication patchset.

New kernel dedup will has 2 different dedup backends and a ioctl
interface to enable/disable dedup.

The ioctl interface and on-disk format (mostly) is determined, so submit
this patchset first before de-duplication first.

The patchset can also be fetched from github:
https://github.com/adam900710/btrfs-progs.git dedup

v2:
  Better objectid/offset format for dedup hash items
  Output hash for dedup hash items
v3:
  Keep dedup tree objectid and ro_flag the same with kernal,
  since the tree objectid 11 and ro_flag 1 are all taken by space cache
  tree v2.
  Add dedup property support.
v4:
  Better debug tree output for dedup tree
  Update document to keep consist with new default values.

Qu Wenruo (7):
  btrfs-progs: Basic framework for dedup command group
  btrfs-progs: dedup: Add enable command for dedup command group
  btrfs-progs: dedup: Add disable support for inband deduplication
  btrfs-progs: dedup: Add status subcommand
  btrfs-progs: Add dedup feature for mkfs and convert
  btrfs-progs: Add show-super support for new DEDUP flag
  btrfs-progs: debug-tree: Add dedup tree support

Wang Xiaoguang (1):
  btrfs-progs: property: add a dedup property

 Documentation/Makefile.in             |   1 +
 Documentation/btrfs-dedup.asciidoc    | 124 ++++++++++++++
 Documentation/btrfs-property.asciidoc |   2 +
 Documentation/btrfs.asciidoc          |   4 +
 Documentation/mkfs.btrfs.asciidoc     |   9 +
 Makefile.in                           |   2 +-
 btrfs-convert.c                       |  19 ++-
 btrfs-debug-tree.c                    |   4 +
 btrfs-show-super.c                    |  17 ++
 btrfs.c                               |   1 +
 cmds-dedup.c                          | 304 ++++++++++++++++++++++++++++++++++
 commands.h                            |   2 +
 ctree.h                               |  42 ++++-
 dedup.h                               |  42 +++++
 ioctl.h                               |  23 +++
 mkfs.c                                |   8 +-
 print-tree.c                          |  94 +++++++++++
 props.c                               |  73 ++++++++
 utils.c                               |  47 ++++--
 utils.h                               |   7 +-
 20 files changed, 800 insertions(+), 25 deletions(-)
 create mode 100644 Documentation/btrfs-dedup.asciidoc
 create mode 100644 cmds-dedup.c
 create mode 100644 dedup.h

-- 
2.7.0



