Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:20770 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751446AbdFAIzV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Jun 2017 04:55:21 -0400
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH v2 0/9] btrfs: check namelen before read name
Date: Thu, 1 Jun 2017 16:57:07 +0800
Message-ID: <20170601085716.25898-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When reading out name from inode_ref, dir_item, it's possible that
corrupted name_len leads to read beyond boundary.
Since there are already patches for btrfs-progs, this patchset is
for btrfs.

Introduce 'btrfs_is_namelen_valid' to make check namelen with
item boundary.
If read name from dir_item, use 'verify_dir_item' to do more strict
check. Otherwise, use 'btrfs_is_namelen_valid'.

It's unnessary to do check before every read/memcmp_extent_buffer name.
Checking namelen when read name for the first time in the call graph is
enough.

Changlog:
v2:
	1.Change 'btrfs_check_namelen' to 'btrfs_is_namelen_valid'.
	2.Split patches according call graph.

Su Yue (9):
  btrfs: Introduce btrfs_is_namelen_valid to avoid reading beyond
    boundary
  btrfs: Check namelen with boundary in verify dir_item
  btrfs: Check name len on add_inode_ref call path
  btrfs: Verify dir_item in 'replay_xattr_deletes'
  btrfs: Check namelen in 'btrfs_check_ref_name_override'
  btrfs: Check name before read in 'iterate_dir_item'
  btrfs: Check namelen before read in 'btrfs_get_name'
  btrfs: Check namelen before in 'btrfs_del_root_ref'
  btrfs: Verify dir_item 'in iterate_object_props'

 fs/btrfs/ctree.h     |  4 ++-
 fs/btrfs/dir-item.c  | 89 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/export.c    |  5 +++
 fs/btrfs/inode.c     |  2 +-
 fs/btrfs/props.c     |  7 +++++
 fs/btrfs/root-tree.c |  7 +++++
 fs/btrfs/send.c      |  6 ++++
 fs/btrfs/tree-log.c  | 43 ++++++++++++++++++-------
 fs/btrfs/xattr.c     |  2 +-
 9 files changed, 149 insertions(+), 16 deletions(-)

-- 
2.13.0



