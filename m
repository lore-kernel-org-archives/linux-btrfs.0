From: Chris Mason <chris.mason@oracle.com>
Subject: Re: can't read superblock (but could mount)
Date: Thu, 16 Feb 2012 13:14:07 -0500
Message-ID: <20120216181407.GR21896@shiny>
References: <20120210233959.GV8384@shiny>
 <20120211072725.Horde.8iYhMlNNcXdPNgpNS2yG-PA@webmail.df.eu>
 <20120213130943.GA1573@shiny>
 <alpine.LNX.2.00.1202141832420.11051@localhost>
 <20120214184131.GZ1573@shiny>
 <alpine.LNX.2.00.1202141950420.18337@localhost>
 <20120214211422.GE1573@shiny>
 <alpine.LNX.2.00.1202150701150.24133@localhost>
 <20120215132322.GR1573@shiny>
 <alpine.LNX.2.00.1202161856220.1579@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Timo Nentwig <btrfs@nentwig.biz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1202161856220.1579@localhost>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 16, 2012 at 06:04:47PM +0100, Timo Nentwig wrote:
> 
> 
> On Wed, 15 Feb 2012, Chris Mason wrote:
> 
> >Date: Wed, 15 Feb 2012 08:23:22 -0500
> >From: Chris Mason <chris.mason@oracle.com>
> >To: Timo Nentwig <btrfs@nentwig.biz>
> >Cc: linux-btrfs@vger.kernel.org
> >Subject: Re: can't read superblock (but could mount)
> >
> >On Wed, Feb 15, 2012 at 07:03:49AM +0100, Timo Nentwig wrote:
> >>On Tue, 14 Feb 2012, Chris Mason wrote:
> >>
> >>>Ok, 3.2 shouldn't have done this.  Was this an external drive?  What
> >>>else do you have on the system?
> >>
> >>Nothing special actually. Standard arch linux with virtualbox kernel modules.
> >>It's a SSD if this should matter. Mounted with ssd,compress=lzo,noatime.
> >
> >Ok, it sounds like we've got some memory corruption problems in here.
> >Hopefully not from virtualbox, but I'd start with an memtest.
> 
> Wow, now I'm really impressed! :) You are probably right. I overclocked memory
> and ran memtest for like 1-2h without errors and had a rock solid
> system for quite a while when I recently started to witness all
> kinds of random and reoccuring crashes. Actually blamed the broken
> FS rather than to run memtest again. Mea culpa.
> 
> So, I hit 1 error after a while, somewhat lowered clock freq and no
> error in 17h straight. I'll recreate the FS on that box.

Grin, never be impressed when kernel guys blame the memory.  We might as
well be saying its cosmic rays.

Really though, for this particular type of corruption it is usually some
hardware problem, or a memory corruption bug in the kernel.  Thanks for
humoring me and running the memtest.

-chris
