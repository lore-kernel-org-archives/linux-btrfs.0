From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [patch] Move nodesize/leafsize/sectorsize to fs_info
Date: Wed, 26 Oct 2011 12:27:19 -0400
Message-ID: <20111026162719.GC5177@shiny.Mikenopa.local>
References: <CAKyAS7s1Xm3L_1QwptAKs61e0bc4s4z7k8jWo4SiujQFMSss0g@mail.gmail.com>
 <20111026133409.GA5914@twin.jikos.cz>
 <4EA81D73.8090005@gmx.net>
 <20111026162338.GD5914@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Arne Jansen <sensille@gmx.net>,
	Peeters Simon <peeters.simon@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111026162338.GD5914@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 26, 2011 at 06:23:38PM +0200, David Sterba wrote:
> On Wed, Oct 26, 2011 at 04:47:15PM +0200, Arne Jansen wrote:
> > The sizes get initialized to 4096, but after the super block is read,
> > these are replaced by those from the SB.
> 
> [reads sources again] right, and the initial values are not used up to
> that point, so 4096 could be any number.
> 
> > It was indeed meant to get rid of the possibility to have different
> > sizes for different trees, as it just adds complexity. Chris mentioned
> > once that he does not intend to allow different sizes between trees,
> > thus the idea for this cleanup.
> 
> Ok then. I'll gather it to cleanup patch queue.

Thanks, I actually don't intend to allow different leaf and node sizes
anymore either, but we might as well keep both numbers.

-chris

