From: Peter Stuge <peter@stuge.se>
Subject: Re: Cannot Deinstall a Debian Package
Date: Fri, 6 May 2011 23:23:42 +0200
Message-ID: <20110506212342.380.qmail@stuge.se>
References: <201105031227.43619.CACook@quantum-sci.com> <201105061304.28903.CACook@quantum-sci.com> <20110506201640.GF3342@mother.jarsat.pl> <201105061356.43853.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201105061356.43853.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

CACook@quantum-sci.com wrote:
> # update-grub
> /usr/sbin/grub-probe: error: cannot find a device for / (is /dev mounted?).
> # update-grub -v
> grub-mkconfig (GRUB) 1.99~rc1-13
> #
> 
> It's still BTRFS incompatibility.

Either that, or maybe something has broken in your many attempts to
solve the problem while avoiding to educate yourself.


> > > I don't understand this.  grub-update at least -pretended- to work
> > > before I rebooted.  I am still in shock.  MUST get some actual work
> > > done today, rather than bit-twiddling.  MUST try and make a living.
> > 
> > Dude, really ..
> 
> Really, what?
> You -really- have no idea of the pressures I'm under.

I'm afraid that's something you should have considered before
choosing to mkfs.btrfs.


> Don't want to help, don't.  I -really- don't have much more time to
> fool with this.

I'm sorry that you decided to use experimental software without being
prepared for the consequences. But it does sound like you've actually
had ample warning.

Stop fooling with this. You'll likely not be successful if you are
only interested in the quick fix, and people helping you with this
will basically be wasting their time since you seem very unlikely to
contribute anything back. (Like high quality debugging, a testing
environment, or even patches. All of which take both time and
significant technical skill to produce.)


//Peter
