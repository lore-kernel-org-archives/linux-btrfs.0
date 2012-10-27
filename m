Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:46801 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759138Ab2J0WbO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Oct 2012 18:31:14 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: [RFC] New attempt to a better "btrfs fi df"
Date: Sun, 28 Oct 2012 00:30:44 +0200
Cc: Michael =?utf-8?q?Kj=C3=B6rling?= <michael@kjorling.se>
References: <50899151.1070503@inwind.it> <201210271843.40540.Martin@lichtvoll.de> <20121027195513.GS2381@yeono.kjorling.se> (sfid-20121028_001804_376096_F065177B)
In-Reply-To: <20121027195513.GS2381@yeono.kjorling.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201210280030.45190.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 27. Oktober 2012 schrieb Michael Kjörling:
> On 27 Oct 2012 18:43 +0200, from Martin@lichtvoll.de (Martin 
Steigerwald):
> > Possibly this could be done tabular as well, like:
> > 
> >                         vdb           vdc             vdd
> >
> > Data, RAID 0  307,25MB        307,25MB        307,25MB
> > …
> > System,RAID1  -               8MB             8MB
> > …
> > Unused                2,23GB  2,69GB  2,24GB
> >
> > 
> >
> > I like this. But what if the filesystem has 100 disks?
> 
> Maybe I'm just not familiar enough with btrfs yet to punch an
> immediate hole in the idea, but how about pivoting that table? Columns
> for data values ("data, raid 0", "system, raid 1", "unused", ...) and
> rows for the underlying devices? Something like this, copying the
> numbers from your example. And I'm using colon here rather than comma,
> because I believe that it better captures the intent.
> 
>            Data: RAID 0   System: RAID 1   Unused
> /dev/vdb     307.25 MB                -        2.23 GB
> /dev/vdc     307.25 MB             8 MB        2.69 GB
> /dev/vdd     307.25 MB             8 MB        2.24 GB
>            ============   ==============   ============
> TOTAL        921.75 MB            16 MB        7.16 GB

Hmmm, good idea. I like it this way around.

It would scale better with the number of drives and there is a good way to 
place the totals.

I wonder about how to possibly include the used part of each tree. With 
mostly 5 columns it might be doable.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
