From: Martin Schitter <ms@mur.at>
Subject: Re: btrfs csum failed
Date: Wed, 04 May 2011 16:42:51 +0200
Message-ID: <4DC165EB.7060304@mur.at>
References: <4DC07A10.7070200@mur.at>	<20110504002815.GA27861@dhcp231-156.rdu.redhat.com>	<4DC0A153.3080806@mur.at>	<BANLkTin1quUuSq4oKdt1SowTPv4dhGEM5g@mail.gmail.com>	<4DC13B02.9030604@mur.at> <BANLkTiniD_mztDPriodDWybTzt7Dqtherg@mail.gmail.com> <4DC1464D.4060204@mur.at> <000e01cc0a5e$7446eab0$5cd4c010$@nedharvey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: cwillu <cwillu@cwillu.com>, "Fajar A. Nugraha" <list@fajar.net>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Edward Ned Harvey <kernel@nedharvey.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <000e01cc0a5e$7446eab0$5cd4c010$@nedharvey.com>
List-ID: <linux-btrfs.vger.kernel.org>

Am 2011-05-04 15:23, schrieb Edward Ned Harvey:
>> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
>> owner@vger.kernel.org] On Behalf Of Martin Schitter
>>
>> well -- i am doing a backup of all images every night. this
>> process should work like a simple "scrub" because all data (and its
>> checksumes) will be read.
>
> Sorry, not correct.  When you read all the data using something in
> user-land, the OS only needs to read one side of the data.  It can
> accelerate by staggering the read requests across multiple disks.  So
> some sectors remain unread on some disks.
>
> When you scrub, it reads all the data from all the redundant copies
> (mirrored or raid) on all the individual disks in the raid set.

ok -- i see -- you're right!

i know, there a some befits in the way btrfs and zfs implement RAID / 
multiply disk usage and checksumming, but i a also want to stay on the 
save side, when it comes to real practical problems. so i decided to use 
'classical' linux software RAID-1 as the base layer. that's a very old 
fashioned solution, but it usually simply works... and you can change a 
broken disk without any respect of the used filesystem(s). in general i 
try to use btrfs only on account of its snapshot features in a very 
simple way.

it looks very strange to me, that i don't see any SMART warnings on the 
harddisks or errors on other filsystems on the same raid-array. there 
was also no reboot, power-failure or similar when the corruption 
suddenly appeared. so i think, a btrfs bug would be the most evident 
explanation.

martin

