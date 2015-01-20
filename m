Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:63914 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbbATVuA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Jan 2015 16:50:00 -0500
Received: by mail-wg0-f43.google.com with SMTP id k14so37295522wgh.2
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Jan 2015 13:49:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQQnovS94fo-hRQa_O6Q7EM9KOCPFxC3FTkTC4=CT93sA@mail.gmail.com>
References: <CA+WRLO9nCFgjHzY1F_xR5PpmgaSEemfmZ=MtiSpiaHcROQnq-A@mail.gmail.com>
	<CA+WRLO8gGUxxHhqQfgQWXyU0kT2=nf7u5oPFYJTWY=hSMNBj=w@mail.gmail.com>
	<CAJCQCtRe+0n84PUZuWKw0UUwK_RF_AhW4sMZ+07r96qaNvRWKg@mail.gmail.com>
	<CA+WRLO-VnULLGOE1VkrOortCdQNCKPCwJ70FDJL3KQwru8TLhQ@mail.gmail.com>
	<CAJCQCtQQnovS94fo-hRQa_O6Q7EM9KOCPFxC3FTkTC4=CT93sA@mail.gmail.com>
Date: Wed, 21 Jan 2015 08:49:58 +1100
Message-ID: <CA+WRLO89nFArYhRgjqPBruW0avExOZcf9iZgvusLAr_+4ddxoQ@mail.gmail.com>
Subject: Re: btrfs convert running out of space
From: Gareth Pye <gareth@cerberos.id.au>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The conversion is going the other way (raid10->raid1), but I expect
the analysis is going to be the same. I'll wait on 3.19 kernel then
(or probably 3.19.1) as this system is slightly more production than
use of btrfs would suggest.

The flags 17 messages are from the non-converting balance to clear up
the empty blocks, the flags 65 messages are from the RAID10->RAID1
balance

On Wed, Jan 21, 2015 at 8:41 AM, Chris Murphy <lists@colorremedies.com> wrote:
> On Tue, Jan 20, 2015 at 2:25 PM, Gareth Pye <gareth@cerberos.id.au> wrote:
>> Yeah, I have updated btrfs-progs to 3.18. While it is plausible that
>> the bug was created by using 3.12, none of the behavior has changed
>> now I'm using 3.18.
>>
>> I was experimenting with -dusage values to try and process the blocks
>> in a different order to see if that made any difference. It did let me
>> get through more of the file system before erroring but now it errors
>> on the first block it tries.
>>
>> Using "btrfs balance start -v -dusage=2 /data" cleans up all the empty
>> block groups that "btrfs balance start -v
>> -dconvert=raid1,soft,limit=10 /data" creates. I'm using limit=10 to
>> speed up testing, I have tried without it and it just takes longer to
>> complete and the whole time the RAID1 total sky rockets while the
>> RAID1 used doesn't move.
>
> Sounds like during the conversion, no longer needed raid1 chunks
> aren't quickly deallocated so they can be used as raid10 chunks.
> There's been some work on this in the 3.19 kernel, it might be worth
> testing.
>
> I'm not sure if the significance of the change from flags 17 to flags
> 65 right before the enospc errors. The spacing between flags 17 chunks
> is exactly 1GB whereas the spacing between the values reported for
> flags 65 vary a lot, one is a 12GB gap.
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
