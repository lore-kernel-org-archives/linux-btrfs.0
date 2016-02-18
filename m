Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:34625 "EHLO
	mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946330AbcBRX1L (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Feb 2016 18:27:11 -0500
Received: by mail-lf0-f48.google.com with SMTP id j78so43115699lfb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Feb 2016 15:27:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56C52685.8090505@cn.fujitsu.com>
References: <CABmr4wVBb0CCEoU_N2jxYvC=gVn9vUKWfb0902yZDuP2N3ck3w@mail.gmail.com>
	<56C40C06.8090900@cn.fujitsu.com>
	<CABmr4wVvjB7vGDsZWyCd222E1D-+kmk2SS2XwH2dp+K6YWWe=A@mail.gmail.com>
	<56C52685.8090505@cn.fujitsu.com>
Date: Fri, 19 Feb 2016 00:27:09 +0100
Message-ID: <CAPmG0jbi=TB=0+3mHmxW0+7s+mA79YExiSKoQGs1W-DdU1fKbA@mail.gmail.com>
Subject: Re: RAID 6 full, but there is still space left on some devices
From: Henk Slager <eye1tm@gmail.com>
To: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 18, 2016 at 3:03 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>
> Dan Blazejewski wrote on 2016/02/17 18:04 -0500:
>>
>> Hello,
>>
>> I upgraded my kernel to 4.4.2, and btrfs-progs to 4.4. I also added
>> another 4TB disk and kicked off a full balance (currently 7x4TB
>> RAID6). I'm interested to see what an additional drive will do to
>> this. I'll also have to wait and see if a full system balance on a
>> newer version of BTRFS tools does the trick or not.
>>
>> I also noticed that "btrfs device usage" shows multiple entries for
>> Data, RAID 6 on some drives. Is this normal? Please note that /dev/sdh
>> is the new disk, and I only just started the balance.
>>
>> # btrfs dev usage /mnt/data
>> /dev/sda, ID: 5
>>     Device size:             3.64TiB
>>     Data,RAID6:              1.43TiB
>>     Data,RAID6:              1.48TiB
>>     Data,RAID6:            320.00KiB
>>     Metadata,RAID6:          2.55GiB
>>     Metadata,RAID6:          1.50GiB
>>     System,RAID6:           16.00MiB
>>     Unallocated:           733.67GiB
>>
>> /dev/sdb, ID: 6
>>     Device size:             3.64TiB
>>     Data,RAID6:              1.48TiB
>>     Data,RAID6:            320.00KiB
>>     Metadata,RAID6:          1.50GiB
>>     System,RAID6:           16.00MiB
>>     Unallocated:             2.15TiB
>>
>> /dev/sdc, ID: 7
>>     Device size:             3.64TiB
>>     Data,RAID6:              1.43TiB
>>     Data,RAID6:            732.69GiB
>>     Data,RAID6:              1.48TiB
>>     Data,RAID6:            320.00KiB
>>     Metadata,RAID6:          2.55GiB
>>     Metadata,RAID6:        982.00MiB
>>     Metadata,RAID6:          1.50GiB
>>     System,RAID6:           16.00MiB
>>     Unallocated:            25.21MiB
>>
>> /dev/sdd, ID: 1
>>     Device size:             3.64TiB
>>     Data,RAID6:              1.43TiB
>>     Data,RAID6:            732.69GiB
>>     Data,RAID6:              1.48TiB
>>     Data,RAID6:            320.00KiB
>>     Metadata,RAID6:          2.55GiB
>>     Metadata,RAID6:        982.00MiB
>>     Metadata,RAID6:          1.50GiB
>>     System,RAID6:           16.00MiB
>>     Unallocated:            25.21MiB
>>
>> /dev/sdf, ID: 3
>>     Device size:             3.64TiB
>>     Data,RAID6:              1.43TiB
>>     Data,RAID6:            732.69GiB
>>     Data,RAID6:              1.48TiB
>>     Data,RAID6:            320.00KiB
>>     Metadata,RAID6:          2.55GiB
>>     Metadata,RAID6:        982.00MiB
>>     Metadata,RAID6:          1.50GiB
>>     System,RAID6:           16.00MiB
>>     Unallocated:            25.21MiB
>>
>> /dev/sdg, ID: 2
>>     Device size:             3.64TiB
>>     Data,RAID6:              1.43TiB
>>     Data,RAID6:            732.69GiB
>>     Data,RAID6:              1.48TiB
>>     Data,RAID6:            320.00KiB
>>     Metadata,RAID6:          2.55GiB
>>     Metadata,RAID6:        982.00MiB
>>     Metadata,RAID6:          1.50GiB
>>     System,RAID6:           16.00MiB
>>     Unallocated:            25.21MiB
>>
>> /dev/sdh, ID: 8
>>     Device size:             3.64TiB
>>     Data,RAID6:            320.00KiB
>>     Unallocated:             3.64TiB
>>
>
> Not sure how that multiple chunk type shows up.
> Maybe all these shown RAID6 has different number of stripes?

Indeed, its 4 different sets of stripe-widths, i.e. how many drives is
striped accross. Someone has suggested to indicate this in the output
of    btrfs de us  comand some time ago.

The fs has only RAID6 profile and I am not fully sure if the
'Unallocated'  numbers are correct (on RAID10 they are 2x too high
with unpatched v4.4 progs), but anyhow the lower devid's are way too
full.

>From the size, one can derive how many devices (or stipe-width):
732.69GiB 4, 1.43TiB 5, 1.48TiB 6, 320.00KiB 7

>> Qu, in regards to your question, I ran RAID 1 on multiple disks of
>> different sizes. I believe I had a mix of 2x4TB, 1x2TB, and 1x3TB
>> drive. I replaced the 2TB drive first with a 4TB, and balanced it.
>> Later on, I replaced the 3TB drive with another 4TB, and balanced,
>> yielding an array of 4x4TB RAID1. A little while later, I wound up
>> sticking a fifth 4TB drive in, and converting to RAID6. The sixth 4TB
>> drive was added some time after that. The seventh was added just a few
>> minutes ago.
>
>
> Personally speaking, I just came up to one method to balance all these
> disks, and in fact you don't need to add a disk.
>
> 1) Balance all data chunk to single profile
> 2) Balance all metadata chunk to single or RAID1 profile
> 3) Balance all data chunk back to RAID6 profile
> 4) Balance all metadata chunk back to RAID6 profile
> System chunk is so small that normally you don't need to bother.
>
> The trick is, as single is the most flex chunk type, only needs one disk
> with unallocated space.
> And btrfs chunk allocater will allocate chunk to device with most
> unallocated space.
>
> So after 1) and 2) you should found that chunk allocation is almost
> perfectly balanced across all devices, as long as they are in same size.
>
> Now you have a balance base layout for RAID6 allocation. Should make things
> go quite smooth and result a balanced RAID6 chunk layout.

This is a good trick to get out of 'the RAID6 full' situation. I have
done some RAID5 tests on 100G VM disks with kernel/tools 4.5-rcX/v4.4,
and various balancing starts, cancels, profile converts etc, worked
surprisingly well, compared to my experience a year back with RAID5
(hitting bugs, crashes).

A RAID6 full balance with this setup might be very slow, even if the
fs would be not so full. The VMs I use are on a mixed SSD/HDD
(bcache'd) array so balancing within the last GB(s), so almost no
workspace, still makes progress. But on HDD only, things can take very
long. The 'Unallocated' space on devid 1 should be at least a few GiB,
otherwise rebalancing will be very slow or just not work.

The way from RAID6 -> single/RAID1 -> RAID6 might also be more
acceptable w.r.t. speed in total. Just watch progress I would say.
Maybe its not needed to do a full convert, just make sure you will
have enough workspace before starting a convert from single/RAID1 to
RAID6 again.

With v4.4 tools, you can do filtered balance based on stripe-width, so
it avoids complete balance again of block groups that are already
allocated across the right amount of devices.

In this case, avoiding the re-balance of the '320.00KiB group' (in the
means time could be much larger) you could do this:
btrfs balance start -v -dstripes=1..6 /mnt/data
