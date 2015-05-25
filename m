Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:37308 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbbEYWFS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 May 2015 18:05:18 -0400
Received: by wifw1 with SMTP id w1so9645529wif.0
        for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2015 15:05:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <33764626-2528-47DC-A31B-B801419856C7@plack.net>
References: <CA+WRLO_=RV_Ga7d-ff=p13TxycquQ1Ra2d2WYeGroQn9tm934w@mail.gmail.com>
	<036B4518-F7BF-4C9A-8906-38550D7F125F@plack.net>
	<CA+WRLO_5mG7t+2x-B+AV052i2=pkPmAr88txeQ4ZkxL7jvOAig@mail.gmail.com>
	<33764626-2528-47DC-A31B-B801419856C7@plack.net>
Date: Tue, 26 May 2015 08:05:17 +1000
Message-ID: <CA+WRLO9hLPmNZ3ZBVBR9RmLC3aeNDp3_8we9kBz-E8PNoy77CQ@mail.gmail.com>
Subject: Re: Did convert do anything?
From: Gareth Pye <gareth@cerberos.id.au>
To: Anthony Plack <tmy@plack.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After a full balance that is likely to change to 4.41TiB used of
4.41TiB total. Is that going to help anything, Peter is saying it's a
known bug that convert can't do anything currently.

On Tue, May 26, 2015 at 2:36 AM, Anthony Plack <tmy@plack.net> wrote:
>
>> On May 24, 2015, at 11:00 PM, Gareth Pye <gareth@cerberos.id.au> wrote:
>>
>> 2.
>> 18% or 1.1T spare currently. That isn't what I'd call tiny free space.
>> --
>>
>
> # btrfs  fi df /data
> Data, RAID1: total=4.43TiB, used=4.41TiB
>
> Of 4.43TiB, btrfs believes you have used 4.41TiB.
>
> Chris’s fix to this has to deal with the ENOSPC error "No space left on device”, not because you don’ t have free space but because your extents are marked as used and you need a balance operation to clean it up.
>
> https://patchwork.kernel.org/patch/6238111/
>> Before the reverted commit, this test case failed with ENOSPC because
>> all chunks on the freshly converted filesystem were allocated, although
>> many were empty. The reverted commit removed an allocation attempt in
>> btrfs_set_block_group_ro(), but that fix wasn't right. After the
>> reverted commit, the balance succeeds, but the data/metadata profiles
>> aren't actually updated:
>



-- 
Gareth Pye
Level 2 MTG Judge, Melbourne, Australia
"Dear God, I would like to file a bug report"
