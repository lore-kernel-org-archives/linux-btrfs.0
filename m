Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:38755 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753571AbcI2MzX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Sep 2016 08:55:23 -0400
Received: by mail-wm0-f44.google.com with SMTP id w72so25515693wmf.1
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Sep 2016 05:55:23 -0700 (PDT)
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
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Alexandre Poux <pums974@gmail.com>
Message-ID: <e3955660-bf6b-096c-5249-bbe67be255bd@gmail.com>
Date: Thu, 29 Sep 2016 14:55:17 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQrKVsBTU=B+5qMbvCdzTZfaY_z3uqU_LHumisQ4Ex5kg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I finally did it : patched the kernel and removed the device.
As expected he did not scream since there was nothing at all on the device.
Now I'm checking that everything is fine:
scrub (in read only)
check (in read only)
but I think that everything will be OK
If not, I will rebuild the array from scratch (I did managed to save my
data)

Thank you both for your guidance.
I think that a warning should be put in the wiki in order for other user
to not do the same mistake I did :
never ever use the single mode

I will try to do it soon

Again thank you

Le 20/09/2016 à 23:15, Chris Murphy a écrit :
> On Tue, Sep 20, 2016 at 2:18 PM, Alexandre Poux <pums974@gmail.com> wrote:
>>
>> Le 20/09/2016 à 21:46, Chris Murphy a écrit :
>>> On Tue, Sep 20, 2016 at 1:31 PM, Alexandre Poux <pums974@gmail.com> wrote:
>>>> Le 20/09/2016 à 21:11, Chris Murphy a écrit :
>>>>> And no backup? Umm, I'd resolve that sooner than anything else.
>>>> Yeah you are absolutely right, this was a temporary solution which came
>>>> to be not that temporary.
>>>> And I regret it already...
>>> Well on the bright side, if this were LVM or mdadm linear/concat
>>> array, the whole thing would be toast because any other file system
>>> would have lost too much fs metadata on the missing device.
>>>
>>>>>  It
>>>>> should be true that it'll tolerate a read only mount indefinitely, but
>>>>> read write? Not sure. This sort of edge case isn't well tested at all
>>>>> seeing as it required changing the kernel to reduce safe guards. So
>>>>> all bets are off the whole thing could become unmountable, not even
>>>>> read only, and then it's a scraping job.
>>>> I'm not that crazy, I tried the patch inside a virtual machine on
>>>> virtual drives...
>>>> And since it's only virtual, it may not work on the real partition...
>>> Are you sure the virtual setup lacked a CHUNK_ITEM on the missing
>>> device? That might be what pinned it in that case.
>> In fact in my virtual setup there was more chunk missing (1 metadata 1
>> System and 1 Data).
>> I will try to do a setup closer to my real one.
> Probably the reason why that missing device has no used chunks is
> because it's so small. Btrfs allocates block groups to devices with
> the most unallocated space first. Only once the unallocated space is
> even (approximately) on all devices would it allocate a block group to
> the small device.
>
>


