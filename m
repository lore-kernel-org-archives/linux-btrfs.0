From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC] Add a new file op for fsync to give fs's more control
Date: Mon, 18 Apr 2011 10:30:34 -0400
Message-ID: <1303136831-sup-2236@think>
References: <1302894582-24341-1-git-send-email-josef@redhat.com> <20110415192412.GA17974@infradead.org> <4DA89D59.1070402@redhat.com> <4DABDF0F.2060609@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4DABDF0F.2060609@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from liubo's message of 2011-04-18 02:49:51 -0400:
> On 04/16/2011 03:32 AM, Josef Bacik wrote:
> > On 04/15/2011 03:24 PM, Christoph Hellwig wrote:
> >> Sorry, but this is too ugly to live.  If the reason for this really is
> >> good enough we'll just need to push the filemap_write_and_wait_range
> >> and i_mutex locking into every ->fsync instance.
> >>
> > 
> > So part of what makes small fsyncs slow in btrfs is all of our random
> > threads to make checksumming not suck.  So we submit IO which spreads it
> > out to helper threads to do the checksumming, and then when it returns
> > it gets handed off to endio threads that run the endio stuff.  This
> > works awesome with doing big writes and such, but if say we're and RPM
> > database and write a couple of kilbytes, this tends to suck because we
> > keep handing work off to other threads and waiting, so the scheduling
> > latencies really hurt.
> > 
> > So we'd like to be able to say "hey this is a small amount of io, lets
> > just do the checksumming in the current thread", and the same with
> > handling the endio stuff.  We can't do that currently because
> > filemap_write_and_wait_range is called before we get to fsync.  We'd
> > like to be able to control this so we can do the appropriate magic to do
> > the submission within the fsyncings thread context in order to speed
> > things up a bit.
> > 
> > That plus the stuff I said about i_mutex.  Is that a good enough reason
> > to just push this down into all the filesystems?  Thanks,
> > 
> 
> Fine with the i_mutex.
> 
> I'm wandering that is it worth of doing so?
> 
> I've tested your patch with sysbench, and there is little improvement. :(
> 
> Sysbench args:
> sysbench --test=fileio --num-threads=1 --file-num=10240 --file-block-size=1K --file-total-size=20M --file-test-mode=rndwr --file-io-mode=sync --file-extra-flags=  run

Btrfs is already dropping i_mutex in its fsync as much as it can.  It is
somewhat less efficient because it has to take it back again before
returning, but I don't think it will be a huge difference.

> 
> 
> 10240 files, 2Kb each
> ===
> fsync_nolock (patch):
> Operations performed:  0 Read, 10000 Write, 1024000 Other = 1034000 Total
> Read 0b  Written 9.7656Mb  Total transferred 9.7656Mb  (35.152Kb/sec)
>    35.15 Requests/sec executed
> 
> fsync (orig):
> Operations performed:  0 Read, 10000 Write, 1024000 Other = 1034000 Total
> Read 0b  Written 9.7656Mb  Total transferred 9.7656Mb  (35.287Kb/sec)
>    35.29 Requests/sec executed
> ===
> 
> Seems that the improvement of avoiding threads interchange is not enough.
> 
> BTW, I'm trying to improve the fsync performance stuff, but mainly for large files(>4G).
> And I found that a large file will have a tremendous amount of csum items needed to
> be flush into tree log during fsync().  Btrfs now uses a brute force approach to
> ensure to get the most uptodate copies of everything, and this results in a bad
> performance.  To change the brute way is bugging me a lot...

The big problem with the fsync log is that we need to bump the
transaction id as we do tree log commits.  This will allow us to find
just the things that have changed since our last fsync.

The current code that relogs the entire inode every time also needs to
be more fine grained.  It is much better suited to small files than
large ones.

-chris
