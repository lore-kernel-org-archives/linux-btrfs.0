From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: Still Problems with /dev/btrfs-control
Date: Sat, 9 Jan 2010 15:50:59 +0100
Message-ID: <201001091551.00064.johannes.hirte@fem.tu-ilmenau.de>
References: <20100109114203.70ae0c14@simplux> <201001091205.34578.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: "Dipl.-Ing. Michael Niederle" <mniederle@gmx.at>,
	linux-btrfs@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
To: Goffredo Baroncelli <kreijack@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201001091205.34578.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag 09 Januar 2010 12:05:34 schrieb Goffredo Baroncelli:
> Hi Michael
> 
> On Saturday 09 January 2010, Dipl.-Ing. Michael Niederle wrote:
> > Thanks for the quick reply!
> > 
> > But I still have problems with btrfsctl:
> > > stat /dev/btrfs-control
> > > 
> >   File: `/dev/btrfs-control'
> >   Size: 0         	Blocks: 0          IO Block: 4096   block special file
> > 
> > Device: ch/12d	Inode: 659848      Links: 1     Device type: a,3e
> 
> Ok, two things:
> 
> 1) btrfs-control is a *character* device and _not_ a *block device*
> 2) on my system it is allocated under 10,55 (major/minor).

This must be checked on the target machine, as the minor number is allocated 
dynamically.

regards,
  Johannes
