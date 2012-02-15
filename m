From: Chris Mason <chris.mason@oracle.com>
Subject: Re: can't read superblock (but could mount)
Date: Wed, 15 Feb 2012 08:23:22 -0500
Message-ID: <20120215132322.GR1573@shiny>
References: <20120210203051.Horde.q5KnHsL8999PNXBrH5AlxdA@webmail.df.eu>
 <20120210221842.GU8384@shiny>
 <20120210233959.GV8384@shiny>
 <20120211072725.Horde.8iYhMlNNcXdPNgpNS2yG-PA@webmail.df.eu>
 <20120213130943.GA1573@shiny>
 <alpine.LNX.2.00.1202141832420.11051@localhost>
 <20120214184131.GZ1573@shiny>
 <alpine.LNX.2.00.1202141950420.18337@localhost>
 <20120214211422.GE1573@shiny>
 <alpine.LNX.2.00.1202150701150.24133@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Timo Nentwig <btrfs@nentwig.biz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1202150701150.24133@localhost>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 15, 2012 at 07:03:49AM +0100, Timo Nentwig wrote:
> 
> 
> On Tue, 14 Feb 2012, Chris Mason wrote:
> 
> >Ok, 3.2 shouldn't have done this.  Was this an external drive?  What
> >else do you have on the system?
> 
> Nothing special actually. Standard arch linux with virtualbox kernel modules.
> It's a SSD if this should matter. Mounted with ssd,compress=lzo,noatime.

Ok, it sounds like we've got some memory corruption problems in here.
Hopefully not from virtualbox, but I'd start with an memtest.

> 
> >Is this the same FS that was corrupted or a different one?
> 
> Different one. Created from an old 3.2.1 gentoo install (btrfs 0.19-dirty).

Different FS, same machine?  Please include all the kernel messages.

-chris

