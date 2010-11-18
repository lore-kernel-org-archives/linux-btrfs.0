From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Poor performance unlinking hard-linked files (repost)
Date: Thu, 18 Nov 2010 10:30:47 -0500
Message-ID: <1290094104-sup-8656@think>
References: <1289618724.28645.1405062363@webmail.messagingengine.com> <20101116125445.GA3229@brong.net> <1289914577-sup-8535@think> <20101117041148.GA10048@brong.net>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Bron Gondwana <brong@fastmail.fm>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20101117041148.GA10048@brong.net>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Bron Gondwana's message of 2010-11-16 23:11:48 -0500:
> On Tue, Nov 16, 2010 at 08:38:13AM -0500, Chris Mason wrote:
> > Excerpts from Bron Gondwana's message of 2010-11-16 07:54:45 -0500:
> > > Just posting this again more neatly formatted and just the
> > > 'meat':
> > > 
> > > a) program creates piles of small temporary files, hard
> > >    links them out to different directories, unlinks the
> > >    originals.
> > > 
> > > b) filesystem size: ~ 300Gb (backed by hardware RAID5)
> > > 
> > > c) as the filesystem grows (currently about 30% full) 
> > >    the unlink performance becomes horrible.  Watching
> > >    iostat, there's a lot of reading going on as well.
> > > 
> > > Is this expected?  Is there anything we can do about it?
> > > (short of rewrite Cyrus replication)
> > 
> > Hi,
> > 
> > It sounds like the unlink speed is limited by the reading, and the reads
> > are coming from one of two places.  We're either reading to cache cold
> > block groups or we're reading to find the directory entries.
> 
> All the unlinks for a single process will be happening in the same
> directory (though the hard linked copies will be all over)
> 
> > Could you sysrq-w while the performance is bad?  That would narrow it
> > down.
> 
> Here's one:
> 
> http://pastebin.com/Tg7agv42

Ok, we're mixing unlinks and fsyncs.  If it fsyncing directories too?

-chris
