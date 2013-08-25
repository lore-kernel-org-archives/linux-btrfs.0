Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from crane.lixil.net ([71.19.157.101]:58888 "EHLO crane.lixil.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754861Ab3HYCmg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 24 Aug 2013 22:42:36 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Sat, 24 Aug 2013 20:42:34 -0600
From: Joel Johnson <mrjoel@lixil.net>
To: Sandy McArthur <sandymac@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Help interpreting RAID1 space allocation
In-Reply-To: <CAPs0BijKPr7Df-42dQC=ydA9xzEaEvk1XMFP-dYKqBuzrNvmAA@mail.gmail.com>
References: <25d36b2410416c9a767766fb9be313b6@lixil.net>
 <093e4c7d21b5e734c86fc4bb1703a69e@lixil.net>
 <0e13ab74252d33d24ad58591b7b0f6fb@lixil.net>
 <CAPs0BijKPr7Df-42dQC=ydA9xzEaEvk1XMFP-dYKqBuzrNvmAA@mail.gmail.com>
Message-ID: <3233666063a20b61c50fc4d668848fae@lixil.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2013-08-24 14:30, Sandy McArthur wrote:
> I was surprised to find
> that I'm not allowed to remove one of the two drives in a RAID1. Kernel
> message is "btrfs: unable to go below two devices on raid1" Not 
> allowing it
> by default makes some sense, however a --force flag or something would 
> be
> beneficial.
> 
> If you have an USB enclosure you could connect another drive via USB
> temporarily.
> That said my biggest btrfs problem happened while I had some drives on
> SATA and others on USB.

Ah, indeed, a close look at my device names reveals that I claim to only 
have three SATA ports, but sdc and sdd are used for my btrfs test. The 
sdb device is in fact an external USB enclosure that I'm using as my 
data source for the testing.

I'm really just wanting to test what I see as some common use cases for 
a RAID1 btrfs filesystem. A very common one that seems to fail currently 
is wishing to preemptively (SMART errors on drive, many other reasons) 
remove it from the mirror, in order to add a replacement device - and 
keep things online during the entire process. As I see it now, I'd need 
to umount, forcibly/uncleanly pull the drive, mount degraded, add the 
new device, umount, mount cleanly, rebalance and move forward.

I'd like to use btrfs for the data checksumming, however based on my 
investigations it doesn't appear to be ready for the set of RAID1 
support I'd expect. Based on that, I'm relooking at options.

Are there any known gotchas or limitations with a btrfs filesystem with 
single data and metadata, running on top of an md-raid RAID1 mirror?

Joel
