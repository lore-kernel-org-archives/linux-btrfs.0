Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:35520 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756671AbbLWTtm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Dec 2015 14:49:42 -0500
Received: by mail-ig0-f176.google.com with SMTP id to4so86875336igc.0
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Dec 2015 11:49:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <n5e139$r1h$1@ger.gmane.org>
References: <n5du09$9rn$1@ger.gmane.org>
	<1527885.5NheBqth0k@merkaba>
	<n5e139$r1h$1@ger.gmane.org>
Date: Wed, 23 Dec 2015 12:49:41 -0700
Message-ID: <CAJCQCtStdF=JU11LOjJ_xLXir_CPzJ7GaQRRqsROEE0eOADFWA@mail.gmail.com>
Subject: Re: btrfs und lvm-cache?
From: Chris Murphy <lists@colorremedies.com>
To: Neuer User <auslands-kv@gmx.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 23, 2015 at 4:38 AM, Neuer User <auslands-kv@gmx.de> wrote:
> Am 23.12.2015 um 12:21 schrieb Martin Steigerwald:
>> Hi.
>>
>> As far as I understand this way you basically loose the RAID 1 semantics of
>> BTRFS. While the data is redundant on the HDDs, it is not redundant on the
>> SSD. It may work for a pure read cache, but for write-through you definately
>> loose any data integrity protection a RAID 1 gives you.
>>
> Hmm, are you sure? I thought LVM lies underneath btrfs. Btrfs thus
> should not know about the caching SSD at all. It only knows of the two
> LVs on the HDDs, reading and writing data from or to one or both of the
> two LVs.
>
> Only then lvmcache decides if it reads the data from the underlying HDD
> or from the cache ssd. LVM shouldn't even know that the two LVs are
> configured as RAID1 on btrfs as this is a level higher. So for LVM the
> two LVs are diffeent data, both of which would need to be cached
> independently on the SDD.
>
> What might happen though, is that there is a data loss on the SDD,
> returning a mismatching checksum, so btrfs might think that the data is
> incorrect on one LV (=HDD), although it is indeed correct there. That
> would lead btrfs to read the data from the second LV (which might also
> be in the SDD cache or not) and then updating the (correct and
> identical) data of the first LV with it.

Seems to me if the LV's on the two HDDs are exposed, the lvmcache has
to separately keep track of those LVs. So as long as everything is
working correctly, it should be fine. That includes either transient
or persistent, but consistent, errors for either HDD or the SSD, and
Btrfs can fix up those bad reads with data from the other. If the SSD
were to decide to go nutty, chances are reads through lvmcache would
be corrupt no matter what LV is being read by Btrfs, and it'll be
aware of that and discard those reads. Any corrupt writes in this
case, won't be immediately known by Btrfs because it (like any file
system) assumes writes are OK unless the device reports a write
failure, but those too would be found on read.

The question I have, that I don't know the answer to, is if the stack
arrives at a point where all writes are corrupt but hardware isn't
reporting write errors, and it continues to happen for a while, once
you've resolved that problem and try to mount the file system again,
how well does Btrfs disregard all those bad writes? How well would any
filesystem?



-- 
Chris Murphy
