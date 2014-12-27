Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:52563 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaL0OGa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Dec 2014 09:06:30 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Robert White <rwhite@pobox.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again
Date: Sat, 27 Dec 2014 15:06:28 +0100
Message-ID: <2655489.fNrZQCiWVG@merkaba>
In-Reply-To: <549EB8FC.9040101@pobox.com>
References: <3738341.y7uRQFcLJH@merkaba> <9534911.qSQhRgc3Jg@merkaba> <549EB8FC.9040101@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 27. Dezember 2014, 05:49:48 schrieb Robert White:
> > Anyway, I got it reproduced. And am about to write a lengthy mail about.
> 
> Have fun with that lengthy email, but the devs already know about the 
> data waste profile of the system. They just don't have a good solution yet.
> 
> Practical use cases involving _not_ defragging and _not_ packing files, 
> or disabling COW and using raw image formats for VM disk storage are, 
> meanwhile, also well understood.

Okay, then how about a database?

BTRFS is not usable for these kind of workloads then.

And thats about it.

Not even on SSD.

Yet, what I have shown in my lengthy mail is pathological.

Its even abysmal.

And yet it only happens when BTRFS is forced to pack things into *existing* 
chunks. It does not happen when BTRFS can still reserve new chunks and write 
to them.

And this makes all the talk that you should not need to rebalance obsolete 
when in practice you need to to get decent performance. To get out of your 
SSDs what your SSDs can provide instead of waiting for BTRFS to finish being 
busy with itself.

Still, I have only yet reproduced it on this /home filesystem. If that is also 
reproducable on a freshly created filesystem after some runs of the fio job I 
provided I´d say that there is a performance bug in BTRFS. And thats it.

No talking about technicalities my turn this performance bug observation away. 
Heck 254 IOPS from a Dual SSD RAID 1? Are you even kidding me?

I refuse to believe that this is built into the design, no matter how much you 
outline its limitations.

And if it is?

Well… then maybe BTRFS won´t save us. Unless you give it a ton of extra free 
space. Unless you do as I recommend and if you use 25 GB you make it 100 GB 
big so it will always find enough space to waste.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
