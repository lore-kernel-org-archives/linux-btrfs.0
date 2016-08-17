Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31784 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752152AbcHQA4p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Aug 2016 20:56:45 -0400
Subject: Re: btrfs quota issues
To: Rakesh Sankeshi <rakesh.sankeshi@gmail.com>
References: <CAGj_d3D2OZt2nY622rp9NzxgAfKZ2iN1kLSQ2Ras-0fM+1+-ig@mail.gmail.com>
 <fe8222d8-6463-8b4d-0613-b3639455463d@cn.fujitsu.com>
 <CAGj_d3C1nf3LGCXfWxoYNpWP2X81v-+eT22yBx17HgfMaP7ocg@mail.gmail.com>
 <4a941169-1845-ba0e-6102-39920e1364b9@cn.fujitsu.com>
 <CAGj_d3C4=M7ZTvDhn+twROnf1qO4u-UXBmbP8HVQgfGiD91W6w@mail.gmail.com>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <f150f0b6-ed88-5e3a-240f-d92a629f381e@cn.fujitsu.com>
Date: Wed, 17 Aug 2016 08:56:40 +0800
MIME-Version: 1.0
In-Reply-To: <CAGj_d3C4=M7ZTvDhn+twROnf1qO4u-UXBmbP8HVQgfGiD91W6w@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 08/17/2016 12:05 AM, Rakesh Sankeshi wrote:
> 2) after EDQUOT, can't write anymore.
>
> I can delete the data, but still can't write further

So it's a underflow now.

>
> 3) tested it without compression and also with LZO and ZLIB.. all
> behave same way with qgroup. no consistency on when it hits the quota
> limit and don't understand on how it's calculating the numbers.

Even without compression?!

That's a really big problem then.
Workload please, it's an urgent bug now.

It's better to provide the scripts to reproduce it.



And for the meaning of the numbers, for rfer(reference) it means the 
size of all extents the subvolume has referred to, including both data 
and metadata.

For excl(exclusive), it means the size of all extents that only belongs 
to the subvolume.

And since it's all about size of extents(on-disk), for compression case, 
it's the size after compression.

Also, if one subvolume only referred to part of an extent, the whole 
extent size will be accounted.


Last but not least.
Considering there is quite a lot of report about hitting ENOSPC while 
there is still a lot of unallocated space,
is it reporting error message like "No space left on device" (ENOSPC) or 
"Quota exceeded"(EDQUOT)?

Thanks,
Qu

>
> In case of ext4 and xfs, I can see visually that it's hitting the quota limit.
>
>
>
> On Mon, Aug 15, 2016 at 6:01 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>
>>
>> At 08/16/2016 03:11 AM, Rakesh Sankeshi wrote:
>>>
>>> yes, subvol level.
>>>
>>> qgroupid         rfer         excl     max_rfer     max_excl parent  child
>>>
>>> --------         ----         ----     --------     -------- ------  -----
>>>
>>> 0/5          16.00KiB     16.00KiB         none         none ---     ---
>>>
>>> 0/258       119.48GiB    119.48GiB    200.00GiB         none ---     ---
>>>
>>> 0/259        92.57GiB     92.57GiB    200.00GiB         none ---     ---
>>>
>>>
>>> although I have 200GB limit on 2 subvols, running into issue at about
>>> 120 and 92GB itself
>>
>>
>> 1) About workload
>> Would you mind to mention the work pattern of your write?
>>
>> Just dd data with LZO compression?
>> For compression part, it's a little complicated, as the reserved data size
>> and on disk extent size are different.
>>
>> It's possible that at some code we leaked some reserved data space.
>>
>>
>> 2) Behavior after EDQUOT
>> And, after EDQUOT happens, can you write data into the subvolume?
>> If you can still write a lot of data (at least several giga), it seems to be
>> something related with temporary reserved space.
>>
>> If not, and even can't remove any file due to EQUOTA, then it's almost sure
>> we have underflowed the reserved data.
>> In that case, unmount and mount again will be the only workaround.
>> (In fact, not workaround at all)
>>
>> 3) Behavior without compression
>>
>> If it's OK for you, would you mind to test it without compression?
>> Currently we mostly use the assumption that on-disk extent size are the same
>> with in-memory extent size (non-compression).
>>
>> So qgroup + compression is not the main concern before and is buggy.
>>
>> If without compression, qgroup works sanely, at least we can be sure that
>> the cause is qgroup + compression.
>>
>> Thanks,
>> Qu
>>
>>
>>>
>>>
>>> On Sun, Aug 14, 2016 at 7:11 PM, Qu Wenruo <quwenruo@cn.fujitsu.com>
>>> wrote:
>>>>
>>>>
>>>>
>>>> At 08/12/2016 01:32 AM, Rakesh Sankeshi wrote:
>>>>>
>>>>>
>>>>> I set 200GB limit to one user and 100GB to another user.
>>>>>
>>>>> as soon as I reached 139GB and 53GB each, hitting the quota errors.
>>>>> anyway to workaround quota functionality on btrfs LZO compressed
>>>>> filesystem?
>>>>>
>>>>
>>>> Please paste "btrfs qgroup show -prce <mnt>" output if you are using
>>>> btrfs
>>>> qgroup/quota function.
>>>>
>>>> And, AFAIK btrfs qgroup is applied to subvolume, not user.
>>>>
>>>> So did you mean limit it to one subvolume belongs to one user?
>>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>>
>>>>>
>>>>> 4.7.0-040700-generic #201608021801 SMP
>>>>>
>>>>> btrfs-progs v4.7
>>>>>
>>>>>
>>>>> Label: none  uuid: 66a78faf-2052-4864-8a52-c5aec7a56ab8
>>>>>
>>>>> Total devices 2 FS bytes used 150.62GiB
>>>>>
>>>>> devid    1 size 1.00TiB used 78.01GiB path /dev/xvdc
>>>>>
>>>>> devid    2 size 1.00TiB used 78.01GiB path /dev/xvde
>>>>>
>>>>>
>>>>> Data, RAID0: total=150.00GiB, used=149.12GiB
>>>>>
>>>>> System, RAID1: total=8.00MiB, used=16.00KiB
>>>>>
>>>>> Metadata, RAID1: total=3.00GiB, used=1.49GiB
>>>>>
>>>>> GlobalReserve, single: total=512.00MiB, used=0.00B
>>>>>
>>>>>
>>>>> Filesystem      Size  Used Avail Use% Mounted on
>>>>>
>>>>> /dev/xvdc       2.0T  153G  1.9T   8% /test_lzo
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
>>>>> in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>
>>>>>
>>>>
>>>>
>>>
>>>
>>
>>
>
>


