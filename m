From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] btrfs: don't return EINTR
Date: Tue, 17 Apr 2012 15:36:20 -0400
Message-ID: <20120417193619.GC4143@localhost.localdomain>
References: <1334408175-6568-1-git-send-email-sensille@gmx.net>
 <4F8D7B04.9050904@gmx.net>
 <20120417152401.GL28915@shiny>
 <20120417182219.GA4143@localhost.localdomain>
 <4F8DBCCB.10904@gmx.net>
 <20120417191424.GB4143@localhost.localdomain>
 <20120417193417.GU28915@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>, Arne Jansen <sensille@gmx.net>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120417193417.GU28915@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 17, 2012 at 03:34:17PM -0400, Chris Mason wrote:
> On Tue, Apr 17, 2012 at 03:14:24PM -0400, Josef Bacik wrote:
> > On Tue, Apr 17, 2012 at 08:56:11PM +0200, Arne Jansen wrote:
> > > On 04/17/12 20:22, Josef Bacik wrote:
> > > >On Tue, Apr 17, 2012 at 11:24:01AM -0400, Chris Mason wrote:
> > > >>On Tue, Apr 17, 2012 at 04:15:32PM +0200, Arne Jansen wrote:
> > > >>>On 14.04.2012 14:56, Arne Jansen wrote:
> > > >>>>It is basically a good thing if we are interruptible when waiting for
> > > >>>>free space, but the generality in which it is implemented currently
> > > >>>>leads to system calls being interruptible that are not documented this
> > > >>>>way. For example git can't handle interrupted unlink(), leading to
> > > >>>>corrupt repos under space pressure.
> > > >>>
> > > >>>Is this patch a candidate for the next rc?
> > > >>
> > > >>The EINTR came from Josef.  We do want to be able to break out of long
> > > >>flushes, but I want to check with him to see if there was a specific bug
> > > >>this was solving?
> > > >
> > > >Sorry I was -ENOINTERNET, no the only thing I was fixing was being able to break
> > > >out of long flushes.  Maybe instead of using the big hammer here we just make
> > > >unlink ignore EINTR and try again, or maybe pass down a flag saying I can't be
> > > >interrupted?  Thanks,
> > > >
> > > 
> > > unlink() is the only call I've seen problems with, but there are
> > > probably other calls where EINTR is also unexpected.
> > > Also, just retrying the unlink internally won't help as the signal
> > > is still pending.
> > > How can we gather a list of calls where EINTR is ok?
> > 
> > Well then passing a flag down that says we can't interrupt I guess is what we're
> > going to have to do and just wait uninterruptible.  I think our best bet is to
> > just fix them as they come up, I thought all system calls could return EINTR but
> > apparently I was wrong :).  Thanks,
> 
> I'd guess that EINTR is unexpected most of the time.  Including in reads
> and writes.  The real question is how long we might end up waiting?
> 

EINTR is valid for both reads and writes.  This was put into place when I would
run tests and get tired of waiting for them so I'd ctrl+c and it wouldn't stop
even though it's something that's completely stoppable.  So I'd like to leave it
in there so at the very least I can still ctrl+c when I accidently run something
I don't want to run ;).  Thanks,

Josef
