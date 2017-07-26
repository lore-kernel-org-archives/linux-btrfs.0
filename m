Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:38380 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751678AbdGZMMX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Jul 2017 08:12:23 -0400
Received: by mail-it0-f45.google.com with SMTP id h199so65936695ith.1
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Jul 2017 05:12:23 -0700 (PDT)
Subject: Re: btrfs raid assurance
To: Hugo Mills <hugo@carfax.org.uk>, waxhead <waxhead@dirtcellar.net>,
        =?UTF-8?Q?H=c3=a9rikz_Nawarro?= <herikz.nawarro@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CAD6NJSxuix4N=kPbQ_=QRnKP4Ny6kLyVyEA4p=PvBfgtbwrUHw@mail.gmail.com>
 <20170725134656.GL7140@carfax.org.uk> <20170725135146.GM7140@carfax.org.uk>
 <CAD6NJSz0qMYhiqmseOQtG-ytVTck1aZykVe+U1FtXQvTMThs4g@mail.gmail.com>
 <20170725135835.GN7140@carfax.org.uk>
 <d07af24a-1689-fce4-296a-af4f10f3058d@dirtcellar.net>
 <20170725214505.GP7140@carfax.org.uk>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <3ae7c0e5-ce84-cbc7-9e68-9e4df9aa4f18@gmail.com>
Date: Wed, 26 Jul 2017 08:12:19 -0400
MIME-Version: 1.0
In-Reply-To: <20170725214505.GP7140@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-07-25 17:45, Hugo Mills wrote:
> On Tue, Jul 25, 2017 at 11:29:13PM +0200, waxhead wrote:
>>
>>
>> Hugo Mills wrote:
>>>
>>>>>     You can see about the disk usage in different scenarios with the
>>>>> online tool at:
>>>>>
>>>>> http://carfax.org.uk/btrfs-usage/
>>>>>
>>>>>     Hugo.
>>>>>
>> As a side note, have you ever considered making this online tool
>> (that should never go away just for the record) part of btrfs-progs
>> e.g. a proper tool? I use it quite often (at least several timers
>> per. month) and I would love for this to be a visual tool
>> 'btrfs-space-calculator' would be a great name for it I think.
>>
>> Imagine how nice it would be to run....
>>
>> btrfs-space-calculator -mraid1 -draid10 /dev/sda1 /dev/sdb1
>> /dev/sdc2 /dev/sdd2 /dev/sde3 for example and instantly get
>> something similar to my example below (no accuracy intended)
> 
>     It's certainly a thought. I've already got the algorithm written
> up. I'd have to resurrect my C skills, though, and it's a long way
> down my list of things to do. :/
> 
>     Also on the subject of this tool, I'd like to make it so that the
> parameters get set in the URL, so that people can copy-paste the URL
> of the settings they've got into IRC for discussion. However, that
> would involve doing more JavaScript, which is possibly even lower down
> my list of things to do than starting doing C again...
Is the core logic posted somewhere?  Because if I have some time, I 
might write up a quick Python script to do this locally (it may not be 
as tightly integrated with the regular tools, but I can count on half a 
hand how many distros don't include Python by default).
> 
>     Hugo.
> 
>> d=data
>> m=metadata
>> .=unusable
>>
>> {  500mb} [|ddddd|] /dev/sda1
>> { 3000mb} [|ddddd|mmmmm|mmmmm|mmmmm|mmmmm|mm...|] /dev/sdb1
>> { 3000mb} [|ddddd|mmmmm|mmmmm|mmmmm|mmmmm|mmm..|] /dev/sdc2
>> { 5000mb}
>> [|ddddd|mmmmm|mmmmm|mmmmm|mmmmm|mmmmm|mmmmm|mmmmm|mmmmm|mmmmm|]
>> /dev/sdb1
>> --------
>> {11500mb} Total space
>>
>> usable for data (raid10): 1000mb / 2000mb
>> usable for metadata (raid1): 4500mb / 9000mb
>> unusable: 500mb
>>
>> Of course this would have to change one (if ever) subvolumes can
>> have different raid levels etc, but I would have loved using
>> something like this instead of jumping around carfax abbey (!) at
>> night.
> 
>     The core algorithm for the tool actually works pretty well for
> dealing with different RAID levels, as long as you know how much of
> each kind of data you're going to be using. (Although it's actually
> path-dependent -- write 100 GB of RAID-0 then 100 GB of RAID-1 can
> have different results than if you write them in the opposite order --
> but that's a kind of edge effect).
> 
>     Hugo.
> 

