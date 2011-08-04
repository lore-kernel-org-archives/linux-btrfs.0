From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL v3] Btrfs: improve write ahead log with sub transaction
Date: Thu, 04 Aug 2011 09:57:54 -0400
Message-ID: <1312465984-sup-9697@shiny>
References: <1308646193-7086-1-git-send-email-liubo2009@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, dave <dave@jikos.cz>,
	josef <josef@redhat.com>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <1308646193-7086-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Liu Bo's message of 2011-06-21 04:49:41 -0400:
> I've been working to try to improve the write-ahead log's performance,
> and I found that the bottleneck addresses in the checksum items,
> especially when we want to make a random write on a large file, e.g a 4G file.

I spent some time last week on this code, because I really wanted to
be able to include it.  But I hit two problems.

Recording the transid of the log tree root doesn't completely solve
problems with later mounts expecting generation + 1.  If an older kernel
were to try and mount a log created by our new code, it wouldn't
understand the transid and the mount would fail.

I think we just need to force the transid of the root block to
generation + 1.  It is slightly less optimal but still much better than
what we have.

The second problem was that I consistently hit crashes during log replay
after a crash.  The test was just to use synctest:

http://oss.oracle.com/~mason/synctest/

synctest -t 32 -f -F -u -n 100 /mnt

I waited about 45 seconds and reset the machine.  Later mounts would
crash during log replay.

-chris

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
> in my sysbench "write + fsync" test:
> 
>     451.01Kb/sec -> 4.3621Mb/sec
> 
> In v2, thanks to Chris, we worked together to solve 2 bugs, and after that it
> works as expected.
> 
> Since there are some vital changes in recent rc, like "kill trans_mutex" and
> "use cur_trans", as David asked, I rebase the patchset to the latest for-linus
> branch.
> 
> More tests are welcome!
> 
> You can also get this patchset from:
> 
>     git://repo.or.cz/linux-btrfs-devel.git sub-trans
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
>   Btrfs: deal with EEXIST after iput
>   Btrfs: use the right generation number to read log_root_tree
>   Revert "Btrfs: do not flush csum items of unchanged file data during
>     treelog"
> 
>  fs/btrfs/btrfs_inode.h |   12 ++-
>  fs/btrfs/ctree.c       |   69 +++++++++---
>  fs/btrfs/ctree.h       |    5 +-
>  fs/btrfs/disk-io.c     |   12 +-
>  fs/btrfs/extent-tree.c |   10 +-
>  fs/btrfs/file.c        |   22 ++---
>  fs/btrfs/inode.c       |   33 ++++---
>  fs/btrfs/ioctl.c       |    6 +-
>  fs/btrfs/relocation.c  |    6 +-
>  fs/btrfs/transaction.c |   14 ++-
>  fs/btrfs/transaction.h |   19 +++-
>  fs/btrfs/tree-defrag.c |    2 +-
>  fs/btrfs/tree-log.c    |  272 ++++++++++++++++++++++++++++++++++-------------
>  13 files changed, 331 insertions(+), 151 deletions(-)
