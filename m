From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Poor performance unlinking hard-linked files (repost)
Date: Fri, 19 Nov 2010 09:10:08 -0500
Message-ID: <1290175586-sup-2461@think>
References: <1289618724.28645.1405062363@webmail.messagingengine.com> <20101116125445.GA3229@brong.net> <1289914577-sup-8535@think> <20101117041148.GA10048@brong.net> <1290094104-sup-8656@think> <20101118214631.GC2401@brong.net>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Bron Gondwana <brong@fastmail.fm>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20101118214631.GC2401@brong.net>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Bron Gondwana's message of 2010-11-18 16:46:31 -0500:
> On Thu, Nov 18, 2010 at 10:30:47AM -0500, Chris Mason wrote:
> > Excerpts from Bron Gondwana's message of 2010-11-16 23:11:48 -0500:
> > > > > a) program creates piles of small temporary files, hard
> > > > >    links them out to different directories, unlinks the
> > > > >    originals.
> > > > > 
> > > > > b) filesystem size: ~ 300Gb (backed by hardware RAID5)
> > > > > 
> > > > > c) as the filesystem grows (currently about 30% full) 
> > > > >    the unlink performance becomes horrible.  Watching
> > > > >    iostat, there's a lot of reading going on as well.
> > > > 
> > > > It sounds like the unlink speed is limited by the reading, and the reads
> > > > are coming from one of two places.  We're either reading to cache cold
> > > > block groups or we're reading to find the directory entries.
> > > 
> > > All the unlinks for a single process will be happening in the same
> > > directory (though the hard linked copies will be all over)
> > > 
> > > > Could you sysrq-w while the performance is bad?  That would narrow it
> > > > down.
> > > 
> > > Here's one:
> > > 
> > > http://pastebin.com/Tg7agv42
> > 
> > Ok, we're mixing unlinks and fsyncs.  If it fsyncing directories too?
> 
> Nup.  I'm pretty sure it doesn't, just files.  Yes - there will certainly
> be fsyncs going on as well - Cyrus is very careful to fsync everything it
> cares about at the file level, but all it does with directories is mkdir
> them if they don't exist.

Could you double check this one please?  fsyncing the directory is a ton
more expensive, I just want to make sure it isn't part of the workload.

Otherwise it looks like we're seeking to read in the inode and unlink
it.  One possibility is that we're not giving the elevator enough clues
about the IO being synchronous.

Are you using cfq or deadline?  I bet we can improve the latencies using
READ_SYNC.

-chris


> 
> This just a single "sync_server" process on an experimental server.  A 
> real server under full load is going to have multiple processes doing
> fsyncs and unlinks.
> 
> A significant portion of unlinks are of files that have another link on
> the filesystem.  Every mailbox "move" is implemented as a copy (hardlink)
> plus expunge (delayed unlink).  The "delay" works by marking the message
> to be deleted in the cyrus.index metadata file, and then deleting later
> (tunable: 7 to 14 days in our case depending when the next weekend is)
> 
> Bron.
