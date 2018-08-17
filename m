Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:49753 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbeHRAVX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Aug 2018 20:21:23 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Roman Mamedov <rm@romanrm.net>, linux-btrfs@vger.kernel.org
Subject: Re: Experiences on BTRFS Dual SSD RAID 1 with outage of one SSD
Date: Fri, 17 Aug 2018 23:16:24 +0200
Message-ID: <1816762.xWVpkm38nr@merkaba>
In-Reply-To: <94de7bd8-1b35-ecbb-566a-86b5c9de06fc@gmail.com>
References: <2331408.nK7QgfhVWv@merkaba> <20180817175022.70cd084e@natsu> <94de7bd8-1b35-ecbb-566a-86b5c9de06fc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn - 17.08.18, 15:01:
> On 2018-08-17 08:50, Roman Mamedov wrote:
> > On Fri, 17 Aug 2018 14:28:25 +0200
> > 
> > Martin Steigerwald <martin@lichtvoll.de> wrote:
> >>> First off, keep in mind that the SSD firmware doing compression
> >>> only
> >>> really helps with wear-leveling.  Doing it in the filesystem will
> >>> help not only with that, but will also give you more space to
> >>> work with.>> 
> >> While also reducing the ability of the SSD to wear-level. The more
> >> data I fit on the SSD, the less it can wear-level. And the better
> >> I compress that data, the less it can wear-level.
> > 
> > Do not consider SSD "compression" as a factor in any of your
> > calculations or planning. Modern controllers do not do it anymore,
> > the last ones that did are SandForce, and that's 2010 era stuff.
> > You can check for yourself by comparing write speeds of
> > compressible vs incompressible data, it should be the same. At
> > most, the modern ones know to recognize a stream of binary zeroes
> > and have a special case for that.
> 
> All that testing write speeds forz compressible versus incompressible
> data tells you is if the SSD is doing real-time compression of data,
> not if they are doing any compression at all..  Also, this test only
> works if you turn the write-cache on the device off.

As the data still needs to be transferred to the SSD at least when the 
SATA connection is maxed out I bet you won´t see any difference in write 
speed whether the SSD compresses in real time or not.

> Besides, you can't prove 100% for certain that any manufacturer who
> does not sell their controller chips isn't doing this, which means
> there are a few manufacturers that may still be doing it.

Who really knows what SSD controller manufacturers are doing? I have not 
seen any Open Channel SSD stuff for laptops so far.

Thanks,
-- 
Martin
