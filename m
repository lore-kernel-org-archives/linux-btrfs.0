From: Chris Mason <chris.mason@oracle.com>
Subject: Re: WARNING: at fs/btrfs/extent-tree.c:124
Date: Mon, 7 Nov 2011 20:04:49 -0500
Message-ID: <20111108010449.GP4265@shiny>
References: <4EB76845.90703@jp.fujitsu.com>
 <20111107161232.GE4265@shiny>
 <4EB8732E.7000807@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EB8732E.7000807@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 08, 2011 at 09:09:18AM +0900, Tsutomu Itoh wrote:
> (2011/11/08 1:12), Chris Mason wrote:
> > On Mon, Nov 07, 2011 at 02:10:29PM +0900, Tsutomu Itoh wrote:
> >> In for-linus branch, when xfstests was executed, the following warning
> >> messages were output.
> > 
> > Dave Sterba and I were consistently getting these last week, but after
> > fixes from Josef and I in the current branch I thought they were fixed.
> > 
> > Do this come up every time?
> 
> No.
> Although I am running xfstests from yesterday, it is only one time that
> this message was output. 
> 
> > 
> > Which mount options were you using?
> 
> # mount
> ...
> /dev/sdd4 on /test7 type btrfs (rw)

Ok, I'm struggling to reproduce this one.  Looks like three of us have
hit it once and only once.

-chris

