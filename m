From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC PATCH] Btrfs: do not flush csum items of unchanged file data during treelog
Date: Thu, 21 Apr 2011 21:28:17 -0400
Message-ID: <1303435579-sup-6101@think>
References: <4DAFE39D.4040309@cn.fujitsu.com> <1303391634-sup-1145@think> <4DB0D20C.9060407@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Cc: liubo <liubo2009@cn.fujitsu.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Josef Bacik <josef@redhat.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4DB0D20C.9060407@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Li Zefan's message of 2011-04-21 20:55:40 -0400:
> Chris Mason wrote:
> > Excerpts from liubo's message of 2011-04-21 03:58:21 -0400:
> >>
> >> The current code relogs the entire inode every time during fsync log,
> >> and it is much better suited to small files rather than large ones.
> >>
> >> During my performance test, the fsync performace of large files sucks,
> >> and we can ascribe this to the tremendous amount of csum infos of the
> >> large ones, cause we have to flush all of these csum infos into log trees
> >> even when there are only _one_ change in the whole file data.  Apparently,
> >> to optimize fsync, we need to create a filter to skip the unnecessary csum
> >> ones, that is, the corresponding file data remains unchanged before this fsync.
> >>
> >> Here I have some test results to show, I use sysbench to do "random write + fsync".
> >>
> >> Sysbench args:
> >>   - Number of threads: 1
> >>   - Extra file open flags: 0
> >>   - 2 files, 4Gb each
> >>   - Block size 4Kb
> >>   - Number of random requests for random IO: 10000
> >>   - Read/Write ratio for combined random IO test: 1.50
> >>   - Periodic FSYNC enabled, calling fsync() each 100 requests.
> >>   - Calling fsync() at the end of test, Enabled.
> >>   - Using synchronous I/O mode
> >>   - Doing random write test
> >>
> >> Sysbench results:
> >> ===
> >>    Operations performed:  0 Read, 10000 Write, 200 Other = 10200 Total
> >>    Read 0b  Written 39.062Mb  Total transferred 39.062Mb
> >> ===
> >> a) without patch:  (*SPEED* : 451.01Kb/sec)
> >>    112.75 Requests/sec executed
> >>
> >> b) with patch:     (*SPEED* : 5.1537Mb/sec)
> >>    1319.34 Requests/sec executed
> > 
> > Really nice results! Especially considering the small size of the patch.
> > 
> > But, I'd really like to look at using sub transaction ids for this, and
> > then logging just the part of the inode that had changed since the last
> > log commit.  It's more complex, but will also help reduce tree searches
> > for the file items.
> > 
> 
> And this patch forgot to mention it has compatability issue.

Right, at the very least we want to just use one bit of that field
instead of all 8.  But keeping a sub-transid and putting that in the
generation field of the file extent instead can get us the same benefits
without stealing the bits.

As we push the sub transid into the btree blocks as well, we'll get much
faster tree walks too.  The penalty is in complexity in the logging
code, since it will have to deal with finding extents in the log tree
and merging in the new extents from the file.

-chris
