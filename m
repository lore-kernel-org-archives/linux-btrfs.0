Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:22399 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758408Ab3BNWLe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Feb 2013 17:11:34 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Rebalancing RAID1
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20130214205632.GF28997@carfax.org.uk>
Date: Thu, 14 Feb 2013 15:11:31 -0700
Cc: Fredrik Tolf <fredrik@dolda2000.com>, linux-btrfs@vger.kernel.org
Message-Id: <C904A523-80FC-480C-933E-50F1497605D2@colorremedies.com>
References: <alpine.DEB.2.02.1302122348460.8810@shack.dolda2000.com> <C8ECD52F-F362-49CD-A3E3-627AF13CF180@colorremedies.com> <alpine.DEB.2.02.1302130711400.8810@shack.dolda2000.com> <5EEA9264-5DCA-4A3F-B305-F3E64E9A3CC5@colorremedies.com> <alpine.DEB.2.02.1302140733070.8810@shack.dolda2000.com> <17E4F30E-2945-44FE-A87F-0F475DFD794F@colorremedies.com> <alpine.DEB.2.02.1302140830310.8810@shack.dolda2000.com> <2D5AAB44-9DA8-460D-9141-3544DE6C45D7@colorremedies.com> <20130214085925.GD28997@carfax.org.uk> <19ABBC76-F774-4225-87A4-73A4D546F53F@colorremedies.com> <20130214205632.GF28997@carfax.org.uk>
To: Hugo Mills <hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 14, 2013, at 1:56 PM, Hugo Mills <hugo@carfax.org.uk> wrote:

>> 
> 
>   Correct, but *all* other single-value (or small-number-of-values)
> displays of space usage fail in similar ways. We've(*) had this
> discussion out on this mailing list many times before. All "simple"
> displays of disk usage will cause someone to misinterpret something at
> some point, and get cross.

The decoder ring method causes misinterpretation.

I refuse the premise that there isn't a way to at least be consistent; and use switches for alternate presentations.

>   If you want a display of "raw bytes used/free", then someone will
> complain that they had 20GB free, wrote a 10GB file, and it's all
> gone. If you want a display of "usable data used/free", then we can't
> predict the "free" part. There is no single set of values that will
> make this simple.

This is exactly how (conventional) df -h works now. And it causes exactly the problem you describe. The df -h size and available numbers are double that of btrfs fi df/show. Not ok. Not consistent. Either df needs to change (likely) or btrfs fi needs to change.

2x 80GB array, btrfs

/dev/sdb        160G  112K  158G   1% /mnt

2x 80GB array, md raid1 xfs

/dev/md0         80G   33M   80G   1% /mnt

And I think it's (regular) df that needs to change the most. btrfs fi df contains 50% superfluous information as far as I can tell:

[root@f18v ~]# btrfs fi df /mnt
Data, RAID1: total=1.00GB, used=0.00
*Data: total=8.00MB, used=0.00
*System, RAID1: total=8.00MB, used=8.00KB
*System: total=4.00MB, used=0.00
Metadata, RAID1: total=1.00GB, used=48.00KB
*Metadata: total=8.00MB, used=0.00

The lines marked * I see zero useful conveyed information. And fi show:

[root@f18v ~]# btrfs fi show
Label: 'hello'  uuid: d5517733-7c9f-458a-9e99-5b832b8776b2
	Total devices 2 FS bytes used 56.00KB
	devid    2 size 80.00GB used 2.01GB path /dev/sdc
	devid    1 size 80.00GB used 2.03GB path /dev/sdb

I don't know why I should care about allocated chunks but if that's what used means in this case, it should say that, rather than "used". I'm sortof annoyed that the same words, total and used, have different meaning depending on their position, without other qualifiers. It's like being in school and the teacher would get pissed when students wouldn't specify units or label axes, and now I'm one of those types. What do these numbers mean? If I have to infer this, then they're obscure, so why should I care about them?

And what I can get from btrfs fi df that it doesn't indicate at all, that could be more useful than regular df (simply because there's no room) is a:

Free Space Estimate: min - max


>   I think the solution, if it's certain that the drive is now
> behaving sensibly again, is one of:
> 
> * unmount, btrfs dev scan, remount, scrub
> or
> * btrfs dev delete missing, add /dev/sdi1 to the FS, and balance

The 2nd won't work because user space tools don't consider there to be a missing device.

So back to the question on how btrfs should behave in such a case. md would have tossed the drive and as far as I know doesn't automatically readd it if it reappears as either the same or a different block device. And when the user uses --re-add there's a resync.


Chris Murphy