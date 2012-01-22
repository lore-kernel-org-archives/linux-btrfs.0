From: Swapnil Pimpale <swapnil.pict@gmail.com>
Subject: Compiler warnings: cast from pointer to integer of different size
Date: Sun, 22 Jan 2012 19:58:43 +0530
Message-ID: <CAGZys+S5cRjtMwFb_kJsZ8L4eYua8YstYJFBCVQ+8EEZ8F9WgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I encounter the following compiler warnings while compiling kernel 3.3.=
0-rc1+

=2E..
  CC      fs/btrfs/super.o
  CC      fs/btrfs/ctree.o
  CC      fs/btrfs/extent-tree.o
fs/btrfs/extent-tree.c: In function =91btrfs_check_data_free_space=92:
fs/btrfs/extent-tree.c:3314:11: warning: cast from pointer to integer
of different size [-Wpointer-to-int-cast]
fs/btrfs/extent-tree.c: In function =91btrfs_free_reserved_data_space=92=
:
fs/btrfs/extent-tree.c:3335:11: warning: cast from pointer to integer
of different size [-Wpointer-to-int-cast]
fs/btrfs/extent-tree.c: In function =91reserve_metadata_bytes=92:
fs/btrfs/extent-tree.c:3698:13: warning: cast from pointer to integer
of different size [-Wpointer-to-int-cast]
fs/btrfs/extent-tree.c:3769:13: warning: cast from pointer to integer
of different size [-Wpointer-to-int-cast]
fs/btrfs/extent-tree.c: In function =91block_rsv_release_bytes=92:
fs/btrfs/extent-tree.c:3915:13: warning: cast from pointer to integer
of different size [-Wpointer-to-int-cast]
fs/btrfs/extent-tree.c: In function =91update_global_block_rsv=92:
fs/btrfs/extent-tree.c:4134:12: warning: cast from pointer to integer
of different size [-Wpointer-to-int-cast]
fs/btrfs/extent-tree.c:4141:12: warning: cast from pointer to integer
of different size [-Wpointer-to-int-cast]
fs/btrfs/extent-tree.c: In function =91btrfs_trans_release_metadata=92:
fs/btrfs/extent-tree.c:4194:62: warning: cast from pointer to integer
of different size [-Wpointer-to-int-cast]
fs/btrfs/extent-tree.c: In function =91btrfs_update_reserved_bytes=92:
fs/btrfs/extent-tree.c:4713:14: warning: cast from pointer to integer
of different size [-Wpointer-to-int-cast]
  CC      fs/btrfs/print-tree.o
  CC      fs/btrfs/root-tree.o
  CC      fs/btrfs/dir-item.o
  CC      fs/btrfs/file-item.o
  CC      fs/btrfs/inode-item.o
  CC      fs/btrfs/inode-map.o
fs/btrfs/inode-map.c: In function =91btrfs_save_ino_cache=92:
fs/btrfs/inode-map.c:441:60: warning: cast from pointer to integer of
different size [-Wpointer-to-int-cast]
fs/btrfs/inode-map.c:503:60: warning: cast from pointer to integer of
different size [-Wpointer-to-int-cast]
  CC      fs/btrfs/disk-io.o
  CC      fs/btrfs/transaction.o
fs/btrfs/transaction.c: In function =91start_transaction=92:
fs/btrfs/transaction.c:330:12: warning: cast from pointer to integer
of different size [-Wpointer-to-int-cast]
  CC      fs/btrfs/inode.o
  CC      fs/btrfs/file.o
  CC      fs/btrfs/tree-defrag.o
  CC      fs/btrfs/extent_map.o
  CC      fs/btrfs/sysfs.o
  CC      fs/btrfs/struct-funcs.o
  CC      fs/btrfs/xattr.o
  CC      fs/btrfs/ordered-data.o
  CC      fs/btrfs/extent_io.o
  CC      fs/btrfs/volumes.o
  CC      fs/btrfs/async-thread.o
  CC      fs/btrfs/ioctl.o
  CC      fs/btrfs/locking.o
  CC      fs/btrfs/orphan.o
  CC      fs/btrfs/export.o
  CC      fs/btrfs/tree-log.o
  CC      fs/btrfs/free-space-cache.o
  CC      fs/btrfs/zlib.o
  CC      fs/btrfs/lzo.o
  CC      fs/btrfs/compression.o
  CC      fs/btrfs/delayed-ref.o
  CC      fs/btrfs/relocation.o
  CC      fs/btrfs/delayed-inode.o
  CC      fs/btrfs/scrub.o
  CC      fs/btrfs/reada.o
  CC      fs/btrfs/backref.o
  CC      fs/btrfs/ulist.o
  CC      fs/btrfs/acl.o
  LD      fs/btrfs/btrfs.o
  LD      fs/btrfs/built-in.o
=2E..

--Swapnil
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
