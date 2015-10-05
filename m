Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:55535 "EHLO mail.bouton.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbbJELQG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 Oct 2015 07:16:06 -0400
Subject: Re: BTRFS as image store for KVM?
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <55F88ECC.1040604@menke.ac>
 <201510021421.09558.russell@coker.com.au> <560E737C.7050206@gmail.com>
 <201510031832.17802.russell@coker.com.au>
 <pan$e9b6$f764fa8a$deeffa51$be52ef68@cox.net> <56111598.2080403@bouton.name>
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <56125BF3.10700@bouton.name>
Date: Mon, 5 Oct 2015 13:16:03 +0200
MIME-Version: 1.0
In-Reply-To: <56111598.2080403@bouton.name>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Le 04/10/2015 14:03, Lionel Bouton a écrit :
> [...]
> This focus on single reader RAID1 performance surprises me.
>
> 1/ AFAIK the kernel md RAID1 code behaves the same (last time I checked
> you need 2 processes to read from 2 devices at once) and I've never seen
> anyone arguing that the current md code is unstable.

To better illustrate my point.

According to Phoronix tests, BTRFS RAID-1 is even faster than md RAID1
most of the time.

http://www.phoronix.com/scan.php?page=article&item=btrfs_raid_mdadm&num=1

The only case where md RAID1 was noticeably faster is sequential reads
with FIO libaio.

So if you base your analysis on Phoronix tests when serving large files
to a few clients maybe md could perform better. In all other cases BTRFS
RAID1 seems to be a better place to start if you want performance.
According to the bad performance -> unstable logic, md would then be the
less stable RAID1 implementation which doesn't make sense to me.

I'm not even saying that BTRFS performs better than md for most
real-world scenarios (these are only benchmarks), but that arguing that
BTRFS is not stable because it has performance issues still doesn't make
sense to me. Even synthetic benchmarks aren't enough to find the best
fit for real-world scenarios, so you could always find a very
restrictive situation where any filesystem, RAID implementation, volume
manager could look bad even the most robust ones.

Of course if BTRFS RAID1 was always slower than md RAID1 the logic might
make more sense. But clearly there were design decisions and performance
tuning in BTRFS that led to better or similar performance in several
scenarios, if the remaining scenarios don't get attention it may be
because they represent a niche (at least from the point of view of the
developers) not a lack of polishing.

Best regards,

Lionel
