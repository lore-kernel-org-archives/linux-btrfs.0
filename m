Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:35392 "EHLO
	mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbcHOTL3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Aug 2016 15:11:29 -0400
Received: by mail-qk0-f172.google.com with SMTP id v123so51081230qkh.2
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Aug 2016 12:11:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <fe8222d8-6463-8b4d-0613-b3639455463d@cn.fujitsu.com>
References: <CAGj_d3D2OZt2nY622rp9NzxgAfKZ2iN1kLSQ2Ras-0fM+1+-ig@mail.gmail.com>
 <fe8222d8-6463-8b4d-0613-b3639455463d@cn.fujitsu.com>
From: Rakesh Sankeshi <rakesh.sankeshi@gmail.com>
Date: Mon, 15 Aug 2016 12:11:28 -0700
Message-ID: <CAGj_d3C1nf3LGCXfWxoYNpWP2X81v-+eT22yBx17HgfMaP7ocg@mail.gmail.com>
Subject: Re: btrfs quota issues
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

yes, subvol level.

qgroupid         rfer         excl     max_rfer     max_excl parent  child

--------         ----         ----     --------     -------- ------  -----

0/5          16.00KiB     16.00KiB         none         none ---     ---

0/258       119.48GiB    119.48GiB    200.00GiB         none ---     ---

0/259        92.57GiB     92.57GiB    200.00GiB         none ---     ---


although I have 200GB limit on 2 subvols, running into issue at about
120 and 92GB itself


On Sun, Aug 14, 2016 at 7:11 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>
> At 08/12/2016 01:32 AM, Rakesh Sankeshi wrote:
>>
>> I set 200GB limit to one user and 100GB to another user.
>>
>> as soon as I reached 139GB and 53GB each, hitting the quota errors.
>> anyway to workaround quota functionality on btrfs LZO compressed
>> filesystem?
>>
>
> Please paste "btrfs qgroup show -prce <mnt>" output if you are using btrfs
> qgroup/quota function.
>
> And, AFAIK btrfs qgroup is applied to subvolume, not user.
>
> So did you mean limit it to one subvolume belongs to one user?
>
> Thanks,
> Qu
>
>>
>>
>> 4.7.0-040700-generic #201608021801 SMP
>>
>> btrfs-progs v4.7
>>
>>
>> Label: none  uuid: 66a78faf-2052-4864-8a52-c5aec7a56ab8
>>
>> Total devices 2 FS bytes used 150.62GiB
>>
>> devid    1 size 1.00TiB used 78.01GiB path /dev/xvdc
>>
>> devid    2 size 1.00TiB used 78.01GiB path /dev/xvde
>>
>>
>> Data, RAID0: total=150.00GiB, used=149.12GiB
>>
>> System, RAID1: total=8.00MiB, used=16.00KiB
>>
>> Metadata, RAID1: total=3.00GiB, used=1.49GiB
>>
>> GlobalReserve, single: total=512.00MiB, used=0.00B
>>
>>
>> Filesystem      Size  Used Avail Use% Mounted on
>>
>> /dev/xvdc       2.0T  153G  1.9T   8% /test_lzo
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>
>
