From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Grow btrfs partition & filesystem backwards
Date: Wed, 9 Nov 2011 14:26:56 -0500
Message-ID: <20111109192656.GR9368@shiny>
References: <CACCfv7obU+-13+Z7-S-N_y8etdJZxyw_csZBD5Ran62xW6tgWA@mail.gmail.com>
 <CANZ96zWM-AuOc9OddyHPrVyQdOpGHqXC3twyGhsZFA=EZpDjUQ@mail.gmail.com>
 <20111109133624.GO4149@shiny>
 <2286851.zJGgl5jPAW@venice>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Billy Crook <billycrook@gmail.com>,
	Ernst =?iso-8859-1?Q?Sj=F6strand?= <ernstp@gmail.com>,
	Jordan Windsor <jordanw2@gmail.com>,
	linux-btrfs@vger.kernel.org
To: Goffredo Baroncelli <kreijack@inwind.it>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <2286851.zJGgl5jPAW@venice>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 09, 2011 at 07:58:44PM +0100, Goffredo Baroncelli wrote:
> On Wednesday, 09 November, 2011 08:36:24 Chris Mason wrote:
> > The only choice for an online operation is to make a new partition in
> > front of the old one and just add that as a second disk in btrfs.
> > 
> > The slow method of shifting the bytes down is probably a better long
> > term choice.
> > 
> > -chris
> 
> Hi Chris,
> 
> does the chunk tree be able to map the sectors "before" ? If so we should only 
> "shift down" the map logical->physical in the chunk tree/device tree.
> 
> The only exception should be the superblock which has to be moved.
> 
> At the mount time we should pass a parameter which set how the data should be 
> moved backward. Then the kernel remap the chunk tree/device tree.
> 
> I don't know if the gains is greater than the work, but from a theoretical 
> point of view, it should be doable..

Agreed, if we wanted to sit down and write a tool, it wouldn't be that
complex.  The only tricky part is maintaining alignment and position of
the super blocks.

-chris
