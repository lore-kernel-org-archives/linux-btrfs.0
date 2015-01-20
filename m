Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:37607 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbbATXEs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Jan 2015 18:04:48 -0500
Received: by mail-we0-f172.google.com with SMTP id k11so40867474wes.3
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Jan 2015 15:04:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTiboWRVkZLE2Te9Kb00SXxUk0_AwE5xv-vTHxrpaDCqA@mail.gmail.com>
References: <CA+WRLO9nCFgjHzY1F_xR5PpmgaSEemfmZ=MtiSpiaHcROQnq-A@mail.gmail.com>
	<CA+WRLO8gGUxxHhqQfgQWXyU0kT2=nf7u5oPFYJTWY=hSMNBj=w@mail.gmail.com>
	<CAJCQCtRe+0n84PUZuWKw0UUwK_RF_AhW4sMZ+07r96qaNvRWKg@mail.gmail.com>
	<CA+WRLO-VnULLGOE1VkrOortCdQNCKPCwJ70FDJL3KQwru8TLhQ@mail.gmail.com>
	<CAJCQCtQQnovS94fo-hRQa_O6Q7EM9KOCPFxC3FTkTC4=CT93sA@mail.gmail.com>
	<CA+WRLO89nFArYhRgjqPBruW0avExOZcf9iZgvusLAr_+4ddxoQ@mail.gmail.com>
	<CAJCQCtTiboWRVkZLE2Te9Kb00SXxUk0_AwE5xv-vTHxrpaDCqA@mail.gmail.com>
Date: Wed, 21 Jan 2015 10:04:47 +1100
Message-ID: <CA+WRLO-oUUQhfJ_LnwaQmr_-sJK_oTCE89R11N3kM-vj-Gv6Wg@mail.gmail.com>
Subject: Re: btrfs convert running out of space
From: Gareth Pye <gareth@cerberos.id.au>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yeah, we don't have that much space spare :(

File system has been going strong from when it was created with early
RAID5 code, then converted to RAID10 with kernel 3.12.

There aren't any nocow files to my knowledge but there are plenty of
files larger than a gig on the file system. The first few results from
logical-resolve have been for files in the 1G~2G range, so that could
be some sticky spaghetti.

On Wed, Jan 21, 2015 at 9:53 AM, Chris Murphy <lists@colorremedies.com> wrote:
> On Tue, Jan 20, 2015 at 2:49 PM, Gareth Pye <gareth@cerberos.id.au> wrote:
>> The conversion is going the other way (raid10->raid1), but I expect
>> the analysis is going to be the same. I'll wait on 3.19 kernel then
>> (or probably 3.19.1) as this system is slightly more production than
>> use of btrfs would suggest.
>>
>> The flags 17 messages are from the non-converting balance to clear up
>> the empty blocks, the flags 65 messages are from the RAID10->RAID1
>> balance
>
> Makes sense.
>
> Are there any particularly large files? File bigger than 1GB? Are any
> of those nocow (xattr +C)? I'm just throwing spaghetti to see what
> might be different with this volume than others which have
> successfully converted between raid10 and raid1. The file system was
> created with btrfs-progs 3.12? Defaults? (Other than data raid 10.)
>
> It looks to be a large file but it might be worth grabbing a
> btrfs-image per the wiki in case the fs behavior changes while doing
> anything else to it (even normal operation might free up whatever's
> stuck and then the problem isn't reproducible).
>
> Another option, if you have the space, is to create two more drbd
> devices of the same size (as each other, they don't have to be the
> same size as what's already in the array), and add them to this
> volume, and then attempt to complete the conversion (with soft option
> as you have been).
>
> Also, those three block values reported with flags 65 can be plugged
> into btrfs-debug-tree or btrfs inspect internal to find out what file
> is involved, and maybe there's something about them that's instigating
> the problem.
>
> I would consider the file system suspect at this point, just being
> conservative about it. The reason is that it's in the middle of a
> conversion to raid1, so anything newly allocated will be raid1, and
> anything old is raid10 and being in this state long term I think is
> sufficiently non-deterministic in that who knows what could happen in
> three weeks. It might be OK. So if you have the space to create a new
> raid1 volume, and btrfs send old to new, it gets you where you
> ultimately want to be much sooner. And then you can throw 3.19rc5 at
> the problemed fs and see how it behaves.
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
