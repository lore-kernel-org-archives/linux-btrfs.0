From: "Sebastian 'gonX' Jensen" <gonx@overclocked.net>
Subject: Re: Raid0 with btrfs
Date: Fri, 6 Aug 2010 20:32:37 +0200
Message-ID: <AANLkTimAvZZdz0LnxM2H+2B4t1L4VDUi43NmsZpZQONm@mail.gmail.com>
References: <AANLkTimS=bgDsbk9jdcPqW-88eQnq+qss1m2mZBfAif2@mail.gmail.com>
	<201008051640.51662.hka@qbs.com.pl>
	<AANLkTin=eOpEXLyhwT_thgU=dnWKVL2FLOQfqs8RR4p0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Hubert Kario <hka@qbs.com.pl>, linux-btrfs@vger.kernel.org
To: Leonidas Spyropoulos <artafinde@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTin=eOpEXLyhwT_thgU=dnWKVL2FLOQfqs8RR4p0@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 6 August 2010 20:23, Leonidas Spyropoulos <artafinde@gmail.com> wrot=
e:
> Do I have to change the partition ID flag of each partition?
> Currently is set to fd (Linux Raid autodetect) for used from mdadm
> mkfs.btrfs supports that or needs to be 83 (Linux) ?

=46D is for mdraid integrated into the Linux kernel. I have mine at 83.
It won't hurt to have them at FD, but the kernel will spend extra time
as it probes the devices on boot, causing a slight slowdown.
>
> On Thu, Aug 5, 2010 at 3:40 PM, Hubert Kario <hka@qbs.com.pl> wrote:
>> On Thursday 05 August 2010 16:15:22 Leonidas Spyropoulos wrote:
>>> Hi all,
>>>
>>> I want to make a btrfs raid0 on 2 partitions of my pc.
>>> Until now I am using the mdadm tools to make a software raid of the=
 2
>>> partitions /dev/sde2, /dev/sdd2
>>> and then mkfs.etx4 the newly created /dev/md0 device.
>>> From performance point of view is it better to keep the configurati=
on of
>>> mdadm and just format the /dev/md0 device as btrfs OR
>>> delete the raid device and format the 2 partitions /dev/sde2 /dev/s=
dd2
>>> as a btrfs with 2 devices?
>>> mkfs.btrfs /dev/sde2 /dev/sdd2
>>
>> Btrfs already supports metadata mirroring when the data is striped. =
What this
>> means, is while the performance should be more-or-less identical to =
MD RAID0
>> (if it isn't it's a bug), your data is a bit more secure as the meta=
data
>> describing it resides on both drives. Later on it will be possible t=
o selct
>> which directories/files should have what level of redundancy. This w=
ill allow
>> to have ~/work RAID1-ed and ~/videos RAID0-ed while keeping both dir=
ectories
>> on the same partition and filesystem.
>>
>>> On a sidenote:
>>> If I decide to go for raid5 which is not supported currently from m=
kfs
>>> I have to use the mdadm tool anyway, right?
>>
>> yes, RAID5 code is not in trunk yet.
>>
>> --
>> Hubert Kario
>> QBS - Quality Business Software
>> 02-656 Warszawa, ul. Ksawer=C3=B3w 30/85
>> tel. +48 (22) 646-61-51, 646-74-24
>> www.qbs.com.pl
>>
>
>
>
> --
> Caution: breathing may be hazardous to your health.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

Regards,
Sebastian J.

PS. Please try to bottom-post rather than top-post. Here's a link I
can advise reading for a clarification on why bottom posting is
essential: http://www.caliburn.nl/topposting.html
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
