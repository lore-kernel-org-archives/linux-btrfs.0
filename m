Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:32861 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab3CSLDI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Mar 2013 07:03:08 -0400
Received: by mail-bk0-f45.google.com with SMTP id i18so157802bkv.4
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2013 04:03:06 -0700 (PDT)
Message-ID: <514845E7.5060605@yerf-it.nl>
Date: Tue, 19 Mar 2013 12:03:03 +0100
From: Remco Hosman - Yerf-IT <remco@yerf-it.nl>
MIME-Version: 1.0
To: dsterba@suse.cz
CC: linux-btrfs@vger.kernel.org
Subject: Re: converting to raid5
References: <19DDB13F-E8EC-4751-A916-E83555347D7E@hosman.xs4all.nl> <20130315124744.GF7229@twin.jikos.cz>
In-Reply-To: <20130315124744.GF7229@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Op 15-3-2013 13:47, David Sterba schreef:
> On Mon, Mar 11, 2013 at 09:15:44PM +0100, Remco Hosman wrote:
>> first, i did the following: `btrfs val start -dconvert=raid5,usage=1` to convert the mostly empty chunks.
>> This resulted in a lot of allocated space (10's of gigs), with only a few 100 meg used.
> Matches my expectation, converting to the new profile needs to allocate
> full 1G chunks, but the usage=1 filter allows to fill them partially.
>
> After this step, several ~empty raid1 chunks should disappear.
It did not only happen when i added the usage=1, but also without.
>> i did `btrfs val start -dusage=75` to clean things up.
>>
>> then i ran `btrfs bal start -dconvert=raid5,soft`.
>> I noticed how the difference between total and used for raid5 kept growing.
> Do you remember if this was temporary or if the difference was
> unexpectedly big after the whole operation finished?
It did not finish, the filesystem did not have that much space free so i 
canceled it (even before it ran out of space) and ran `btrfs bal start 
-dusage=1` to cleanup the unused space
>> My guess is that its taking 1 raid1 chunk (2x1 gig disk space, 1 gig
>> data), and moving it to 1 raid5 chunk (4gig disk space, 3gig data),
>> leaving all chunks 33% used.
> Why 3G of data in raid5 case? I assume you talk about the actually used
> data and this should be the same as in raid1 case, but spread over 3x
> 1GB chunks and leaving them 33% utilized, that makes sense, but is not
> clear from your description.
I assumed that with raid5, btrfs allocated 1 gig on each disk and uses 1 
for parity, giving 3 gig of data in 4gig diskspace.
>> This is what 3 calls of `btrfs file df /` looks like a few minutes after each other, with the balance still running:
>> Data, RAID1: total=807.00GB, used=805.70GB
>> Data, RAID5: total=543.00GB, used=192.81GB
>> --
>> Data, RAID1: total=800.00GB, used=798.70GB
>> Data, RAID5: total=564.00GB, used=199.30GB
>> --
>> Data, RAID1: total=795.00GB, used=793.70GB
>> Data, RAID5: total=579.00GB, used=204.81GB
> raid1 numbers going down, raid5 going up, all ok.
>
> david

