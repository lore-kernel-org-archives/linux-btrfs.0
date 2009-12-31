From: regomodo <regomodo@googlemail.com>
Subject: Re: Mount via /etc/fstab constant failure
Date: Thu, 31 Dec 2009 20:44:58 +0000
Message-ID: <200912312044.58341.regomodo@googlemail.com>
References: <200912311822.57397.regomodo@googlemail.com> <m3hbr73q1v.fsf@pullcord.laptop.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: cjb@laptop.org
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m3hbr73q1v.fsf@pullcord.laptop.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 31 December 2009 19:24:12 Chris Ball wrote:
> Hi Reg,
> 
>    > Hi, I have a btrfs 'pool' of x2 Samsung 500GB HDD's in non-raid
>    > format. It works fine for the most part except for mounting on
>    > bootup. Every bootup I have to change the block-device to and fro
>    > /dev/sda & /dev/sdb. This happens on linux-2.6.32.2 and
>    > 2.6.33-rc2.
> 
> Are you running "btrfsctl -a" in an initrd?  It's necessary to do that
> before the mount call on a multi-disk volume.
I did not know that. I've just given it a try on Funtoo and Ubuntu and it 
makes no difference. On Funtoo, my small script runs 'btrfsctl -a' at the boot 
runlevel but I still get those 3 errors. I even try running 'btrfsctl -a' 
again before I try 'mount -av' but still no luck.
> - Chris.
> 
