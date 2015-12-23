Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:34286 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933410AbbLWU4a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Dec 2015 15:56:30 -0500
Received: by mail-ig0-f173.google.com with SMTP id m11so73264440igk.1
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Dec 2015 12:56:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <567B0245.5000902@gmx.de>
References: <n5du09$9rn$1@ger.gmane.org>
	<1527885.5NheBqth0k@merkaba>
	<n5e139$r1h$1@ger.gmane.org>
	<CAJCQCtStdF=JU11LOjJ_xLXir_CPzJ7GaQRRqsROEE0eOADFWA@mail.gmail.com>
	<567B0245.5000902@gmx.de>
Date: Wed, 23 Dec 2015 13:56:29 -0700
Message-ID: <CAJCQCtSLfwmuBnNFHKbyDmUDV5yQg-BWDB3TjFqxtL_OqEm5TA@mail.gmail.com>
Subject: Re: btrfs und lvm-cache?
From: Chris Murphy <lists@colorremedies.com>
To: Neuer User <auslands-kv@gmx.de>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 23, 2015 at 1:21 PM, Neuer User <auslands-kv@gmx.de> wrote:
> Am 23.12.2015 um 20:49 schrieb Chris Murphy:
>> Seems to me if the LV's on the two HDDs are exposed, the lvmcache has
>> to separately keep track of those LVs. So as long as everything is
>> working correctly, it should be fine. That includes either transient
>> or persistent, but consistent, errors for either HDD or the SSD, and
>> Btrfs can fix up those bad reads with data from the other. If the SSD
>> were to decide to go nutty, chances are reads through lvmcache would
>> be corrupt no matter what LV is being read by Btrfs, and it'll be
>> aware of that and discard those reads. Any corrupt writes in this
>> case, won't be immediately known by Btrfs because it (like any file
>> system) assumes writes are OK unless the device reports a write
>> failure, but those too would be found on read.
>
> What corrupt write do you mean? The "nuts" SSD is not going to write to
> the HDDs, that will be done by lvmcache. So the HDDs should get the
> correct data, only the SSD will be bad, right?

Btrfs always writes to the 'cache LV' and then it's up to lvmcache to
determine how and when things are written to the 'cache pool LV' vs
the 'origin LV' and I have no idea if there's a case with writeback
mode where things write to the SSD and only later get copied from SSD
to the HDD, in which case a wildly misbehaving SSD might corrupt data
on the origin.

If you use writethrough, the default, then the data on HDDs should be
fine even if the single SSD goes crazy for some reason. Even if all
reads go bad, worse case is Btrfs should stop and go read-only. If the
SSD read errors are more transient, then Btrfs tries to fix them with
COW writes, so even if these fixes aren't needed on HDD, they should
arrive safely on both HDDs and hence still no corruption.

I mean *really* if data integrity is paramount you probably would do
this with production methods. Anything that has high IOPS like a mail
server, just write that stuff only to the SSD, and then occasionally
rsync it to conventionally raided (md or lvm) HDDs with XFS. You could
even use lvm snapshots and do this often, and now you not only have
something fast and safe but also you have an integrated backup that's
mirrored, in a sense you have three copies. Whereas what you're
attempting is rather complicated, and while it ought to work and it
gets testing, you're really being a test candidate not least of which
is Btrfs but also lvmcache, but you're also combining both tests. I'd
just say make sure you have regular backups - snapshot the rw
subvolume regularly and sync it to another filesystem. As often as the
workflow can tolerate.




>
> And that would become obvious with the next reads, in which case btrfs
> probably would throw an error as it gets crazy data from apparently both
> LVs (but only coming from the SSD). So, that could be fixed by removing
> the SSD without any data loss from the HDDs, right?

Only if you're using writethrough mode, but yes.


>
>>
>> The question I have, that I don't know the answer to, is if the stack
>> arrives at a point where all writes are corrupt but hardware isn't
>> reporting write errors, and it continues to happen for a while, once
>> you've resolved that problem and try to mount the file system again,
>> how well does Btrfs disregard all those bad writes? How well would any
>> filesystem?
>>
> Hmm, again the writes to the HDDs should be ok. Only the SSD would have
> pretty corrupt data, right? In such a case it might depend on how much
> bad data is read back from the SSDs and what the filesystem does in
> raction to these?
>
> P.S.: Of course, one other possibility would be to use a second SSD, so
> that each LV has a separate caching SSD. In this case, there would
> always be a valid source (given that not both SSDs go nuts the same
> time...).

Simplistically, SSDs seem to fail two ways: a series of transient
errors that Btrfs can pretty much always account for; and then totally
face planting. The way they faceplant can be all writes fail, reads
work, or the whole device just vanishes off the bus. I don't know how
that affects lvmcache writethrough if the entire cache pool vanishes.
It should still write to the HDDs but I don't know that it does.


> But I would need another slot for this. If the pros are very high,
> that's ok. If it works nicely with just one SSD, then even better.

Yeah if it's a decent name brand SSD and not one of the ones with
known crap firmware, then I think it's fine to just have one. Either
way, each origin LV gets a separate cache pool LV if I understand
lvmcache correctly.

Off hand I don't know if you need separate VGs to make sure the 'cache
LVs' you format with Btrfs in fact use different PVs as origins.
That's important. The usual lvcreate command has a way to specify one
or more PVs to use, rather than have it just grab a pile of extents
from the VG (which could be from either PV), but I don't know if
that's the way it works in conjunction with lvmcache.

You're probably best off configuring this, and while doing write, pull
a device. Do that three times, once for each HDD and once for the SSD,
and see if you can recover. If it has to be bullet proof, you need to
spray it with bullets.


-- 
Chris Murphy
