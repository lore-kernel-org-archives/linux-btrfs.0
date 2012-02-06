From: Tommy Faasen <tommy@zwanebloem.nl>
Subject: Re: Btrfs out of inodes becomes corrupt
Date: Mon, 6 Feb 2012 15:35:14 +0000
Message-ID: <20120206153514.GB8542@zwanebloem.nl>
References: <b0ee762c11692ea16e81a34469311c14@localhost>
 <20120205195742.GC19330@carfax.org.uk>
 <CAE5mzvhwSLqBEMEOZo8Xxx63LciYLAxYWzVrQP+7qk_tgyRvwA@mail.gmail.com>
 <20120206114031.GD19330@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Hugo Mills <hugo@carfax.org.uk>, cwillu <cwillu@cwillu.com>,
	Tommy Faasen <tommy@zwanebloem.nl>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120206114031.GD19330@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

I rolled a new kernel 3.2.4 and it picked everything up.
No crashes, my disk was still full, with 40+ gigs free
but now I can delete files and access them.

I'm running btrfs fi balance /mountpoint at the moment which I understand frees up the remaining space.

Thanks again for your assistance!

Tommy

On Mon, Feb 06, 2012 at 11:40:31AM +0000, Hugo Mills wrote:
> On Mon, Feb 06, 2012 at 05:33:51AM -0600, cwillu wrote:
> > >  3.0 is two revisions old -- something on the order of 6
> > > months. There's been a lot of development since then, too. You really
> > > should be running 3.2 or 3.2-rc2 (i.e. the latest released or latest
> > > development version of the kernel).
> > 
> > I think you meant 3.2 or 3.3-rc2.
> 
>    I did indeed. Thanks for the correction.
> 
>    Hugo.
> 
> -- 
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>   --- "What's so bad about being drunk?" "You ask a glass of water" ---  
>                                                                          


