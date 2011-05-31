From: Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH v1 0/3] btrfs: cleanup: pass fs_info instead of root where
 possible
Date: Tue, 31 May 2011 12:38:32 +0200
Message-ID: <4DE4C528.3040700@gmx.net>
References: <cover.1306836192.git.sensille@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: julia@diku.dk
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1306836192.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

3/3 doesn't seem to arrive anymore, possibly due to a mail size
restriction on vger (yes, it is big). So I pushed it out to:

git://git.kernel.org/pub/scm/linux/kernel/git/arne/btrfs-unstable-arne.git
root-eliminate

Thanks,
Arne

On 31.05.2011 12:16, Arne Jansen wrote:
> This series aims to clean up passing of struct btrfs_root and struct
> btrfs_fs_info. It first removes the root pointer from functions and macros
> where it's not needed, afterwards it passes fs_info instead of root to
> functions which only need root->fs_info.
> 
> It is based on 3.0-rc1.
> 
> These patches are based on the following two Coccinelle-scripts, but also
> involve some hand editing.
> 
> a) Remove root parameter where it's completely unneeded. Fix up callers.
> 
> @r@
> identifier fn != btrfs_inc_extent_ref;
> identifier root;
> parameter list[n] P;
> @@
> 
>   fn(P
> -    , struct btrfs_root *root
>    ,...)
>   {
>   ... when != root
>   }
> 
> @@
> identifier r.fn;
> expression list[r.n] E;
> identifier x;
> @@
> 
>   fn(E
> -    ,x
>    ,...)
> 
> b) Change root parameter to fs_info where only root->fs_info is needed. Fix up
>    callers.
> 
> @ s exists @
> identifier fn;
> identifier root, sf;
> identifier member != fs_info;
> position p;
> expression E;
> parameter list[n] P;
> @@
>  fn@p(P,struct btrfs_root *root,...)
>   {
>   ...
> (
>   root->member
> |
>   sf(...,root,...)
> |
>   (root && ...)
> |
>   (root == ...)
> |
>   E = root
> )
>   ... when any
>   }
> 
> @ t @
> identifier fn != {process_one_buffer,btrfs_inc_extent_ref,btrfs_free_extent};
> identifier root;
> parameter list[n] P;
> position p != s.p;
> @@
> 
>   fn@p(P,
> -    struct btrfs_root *root
> +    struct btrfs_fs_info *fs_info
>    ,...)
>   {
>   <...
> -  root->fs_info
> +  fs_info
>   ...>
>   }
> 
> @@
> identifier t.fn;
> expression list[t.n] E;
> expression x;
> @@
> 
>   fn(E,
> -    x
> +    x->fs_info
>    ,...)
> 
> @@
> function fn;
> identifier fs_info;
> identifier x;
> parameter list[n] P;
> @@
>   fn(P, struct btrfs_fs_info *fs_info, ... ) {
>   ...
> - struct btrfs_fs_info *x = fs_info;
>   <...
> -  x
> +  fs_info
>   ...>
>   }
> 
> 
> Thanks to Julia Lawall for helping to build the scripts.
> 
> 
> Arne Jansen (3):
>   btrfs: remove struct btrfs_root parameter where unused
>   btrfs: pass fs_info to btrfs_test_opt instead of root
>   btrfs: cleanup: pass fs_info instead of root where possible
> 
>  fs/btrfs/compression.c      |   11 +-
>  fs/btrfs/ctree.c            |   76 +++++----
>  fs/btrfs/ctree.h            |   66 ++++----
>  fs/btrfs/delayed-inode.c    |   43 +++---
>  fs/btrfs/disk-io.c          |  281 +++++++++++++++---------------
>  fs/btrfs/disk-io.h          |   24 ++--
>  fs/btrfs/extent-tree.c      |  409 ++++++++++++++++++++++---------------------
>  fs/btrfs/file-item.c        |    5 +-
>  fs/btrfs/file.c             |   16 +-
>  fs/btrfs/free-space-cache.c |   12 +-
>  fs/btrfs/free-space-cache.h |    2 +-
>  fs/btrfs/inode.c            |  108 ++++++------
>  fs/btrfs/ioctl.c            |   57 +++---
>  fs/btrfs/ordered-data.c     |   48 +++---
>  fs/btrfs/ordered-data.h     |    6 +-
>  fs/btrfs/print-tree.c       |    2 +-
>  fs/btrfs/relocation.c       |   40 +++--
>  fs/btrfs/scrub.c            |   68 +++-----
>  fs/btrfs/super.c            |   34 ++--
>  fs/btrfs/transaction.c      |  183 ++++++++++----------
>  fs/btrfs/transaction.h      |   12 +-
>  fs/btrfs/tree-defrag.c      |    2 +-
>  fs/btrfs/tree-log.c         |   40 +++--
>  fs/btrfs/volumes.c          |  246 +++++++++++++-------------
>  fs/btrfs/volumes.h          |   10 +-
>  25 files changed, 912 insertions(+), 889 deletions(-)
> 

