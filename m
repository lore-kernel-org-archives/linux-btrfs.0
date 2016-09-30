Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:38907 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750873AbcI3Xqx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Sep 2016 19:46:53 -0400
Received: by mail-wm0-f41.google.com with SMTP id p138so51234418wmb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Sep 2016 16:46:52 -0700 (PDT)
Subject: Re: multi-device btrfs with single data mode and disk failure
To: Chris Murphy <lists@colorremedies.com>
References: <1634818f-ff1d-722c-6d73-747ed7203a13@gmail.com>
 <ecac8c64-8ed4-7c8d-29ad-5b3687981a33@gmail.com>
 <CAJCQCtSupa8LT+RK3=w3t7+T_nDcgUzzjSdfEi16DpiQxbm0hQ@mail.gmail.com>
 <760be1b7-79b2-a25d-7c60-04ceac1b6e40@gmail.com>
 <CAJCQCtR2t+3w6ovo88L0_2GqnVWveK5DNJ-vWdw18y+Sng4chQ@mail.gmail.com>
 <3460a1ac-7e66-cf6f-b229-06a0825401a5@gmail.com>
 <b880821f-bfb5-5265-53a4-213b22487ddb@gmail.com>
 <CAJCQCtRYpvnGurLSbxu2N0ELuvVKrM5w=jBkAneecaEog213dQ@mail.gmail.com>
 <64102181-e02d-69a8-ead7-a27acadbe6a8@gmail.com>
 <CAJCQCtQT=j+P=Dy=VtNOBGkpwenK0AngB2k5xk40BE=hZnEfjA@mail.gmail.com>
 <df35fe50-8195-b2b9-e6d9-687b0c883a28@gmail.com>
 <CAJCQCtTNiJ=E--v5gb5reyzTBqVeZx70-gUfj67EN+BjmcOTmw@mail.gmail.com>
 <4e7ec5eb-7fb6-2d19-f29d-82461e2d0bd2@gmail.com>
 <CAJCQCtQ=sjj9jWHQ+9Xm1FSmVtMVgNbqGC6Mc7r6ZuBZpJ8U1g@mail.gmail.com>
 <0b29471c-363a-1e2f-d352-1d422c07df64@gmail.com>
 <CAJCQCtQrKVsBTU=B+5qMbvCdzTZfaY_z3uqU_LHumisQ4Ex5kg@mail.gmail.com>
 <e3955660-bf6b-096c-5249-bbe67be255bd@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Alexandre Poux <pums974@gmail.com>
Message-ID: <0a5e6528-f929-729b-a608-a46dc6f8a6a3@gmail.com>
Date: Sat, 1 Oct 2016 01:46:49 +0200
MIME-Version: 1.0
In-Reply-To: <e3955660-bf6b-096c-5249-bbe67be255bd@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello again,

Just a quick question.

I did a full scrub and got no error at all

And a full check that gave me this :

#> btrfs check --check-data-csum -p /dev/sde6

Checking filesystem on /dev/sde6
UUID: 62db560b-a040-4c64-b613-6e7db033dc4d
checking extents [o]
checking free space cache [o]
checking fs roots [.]
checking csums
checking root refs
checking quota groups
Counts for qgroup id: 0/5 are different
our:        referenced 7239132803072 referenced compressed 7239132803072
disk:        referenced 7238982733824 referenced compressed 7238982733824
diff:        referenced 150069248 referenced compressed 150069248
our:        exclusive 7239132803072 exclusive compressed 7239132803072
disk:        exclusive 7238982733824 exclusive compressed 7238982733824
diff:        exclusive 150069248 exclusive compressed 150069248
found 7323422314496 bytes used err is 0
total csum bytes: 7020314688
total tree bytes: 11797741568
total fs tree bytes: 2904932352
total extent tree bytes: 656654336
btree space waste bytes: 1560529439
file data blocks allocated: 297363385454592
 referenced 6628544720896

I'm guessing that's not important, but I found nothing about this
so I don't really know what's about.

Can just confirm that everything seems OK ?

Do you think of an another test I should do before starting to use my
array again ?

Le 29/09/2016 à 14:55, Alexandre Poux a écrit :
> Hi,
>
> I finally did it : patched the kernel and removed the device.
> As expected he did not scream since there was nothing at all on the device.
> Now I'm checking that everything is fine:
> scrub (in read only)
> check (in read only)
> but I think that everything will be OK
> If not, I will rebuild the array from scratch (I did managed to save my
> data)
>
> Thank you both for your guidance.
> I think that a warning should be put in the wiki in order for other user
> to not do the same mistake I did :
> never ever use the single mode
>
> I will try to do it soon
>
> Again thank you
>
> Le 20/09/2016 à 23:15, Chris Murphy a écrit :
>> On Tue, Sep 20, 2016 at 2:18 PM, Alexandre Poux <pums974@gmail.com> wrote:
>>> Le 20/09/2016 à 21:46, Chris Murphy a écrit :
>>>> On Tue, Sep 20, 2016 at 1:31 PM, Alexandre Poux <pums974@gmail.com> wrote:
>>>>> Le 20/09/2016 à 21:11, Chris Murphy a écrit :
>>>>>> And no backup? Umm, I'd resolve that sooner than anything else.
>>>>> Yeah you are absolutely right, this was a temporary solution which came
>>>>> to be not that temporary.
>>>>> And I regret it already...
>>>> Well on the bright side, if this were LVM or mdadm linear/concat
>>>> array, the whole thing would be toast because any other file system
>>>> would have lost too much fs metadata on the missing device.
>>>>
>>>>>>  It
>>>>>> should be true that it'll tolerate a read only mount indefinitely, but
>>>>>> read write? Not sure. This sort of edge case isn't well tested at all
>>>>>> seeing as it required changing the kernel to reduce safe guards. So
>>>>>> all bets are off the whole thing could become unmountable, not even
>>>>>> read only, and then it's a scraping job.
>>>>> I'm not that crazy, I tried the patch inside a virtual machine on
>>>>> virtual drives...
>>>>> And since it's only virtual, it may not work on the real partition...
>>>> Are you sure the virtual setup lacked a CHUNK_ITEM on the missing
>>>> device? That might be what pinned it in that case.
>>> In fact in my virtual setup there was more chunk missing (1 metadata 1
>>> System and 1 Data).
>>> I will try to do a setup closer to my real one.
>> Probably the reason why that missing device has no used chunks is
>> because it's so small. Btrfs allocates block groups to devices with
>> the most unallocated space first. Only once the unallocated space is
>> even (approximately) on all devices would it allocate a block group to
>> the small device.
>>
>>
>

