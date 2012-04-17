From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] btrfs: don't return EINTR
Date: Tue, 17 Apr 2012 15:38:43 -0400
Message-ID: <20120417193843.GV28915@shiny>
References: <1334408175-6568-1-git-send-email-sensille@gmx.net>
 <4F8D7B04.9050904@gmx.net>
 <20120417152401.GL28915@shiny>
 <20120417182219.GA4143@localhost.localdomain>
 <4F8DBCCB.10904@gmx.net>
 <20120417191424.GB4143@localhost.localdomain>
 <20120417193417.GU28915@shiny>
 <20120417193619.GC4143@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arne Jansen <sensille@gmx.net>, linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120417193619.GC4143@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 17, 2012 at 03:36:20PM -0400, Josef Bacik wrote:
> > > Well then passing a flag down that says we can't interrupt I guess is what we're
> > > going to have to do and just wait uninterruptible.  I think our best bet is to
> > > just fix them as they come up, I thought all system calls could return EINTR but
> > > apparently I was wrong :).  Thanks,
> > 
> > I'd guess that EINTR is unexpected most of the time.  Including in reads
> > and writes.  The real question is how long we might end up waiting?
> > 
> 
> EINTR is valid for both reads and writes.  This was put into place when I would
> run tests and get tired of waiting for them so I'd ctrl+c and it wouldn't stop
> even though it's something that's completely stoppable.  So I'd like to leave it
> in there so at the very least I can still ctrl+c when I accidently run something
> I don't want to run ;).  Thanks,

Ok. lets just teach git how to eintr.


-chris
