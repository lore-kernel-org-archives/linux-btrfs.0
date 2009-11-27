From: =?iso-8859-1?Q?Jean-S=E9bastien?= Trottier <jst1@email.com>
Subject: Re: Unable to mount loopback devices in RAID mode
Date: Fri, 27 Nov 2009 00:33:38 -0500
Message-ID: <20091127053336.GD25509@jsoft.dyndns.org>
References: <200911192026.04694.lists-receive@programmierforen.de>
 <4B05D64B.7070705@hp.com>
 <200911202022.19306.lists-receive@programmierforen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Drebes <lists-receive@programmierforen.de>,
	linux-btrfs@vger.kernel.org
To: jim owens <jowens@hp.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200911202022.19306.lists-receive@programmierforen.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jim,

In the case of RAID1 (or even RAID10), what happens if loop0 is the
current master but is corrupted/dead and you want to mount loop1 to
recover your data?

Thanks,
JST.

On Fri, Nov 20, 2009 at 08:22:18PM +0100, Andi Drebes wrote:
> Hi!
> 
> > The problem is btrfs randomly changes the "current master"
> > superblock of the filesystem.  Only 1 of the devices will
> > be mountable.  You just have to try the other ones, like:
> > 
> >  > $ mount -t btrfs /dev/loop0 /mnt/btrfs
> >  > mount: wrong fs type, bad option, bad superblock on /dev/loop0,
> > 
> > $ mount -t btrfs /dev/loop1 /mnt/btrfs
> > 
> > until you find one that works.
> Thanks for the hint.
> 
> 	Cheers,
> 		Andi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
