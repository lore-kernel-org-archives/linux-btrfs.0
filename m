From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: 3.2-rc4: scrubbing locks up the kernel, then hung tasks on boot
Date: Mon, 19 Mar 2012 08:48:10 -0700
Message-ID: <20120319154810.GB8176@kroah.com>
References: <201112171833.34720.Martin@lichtvoll.de>
 <201203171043.25660.Martin@lichtvoll.de>
 <20120318003708.GE22993@kroah.com>
 <201203190931.26493.ms@teamix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org,
	Martin Steigerwald <Martin@lichtvoll.de>,
	Chris Mason <chris.mason@oracle.com>,
	Arne Jansen <sensille@gmx.net>, stable@kernel.org
To: Martin Steigerwald <ms@teamix.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201203190931.26493.ms@teamix.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 19, 2012 at 09:31:24AM +0100, Martin Steigerwald wrote:
> > <formletter>
> > 
> > This is not the correct way to submit patches for inclusion in the
> > stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
> > for how to do this properly.
> > 
> > </formletter>
> 
> What point of the rules do you refer to? Is it
> 
>  - It or an equivalent fix must already exist in Linus' tree (upstream).

Yes.

Without that, there's nothing I can do with this.

> Or do you want the patch quoted in the mail?
> 
> Anyways its not yet in linus tree AFAIR and from my side it was a question 
> whether it should be included at all. I thought it might be good ccing you on 
> that question already.

It's nice, yes, but note that you sent this to me directly, didn't cc:
the proper stable mailing list so that others who maintain other stable
trees also didn't get the notice, and again, there's really nothing that
the stable maintainers can do about this at the moment.

But, if this does go to Linus's tree, then stable@vger.kernel.org would
be very interested in knowing about it.

thanks,

greg k-h
