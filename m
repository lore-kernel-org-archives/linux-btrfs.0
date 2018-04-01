Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f180.google.com ([74.125.82.180]:45868 "EHLO
        mail-ot0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752949AbeDAD2s (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 31 Mar 2018 23:28:48 -0400
Received: by mail-ot0-f180.google.com with SMTP id h26-v6so12818894otj.12
        for <linux-btrfs@vger.kernel.org>; Sat, 31 Mar 2018 20:28:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a95813ad-d87e-bd5a-a258-c3d241fa5181@gmx.com>
References: <CAJCQCtRpWuPLsmGLmNcon45YzfewRFPHxjhCJY=mVZ_Od7jxxQ@mail.gmail.com>
 <d784d9a6-bc0e-e4c3-6633-043081ea800b@gmx.com> <CAJCQCtSZmRmeFUGPSiRLV4TCOjbD6uTqpoEqKD24Li8w1iO7qQ@mail.gmail.com>
 <0f6c7514-1cf2-1d88-1307-c43f7642b525@gmx.com> <CAJCQCtSH-w4Pt9kmGhuYZUX_FdktFEpV4WyKnxw5GaDKfVmdng@mail.gmail.com>
 <d8973b92-b320-5088-aae6-2b3835f1b2ca@gmx.com> <CAJCQCtSjBWMauccwremxQ+eCTTBXsz=VEXFy=ckABpKtC-9NTw@mail.gmail.com>
 <af39cb86-693c-2f3b-7831-60968d3b5c3d@gmx.com> <CAJCQCtS6tXcKRuwZiAfB8eUkENz6secVcvxYS=syCFp_VH_+Vw@mail.gmail.com>
 <56401bb3-39fb-66d9-f77b-30e164bd8973@gmx.com> <CAJCQCtQiTt78svzzdcV_Pm2iPK6RgYLXsvMda7H6aQeMf2w07g@mail.gmail.com>
 <4b7a0fae-ca96-7583-90d0-37cabc78849b@gmx.com> <CAJCQCtSezvyBGBQJRwQ+aeJH+8_8QsihkFD-iZaEVFeoL-00+Q@mail.gmail.com>
 <a95813ad-d87e-bd5a-a258-c3d241fa5181@gmx.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 31 Mar 2018 21:28:46 -0600
Message-ID: <CAJCQCtSAfYxZigvrgAq=vw3anMKiPK=ZWnOvC+mbR__XUW8ugA@mail.gmail.com>
Subject: Re: bug? fstrim only trims unallocated space, not unused in bg's
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 20, 2017 at 11:10 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 2017年11月21日 13:58, Chris Murphy wrote:
>> On Mon, Nov 20, 2017 at 9:58 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>>
>>>
>>> On 2017年11月21日 12:49, Chris Murphy wrote:
>>>> On Mon, Nov 20, 2017 at 9:43 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>>>>
>>>>>
>>>>>>
>>>>>> Apply in addition to previous patch? Or apply to clean v4.14?
>>>>>
>>>>> On previous patch.
>>>>
>>>> Refuses to apply with or without previous patch.
>>>>
>>>> $ git apply -v ~/qufstrim3.patch
>>>> Checking patch fs/btrfs/extent-tree.c...
>>>> error: while searching for:
>>>>        int dev_ret = 0;
>>>>        int ret = 0;
>>>>
>>>>        /*
>>>>         * try to trim all FS space, our block group may start from non-zero.
>>>>         */
>>>>
>>>> error: patch failed: fs/btrfs/extent-tree.c:10972
>>>> error: fs/btrfs/extent-tree.c: patch does not apply
>>>>
>>>
>>> Please try this branch.
>>>
>>> It's just previous patch and diff merged together and applied on v4.14
>>> tag from torvalds.
>>>
>>> https://github.com/adam900710/linux/tree/tmp
>>
>> # fstrim -v /
>> /: 38 GiB (40767586304 bytes) trimmed
>> # dmesg
>>
>> ..snip...
>> [   46.408792] BTRFS info (device nvme0n1p8): trimming btrfs, start=0
>> len=75161927680 minlen=512
>> [   46.408800] BTRFS info (device nvme0n1p8): bg start=140882477056
>> len=1073741824
>> [   46.433867] BTRFS info (device nvme0n1p8): trimming done
>
> Great (for the output, not for the trimming failure).
>
> And the problem is very obvious now.
> 140882477056 << First chunk start
> 75161927680  << length of fstrim_range passed in
>
> Obviously, fstrim_range passed in is using the filesystem size it
> assumes to be.
>
> While we stupidly use the range in fstrim_range without considering the
> fact that, we're dealing with *btrfs logical address space*.
> Where our chunk can start from any bytenr (well, at least aligned with
> sectorsize).
> When I read the code I also think the range check has nothing wrong at all.
>
> So the truth here is, we should not ever try to check the range from
> fstrim_range.
>
> And the problem means that, a normal btrfs with some usage and after
> several full balance, fstrim will only trim the unallocated space for btrfs.
>
> Now the fix should not be a hard to craft.
>
> Great thanks for all your help to locate the problem.

I still see this problem in 4.16.0-0.rc7.git1.1.fc29.x86_64. Are there
any patches to test?

[chris@f27h mnt]$ sudo btrfs fi us /
Overall:
    Device size:          70.00GiB
    Device allocated:          60.06GiB
    Device unallocated:           9.94GiB
    Device missing:             0.00B
    Used:              36.89GiB
    Free (estimated):          29.75GiB    (min: 24.78GiB)
    Data ratio:                  1.00
    Metadata ratio:              1.00
    Global reserve:         107.77MiB    (used: 12.38MiB)

Data,single: Size:55.00GiB, Used:35.19GiB
   /dev/nvme0n1p9      55.00GiB

Metadata,single: Size:5.00GiB, Used:1.70GiB
   /dev/nvme0n1p9       5.00GiB

System,DUP: Size:32.00MiB, Used:16.00KiB
   /dev/nvme0n1p9      64.00MiB

Unallocated:
   /dev/nvme0n1p9       9.94GiB
[chris@f27h mnt]$ sudo fstrim -v /
[sudo] password for chris:
/: 10 GiB (10669260800 bytes) trimmed




-- 
Chris Murphy
