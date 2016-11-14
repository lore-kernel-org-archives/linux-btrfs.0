Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:35513 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932483AbcKNSnb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Nov 2016 13:43:31 -0500
Received: by mail-pf0-f177.google.com with SMTP id i88so30825505pfk.2
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Nov 2016 10:43:31 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH v2 0/6] btrfs-progs: better space_cache=v2 support
Date: Mon, 14 Nov 2016 10:43:17 -0800
Message-Id: <cover.1479148594.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Hi,

Cover letter from v1:

This series implements some support for space_cache=v2 in btrfs-progs.
In particular, this adds support for `btrfs check --clear-space-cache v2`,
proper printing of the free space tree flags for `btrfs inspect-internal
dump-super`, and better documentation.

We'd previously talked about always making btrfs-progs always invalidate
the free space tree when doing write operations, but I decided that this
should be an action explicitly requested by the user. It'd also be
unsafe if using a kernel without the free space tree valid bit support,
which is why I didn't implement a `btrfs check --invalidate-free-space-cache`
option. Doing the full clear is always safe.

Still missing is full read-write support, but this should hopefully
cover most btrfs-progs usage.

Changes since v1:

- Change unsigned -> unsigned int argument to
  btrfs_check_fs_compatability() in patch 3
- Remove BUG_ON() in btrfs_del_root() in patch 4
- Return error from btrfs_free_tree_block() in patch 4
- Handle errors from btrfs_free_tree_block() and clean_tree_block() in
  patch 4
- Add Qu Wenruo's Reviewed-by to patches 3, 4, and 5

Thanks!

Omar Sandoval (6):
  btrfs-progs: add the FREE_SPACE_TREE_VALID compat_ro bit definition
  btrfs-progs: format FREE_SPACE_TREE{,_VALID} nicely in dump-super
  btrfs-progs: add OPEN_CTREE_INVALIDATE_FST flag
  btrfs-progs: add btrfs_clear_free_space_tree() from the kernel
  btrfs-progs: implement btrfs check --clear-space-cache v2
  btrfs-progs: document space_cache=v2 more thoroughly

 Documentation/btrfs-check.asciidoc | 14 +++---
 Documentation/btrfs-man5.asciidoc  | 43 ++++++++++--------
 chunk-recover.c                    |  2 +-
 cmds-check.c                       | 34 ++++++++++----
 cmds-inspect-dump-super.c          | 24 ++++++++++
 ctree.h                            | 19 ++++++++
 disk-io.c                          | 29 +++++++-----
 disk-io.h                          |  9 +++-
 extent-tree.c                      | 11 +++++
 free-space-tree.c                  | 91 ++++++++++++++++++++++++++++++++++++++
 free-space-tree.h                  |  1 +
 root-tree.c                        | 25 +++++++++++
 12 files changed, 258 insertions(+), 44 deletions(-)

-- 
2.10.2

