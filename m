From: regomodo <regomodo@googlemail.com>
Subject: Re: Mount via /etc/fstab constant failure
Date: Sat, 2 Jan 2010 12:26:01 +0000
Message-ID: <201001021226.01754.regomodo@googlemail.com>
References: <200912311822.57397.regomodo@googlemail.com> <200912312044.58341.regomodo@googlemail.com> <201001011451.32725@fortytwo.ch>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Cc: linux-btrfs@vger.kernel.org
To: Adrian von Bidder <avbidder@fortytwo.ch>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201001011451.32725@fortytwo.ch>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 01 January 2010 13:51:26 Adrian von Bidder wrote:
> On Thursday 31 December 2009 21.44:58 regomodo wrote:
> > On Thursday 31 December 2009 19:24:12 Chris Ball wrote:
> > > Hi Reg,
> > >
> > >    > Hi, I have a btrfs 'pool' of x2 Samsung 500GB HDD's in non-raid
> > >    > format. It works fine for the most part except for mounting on
> > >    > bootup. Every bootup I have to change the block-device to and fro
> > >    > /dev/sda & /dev/sdb. This happens on linux-2.6.32.2 and
> > >    > 2.6.33-rc2.
> > >
> > > Are you running "btrfsctl -a" in an initrd?  It's necessary to do that
> > > before the mount call on a multi-disk volume.
> >
> > I did not know that. I've just given it a try on Funtoo and Ubuntu and it
> > makes no difference. On Funtoo, my small script runs 'btrfsctl -a' at the
> >  boot runlevel but I still get those 3 errors. I even try running
> >  'btrfsctl -a' again before I try 'mount -av' but still no luck.
btrfs is compiled into my kernel. Should I make it a module instead?
> I had a similar issue and discovered that "btrfsctl -a" doesn't load the
> btrfs module.  So I do "modprobe btrfs; btrfsctl -a"
> 
> cheers
> -- vbi
> 
