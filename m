Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:34088 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756549AbdEUQyq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 May 2017 12:54:46 -0400
Received: by mail-qk0-f195.google.com with SMTP id u75so16190176qka.1
        for <linux-btrfs@vger.kernel.org>; Sun, 21 May 2017 09:54:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$42cee$29ae88fa$3ea3d443$c10a99e5@cox.net>
References: <20170520164953.7344-1-nefelim4ag@gmail.com> <20170520164953.7344-3-nefelim4ag@gmail.com>
 <20170520191400.25202d75@jupiter.sol.kaishome.de> <CAGqmi76cLmXOj=P7qeR58n1aHNB-6e1R0yo+PjuMVLLgnWaryg@mail.gmail.com>
 <pan$42cee$29ae88fa$3ea3d443$c10a99e5@cox.net>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Sun, 21 May 2017 19:54:05 +0300
Message-ID: <CAGqmi77_iaZC0f0BsGWVAzgZnNRvWTHkxvnP=risHa33NGPhGA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] Btrfs: compression must free at least PAGE_SIZE
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-05-21 4:38 GMT+03:00 Duncan <1i5t5.duncan@cox.net>:
> Timofey Titovets posted on Sat, 20 May 2017 21:30:47 +0300 as excerpted:
>
>> 2017-05-20 20:14 GMT+03:00 Kai Krakow <hurikhan77@gmail.com>:
>>
>>> BTW: What's the smallest block size that btrfs stores? Is it always
>>> PAGE_SIZE? I'm not familiar with btrfs internals...
>
> Thanks for asking the question. =:^)  I hadn't made the below conflicting
> patch sets association until I saw it.
>
>> https://btrfs.wiki.kernel.org/index.php/Manpage/mkfs.btrfs
>
>> AFAIK btrfs works with storage and account data by PAGE_SIZEd block,
>> so it's must be usefull to check if compressed size will give as at
>> least one PAGE_SIZE space.
>
> [Not a dev, just a btrfs list regular and btrfs user.  If the devs say
> different...]
>
> While AFAIK, btrfs now saves data in page-size blocks (tho note that if
> the entire file is under a block it may be inlined into metadata
> depending on various limits, at least one of which is configurable)...
>
> There is a sub-page-size patch set that has already been thru several
> revision cycles and AFAIK, remains on the roadmap for eventual merge.
>
> You'd need to check the list or ask the devs about current status, but
> it's quite possible the current code checking for at least one byte of
> compression savings, instead of the at least PAGE_SIZE bytes of savings
> that at present would make more sense, is in anticipation of that patch
> set being merged.
>
> If the sub-page-size block patch-set is no longer anticipated to be
> merged in the relatively near future, it may be worth changing the
> compression profit checks to PAGE_SIZE minimum, as this patch set does,
> but the two patch sets clearly do conflict in concept, so merging this
> one is unlikely to be wise if the other one is still on track for merging.

Sorry, but i know about subpagesize-blocksize patch set, but i don't
understand where you see conflict?

Can you explain what you mean?

By PAGE_SIZE i mean fs cluster size in my patch set.
In the teory it's also possible to use magic constant like 4096, but
then this change will be useless for PowerPC64.

Also (AFAIK) most storage engines use 4KiB+ sector size
So (IMHO) it's bad practice use block size smaller then 4KiB and try
save less 4KiB).

As this is only decision logic change, this can't and will not break
anything in subpage patch set, and can only lead to false positives,
when good compressed data will not saved as compressed.

So if and when subpage patch set would merged, PAGE_SIZE should be
replaced with sector size, and all continue work correctly.

Thanks.
-- 
Have a nice day,
Timofey.
