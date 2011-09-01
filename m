From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: [PATCH 00/12 v5] Btrfs: improve write ahead log with sub transaction
Date: Thu, 1 Sep 2011 12:38:32 -0500
Message-ID: <CAKcLGm8Fgm+R3tAHcESc_VtQMcFgc48oiZ4W1gbemi6D3+B+Ug@mail.gmail.com>
References: <1312623467-31487-1-git-send-email-liubo2009@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1312623467-31487-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 6, 2011 at 4:37 AM, Liu Bo <liubo2009@cn.fujitsu.com> wrote=
:
> I've fixed a bug and rebased this to the latest for-linus branch,
> and with applying my previous posted patch:
>
> =A0 =A0 =A0 =A0[PATCH] Btrfs: fix an oops of log replay
>
> , I also test this sub transaction patchset with
> a) sysbench 0.4.12 tool and
> b) Chris's synctest tool in both _crash_ and _uncrash_ cases, and it =
works well.
>
> Please test this and feel free to notice me if there are any problems=
=2E
> Hope that it can get through with no bugs and be ready for merge this=
 time :)
>
> =3D=3D=3D
> I've been working to try to improve the write-ahead log's performance=
,
> and I found that the bottleneck addresses in the checksum items,
> especially when we want to make a random write on a large file, e.g a=
 4G file.
>
> Then a idea for this suggested by Chris is to use sub transaction ids=
 and just
> to log the part of inode that had changed since either the last log c=
ommit or
> the last transaction commit. =A0And as we also push the sub transid i=
nto the btree
> blocks, we'll get much faster tree walks. =A0As a result, we abandon =
the original
> brute force approach, which is "to delete all items of the inode in l=
og",
> to making sure we get the most uptodate copies of everything, and ins=
tead
> we manage to "find and merge", i.e. finding extents in the log tree a=
nd merging
> in the new extents from the file.
>
> This patchset puts the above idea into code, and although the code is=
 now more
> complex, it brings us a great deal of performance improvement:
>
> in my sysbench "write + fsync" test:
>
> =A0 =A0 =A0 =A0451.01Kb/sec -> 4.3621Mb/sec
>
> In v2, thanks to Chris, we worked together to solve 2 bugs, and after=
 that it
> works as expected.
> In v3, thanks to Josef, we simplify several code.
> In v4, rebase to the latest for-linus branch, Chris hit two problems,=
 and we
> solve them.
>
> Since there are some vital changes in recent rc, like "kill trans_mut=
ex" and
> "use cur_trans", as David asked, I rebase the patchset to the latest =
for-linus
> branch.
>
> More tests are welcome!
>
>
> Liu Bo (12):
> =A0Revert "Btrfs: do not flush csum items of unchanged file data duri=
ng
> =A0 =A0treelog"
> =A0Btrfs: introduce sub transaction stuff
> =A0Btrfs: update block generation if should_cow_block fails
> =A0Btrfs: modify btrfs_drop_extents API
> =A0Btrfs: introduce first sub trans
> =A0Btrfs: still update inode trans stuff when size remains unchanged
> =A0Btrfs: improve log with sub transaction
> =A0Btrfs: add checksum check for log
> =A0Btrfs: fix a bug of log check
> =A0Btrfs: kick off useless code
> =A0Btrfs: do not iput inode when inode is still in log
> =A0Btrfs: use the right generation number to read log_root_tree
>
> =A0fs/btrfs/btrfs_inode.h | =A0 12 ++-
> =A0fs/btrfs/ctree.c =A0 =A0 =A0 | =A0 87 +++++++++++++------
> =A0fs/btrfs/ctree.h =A0 =A0 =A0 | =A0 =A05 +-
> =A0fs/btrfs/disk-io.c =A0 =A0 | =A0 23 ++++--
> =A0fs/btrfs/extent-tree.c | =A0 10 ++-
> =A0fs/btrfs/file.c =A0 =A0 =A0 =A0| =A0 22 ++---
> =A0fs/btrfs/inode.c =A0 =A0 =A0 | =A0 39 ++++++---
> =A0fs/btrfs/ioctl.c =A0 =A0 =A0 | =A0 =A06 +-
> =A0fs/btrfs/relocation.c =A0| =A0 =A06 +-
> =A0fs/btrfs/transaction.c | =A0 13 ++-
> =A0fs/btrfs/transaction.h | =A0 19 ++++-
> =A0fs/btrfs/tree-defrag.c | =A0 =A02 +-
> =A0fs/btrfs/tree-log.c =A0 =A0| =A0225 ++++++++++++++++++++++++++++++=
++----------------
> =A013 files changed, 312 insertions(+), 157 deletions(-)
>

I've had the v5 stack of patches in my kernel for about 3 weeks now.

I've just been testing for general stability in a 3.0 series kernel,
and I haven't run across any issues or obvious performance effects.

I've been testing on both x86 and x86_64 installations in Desktop
service without RAID.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
