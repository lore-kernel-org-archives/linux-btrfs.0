From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] btrfs: don't return EINTR
Date: Tue, 17 Apr 2012 14:22:20 -0400
Message-ID: <20120417182219.GA4143@localhost.localdomain>
References: <1334408175-6568-1-git-send-email-sensille@gmx.net>
 <4F8D7B04.9050904@gmx.net>
 <20120417152401.GL28915@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>,
	Arne Jansen <sensille@gmx.net>, Josef Bacik <josef@redhat.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120417152401.GL28915@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 17, 2012 at 11:24:01AM -0400, Chris Mason wrote:
> On Tue, Apr 17, 2012 at 04:15:32PM +0200, Arne Jansen wrote:
> > On 14.04.2012 14:56, Arne Jansen wrote:
> > > It is basically a good thing if we are interruptible when waiting for
> > > free space, but the generality in which it is implemented currently
> > > leads to system calls being interruptible that are not documented this
> > > way. For example git can't handle interrupted unlink(), leading to
> > > corrupt repos under space pressure.
> > 
> > Is this patch a candidate for the next rc?
> 
> The EINTR came from Josef.  We do want to be able to break out of long
> flushes, but I want to check with him to see if there was a specific bug
> this was solving?

Sorry I was -ENOINTERNET, no the only thing I was fixing was being able to break
out of long flushes.  Maybe instead of using the big hammer here we just make
unlink ignore EINTR and try again, or maybe pass down a flag saying I can't be
interrupted?  Thanks,

Josef 
