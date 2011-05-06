From: CACook@quantum-sci.com
Subject: Re: Cannot Deinstall a Debian Package
Date: Fri, 6 May 2011 13:56:43 -0700
Message-ID: <201105061356.43853.CACook@quantum-sci.com>
References: <201105031227.43619.CACook@quantum-sci.com> <201105061304.28903.CACook@quantum-sci.com> <20110506201640.GF3342@mother.jarsat.pl>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110506201640.GF3342@mother.jarsat.pl>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 6 May, 2011 13:16:52 Tomasz Torcz wrote:
>   Could you create link from you root parition to /dev/root and try again?

# ln -s / /dev/root
# update-grub
/usr/sbin/grub-probe: error: cannot find a device for / (is /dev mounted?).
# update-grub -v
grub-mkconfig (GRUB) 1.99~rc1-13
#

It's still BTRFS incompatibility.


> > CACook@quantum-sci.com wrote (ao):
> > I don't understand this.  grub-update at least -pretended- to work
> > before I rebooted.  I am still in shock.  MUST get some actual work
> > done today, rather than bit-twiddling.  MUST try and make a living.
> On Friday 6 May, 2011 13:40:36 you wrote:
> 
> Dude, really ..

Really, what?  
You -really- have no idea of the pressures I'm under.  Don't want to help, don't.  I -really- don't have much more time to fool with this.


