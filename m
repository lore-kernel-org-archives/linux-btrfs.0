Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:39157 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbbATVZR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Jan 2015 16:25:17 -0500
Received: by mail-wi0-f172.google.com with SMTP id bs8so29934269wib.5
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Jan 2015 13:25:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRe+0n84PUZuWKw0UUwK_RF_AhW4sMZ+07r96qaNvRWKg@mail.gmail.com>
References: <CA+WRLO9nCFgjHzY1F_xR5PpmgaSEemfmZ=MtiSpiaHcROQnq-A@mail.gmail.com>
	<CA+WRLO8gGUxxHhqQfgQWXyU0kT2=nf7u5oPFYJTWY=hSMNBj=w@mail.gmail.com>
	<CAJCQCtRe+0n84PUZuWKw0UUwK_RF_AhW4sMZ+07r96qaNvRWKg@mail.gmail.com>
Date: Wed, 21 Jan 2015 08:25:16 +1100
Message-ID: <CA+WRLO-VnULLGOE1VkrOortCdQNCKPCwJ70FDJL3KQwru8TLhQ@mail.gmail.com>
Subject: Re: btrfs convert running out of space
From: Gareth Pye <gareth@cerberos.id.au>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yeah, I have updated btrfs-progs to 3.18. While it is plausible that
the bug was created by using 3.12, none of the behavior has changed
now I'm using 3.18.

I was experimenting with -dusage values to try and process the blocks
in a different order to see if that made any difference. It did let me
get through more of the file system before erroring but now it errors
on the first block it tries.

Using "btrfs balance start -v -dusage=2 /data" cleans up all the empty
block groups that "btrfs balance start -v
-dconvert=raid1,soft,limit=10 /data" creates. I'm using limit=10 to
speed up testing, I have tried without it and it just takes longer to
complete and the whole time the RAID1 total sky rockets while the
RAID1 used doesn't move.

On Tue, Jan 20, 2015 at 6:38 PM, Chris Murphy <lists@colorremedies.com> wrote:
>> On Mon, Jan 19, 2015 at 5:13 PM, Gareth Pye <gareth@cerberos.id.au> wrote:
>> I just tried from a slightly different tack, after doing another
>> -dusage=2 pass I did the following:
>> # btrfs balance start -v -dconvert=raid1 -dsoft -dusage=96 /data
>> Dumping filters: flags 0x1, state 0x0, force is off
>>   DATA (flags 0x302): converting, target=16, soft is on, usage=96
>> Done, had to relocate 0 out of 3763 chunks
>> # btrfs balance start -v -dconvert=raid1 -dsoft -dusage=99 /data
>> Dumping filters: flags 0x1, state 0x0, force is off
>>   DATA (flags 0x302): converting, target=16, soft is on, usage=99
>> ERROR: error during balancing '/data' - No space left on device
>
>
> I guess I don't really understand the purpose of combining dconvert
> and dusage. Sure, it should either work or give an error, so there may
> still be a bug here. But I'm just not following why they'd be used
> together, seems superfluous. What happens when they're tried
> separately? I'm not sure which one's instigating the problem.
>
> Also I think you should upgrade to btrfs-progs 3.18, seeing as 3.12 is
> old and if there's a bug in that version of progs vs the kernel, it's
> not going to get fixed.
>
>
>
> --
> Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Gareth Pye
Level 2 MTG Judge, Melbourne, Australia
"Dear God, I would like to file a bug report"
