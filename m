Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34793 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754089AbcK3Ifl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Nov 2016 03:35:41 -0500
Received: by mail-wm0-f65.google.com with SMTP id g23so28251205wme.1
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Nov 2016 00:35:40 -0800 (PST)
From: Wilson Meier <wilson.meier@gmail.com>
Subject: Re: Convert from RAID 5 to 10
To: Martin Steigerwald <martin@lichtvoll.de>, Roman Mamedov <rm@romanrm.net>
References: <10bbbf97-7f43-c972-a832-4a8cf054d5e5@xgm.de>
 <fce2df8b-0775-1ecf-c08d-960018822c20@googlemail.com>
 <20161130103808.74e5ae95@natsu> <3713990.abIjkpnqyF@merkaba>
Cc: Wilson Meier <wilson.meier@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <73d0d10c-7a06-b282-ee76-4512aaed5723@googlemail.com>
Date: Wed, 30 Nov 2016 09:35:36 +0100
MIME-Version: 1.0
In-Reply-To: <3713990.abIjkpnqyF@merkaba>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Am 30/11/16 um 09:06 schrieb Martin Steigerwald:
> Am Mittwoch, 30. November 2016, 10:38:08 CET schrieb Roman Mamedov:
>> On Wed, 30 Nov 2016 00:16:48 +0100
>>
>> Wilson Meier <wilson.meier@gmail.com> wrote:
>>> That said, btrfs shouldn't be used for other then raid1 as every other
>>> raid level has serious problems or at least doesn't work as the expected
>>> raid level (in terms of failure recovery).
>> RAID1 shouldn't be used either:
>>
>> *) Read performance is not optimized: all metadata is always read from the
>> first device unless it has failed, data reads are supposedly balanced
>> between devices per PID of the process reading. Better implementations
>> dispatch reads per request to devices that are currently idle.
>>
>> *) Write performance is not optimized, during long full bandwidth sequential
>> writes it is common to see devices writing not in parallel, but with a long
>> periods of just one device writing, then another. (Admittedly have been
>> some time since I tested that).
>>
>> *) A degraded RAID1 won't mount by default.
>>
>> If this was the root filesystem, the machine won't boot.
>>
>> To mount it, you need to add the "degraded" mount option.
>> However you have exactly a single chance at that, you MUST restore the RAID
>> to non-degraded state while it's mounted during that session, since it
>> won't ever mount again in the r/w+degraded mode, and in r/o mode you can't
>> perform any operations on the filesystem, including adding/removing
>> devices.
>>
>> *) It does not properly handle a device disappearing during operation.
>> (There is a patchset to add that).
>>
>> *) It does not properly handle said device returning (under a
>> different /dev/sdX name, for bonus points).
>>
>> Most of these also apply to all other RAID levels.
> So the stability matrix would need to be updated not to recommend any kind of 
> BTRFS RAID 1 at the moment?
>
> Actually I faced the BTRFS RAID 1 read only after first attempt of mounting it 
> "degraded" just a short time ago.
>
> BTRFS still needs way more stability work it seems to me.
>
I would say the matrix should be updated to not recommend any RAID Level
as from the discussion it seems they all of them have flaws.
To me RAID is broken if one cannot expect to recover from a device
failure in a solid way as this is why RAID is used.
Correct me if i'm wrong. Right now i'm making my thoughts about
migrating to another FS and/or Hardware RAID.


