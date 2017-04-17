Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62053 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932464AbdDQD0t (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Apr 2017 23:26:49 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 0/9] Introduce btrfs-modify prog to make corruption easier
Date: Mon, 17 Apr 2017 11:26:33 +0800
Message-ID: <20170417032642.30770-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new command, btrfs-modify, which is not part of 'btrfs', but
an independent command, bring minimal impact to existing btrfs commands.

Btrfs-modify is designed to provides better documentation than current
btrfs-corrupt-block with better subcommand division to reduce confusing
or conflicting options.

Btrfs-modify paired with offline-scrub patchset (not merged yet) could
provide a full suite for test case writers to do corruption and recovery
verification.

Qu Wenruo (9):
  btrfs-progs: Introduce new btrfs_map_block function which returns more
    unified result.
  btrfs-progs: Allow __btrfs_map_block_v2 to remove unrelated stripes
  btrfs-progs: Export commands processing code to commands.c from
    btrfs.c
  btrfs-progs: help: Unbind short help description from btrfs
  btrfs-progs: utils: Introduce new function arg_strtou32
  btrfs-progs: Introduce btrfs-modify tool to modify btrfs internal
    structures
  btrfs-progs: modify: Add support to corrupt specified mirror
  btrfs-progs: modify: Introduce option to specify range by root,ino and
    offset
  btrfs-progs: modify: Introduce option to specify the pattern to fill
    mirror

 .gitignore                          |   1 +
 Documentation/Makefile.in           |   1 +
 Documentation/btrfs-modify.asciidoc |  64 +++++
 Makefile                            |  14 +-
 btrfs.c                             | 116 +--------
 commands.c                          | 127 ++++++++++
 commands.h                          |   4 +
 help.c                              |  14 +-
 help.h                              |   3 +-
 modify/main.c                       | 110 +++++++++
 modify/mirror.c                     | 472 ++++++++++++++++++++++++++++++++++++
 modify/modify_commands.h            |  25 ++
 utils-lib.c                         |  15 ++
 utils.h                             |   1 +
 volumes.c                           | 283 +++++++++++++++++++++
 volumes.h                           |  78 ++++++
 16 files changed, 1213 insertions(+), 115 deletions(-)
 create mode 100644 Documentation/btrfs-modify.asciidoc
 create mode 100644 commands.c
 create mode 100644 modify/main.c
 create mode 100644 modify/mirror.c
 create mode 100644 modify/modify_commands.h

-- 
2.12.2



