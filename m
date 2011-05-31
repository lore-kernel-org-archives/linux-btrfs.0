From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: [PATCH v2 0/7] Btrfs: New inode number allocator
Date: Tue, 31 May 2011 23:01:23 +0200
Message-ID: <201105312301.24788.johannes.hirte@fem.tu-ilmenau.de>
References: <4DB5378B.2070904@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DB5378B.2070904@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 25 April 2011 10:57:47 Li Zefan wrote:
> Currently btrfs stores the highest objectid of the fs tree, and it always
> returns (highest+1) inode number when we create a file, so inode numbers
> won't be reclaimed when we delete files, so we'll run out of inode numbers
> as we keep create/delete files in 32bits machines.
> 
> This patchset aims to fix this, and it works similar to free space caching
> for block groups.
> 
> I've run xfstests, and I also tested it with snapshot, balance etc.
> 
> More testing is appreciated!
> 
> Changelog v2:
> 
> - Rebased against latest btrfs-unstable tree
> - Fixed several small bugs.
> 
> ---
>  fs/btrfs/btrfs_inode.h      |    9 +
>  fs/btrfs/compression.c      |    5 +-
>  fs/btrfs/ctree.h            |   29 +-
>  fs/btrfs/disk-io.c          |   19 +
>  fs/btrfs/export.c           |   25 +-
>  fs/btrfs/extent-tree.c      |   50 ++-
>  fs/btrfs/extent_io.c        |    4 +-
>  fs/btrfs/file-item.c        |    5 +-
>  fs/btrfs/file.c             |   27 +-
>  fs/btrfs/free-space-cache.c |  968
> ++++++++++++++++++++++++++----------------- fs/btrfs/free-space-cache.h | 
>  48 ++-
>  fs/btrfs/inode-map.c        |  428 +++++++++++++++++++-
>  fs/btrfs/inode-map.h        |   13 +
>  fs/btrfs/inode.c            |  282 +++++++------
>  fs/btrfs/ioctl.c            |   22 +-
>  fs/btrfs/relocation.c       |   27 +-
>  fs/btrfs/transaction.c      |   13 +-
>  fs/btrfs/tree-log.c         |   54 ++--
>  fs/btrfs/xattr.c            |    8 +-
>  19 files changed, 1402 insertions(+), 634 deletions(-)

This makes my laptop unusable here. With linux-3.0-rc1 I have the problem that 
booting is horrible slow with very much IO (the kernel thread that reads the 
file tree?). I've never tried how long it would take to boot the system. After 
10-15 minutes I've canceled the boot (sysrq-u, sysrq-b) and took a working 
kernel.

git bisect pointed me to:

commit 581bb050941b4f220f84d3e5ed6dace3d42dd382
Author: Li Zefan <lizf@cn.fujitsu.com>
Date:   Wed Apr 20 10:06:11 2011 +0800

    Btrfs: Cache free inode numbers in memory
    
    Currently btrfs stores the highest objectid of the fs tree, and it always
    returns (highest+1) inode number when we create a file, so inode numbers
    won't be reclaimed when we delete files, so we'll run out of inode numbers
    as we keep create/delete files in 32bits machines.
    
    This fixes it, and it works similarly to how we cache free space in block
    cgroups.
    
    We start a kernel thread to read the file tree. By scanning inode items,
    we know which chunks of inode numbers are free, and we cache them in
    an rb-tree.
    
    Because we are searching the commit root, we have to carefully handle the
    cross-transaction case.
    
    The rb-tree is a hybrid extent+bitmap tree, so if we have too many small
    chunks of inode numbers, we'll use bitmaps. Initially we allow 16K ram
    of extents, and a bitmap will be used if we exceed this threshold. The
    extents threshold is adjusted in runtime.
    
    Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

I have three subvolumes here, the default one, one for / and one for /home. 
Don't know if this matters. If you need more infos, please tell me.

regards,
  Johannes
