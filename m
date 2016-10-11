Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:41982 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1753111AbcJKCpE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Oct 2016 22:45:04 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 0/4] Btrfs-convert: Add support to copy common inode flags
Date: Tue, 11 Oct 2016 10:44:42 +0800
Message-Id: <20161011024446.16546-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Branch can be fetched from:
https://github.com/adam900710/btrfs-progs/tree/convert_inode_flags

Thanks for the report from Lakshmipathi.G, we exposed a bug that
btrfs-convert never copies common inode flags like SYNC/IMMUTABLE/APPEND.

The root cause is quite awkward, we didn't even have these flags defined
in ctree.h.

This patchset will copy related flags to btrfs-progs header and make
btrfs-convert to copy these flags.(Only some ext2 flags are support)
And enhance btrfs-debug-tree to handle these flags.

Finally, adds test case to prevent such problem happens again.

Changelog:
v2:
  Use upper case for stringification macro for patch 2 and 3.

Qu Wenruo (4):
  btrfs-progs: Copy btrfs inode flags from kernel header
  btrfs-progs: Make btrfs-debug-tree print all readable strings for
    inode flags
  btrfs-progs: convert: Convert ext inode flags to btrfs inode flags
  btrfs-progs: convert-test: Add test case for common inode flags

 btrfs-convert.c                                    | 26 ++++++++++++
 ctree.h                                            |  9 +++++
 print-tree.c                                       | 47 +++++++++++++---------
 tests/convert-tests/009-common-inode-flags/test.sh | 34 ++++++++++++++++
 4 files changed, 96 insertions(+), 20 deletions(-)
 create mode 100755 tests/convert-tests/009-common-inode-flags/test.sh

-- 
2.10.0



