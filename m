From: Chris Mason <chris.mason@oracle.com>
Subject: Re: can't read superblock (but could mount)
Date: Tue, 14 Feb 2012 16:14:22 -0500
Message-ID: <20120214211422.GE1573@shiny>
References: <20120210203051.Horde.q5KnHsL8999PNXBrH5AlxdA@webmail.df.eu>
 <20120210221842.GU8384@shiny>
 <20120210233959.GV8384@shiny>
 <20120211072725.Horde.8iYhMlNNcXdPNgpNS2yG-PA@webmail.df.eu>
 <20120213130943.GA1573@shiny>
 <alpine.LNX.2.00.1202141832420.11051@localhost>
 <20120214184131.GZ1573@shiny>
 <alpine.LNX.2.00.1202141950420.18337@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Timo Nentwig <btrfs@nentwig.biz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1202141950420.18337@localhost>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 14, 2012 at 07:54:43PM +0100, Timo Nentwig wrote:
> 
> 
> On Tue, 14 Feb 2012, Chris Mason wrote:
> 
> >As for how we got here, I think you said you were originally running
> >something older than 3.2 when these problems started, correct?
> 
> Nope, I was already on 3.2.1 or 3.2.4. I restored a backup in the meantime
> and already had to soft-reset the box:

Ok, 3.2 shouldn't have done this.  Was this an external drive?  What
else do you have on the system?

> 
> # ls -ltr ~/.kde4/share/config/
> ls: reading directory /home/foo/.kde4/share/config/: Input/output error
> 
> Sigh...

Is this the same FS that was corrupted or a different one?

-chris

