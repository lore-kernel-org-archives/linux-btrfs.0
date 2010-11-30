From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Poor performance unlinking hard-linked files (repost)
Date: Tue, 30 Nov 2010 07:49:26 -0500
Message-ID: <1291121299-sup-9081@think>
References: <1289618724.28645.1405062363@webmail.messagingengine.com> <20101116125445.GA3229@brong.net> <1289914577-sup-8535@think> <20101117041148.GA10048@brong.net> <1290094104-sup-8656@think> <20101118214631.GC2401@brong.net> <1290175586-sup-2461@think> <20101119215810.GF12386@brong.net> <20101130093510.GB3622@brong.net>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Bron Gondwana <brong@fastmail.fm>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20101130093510.GB3622@brong.net>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Bron Gondwana's message of 2010-11-30 04:35:10 -0500:
> On Sat, Nov 20, 2010 at 08:58:10AM +1100, Bron Gondwana wrote:
> > On Fri, Nov 19, 2010 at 09:10:08AM -0500, Chris Mason wrote:
> > > Excerpts from Bron Gondwana's message of 2010-11-18 16:46:31 -0500:
> > > > On Thu, Nov 18, 2010 at 10:30:47AM -0500, Chris Mason wrote:
> > > > > Ok, we're mixing unlinks and fsyncs.  If it fsyncing directories too?
> > > > 
> > > > Nup.  I'm pretty sure it doesn't, just files.  Yes - there will certainly
> > > > be fsyncs going on as well - Cyrus is very careful to fsync everything it
> > > > cares about at the file level, but all it does with directories is mkdir
> > > > them if they don't exist.
> > > 
> > > Could you double check this one please?  fsyncing the directory is a ton
> > > more expensive, I just want to make sure it isn't part of the workload.
> > > 
> > > Otherwise it looks like we're seeking to read in the inode and unlink
> > > it.  One possibility is that we're not giving the elevator enough clues
> > > about the IO being synchronous.
> > > 
> > > Are you using cfq or deadline?  I bet we can improve the latencies using
> > > READ_SYNC.
> > 
> > I'm using deadline.
> > 
> > All I'm seeing is the fsyncs on the files.  And some unnecessary mkdir
> > calls that I can probably remove, and an unneccary truncate on the
> > quota file.
> 
> Do you have any suggestsions for what I could try?  You mentioned READ_SYNC
> above.  We now have one working partition on this machine, but it took longer
> to set up than most, and I'm not sure how it will cope with 7 more of them 
> (which is my next project - compare to the historical performance of this
> box first with reiserfs and then with ext4!)

Let me work up a patch that does READ_SYNC calls for the metadata reads,
and I'll try to model this here a little.  We should be able to improve
things.

-chris
