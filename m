Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:43630 "EHLO
        mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727635AbeGRRwy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jul 2018 13:52:54 -0400
Received: by mail-lf0-f42.google.com with SMTP id m12-v6so3988680lfc.10
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jul 2018 10:14:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0a3a8550-3622-0c7b-bcf7-e2d7cabf6b4a@gmail.com>
References: <20180716205809.42jywfvuxwuuqixd@wolfsden.cz> <2197534.TZSffJRfLT@merkaba>
 <9ea19b13-3c46-666f-fa79-f40bd1ae7658@suse.com> <1736761.B5nO4FXixV@merkaba>
 <33396c10-33ef-b8ff-0041-c94d87c67722@gmail.com> <CAJCQCtSZruKeM117EfQNQnEFuk_bswhhKnEnFVD2i7MHWU65RQ@mail.gmail.com>
 <d42d5c79-46df-4e11-0ba2-1adb9e073ed9@gmail.com> <CAJCQCtSpMi-GmJSQx+tjt+WjDqvEH5Z9yeUrYSjLFz+P4f2j2A@mail.gmail.com>
 <0a3a8550-3622-0c7b-bcf7-e2d7cabf6b4a@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 18 Jul 2018 11:14:01 -0600
Message-ID: <CAJCQCtQrY2rz0CTntCO9szii7SveshtSMgCPz4JQqq16kfATNw@mail.gmail.com>
Subject: Re: Healthy amount of free space?
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Martin Steigerwald <martin@lichtvoll.de>,
        Nikolay Borisov <nborisov@suse.com>, Wolf <wolf@wolfsden.cz>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 18, 2018 at 11:06 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2018-07-18 13:04, Chris Murphy wrote:
>>
>> On Wed, Jul 18, 2018 at 7:30 AM, Austin S. Hemmelgarn
>> <ahferroin7@gmail.com> wrote:
>>
>>>
>>> I'm not sure.  In this particular case, this will fail on BTRFS for any X
>>> larger than just short of one third of the total free space.  I would
>>> expect
>>> it to fail for any X larger than just short of half instead.
>>
>>
>> I'm confused. I can't get it to fail when X is 3/4 of free space.
>>
>> lvcreate -V 2g -T vg/thintastic -n btrfstest
>> mkfs.btrfs -M /dev/mapper/vg-btrfstest
>> mount /dev/mapper/vg-btrfstest /mnt/btrfs
>> cd /mnt/btrfs
>> fallocate -l 1500m tmp
>> dd if=/dev/zero of=/mnt/btrfs/tmp bs=1M count=1450
>>
>> Succeeds. No enospc. This is on kernel 4.17.6.
>
> Odd, I could have sworn it would fail reliably.  Unless something has
> changed since I last tested though, doing it with X equal to the free space
> on the filesystem will fail.

OK well X is being defined twice here so I can't tell if I'm doing
this correctly. There's fallocate X and that's 75% of free space for
the empty fs at the time of fallocate.

And then there's dd which is 1450m which is ~2.67x the free space at
the time of dd.

I don't know for sure, but based on the addresses reported before and
after dd for the fallocated tmp file, it looks like Btrfs is not using
the originally fallocated addresses for dd. So maybe it is COWing into
new blocks, but is just as quickly deallocating the fallocated blocks
as it goes, and hence doesn't end up in enospc?



-- 
Chris Murphy
