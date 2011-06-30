From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [GIT PULL v4] Btrfs: improve write ahead log with sub transaction
Date: Thu, 30 Jun 2011 17:27:47 +0800
Message-ID: <4E0C4193.203@cn.fujitsu.com>
References: <1309419392-17770-1-git-send-email-liubo2009@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: dave@jikos.cz, chris.mason@oracle.com, josef@redhat.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1309419392-17770-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/30/2011 03:36 PM, Liu Bo wrote:
> I've been working to try to improve the write-ahead log's performance,
> and I found that the bottleneck addresses in the checksum items,
> especially when we want to make a random write on a large file, e.g a 4G file.
> 
> Then a idea for this suggested by Chris is to use sub transaction ids and just
> to log the part of inode that had changed since either the last log commit or
> the last transaction commit.  And as we also push the sub transid into the btree
> blocks, we'll get much faster tree walks.  As a result, we abandon the original
> brute force approach, which is "to delete all items of the inode in log",
> to making sure we get the most uptodate copies of everything, and instead
> we manage to "find and merge", i.e. finding extents in the log tree and merging
> in the new extents from the file.
> 
> This patchset puts the above idea into code, and although the code is now more
> complex, it brings us a great deal of performance improvement:
> 

This is also available in

	git://repo.or.cz/linux-btrfs-devel.git sub-trans


thanks,
liubo

> in my sysbench "write + fsync" test:
> 
>         451.01Kb/sec -> 4.3621Mb/sec
> 
> Also, I've run the "synctest", and it works well with both directory and file.
> 
> v1->v2, rebase.
> v2->v3, thanks to Chris, we worked together to solve 2 bugs, and after that it
> worked as expected.
> v3->v4, thanks to Josef, we simplify several codes.
>  
> Liu Bo (12):
>   Btrfs: introduce sub transaction stuff
>   Btrfs: update block generation if should_cow_block fails
>   Btrfs: modify btrfs_drop_extents API
>   Btrfs: introduce first sub trans
>   Btrfs: still update inode trans stuff when size remains unchanged
>   Btrfs: improve log with sub transaction
>   Btrfs: add checksum check for log
>   Btrfs: fix a bug of log check
>   Btrfs: kick off useless code
>   Btrfs: use the right generation number to read log_root_tree
>   Btrfs: do not iput inode when inode is still in log
>   Revert "Btrfs: do not flush csum items of unchanged file data during
>     treelog"
> 
>  fs/btrfs/btrfs_inode.h |   12 ++-
>  fs/btrfs/ctree.c       |   69 +++++++++++----
>  fs/btrfs/ctree.h       |    5 +-
>  fs/btrfs/disk-io.c     |   12 ++--
>  fs/btrfs/extent-tree.c |   10 ++-
>  fs/btrfs/file.c        |   22 ++---
>  fs/btrfs/inode.c       |   39 ++++++---
>  fs/btrfs/ioctl.c       |    6 +-
>  fs/btrfs/relocation.c  |    6 +-
>  fs/btrfs/transaction.c |   13 ++-
>  fs/btrfs/transaction.h |   19 ++++-
>  fs/btrfs/tree-defrag.c |    2 +-
>  fs/btrfs/tree-log.c    |  225 ++++++++++++++++++++++++++++++++----------------
>  13 files changed, 293 insertions(+), 147 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

