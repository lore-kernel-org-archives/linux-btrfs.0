From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs csum failed
Date: Wed, 04 May 2011 14:10:49 -0400
Message-ID: <1304532490-sup-9008@think>
References: <4DC07A10.7070200@mur.at> <20110504002815.GA27861@dhcp231-156.rdu.redhat.com> <4DC0A153.3080806@mur.at> <BANLkTin1quUuSq4oKdt1SowTPv4dhGEM5g@mail.gmail.com> <4DC13B02.9030604@mur.at> <BANLkTiniD_mztDPriodDWybTzt7Dqtherg@mail.gmail.com> <4DC1464D.4060204@mur.at> <000e01cc0a5e$7446eab0$5cd4c010$@nedharvey.com> <4DC165EB.7060304@mur.at>
Content-Type: text/plain; charset=UTF-8
Cc: Edward Ned Harvey <kernel@nedharvey.com>,
	cwillu <cwillu@cwillu.com>, "Fajar A. Nugraha" <list@fajar.net>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Martin Schitter <ms@mur.at>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4DC165EB.7060304@mur.at>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Martin Schitter's message of 2011-05-04 10:42:51 -0400:
> Am 2011-05-04 15:23, schrieb Edward Ned Harvey:
> >> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> >> owner@vger.kernel.org] On Behalf Of Martin Schitter
> >>
> >> well -- i am doing a backup of all images every night. this
> >> process should work like a simple "scrub" because all data (and its
> >> checksumes) will be read.
> >
> > Sorry, not correct.  When you read all the data using something in
> > user-land, the OS only needs to read one side of the data.  It can
> > accelerate by staggering the read requests across multiple disks.  So
> > some sectors remain unread on some disks.
> >
> > When you scrub, it reads all the data from all the redundant copies
> > (mirrored or raid) on all the individual disks in the raid set.
> 
> ok -- i see -- you're right!
> 
> i know, there a some befits in the way btrfs and zfs implement RAID / 
> multiply disk usage and checksumming, but i a also want to stay on the 
> save side, when it comes to real practical problems. so i decided to use 
> 'classical' linux software RAID-1 as the base layer. that's a very old 
> fashioned solution, but it usually simply works... and you can change a 
> broken disk without any respect of the used filesystem(s). in general i 
> try to use btrfs only on account of its snapshot features in a very 
> simple way.
> 
> it looks very strange to me, that i don't see any SMART warnings on the 
> harddisks or errors on other filsystems on the same raid-array. there 
> was also no reboot, power-failure or similar when the corruption 
> suddenly appeared. so i think, a btrfs bug would be the most evident 
> explanation.

That's the bad news, it can be very hard to tell.   The disk could be
returning garbage or btrfs would be messing up the csums.

The btrfs unstable tree does have one fix that is related to O_DIRECT
and kvm, but we've only ever seen it happen with a windows guest.  This
doesn't mean it is impossible for a linux guest to trigger it though.

-chris
