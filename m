From: Leonidas Spyropoulos <artafinde@gmail.com>
Subject: Re: Raid0 with btrfs
Date: Sat, 7 Aug 2010 15:15:04 +0100
Message-ID: <AANLkTikySP7eXy6s-ZnNwuxhqwEoGh_kLtQhtJPMSk4y@mail.gmail.com>
References: <AANLkTimS=bgDsbk9jdcPqW-88eQnq+qss1m2mZBfAif2@mail.gmail.com>
	<201008051640.51662.hka@qbs.com.pl>
	<AANLkTin=eOpEXLyhwT_thgU=dnWKVL2FLOQfqs8RR4p0@mail.gmail.com>
	<AANLkTimAvZZdz0LnxM2H+2B4t1L4VDUi43NmsZpZQONm@mail.gmail.com>
	<AANLkTimOin7isn9Gyi42x4evVnY6KW1H_ycAWUid-JKG@mail.gmail.com>
	<AANLkTinBTJV77qDmVAJQ6a2qqT3TS9N7J-rR6UMVvG+R@mail.gmail.com>
	<AANLkTikoMg6Y8SXt2_p0PhJPBqET19SbFEn00tjMKiwP@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Hubert Kario <hka@qbs.com.pl>, linux-btrfs@vger.kernel.org
To: "Sebastian 'gonX' Jensen" <gonx@overclocked.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikoMg6Y8SXt2_p0PhJPBqET19SbFEn00tjMKiwP@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 7, 2010 at 12:16 PM, Leonidas Spyropoulos
<artafinde@gmail.com> wrote:
> On Sat, Aug 7, 2010 at 1:03 AM, Sebastian 'gonX' Jensen
> <gonx@overclocked.net> wrote:
>> On 7 August 2010 00:24, Leonidas Spyropoulos <artafinde@gmail.com> w=
rote:
>>> On Fri, Aug 6, 2010 at 7:32 PM, Sebastian 'gonX' Jensen
>>> <gonx@overclocked.net> wrote:
>>>> On 6 August 2010 20:23, Leonidas Spyropoulos <artafinde@gmail.com>=
 wrote:
>>>>> Do I have to change the partition ID flag of each partition?
>>>>> Currently is set to fd (Linux Raid autodetect) for used from mdad=
m
>>>>> mkfs.btrfs supports that or needs to be 83 (Linux) ?
>>>>
>>>> FD is for mdraid integrated into the Linux kernel. I have mine at =
83.
>>>> It won't hurt to have them at FD, but the kernel will spend extra =
time
>>>> as it probes the devices on boot, causing a slight slowdown.
>>>
>>> Ok done them id 83 and used 3 devices eventually
>>> Using raid0 for data and metadata
>>> # mkfs.btrfs -m raid0 -d raid0 /dev/sdc1 /dev/sdd2 /dev/sde2
>>>
>>> 2 SATA and 1 ATA drive
>>> I thought that ATA will bottleneck the other 2 drives but seems lik=
e I gain
>>> something from it.
>>> Using iozone for benchmark:
>>> # iozone -s 8g -r 1024 -i 0 -i 1
>>> with 2 SATA devices and then 3 devices (SATA + ATA):
>>> =A0 =A0 =A0 =A0KB =A0reclen =A0 =A0 =A0write =A0 rewrite =A0 =A0 =A0=
 read =A0 =A0 reread
>>> 8388608 =A0 =A01024 =A0134869 =A0139607 =A0 229146 =A0 228800
>>> 8388608 =A0 =A01024 =A0135151 =A0139050 =A0 233461 =A0 235929
>>>
>>> The above is with -o compress option enabled and my cpu topped up o=
n
>>> 100% cpu (both cores) while test and copy huge data.
>>> Is it possible I am bottlenecked by my cpu speed?
>>> AMD Opteron 165 @ 2700 Mhz
>>>
>>>>>
>>>>> On Thu, Aug 5, 2010 at 3:40 PM, Hubert Kario <hka@qbs.com.pl> wro=
te:
>>>>>> On Thursday 05 August 2010 16:15:22 Leonidas Spyropoulos wrote:
>>>>>>> Hi all,
>>>>>>>
>>>>>>> I want to make a btrfs raid0 on 2 partitions of my pc.
>>>>>>> Until now I am using the mdadm tools to make a software raid of=
 the 2
>>>>>>> partitions /dev/sde2, /dev/sdd2
>>>>>>> and then mkfs.etx4 the newly created /dev/md0 device.
>>>>>>> From performance point of view is it better to keep the configu=
ration of
>>>>>>> mdadm and just format the /dev/md0 device as btrfs OR
>>>>>>> delete the raid device and format the 2 partitions /dev/sde2 /d=
ev/sdd2
>>>>>>> as a btrfs with 2 devices?
>>>>>>> mkfs.btrfs /dev/sde2 /dev/sdd2
>>>>>>
>>>>>> Btrfs already supports metadata mirroring when the data is strip=
ed. What this
>>>>>> means, is while the performance should be more-or-less identical=
 to MD RAID0
>>>>>> (if it isn't it's a bug), your data is a bit more secure as the =
metadata
>>>>>> describing it resides on both drives. Later on it will be possib=
le to selct
>>>>>> which directories/files should have what level of redundancy. Th=
is will allow
>>>>>> to have ~/work RAID1-ed and ~/videos RAID0-ed while keeping both=
 directories
>>>>>> on the same partition and filesystem.
>>>>>>
>>>>>>> On a sidenote:
>>>>>>> If I decide to go for raid5 which is not supported currently fr=
om mkfs
>>>>>>> I have to use the mdadm tool anyway, right?
>>>>>>
>>>>>> yes, RAID5 code is not in trunk yet.
>>>>>>
>>>>>> --
>>>>>> Hubert Kario
>>>>>> QBS - Quality Business Software
>>>>>> 02-656 Warszawa, ul. Ksawer=F3w 30/85
>>>>>> tel. +48 (22) 646-61-51, 646-74-24
>>>>>> www.qbs.com.pl
>>>>>>
>>>>>
>>>>>
>>>>>
>>>>> --
>>>>> Caution: breathing may be hazardous to your health.
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-b=
trfs" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.h=
tml
>>>>>
>>>>
>>>> Regards,
>>>> Sebastian J.
>>>>
>>>> PS. Please try to bottom-post rather than top-post. Here's a link =
I
>>>> can advise reading for a clarification on why bottom posting is
>>>> essential: http://www.caliburn.nl/topposting.html
>>>>
>>> Thanks for the heads up about bottom-posting.
>>>
>>>
>>> --
>>> Caution: breathing may be hazardous to your health.
>>>
>>
>> It seems odd that you are reaching 100% CPU usage. Maybe it's becaus=
e
>> I am on an Intel processor with the integrated crc32c module, but wi=
th
>> metadata and data striping on 2 decent desktop drives (60 MB/s in av=
g
>> each on large reads), I don't go much anywhere near 10% CPU usage, a=
nd
>> I have compress-force enabled. I've never tried a stress test iozone=
,
>> but if I can still remember it, I will try to run it once I get back
>> from holidays. Sorry that it doesn't help your problem, but it seems
>> like it's something else.
>
> I really doubt my old Opteron has SSE 4.2 and as mentioned from other
> users it makes a huge difference.
>>
>> I'm assuming you're running the nForce4 chipset. I don't recall it
>> being there, but is there an AHCI option for S-ATA in the BIOS, rath=
er
>> than legacy or PATA mode, or something in the lines of that? That
>> could in theory reduce CPU usage somewhat, but shouldn't really affe=
ct
>> anything before very high transfer speeds.
>>
> Yes it's an nForce4 chipset (DFI Expert)
> And if I recall it's SATA+PATA mode enabled on mine now.
> I can't be sure since I am working on it from ssh.
>
>> And yes, you are bottlenecked if you're running at max CPU usage. I
>> would try disabling the compress mount option if the above does not
>> help.
> After disabling the compress and done the test again it affected the =
write speed
> and my CPU wasn't topped up all the time something like 80-90%
> results with iozone
> =A0 =A0 =A0 =A0KB =A0 reclen =A0 =A0 write =A0 rewrite =A0 =A0 =A0 re=
ad =A0 =A0 reread
> 8388608 =A0 =A01024 =A0147736 =A0147062 =A0 135427 =A0 134744
>
> thanks for that

I am trying to get the best ration from CPU usage and performance
I found out that 2 SATA devices or 2 SATA and 1 ATA devices does
not make a lot of difference in performance point of view but some in
CPU usage

The iozone results for 2 sata devices with compress are
        KB  reclen      write   rewrite       read     reread
8388608    1024  138133  135645   166751   164077

and the cpu average topped up at ~100%
Avg: 0.2% sy: 76.9% ni: 0.0% hi: 0.0% sy: 1.4% wa: 18.6%

On a side note what are the differences of sy: and wa: cpu on cpu usage=
?
Because on 2 sata + 1 ata the sy value was almost all time under 20%
and wa value was topped till ~85%

What is better? from cpu usage point of view?
=46rom performance point of view I would probably keep something
that gives me around ~130mb/sec write and ~140mb/sec
>>
>> Regards,
>> Sebastian J.
>>
>
> The next step is remove the ATA drive and test again with and without
> compress mount.
>
>
> --
> Caution: breathing may be hazardous to your health.
>



--=20
Caution: breathing may be hazardous to your health.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
