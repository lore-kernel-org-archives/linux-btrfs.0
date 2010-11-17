From: Bron Gondwana <brong@fastmail.fm>
Subject: Re: Poor performance unlinking hard-linked files (repost)
Date: Wed, 17 Nov 2010 15:11:48 +1100
Message-ID: <20101117041148.GA10048@brong.net>
References: <1289618724.28645.1405062363@webmail.messagingengine.com>
 <20101116125445.GA3229@brong.net>
 <1289914577-sup-8535@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Bron Gondwana <brong@fastmail.fm>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1289914577-sup-8535@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 16, 2010 at 08:38:13AM -0500, Chris Mason wrote:
> Excerpts from Bron Gondwana's message of 2010-11-16 07:54:45 -0500:
> > Just posting this again more neatly formatted and just the
> > 'meat':
> > 
> > a) program creates piles of small temporary files, hard
> >    links them out to different directories, unlinks the
> >    originals.
> > 
> > b) filesystem size: ~ 300Gb (backed by hardware RAID5)
> > 
> > c) as the filesystem grows (currently about 30% full) 
> >    the unlink performance becomes horrible.  Watching
> >    iostat, there's a lot of reading going on as well.
> > 
> > Is this expected?  Is there anything we can do about it?
> > (short of rewrite Cyrus replication)
> 
> Hi,
> 
> It sounds like the unlink speed is limited by the reading, and the reads
> are coming from one of two places.  We're either reading to cache cold
> block groups or we're reading to find the directory entries.

All the unlinks for a single process will be happening in the same
directory (though the hard linked copies will be all over)

> Could you sysrq-w while the performance is bad?  That would narrow it
> down.

Here's one:

http://pastebin.com/Tg7agv42
 
> Josef has the reads for caching block groups fixed, but we'll have to
> look hard at the reads for the rest of unlink.

I suspect you may want a couple more before you have enough data.  I
could set up a job to run one every 10 minutes for a couple of hours
or something.  There will be at least two, possibly three threads of
"sync_server" running on this particular server instance.  It has two
btrfs partitions - a 15Gb partition on RAID1 and a 300Gb partition
on RAID5.  All the unlinks will be happening to the RAID5 one.

Bron ( our usual fully loaded server might have up to 40 of these pairs
       over 12 separate RAID sets, so anything that doesn't scale out
       to lots of filesystems would make us pretty sad too )
