Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:54956 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752400AbdIXOK7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 24 Sep 2017 10:10:59 -0400
Subject: Re: AW: Btrfs performance with small blocksize on SSD
To: "Fuhrmann, Carsten" <carsten.fuhrmann@rwth-aachen.de>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <3321b3c199da4d378bbfa3dbac3c4059@rwth-aachen.de>
 <f05a6500-19d6-fc7c-7461-905417c855b7@gmx.com>
 <b9067303023a49158bae2cdc34393716@rwth-aachen.de>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <bedeafc0-9ee3-e5c3-f7d6-94c58a4d3759@gmx.com>
Date: Sun, 24 Sep 2017 22:10:52 +0800
MIME-Version: 1.0
In-Reply-To: <b9067303023a49158bae2cdc34393716@rwth-aachen.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月24日 21:53, Fuhrmann, Carsten wrote:
> Hello,
> 
> 1)
> I used direct write (no page cache) but I didn't disable the Disk cache of the HDD/SSD itself. In all tests I wrote 1GB and looked for the runtime of that write process.

Are you writing all the 1G into one file?
Or into different files?

> I run every test 5 times with different Blocksizes (2k, 8k, 32k, 128k, 512k). Those values are on the x-axis. On the Y-Axis is the runtime for the test.

Good to know that.

Then there may be 2 factors impacting performance:

1) Convert between inlined and regular data extent
    1st 2K write will be inlined and then 2nd 2K write will convert it
    back to regular data extent.
    The overhead can be quite high.

    Retest with "-o max_inline=0" will disable such behavior so all write
    will only cause regular data extent.

2) Unaligned data size causing extra rewrite/CoW
    Btrfs restore its data in unit of sectorsize, and in your case it is
    4K.
    Writing with 2K will cause btrfs to read out the half written data
    and then CoW it to somewhere else.
    The overhead can be quite huge.

    And I assume 2) is the main overhead.

    Retest with 4K blocksize to see if it's related.

    Please note that, 4K blocksize and 2K blocksize are going through
    different routines (4K blocks routine has no extra CoW overhead, so
    it' should be near 8K blockszie result)

Thanks,
Qu

> 
> 2)
> Yes every test is on RAID1 for data and metadata
> 
> 3)
> Everything default
> mkfs.btrfs -d raid1 -m raid1 /dev/sda /dev/sdb /dev/sdc /dev/sdd
> 
> 
> best regards
> 
> Carsten
> 
> -----Ursprüngliche Nachricht-----
> Von: Qu Wenruo [mailto:quwenruo.btrfs@gmx.com]
> Gesendet: Sonntag, 24. September 2017 15:41
> An: Fuhrmann, Carsten <carsten.fuhrmann@rwth-aachen.de>; linux-btrfs@vger.kernel.org
> Betreff: Re: Btrfs performance with small blocksize on SSD
> 
> 
> 
> On 2017年09月24日 21:24, Fuhrmann, Carsten wrote:
>> Hello,
>>
>> i run a few performance tests comparing mdadm, hardware raid and the btrfs raid. I noticed that the performance for small blocksizes (2k) is very bad on SSD in general and on HDD for sequential writing.
> 
> 2K is smaller than the minimal btrfs sectorsize (4K for x86 family).
> 
> It's common that unaligned access will impact performance, but we need more info about your test cases, including:
> 1) How write is done?
>      Buffered? DIO? O_SYNC? fdatasync?
>      I can't read Germany so I'm not sure what the result means. (Although
>      I can guess Y axle is latency, but I don't know the meaning of X axle.
>      And how many files are involved, how large of these files and etc.
> 
> 2) Data/meta/sys profiles
>      All RADI1?
> 
> 3) Mkfs profile
>      Like nodesize if not default, and any incompat features enabled.
> 
>> I wonder about that result, because you say on the wiki that btrfs is very effective for small files.
> 
> It can be space effective or performance effective.
> 
> If *ignoring* meta profile, btrfs is space-effectient since it inline the data into metadata, avoiding padding it to sectorsize so it can save some space.
> 
> And such behavior can also be somewhat performance effective, by avoiding extra seeking for data, since when reading out the metadata we have already read out the inlined data.
> 
> But such efficiency come with cost.
> 
> One obvious one is when we need to convert inline data into regular one.
> It may cause extra tree balancing and increase latency.
> 
> Would you please try retest with "-o max_inline=0" mount option to disable inline data (which makes btrfs behavior like ext*/xfs) to see if it's related?
> 
> Thanks,
> Qu
> 
>>
>> I attached my results from raid 1 random write HDD (rH1), SSD (rS1)
>> and from sequential write HDD (sH1), SSD (sS1)
>>
>> Hopefully you have an explanation for that.
>>
>> raid@raid-PowerEdge-T630:~$ uname -a
>> Linux raid-PowerEdge-T630 4.10.0-33-generic #37~16.04.1-Ubuntu SMP Fri
>> Aug 11 14:07:24 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
>> raid@raid-PowerEdge-T630:~$ btrfs --version btrfs-progs v4.4
>>
>>
>> best regards
>>
>> Carsten
>>
> N�����r��y���b�X��ǧv�^�)޺{.n�+����{�n�߲)���w*jg��������ݢj/���z�ޖ��2�ޙ���&�)ߡ�a�����G���h��j:+v���w�٥
> 
