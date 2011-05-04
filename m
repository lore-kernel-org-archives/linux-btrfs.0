From: Martin Schitter <ms@mur.at>
Subject: Re: btrfs csum failed
Date: Wed, 04 May 2011 14:27:57 +0200
Message-ID: <4DC1464D.4060204@mur.at>
References: <4DC07A10.7070200@mur.at>	<20110504002815.GA27861@dhcp231-156.rdu.redhat.com>	<4DC0A153.3080806@mur.at>	<BANLkTin1quUuSq4oKdt1SowTPv4dhGEM5g@mail.gmail.com>	<4DC13B02.9030604@mur.at> <BANLkTiniD_mztDPriodDWybTzt7Dqtherg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: "Fajar A. Nugraha" <list@fajar.net>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: cwillu <cwillu@cwillu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTiniD_mztDPriodDWybTzt7Dqtherg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Am 2011-05-04 13:51, schrieb cwillu:
>> that looks very unplausible to me. there is an RAID1 layer beneath btrfs in
>> our setup and i don't see any errors there.
>
> That doesn't rule out the possibility of corruption when it was
> written in the first place, or some similar problem that the raid1
> faithfully reproduced on both mirrors.  That's not to say that it's
> impossible that the problem is in btrfs, just that it's not the only
> plausible possibility.

well -- i am doing a backup of all images every night. this process 
should work like a simple "scrub" because all data (and its checksumes) 
will be read. that's the way i stumbled over this problem!

>> and the 'nodatasum' option should also ignore csum issues.-- isn't it?
 >
> No, it only affects writing new checksums; any existing checksums are
> still checked.

would it make some sense to remount the volume with checksumming enabled 
and run additional tests to find similar suspect blocks to prevent this 
kind of suddenly broken files?

martin
