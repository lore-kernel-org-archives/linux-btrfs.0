Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ed1-f68.google.com ([209.85.208.68]:46952 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbeGTGEO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jul 2018 02:04:14 -0400
Received: by mail-ed1-f68.google.com with SMTP id o8-v6so8747451edt.13
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2018 22:17:46 -0700 (PDT)
Subject: Re: [PATCH 0/4] 3- and 4- copy RAID1
To: kreijack@inwind.it, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
References: <cover.1531503452.git.dsterba@suse.com>
 <9945d460-99b5-a927-a614-c797bbc7862d@dirtcellar.net>
 <d340ce28-6c93-22d4-0f56-73de8e55f1f6@libero.it>
 <pan$b5258$f3ecc84$8e06948b$54511335@cox.net>
 <793d8ec3-7934-ea60-521d-7a039c9f1ce9@libero.it>
 <pan$98af2$39851f53$ef9fd141$bfd51f5b@cox.net>
 <89d20da9-0e80-51d1-3a4f-4cccb44d31ef@libero.it>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <2f1b19da-f2a2-077b-eee1-1106f40679ac@gmail.com>
Date: Fri, 20 Jul 2018 08:17:43 +0300
MIME-Version: 1.0
In-Reply-To: <89d20da9-0e80-51d1-3a4f-4cccb44d31ef@libero.it>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

18.07.2018 22:42, Goffredo Baroncelli пишет:
> On 07/18/2018 09:20 AM, Duncan wrote:
>> Goffredo Baroncelli posted on Wed, 18 Jul 2018 07:59:52 +0200 as
>> excerpted:
>>
>>> On 07/17/2018 11:12 PM, Duncan wrote:
>>>> Goffredo Baroncelli posted on Mon, 16 Jul 2018 20:29:46 +0200 as
>>>> excerpted:
>>>>
>>>>> On 07/15/2018 04:37 PM, waxhead wrote:
>>>>
>>>>> Striping and mirroring/pairing are orthogonal properties; mirror and
>>>>> parity are mutually exclusive.
>>>>
>>>> I can't agree.  I don't know whether you meant that in the global
>>>> sense,
>>>> or purely in the btrfs context (which I suspect), but either way I
>>>> can't agree.
>>>>
>>>> In the pure btrfs context, while striping and mirroring/pairing are
>>>> orthogonal today, Hugo's whole point was that btrfs is theoretically
>>>> flexible enough to allow both together and the feature may at some
>>>> point be added, so it makes sense to have a layout notation format
>>>> flexible enough to allow it as well.
>>>
>>> When I say orthogonal, It means that these can be combined: i.e. you can
>>> have - striping (RAID0)
>>> - parity  (?)
>>> - striping + parity  (e.g. RAID5/6)
>>> - mirroring  (RAID1)
>>> - mirroring + striping  (RAID10)
>>>
>>> However you can't have mirroring+parity; this means that a notation
>>> where both 'C' ( = number of copy) and 'P' ( = number of parities) is
>>> too verbose.
>>
>> Yes, you can have mirroring+parity, conceptually it's simply raid5/6 on 
>> top of mirroring or mirroring on top of raid5/6, much as raid10 is 
>> conceptually just raid0 on top of raid1, and raid01 is conceptually raid1 
>> on top of raid0.  
> And what about raid 615156156 (raid 6 on top of raid 1 on top of raid 5 on top of....) ???
> 
> Seriously, of course you can combine a lot of different profile; however the only ones that make sense are the ones above.

RAID50 (striping across RAID5) is common.

