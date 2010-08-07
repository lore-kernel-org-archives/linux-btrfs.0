From: "Sebastian 'gonX' Jensen" <gonx@overclocked.net>
Subject: Re: Raid0 with btrfs
Date: Sat, 7 Aug 2010 02:03:01 +0200
Message-ID: <AANLkTinBTJV77qDmVAJQ6a2qqT3TS9N7J-rR6UMVvG+R@mail.gmail.com>
References: <AANLkTimS=bgDsbk9jdcPqW-88eQnq+qss1m2mZBfAif2@mail.gmail.com>
	<201008051640.51662.hka@qbs.com.pl>
	<AANLkTin=eOpEXLyhwT_thgU=dnWKVL2FLOQfqs8RR4p0@mail.gmail.com>
	<AANLkTimAvZZdz0LnxM2H+2B4t1L4VDUi43NmsZpZQONm@mail.gmail.com>
	<AANLkTimOin7isn9Gyi42x4evVnY6KW1H_ycAWUid-JKG@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Hubert Kario <hka@qbs.com.pl>, linux-btrfs@vger.kernel.org
To: Leonidas Spyropoulos <artafinde@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimOin7isn9Gyi42x4evVnY6KW1H_ycAWUid-JKG@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 7 August 2010 00:24, Leonidas Spyropoulos <artafinde@gmail.com> wrot=
e:
> On Fri, Aug 6, 2010 at 7:32 PM, Sebastian 'gonX' Jensen
> <gonx@overclocked.net> wrote:
>> On 6 August 2010 20:23, Leonidas Spyropoulos <artafinde@gmail.com> w=
rote:
>>> Do I have to change the partition ID flag of each partition?
>>> Currently is set to fd (Linux Raid autodetect) for used from mdadm
>>> mkfs.btrfs supports that or needs to be 83 (Linux) ?
>>
>> FD is for mdraid integrated into the Linux kernel. I have mine at 83=
=2E
>> It won't hurt to have them at FD, but the kernel will spend extra ti=
me
>> as it probes the devices on boot, causing a slight slowdown.
>
> Ok done them id 83 and used 3 devices eventually
> Using raid0 for data and metadata
> # mkfs.btrfs -m raid0 -d raid0 /dev/sdc1 /dev/sdd2 /dev/sde2
>
> 2 SATA and 1 ATA drive
> I thought that ATA will bottleneck the other 2 drives but seems like =
I gain
> something from it.
> Using iozone for benchmark:
> # iozone -s 8g -r 1024 -i 0 -i 1
> with 2 SATA devices and then 3 devices (SATA + ATA):
> =C2=A0 =C2=A0 =C2=A0 =C2=A0KB =C2=A0reclen =C2=A0 =C2=A0 =C2=A0write =
=C2=A0 rewrite =C2=A0 =C2=A0 =C2=A0 read =C2=A0 =C2=A0 reread
> 8388608 =C2=A0 =C2=A01024 =C2=A0134869 =C2=A0139607 =C2=A0 229146 =C2=
=A0 228800
> 8388608 =C2=A0 =C2=A01024 =C2=A0135151 =C2=A0139050 =C2=A0 233461 =C2=
=A0 235929
>
> The above is with -o compress option enabled and my cpu topped up on
> 100% cpu (both cores) while test and copy huge data.
> Is it possible I am bottlenecked by my cpu speed?
> AMD Opteron 165 @ 2700 Mhz
>
>>>
>>> On Thu, Aug 5, 2010 at 3:40 PM, Hubert Kario <hka@qbs.com.pl> wrote=
:
>>>> On Thursday 05 August 2010 16:15:22 Leonidas Spyropoulos wrote:
>>>>> Hi all,
>>>>>
>>>>> I want to make a btrfs raid0 on 2 partitions of my pc.
>>>>> Until now I am using the mdadm tools to make a software raid of t=
he 2
>>>>> partitions /dev/sde2, /dev/sdd2
>>>>> and then mkfs.etx4 the newly created /dev/md0 device.
>>>>> From performance point of view is it better to keep the configura=
tion of
>>>>> mdadm and just format the /dev/md0 device as btrfs OR
>>>>> delete the raid device and format the 2 partitions /dev/sde2 /dev=
/sdd2
>>>>> as a btrfs with 2 devices?
>>>>> mkfs.btrfs /dev/sde2 /dev/sdd2
>>>>
>>>> Btrfs already supports metadata mirroring when the data is striped=
=2E What this
>>>> means, is while the performance should be more-or-less identical t=
o MD RAID0
>>>> (if it isn't it's a bug), your data is a bit more secure as the me=
tadata
>>>> describing it resides on both drives. Later on it will be possible=
 to selct
>>>> which directories/files should have what level of redundancy. This=
 will allow
>>>> to have ~/work RAID1-ed and ~/videos RAID0-ed while keeping both d=
irectories
>>>> on the same partition and filesystem.
>>>>
>>>>> On a sidenote:
>>>>> If I decide to go for raid5 which is not supported currently from=
 mkfs
>>>>> I have to use the mdadm tool anyway, right?
>>>>
>>>> yes, RAID5 code is not in trunk yet.
>>>>
>>>> --
>>>> Hubert Kario
>>>> QBS - Quality Business Software
>>>> 02-656 Warszawa, ul. Ksawer=C3=B3w 30/85
>>>> tel. +48 (22) 646-61-51, 646-74-24
>>>> www.qbs.com.pl
>>>>
>>>
>>>
>>>
>>> --
>>> Caution: breathing may be hazardous to your health.
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btr=
fs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
>>>
>>
>> Regards,
>> Sebastian J.
>>
>> PS. Please try to bottom-post rather than top-post. Here's a link I
>> can advise reading for a clarification on why bottom posting is
>> essential: http://www.caliburn.nl/topposting.html
>>
> Thanks for the heads up about bottom-posting.
>
>
> --
> Caution: breathing may be hazardous to your health.
>

It seems odd that you are reaching 100% CPU usage. Maybe it's because
I am on an Intel processor with the integrated crc32c module, but with
metadata and data striping on 2 decent desktop drives (60 MB/s in avg
each on large reads), I don't go much anywhere near 10% CPU usage, and
I have compress-force enabled. I've never tried a stress test iozone,
but if I can still remember it, I will try to run it once I get back
from holidays. Sorry that it doesn't help your problem, but it seems
like it's something else.

I'm assuming you're running the nForce4 chipset. I don't recall it
being there, but is there an AHCI option for S-ATA in the BIOS, rather
than legacy or PATA mode, or something in the lines of that? That
could in theory reduce CPU usage somewhat, but shouldn't really affect
anything before very high transfer speeds.

And yes, you are bottlenecked if you're running at max CPU usage. I
would try disabling the compress mount option if the above does not
help.

Regards,
Sebastian J.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
