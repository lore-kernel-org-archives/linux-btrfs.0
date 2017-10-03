Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36732 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdJCWtK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Oct 2017 18:49:10 -0400
Received: by mail-pf0-f195.google.com with SMTP id f84so10522800pfj.3
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Oct 2017 15:49:10 -0700 (PDT)
Subject: Re: Seeking Help on Corruption Issues
To: Hugo Mills <hugo@carfax.org.uk>,
        Stephen Nesbitt <snesbitt@aussieswithtails.com>,
        linux-btrfs@vger.kernel.org
References: <c67167b4-190b-dfdc-33a8-8cb75a4744ef@gmail.com>
 <20171003201047.GE3293@carfax.org.uk>
 <CAPXGFsE4HzGWhjKtp=E-4LN_-vQnFtqJDDhTva9Wkg9Gtm9D_w@mail.gmail.com>
 <20171003211121.GF3293@carfax.org.uk>
From: Stephen Nesbitt <nesbittmeister@gmail.com>
Message-ID: <e531fc75-8080-eb82-86bb-2f787bf0ea43@gmail.com>
Date: Tue, 3 Oct 2017 15:49:25 -0700
MIME-Version: 1.0
In-Reply-To: <20171003211121.GF3293@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 10/3/2017 2:11 PM, Hugo Mills wrote:
>     Hi, Stephen,
>
> On Tue, Oct 03, 2017 at 08:52:04PM +0000, Stephen Nesbitt wrote:
>> Here it i. There are a couple of out-of-order entries beginning at 117. And
>> yes I did uncover a bad stick of RAM:
>>
>> btrfs-progs v4.9.1
>> leaf 2589782867968 items 134 free space 6753 generation 3351574 owner 2
>> fs uuid 24b768c3-2141-44bf-ae93-1c3833c8c8e3
>> chunk uuid 19ce12f0-d271-46b8-a691-e0d26c1790c6
> [snip]
>> item 116 key (1623012749312 EXTENT_ITEM 45056) itemoff 10908 itemsize 53
>> extent refs 1 gen 3346444 flags DATA
>> extent data backref root 271 objectid 24999978 offset 0 count 1
>> item 117 key (1621939052544 EXTENT_ITEM 8192) itemoff 10855 itemsize 53
>> extent refs 1 gen 3346495 flags DATA
>> extent data backref root 271 objectid 21751764 offset 6733824 count 1
>> item 118 key (1623012450304 EXTENT_ITEM 8192) itemoff 10802 itemsize 53
>> extent refs 1 gen 3351513 flags DATA
>> extent data backref root 271 objectid 5724364 offset 680640512 count 1
>> item 119 key (1623012802560 EXTENT_ITEM 12288) itemoff 10749 itemsize 53
>> extent refs 1 gen 3346376 flags DATA
>> extent data backref root 271 objectid 21751764 offset 6701056 count 1
>>>> hex(1623012749312)
> '0x179e3193000'
>>>> hex(1621939052544)
> '0x179a319e000'
>>>> hex(1623012450304)
> '0x179e314a000'
>>>> hex(1623012802560)
> '0x179e31a0000'
>
>     That's "e" -> "a" in the fourth hex digit, which is a single-bit
> flip, and should be fixable by btrfs check (I think). However, even
> fixing that, it's not ordered, because 118 is then before 117, which
> could be another bitflip ("9" -> "4" in the 7th digit), but two bad
> bits that close to each other seems unlikely to me.
>
>     Hugo.

Hope this is a duplicate reply - I might have fat fingered something.

The underlying file is disposable/replaceable. Any way to zero out/zap 
the bad BTRFS entry?

-steve

