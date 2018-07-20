Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:39729 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388110AbeGTTgR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jul 2018 15:36:17 -0400
Received: by mail-it0-f66.google.com with SMTP id g141-v6so13476019ita.4
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Jul 2018 11:46:45 -0700 (PDT)
Subject: Re: [PATCH 0/4] 3- and 4- copy RAID1
To: Hugo Mills <hugo@carfax.org.uk>, Andrei Borzenkov <arvidjaar@gmail.com>,
        kreijack@inwind.it, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
References: <cover.1531503452.git.dsterba@suse.com>
 <9945d460-99b5-a927-a614-c797bbc7862d@dirtcellar.net>
 <d340ce28-6c93-22d4-0f56-73de8e55f1f6@libero.it>
 <pan$b5258$f3ecc84$8e06948b$54511335@cox.net>
 <793d8ec3-7934-ea60-521d-7a039c9f1ce9@libero.it>
 <pan$98af2$39851f53$ef9fd141$bfd51f5b@cox.net>
 <89d20da9-0e80-51d1-3a4f-4cccb44d31ef@libero.it>
 <2f1b19da-f2a2-077b-eee1-1106f40679ac@gmail.com>
 <b9ccc6fa-da45-4038-7911-ba012371f223@inwind.it>
 <1066d34f-2703-19e3-62ea-c4178640b8c3@gmail.com>
 <20180720184159.GD21293@carfax.org.uk>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <ac9b68aa-0d4c-1d8c-9a5c-a5d9dda7473c@gmail.com>
Date: Fri, 20 Jul 2018 14:46:42 -0400
MIME-Version: 1.0
In-Reply-To: <20180720184159.GD21293@carfax.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-07-20 14:41, Hugo Mills wrote:
> On Fri, Jul 20, 2018 at 09:38:14PM +0300, Andrei Borzenkov wrote:
>> 20.07.2018 20:16, Goffredo Baroncelli пишет:
> [snip]
>>> Limiting the number of disk per raid, in BTRFS would be quite simple to implement in the "chunk allocator"
>>>
>>
>> You mean that currently RAID5 stripe size is equal to number of disks?
>> Well, I suppose nobody is using btrfs with disk pools of two or three
>> digits size.
> 
>     But they are (even if not very many of them) -- we've seen at least
> one person with something like 40 or 50 devices in the array. They'd
> definitely got into /dev/sdac territory. I don't recall what RAID level
> they were using. I think it was either RAID-1 or -10.
> 
>     That's the largest I can recall seeing mention of, though.
I've talked to at least two people using it on 100+ disks in a SAN 
situation.  In both cases however, BTRFS itself was only seeing about 20 
devices and running in raid0 mode on them, with each of those being a 
RAID6 volume configured on the SAN node holding the disks for it.  From 
what I understood when talking to them, they actually got rather good 
performance in this setup, though maintenance was a bit of a pain.
