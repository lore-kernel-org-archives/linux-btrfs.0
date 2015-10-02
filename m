Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:33960 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbbJBKKt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Oct 2015 06:10:49 -0400
Received: by obbda8 with SMTP id da8so78509964obb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Oct 2015 03:10:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMH1C+oztyJ1-M8AxXCG_Lt9AD1JycaneGVG1CikZZfRkq_93Q@mail.gmail.com>
References: <CAMH1C+r4yYU8hYfcZpFRyN1UWY8OPTs5Md7MdE=bm2RW9udREQ@mail.gmail.com>
	<20150923144334.GP5918@carfax.org.uk>
	<CAMH1C+qz76gDf=xPyph3C-PPHsHegc6L4o7LtOa7oY6QYtE8Gw@mail.gmail.com>
	<CAMH1C+qQkDrHxk1HLwqupjbrSNZvhZdOX0v78EQ=5pP+pc4R4Q@mail.gmail.com>
	<20150925100633.GE3749@carfax.org.uk>
	<CAMH1C+qD8Me-D0VVb5pntPQd4A9VXGCEbxQajZfDCEnWbJUxSA@mail.gmail.com>
	<CAMH1C+oztyJ1-M8AxXCG_Lt9AD1JycaneGVG1CikZZfRkq_93Q@mail.gmail.com>
Date: Fri, 2 Oct 2015 12:10:48 +0200
Message-ID: <CAMH1C+oe6nBYH5JdfYxNNjF181je9_ON=pwTCWMOaHj4sqbm_Q@mail.gmail.com>
Subject: Re: Btrfs check dont repair
From: =?UTF-8?B?VmFja8OhxZkgRnJhbnRpxaFlaw==?= <vackarf@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So... I find a solution! :)

I tried to play with mount options. Finally I sucessfully mounted
corrupted btrfs with

mount -t btrfs -oro,degraded,recovery  /dev/sdb2 /mnt/hdd-root/

Thank you for help. Now I copy all data to external drive and make new
filestystem.

Frantisek



2015-10-02 11:05 GMT+02:00 Vackář František <vackarf@gmail.com>:
> I'm not sure if it was my last email with attachement delivered.
>
> My last email is below. Attachement is uploaded here:
> http://franta.naobzoru.cz/files/btrfs-failed.txt
>
> Thank you.
>
> Frantisek
>
> 2015-09-27 11:51 GMT+02:00 Vackář František <vackarf@gmail.com>:
>> So I copy with dd all my 1.7 TB partition with broken btrfs on
>> external hdd and try to repair, but without success.
>>
>> I tried to apply patch to actual sources but its too different to
>> apply. So I downloaded sources from april 2014 (last before date od
>> patch) and it was applied correctly. But when I ran it (./btrfsck
>> --repair /dev/sdb2) it faild. Output is in attachment. Do you have any
>> idea what to do?
>>
>> Frantisek
>>
>> 2015-09-25 12:06 GMT+02:00 Hugo Mills <hugo@carfax.org.uk>:
>>> On Fri, Sep 25, 2015 at 11:36:55AM +0200, Vackář František wrote:
>>>> Now I have memory ok.
>>>>
>>>> I found this patch, but i am not sure, if its the correct one.
>>>> https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg33496.html
>>>>
>>>> Cay you help me please, witch patch i should use?
>>>
>>>    Yes, that's the patch series (you'll need all three patches). David
>>> Sterba said it didn't apply cleanly any more; I don't know how hard
>>> it'll be to fix up the problems, though.
>>>
>>>    Hugo.
>>>
>>>> Frantisek
>>>>
>>>> 2015-09-23 17:22 GMT+02:00 Vackář František <vackarf@gmail.com>:
>>>> > Yes, I have bad ram. I ran memtest and memory is really bad.
>>>> >
>>>> > So a must buy new memory first.
>>>> >
>>>> > Thank you.
>>>> >
>>>> > Frantisek
>>>> >
>>>> > 2015-09-23 16:43 GMT+02:00 Hugo Mills <hugo@carfax.org.uk>:
>>>> >> On Wed, Sep 23, 2015 at 04:39:27PM +0200, Vackář František wrote:
>>>> >>> Hello,
>>>> >>>
>>>> >>> i have problem with my btrfs, can you help me, please? Its on my
>>>> >>> notebook. Sometimes it exhausted battery during sleep and died. But
>>>> >>> everytime FS was ok. But ones mount fail.
>>>> >>>
>>>> >>> Do you have any idea how repair it?
>>>> >> [snip]
>>>> >>> [root@rak ~]# dmesg | tail
>>>> >> [snip]
>>>> >>> [ 4108.444472] BTRFS critical (device sdb2): corrupt leaf, bad key
>>>> >>> order: block=3242455040,root=1, slot=0
>>>> >>
>>>> >>    You have bad RAM. You should run memtest and fix the hardware first.
>>>> >>
>>>> >>    After that, there's some patches that should allow btrfs repair to
>>>> >> fix bad key orders in most situations -- I think David was picking
>>>> >> them up again, but I don't know what state they're in right now.
>>>> >>
>>>> >>    Hugo.
>>>> >>
>>>> >>> [ 4108.444649] BTRFS critical (device sdb2): corrupt leaf, bad key
>>>> >>> order: block=3242455040,root=1, slot=0
>>>> >>> [ 4108.444681] BTRFS error (device sdb2): Error removing orphan entry,
>>>> >>> stopping orphan cleanup
>>>> >>> [ 4108.444684] BTRFS error (device sdb2): could not do orphan cleanup -22
>>>> >>> [ 4111.047323] BTRFS: open_ctree failed
>>>> >>>
>>>> >>> [root@rak ~]# uname -a
>>>> >>> Linux rak 4.1.2-2-ARCH #1 SMP PREEMPT Wed Jul 15 08:30:32 UTC 2015
>>>> >>> x86_64 GNU/Linux
>>>> >>>
>>>> >>> [root@rak ~]# btrfs fi show /dev/sdb2
>>>> >>> Label: 'data'  uuid: 754a3186-c0ae-4680-ab28-864c8bdad8b5
>>>> >>>         Total devices 1 FS bytes used 1.23TiB
>>>> >>>         devid    1 size 1.72TiB used 1.24TiB path /dev/sdb2
>>>> >>>
>>>> >>> btrfs-progs v4.2
>>>> >>>
>>>> >>> [root@rak ~]# btrfs --version
>>>> >>> btrfs-progs v4.2
>>>> >>>
>>>> >>> [root@rak ~]#   btrfs fi show
>>>> >>> Label: 'data'  uuid: 754a3186-c0ae-4680-ab28-864c8bdad8b5
>>>> >>>         Total devices 1 FS bytes used 1.23TiB
>>>> >>>         devid    1 size 1.72TiB used 1.24TiB path /dev/sdb2
>>>> >>>
>>>> >>> btrfs-progs v4.2
>>>> >>
>>>
>>> --
>>> Hugo Mills             | Do not meddle in the affairs of wizards, for they
>>> hugo@... carfax.org.uk | are subtle, and quick to anger.
>>> http://carfax.org.uk/  |
>>> PGP: E2AB1DE4          |                                        J.R.R. Tolkein
