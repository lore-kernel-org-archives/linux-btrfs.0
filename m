Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:64820 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751939AbcJJDLm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 9 Oct 2016 23:11:42 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, lakshmipathi.g@gmail.com
Subject: [PATCH 0/4] Btrfs-convert: Add support to copy common inode flags
Date: Mon, 10 Oct 2016 11:11:17 +0800
Message-Id: <20161010031121.5017-1-quwenruo@cn.fujitsu.com>
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

Qu Wenruo (4):
  btrfs-progs: Copy btrfs inode flags from kernel header
  btrfs-progs: Make btrfs-debug-tree print all readable strings for
    inode flags
  btrfs-progs: convert: Convert ext inode flags to btrfs inode flags
  btrfs-progs: convert-test: Add test case for common inode flags

 btrfs-convert.c                                    | 25 ++++++++++++
 ctree.h                                            |  9 +++++
 print-tree.c                                       | 46 ++++++++++++----------
 tests/convert-tests/009-common-inode-flags/test.sh | 34 ++++++++++++++++
 4 files changed, 94 insertions(+), 20 deletions(-)
 create mode 100755 tests/convert-tests/009-common-inode-flags/test.sh

-- 
2.10.0



