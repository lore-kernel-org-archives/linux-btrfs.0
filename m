Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:54786 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755545AbaGNV6e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Jul 2014 17:58:34 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS hang with 3.16-rc5
Date: Mon, 14 Jul 2014 23:58:32 +0200
Message-ID: <29286605.flGgbBIpOj@merkaba>
In-Reply-To: <53C439A6.5010905@fb.com>
References: <1502954.OtX3SzjMKZ@merkaba> <3226395.MP6iD3ZiSL@merkaba> <53C439A6.5010905@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag, 14. Juli 2014, 16:12:22 schrieb Chris Mason:
> On 07/14/2014 11:10 AM, Martin Steigerwald wrote:
> > Am Montag, 14. Juli 2014, 17:04:22 schrieben Sie:
> >> Hi!
> >> 
> >> While with 3.16-rc3 and rc4 I didn´t have a BTRFS hang in several days of
> >> usage, with 3-16-rc5 I had a hang again. Less than a hour since booting
> >> it.
> >> 
> >> Since the hang bug I and others had with 3.15 and upto 3.16-rc2 usually
> >> didn´t happen that quickly after boot and since backtrace looks a bit
> >> different from what I have in memory, I post this in a new thread.
> >> See thread "Blocked tasks on 3.15.1" for a discussion of previous hang
> >> issues.
> > 
> > Probably good to add some basic information on the filesystem:
> Do you have compression enabled?  I wasn't able to nail down the 3.15.1
> hang before vacation attacked me, but I'm hoping to track it down today.

Yes. I have.

It just hung again while I was playing PlaneShift.

Back to 3.16-rc4 as rc5 seems to be broke here.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
