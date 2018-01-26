Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:34424 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751291AbeAZSlY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 13:41:24 -0500
Received: by mail-pf0-f176.google.com with SMTP id e76so827952pfk.1
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 10:41:24 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH 00/26] btrfs-progs: introduce libbtrfsutil, "btrfs-progs as a library"
Date: Fri, 26 Jan 2018 10:40:48 -0800
Message-Id: <cover.1516991902.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Hello,

One of the features requests I get most often is a library to do the
sorts of operations that we do with btrfs-progs. We can shell out to
btrfs-progs, but the output format isn't always easily parsasble, and
shelling out isn't always ideal. There's libbtrfs, but it's very
incomplete, doesn't have a well thought out API, and is licensed under
the GPL, making it hard to use for many projects.

libbtrfsutil is a new library written from scratch to address these
issues. The implementation is completely independent of the existing
btrfs-progs code, including kerncompat.h, and has a clean API and naming
scheme. It is licensed under the LGPL. It also includes Python bindings
by default. I will maintain the library code.

Patch 1 is a preparation cleanup which can go in independently. Patch 2
adds the build system stuff for the library, and patch 3 does the same
for the Python bindings. Patches 4-14 implement the library helpers,
currently subvolume helpers and the sync ioctls. Patches 15-26 replace
the btrfs-progs and libbtrfs code to use libbtrfsutil instead. I took
care to preserve backwards-compatibility. `btrfs subvol list` in
particular had some buggy behaviors for -o and -a that I emulated in the
new code, see the comments in the code.

These patches are also available on my GitHub:
https://github.com/osandov/btrfs-progs/tree/libbtrfsutil. That branch
will rebase as I update this series.

Please share feedback regarding the API, implementation, or anything
else.

Thanks!

Omar Sandoval (26):
  btrfs-progs: get rid of undocumented qgroup inheritance options
  Add libbtrfsutil
  libbtrfsutil: add Python bindings
  libbtrfsutil: add btrfs_util_is_subvolume() and
    btrfs_util_subvolume_id()
  libbtrfsutil: add qgroup inheritance helpers
  libbtrfsutil: add btrfs_util_create_subvolume()
  libbtrfsutil: add btrfs_util_subvolume_info()
  libbtrfsutil: add btrfs_util_[gs]et_read_only()
  libbtrfsutil: add btrfs_util_[gs]et_default_subvolume()
  libbtrfsutil: add subvolume iterator helpers
  libbtrfsutil: add btrfs_util_create_snapshot()
  libbtrfsutil: add btrfs_util_delete_subvolume()
  libbtrfsutil: add btrfs_util_deleted_subvolumes()
  libbtrfsutil: add filesystem sync helpers
  btrfs-progs: use libbtrfsutil for read-only property
  btrfs-progs: use libbtrfsutil for sync ioctls
  btrfs-progs: use libbtrfsutil for set-default
  btrfs-progs: use libbtrfsutil for get-default
  btrfs-progs: use libbtrfsutil for subvol create and snapshot
  btrfs-progs: use libbtrfsutil for subvol delete
  btrfs-progs: use libbtrfsutil for subvol show
  btrfs-progs: use libbtrfsutil for subvol sync
  btrfs-progs: replace test_issubvolume() with btrfs_util_is_subvolume()
  btrfs-progs: add recursive snapshot/delete using libbtrfsutil
  btrfs-progs: deprecate libbtrfs helpers with libbtrfsutil equivalents
  btrfs-progs: use libbtrfsutil for subvolume list

 .gitignore                                   |    2 +
 Documentation/btrfs-subvolume.asciidoc       |   14 +-
 INSTALL                                      |    4 +
 Makefile                                     |   84 +-
 Makefile.inc.in                              |    2 +
 btrfs-list.c                                 | 1201 +++++++---------------
 btrfs-list.h                                 |   22 +-
 cmds-filesystem.c                            |   20 +-
 cmds-inspect.c                               |    9 +-
 cmds-qgroup.c                                |   20 +-
 cmds-receive.c                               |   12 +-
 cmds-subvolume.c                             |  807 +++++----------
 configure.ac                                 |   15 +
 libbtrfsutil/COPYING                         |  674 +++++++++++++
 libbtrfsutil/COPYING.LESSER                  |  165 +++
 libbtrfsutil/README.md                       |   35 +
 libbtrfsutil/btrfsutil.h                     |  621 ++++++++++++
 libbtrfsutil/errors.c                        |   55 +
 libbtrfsutil/filesystem.c                    |  103 ++
 libbtrfsutil/internal.h                      |   36 +
 libbtrfsutil/python/.gitignore               |    7 +
 libbtrfsutil/python/btrfsutilpy.h            |   84 ++
 libbtrfsutil/python/error.c                  |  202 ++++
 libbtrfsutil/python/filesystem.c             |   94 ++
 libbtrfsutil/python/module.c                 |  321 ++++++
 libbtrfsutil/python/qgroup.c                 |  141 +++
 libbtrfsutil/python/setup.py                 |  103 ++
 libbtrfsutil/python/subvolume.c              |  665 +++++++++++++
 libbtrfsutil/python/tests/__init__.py        |   66 ++
 libbtrfsutil/python/tests/test_filesystem.py |   73 ++
 libbtrfsutil/python/tests/test_qgroup.py     |   57 ++
 libbtrfsutil/python/tests/test_subvolume.py  |  383 +++++++
 libbtrfsutil/qgroup.c                        |   86 ++
 libbtrfsutil/subvolume.c                     | 1383 ++++++++++++++++++++++++++
 messages.h                                   |   14 +
 props.c                                      |   69 +-
 qgroup.c                                     |  106 --
 qgroup.h                                     |    4 -
 send-utils.c                                 |   25 +-
 utils.c                                      |  152 +--
 utils.h                                      |    6 -
 41 files changed, 6188 insertions(+), 1754 deletions(-)
 create mode 100644 libbtrfsutil/COPYING
 create mode 100644 libbtrfsutil/COPYING.LESSER
 create mode 100644 libbtrfsutil/README.md
 create mode 100644 libbtrfsutil/btrfsutil.h
 create mode 100644 libbtrfsutil/errors.c
 create mode 100644 libbtrfsutil/filesystem.c
 create mode 100644 libbtrfsutil/internal.h
 create mode 100644 libbtrfsutil/python/.gitignore
 create mode 100644 libbtrfsutil/python/btrfsutilpy.h
 create mode 100644 libbtrfsutil/python/error.c
 create mode 100644 libbtrfsutil/python/filesystem.c
 create mode 100644 libbtrfsutil/python/module.c
 create mode 100644 libbtrfsutil/python/qgroup.c
 create mode 100755 libbtrfsutil/python/setup.py
 create mode 100644 libbtrfsutil/python/subvolume.c
 create mode 100644 libbtrfsutil/python/tests/__init__.py
 create mode 100644 libbtrfsutil/python/tests/test_filesystem.py
 create mode 100644 libbtrfsutil/python/tests/test_qgroup.py
 create mode 100644 libbtrfsutil/python/tests/test_subvolume.py
 create mode 100644 libbtrfsutil/qgroup.c
 create mode 100644 libbtrfsutil/subvolume.c

-- 
2.16.1

