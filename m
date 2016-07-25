Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:19955 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbcGYHzJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jul 2016 03:55:09 -0400
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, jbacik@fb.com, holger@applied-asynchrony.com
Subject: [PATCH v2 0/4] update bytes_may_use timely to avoid false ENOSPC issue
Date: Mon, 25 Jul 2016 15:51:37 +0800
Message-Id: <20160725075141.5712-1-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently in btrfs, for data space reservation, it does not update
bytes_may_use in btrfs_update_reserved_bytes() and the decrease operation
will be delayed to be done in extent_clear_unlock_delalloc(), for
fallocate(2), decrease operation is even delayed to be done in end
of btrfs_fallocate(), which is too late. Obviously such delay will
cause unnecessary pressure to enospc system.

So in this patch set, we will remove RESERVE_FREE, RESERVE_ALLOC and
RESERVE_ALLOC_NO_ACCOUNT, and always update bytes_may_use timely.

I already have sent a fstests test case for this issue, and I can send
[Patch 4/4] as a independent patch, but its bug also can be revealed by
the same reproduce scripts, so I include it here.

Changelog:
v2:
  Fix a trace point issue.

Wang Xiaoguang (4):
  btrfs: use correct offset for reloc_inode in
    prealloc_file_extent_cluster()
  btrfs: divide btrfs_update_reserved_bytes() into two functions
  btrfs: update btrfs_space_info's bytes_may_use timely
  btrfs: should block unused block groups deletion work when allocating
    data space

 fs/btrfs/ctree.h       |   3 +-
 fs/btrfs/disk-io.c     |   1 +
 fs/btrfs/extent-tree.c | 171 ++++++++++++++++++++++++++++---------------------
 fs/btrfs/extent_io.h   |   1 +
 fs/btrfs/file.c        |  26 ++++----
 fs/btrfs/inode-map.c   |   3 +-
 fs/btrfs/inode.c       |  37 ++++++++---
 fs/btrfs/relocation.c  |  17 +++--
 8 files changed, 159 insertions(+), 100 deletions(-)

-- 
2.9.0



