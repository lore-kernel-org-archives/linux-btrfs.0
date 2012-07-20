Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:63942 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab2GTKX4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jul 2012 06:23:56 -0400
Received: by lbbgm6 with SMTP id gm6so4820033lbb.19
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Jul 2012 03:23:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <500923E5.6040609@hosman.xs4all.nl>
References: <CALa9hx1ojpNEYOr8-pLbcm3Y80+GNaeJBtnEugh-BZF4OkpAHw@mail.gmail.com>
	<201207191619.39100.Martin@lichtvoll.de>
	<CALa9hx2kjgvNYD_8=z5Mt=q=kSRW_6uR5pr_uF-BQ6=CPknvCw@mail.gmail.com>
	<201207201115.42483.Martin@lichtvoll.de>
	<500923E5.6040609@hosman.xs4all.nl>
Date: Fri, 20 Jul 2012 20:23:54 +1000
Message-ID: <CALa9hx2-YTbRatm5k4POH4M_erSOouHW_EzSK2Bb8PXBTuGbXQ@mail.gmail.com>
Subject: Re: Very slow samba file transfer speed... any ideas ?
From: Shavi N <shavi64@gmail.com>
To: Remco Hosman <remco@hosman.xs4all.nl>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin,

I agree with you 100% that dd does not measure proper performance (and
that /dev/zero is not a very good test).

Hence I'm asking.. I know that I get fast copy/write speeds on the
btrfs volume from real life situations, but NOT with samba.
So, is there something I can do to test why samba is slow transferring
from win7 to a samba share on a btrfs volume?

Thank you,

On Fri, Jul 20, 2012 at 7:24 PM, Remco Hosman <remco@hosman.xs4all.nl> wrote:
>
> Op 20-7-2012 11:15, Martin Steigerwald schreef:
>
>> Am Freitag, 20. Juli 2012 schrieb Shavi N:
>>
>>> On Fri, Jul 20, 2012 at 12:19 AM, Martin Steigerwald
>>>
>>> <Martin@lichtvoll.de> wrote:
>>>>
>>>> Am Donnerstag, 19. Juli 2012 schrieb Shavi N:
>>>>>
>>>>> Hi,
>>>>
>>>> Hi Shavi,
>>>>
>>>>> Thanks.
>>>>>
>>>>> This is the output:
>>>>> btrfs:
>>>>> $ dd if=/dev/zero of=/mnt/shared/misc/temp_file bs=1M count=1400
>>>>> 1400+0 records in
>>>>> 1400+0 records out
>>>>> 1468006400 bytes (1.5 GB) copied, 1.56841 s, 936 MB/s
>>>>>
>>>>> ext4:
>>>>> $ dd if=/dev/zero
>>>>> of=/mnt/500/VirutalBox_VMs/thor/thor-data/temp_file bs=1M
>>>>> count=1400
>>>>> 1400+0 records in
>>>>> 1400+0 records out
>>>>> 1468006400 bytes (1.5 GB) copied, 4.98993 s, 294 MB/s
>>>>
>>>> Did you actually read and understand my mail?
>>>>
>>>> Do you really think that your local disks is/are yielding that
>>>> transferrate? (Unless you are using BTRFS RAID 0/10 on lots of
>>>> disks.)
>>>
>>> Yes I read and understood your email. my btrfs volume consists of 11
>>> HDD's. I was very surprised with that result myself...
>>
>> I think that you did not understood it. Why? Your dd tests where without
>> conv=fsync – did you even try with conv=fsync to compare results?
>>
>> 11 really fast 15000rpm FC / SAS disks could possibly do 936 MB/s. But
>> regular 7200rpm SATA disks depending to the on disk location might be as
>> slow as 40-50 MB/s – just try fio disk-zone-profile on one if you do not
>> believe this – and then even with 11 disks 936 MB/s is out of reach.
>
>
> My BTRFS array consists of 5 WD Green 2T disks. each of them goes a bit over
> 100MB/sec on sequential read/write.
>
> Remco
>
>
>> And then speed depends on the BTRFS RAID level as well. And if BTRFS is
>> using compression then testing with zeros is bogus anyway.
>>
>> Also its questionable whether CIFS will use 1 MiB blocksizes. It might be
>> using it in most current kernels, since there have been some adaption  –
>> but I am not sure ATM whether they have been for reads or writes, they
>> have not been for both, check wsize, rsize or similar named option
>> maximums –, but thats also a point where to look.
>>
>> But then are the files that you transfer there that big at all? And what
>> is the accesses pattern? Virtualbox VM images are usually not written
>> sequentially to, so you need a random I/O workload.
>>
>> I do think in order to get more close to the possible reason of Samba
>> slowness with BTRFS a simple dd test won´t help one bit. Even the
>> conv=fsync case will most likely not be testing the workload that Samba
>> exercises on the local disks.
>>
>> Some fio random I/O workload or dbench or filebench workload might be much
>> closer.
>>
>> I think currently you are measuring something that has almost nothing to
>> do with your real workload.
>>
>> Ciao,
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
