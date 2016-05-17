Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:53468 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754739AbcEQDsd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 May 2016 23:48:33 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 0/4] Add support to clear v1 free space cache for btrfs check
Date: Tue, 17 May 2016 11:47:54 +0800
Message-Id: <1463456878-17550-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The patchset can be also fetched from github, just in case mail list
blocks the last patch, which contains binary file.
https://github.com/adam900710/btrfs-progs.git fsck_clear_cache

Just as describe in the first patch, btrfs kernel "clear_cache" mount
option can't rebuild all free space cache, due to the design of free
space cache.
(Although I pretty like the idea to delay the load of free space cache,
as it hugely reduce the mount time of large fs)

So this makes users to report error in mail list, complaining
"clear_cache" doesn't wipe the annoying kernel warning on corrupted free
space cache.

Since kernel can't handle it, and user consider it more like an error,
we'd better handle it like an error, to fix it in btrfs check.

So this patchset adds the ability to clear free space cache, and add
test case for it.

The clear procedure is different from kernel, it will remove all free
space cache inodes and its contents(with backrefs), and set
cache_generation of super block to -1.
So there will be no free space cache at all and kernel will be happy
with that.

This patch also enhances btrfs_previous_item() to use min_objectid to
return as early as possible.

Lu Fengqi (1):
  btrfs-progs: tests: add 020-bad-free-space-cache

Qu Wenruo (3):
  btrfs-progs: corrupt-block: Add ability to corrupt free space cache
    file
  btrfs-progs: ctree: return earlier for btrfs_previous_item
  btrfs-progs: fsck: Add support to clear free space cache

 Documentation/btrfs-check.asciidoc                 |   8 ++
 btrfs-corrupt-block.c                              | 124 ++++++++++++++++++++-
 cmds-check.c                                       |  58 +++++++++-
 ctree.c                                            |   2 +
 free-space-cache.c                                 | 124 +++++++++++++++++++++
 free-space-cache.h                                 |   4 +
 .../020-bad-free-space-cache/default_case.raw.xz   | Bin 0 -> 164068 bytes
 tests/fsck-tests/020-bad-free-space-cache/test.sh  |  16 +++
 8 files changed, 334 insertions(+), 2 deletions(-)
 create mode 100644 tests/fsck-tests/020-bad-free-space-cache/default_case.raw.xz
 create mode 100755 tests/fsck-tests/020-bad-free-space-cache/test.sh

-- 
2.8.2



