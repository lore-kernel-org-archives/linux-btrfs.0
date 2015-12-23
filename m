Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34323 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932531AbbLWLib (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Dec 2015 06:38:31 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aBhkS-0001Ez-2Y
	for linux-btrfs@vger.kernel.org; Wed, 23 Dec 2015 12:38:28 +0100
Received: from 178-83-240-22.dynamic.hispeed.ch ([178.83.240.22])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Dec 2015 12:38:28 +0100
Received: from auslands-kv by 178-83-240-22.dynamic.hispeed.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Dec 2015 12:38:28 +0100
To: linux-btrfs@vger.kernel.org
From: Neuer User <auslands-kv@gmx.de>
Subject: Re: btrfs und lvm-cache?
Date: Wed, 23 Dec 2015 12:38:16 +0100
Message-ID: <n5e139$r1h$1@ger.gmane.org>
References: <n5du09$9rn$1@ger.gmane.org> <1527885.5NheBqth0k@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
In-Reply-To: <1527885.5NheBqth0k@merkaba>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 23.12.2015 um 12:21 schrieb Martin Steigerwald:
> Hi.
> 
> As far as I understand this way you basically loose the RAID 1 semantics of 
> BTRFS. While the data is redundant on the HDDs, it is not redundant on the 
> SSD. It may work for a pure read cache, but for write-through you definately 
> loose any data integrity protection a RAID 1 gives you.
> 
Hmm, are you sure? I thought LVM lies underneath btrfs. Btrfs thus
should not know about the caching SSD at all. It only knows of the two
LVs on the HDDs, reading and writing data from or to one or both of the
two LVs.

Only then lvmcache decides if it reads the data from the underlying HDD
or from the cache ssd. LVM shouldn't even know that the two LVs are
configured as RAID1 on btrfs as this is a level higher. So for LVM the
two LVs are diffeent data, both of which would need to be cached
independently on the SDD.

What might happen though, is that there is a data loss on the SDD,
returning a mismatching checksum, so btrfs might think that the data is
incorrect on one LV (=HDD), although it is indeed correct there. That
would lead btrfs to read the data from the second LV (which might also
be in the SDD cache or not) and then updating the (correct and
identical) data of the first LV with it.

Or do I see that wrong?

> Of course, you can use two SSDs and have them work as RAID 1 as well.
> 
> There is a patch set for in-BTRFS SSD-caching. It consists of a patch set to 
> add hot data tracking to VFS and a patch set for adding support in BTRFS. But 
> I didn´t see anything of these in quite some time.

That would be interesting, but for my project it's probably too late.

> 
> Happy christmas,
> 

Yeah, happy christmas to you and eveybody on the list.

Michael

