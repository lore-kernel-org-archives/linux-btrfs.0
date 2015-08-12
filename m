Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:33593 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbbHLUsa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Aug 2015 16:48:30 -0400
Received: by igbpg9 with SMTP id pg9so120481764igb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2015 13:48:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK7bmU-qwKN7peYC+fZGJPosa+XBZCOnW4=LKMNrSPi5ZUeiQA@mail.gmail.com>
References: <CAK7bmU97q-oz8aSTQijHJR1MQRgOs+F9nHx2hMuqgPO6G5et9g@mail.gmail.com>
	<CAJCQCtS=v+T-qGFLeaELn7Bt+Mb8ViK+8+YgontAE=1ucAnWZg@mail.gmail.com>
	<CAK7bmU_d3RTU4HZVHB9Z7ZAOpQ8C-wZn7WpvYsJaXiGDJki7fg@mail.gmail.com>
	<CAJCQCtQ9kxpuQD3k-rO84O+0jRpiWbCJAUdog+2_Da6EK5yGsQ@mail.gmail.com>
	<CAK7bmU9X8cvPs2sn3eZRaOowoT2H5jthpessWMQSVgvojjJ5EA@mail.gmail.com>
	<CAJCQCtQvkOr0WSOa_hUTCY72esF1euc_qz_FAEVEZ4c4cc+_dQ@mail.gmail.com>
	<CAK7bmU-KrAVoj_2gVGetAyVBNyTuipi2f+VU5SNzEDWxmnizDA@mail.gmail.com>
	<CAJCQCtSzYS=eDDLt_pMBbi8SY94wAXYnZCE_oppDtm8KEwqh1A@mail.gmail.com>
	<CAK7bmU9DVmXoEUBd2dmQPuVUb-iohacHqXvF73uOdaiL1GwtnA@mail.gmail.com>
	<CAJCQCtQLv83O2DD+J97Rw-i6FsLrANisSapjxydyx0kJT_vokA@mail.gmail.com>
	<CAK7bmU9SL7Fxqe+hAbe229Y7Fzegs2Dx42tLXyZ5Wttk+UeZDQ@mail.gmail.com>
	<CAJCQCtTmdwbLYbCQviNETy_w6Rv8=cu_hWtpVSeUMkGX_SX1Yg@mail.gmail.com>
	<CAK7bmU9onrSNnPhHu+3j1CsUozVU_WV2HM91k30r=CkhcGcgZw@mail.gmail.com>
	<CAK7bmU-qwKN7peYC+fZGJPosa+XBZCOnW4=LKMNrSPi5ZUeiQA@mail.gmail.com>
Date: Wed, 12 Aug 2015 16:48:29 -0400
Message-ID: <CAK7bmU-QaT-f3Dc-N1-VOByO+RAVXXeQiADsXhLaCu8S3opwpg@mail.gmail.com>
Subject: Re: Damaged filesystem, can read, can't repair, error says to contact devs
From: Timothy Normand Miller <theosib@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Actually, it didn't resume.  The "btrfs delete missing" was using 100%
of the I/O bandwidth but wasn't actually doing any disk reads of
writes.  I tried to reboot, but the system wouldn't go down, so after
waiting 10 minutes, I power-cycled.  Now I can't mount at all and
here's what dmesg says about that:

[  236.118419] BTRFS info (device sdb): allowing degraded mounts
[  236.118421] BTRFS info (device sdb): disk space caching is enabled
[  236.165470] BTRFS: bdev (null) errs: wr 1724, rd 305, flush 45,
corrupt 0, gen 2
[  245.883595] BTRFS: too many missing devices, writeable mount is not allowed
[  245.946570] BTRFS: open_ctree failed

It thinks now that there should be five devices, and since there are
only three available, it won't let me mount.

# btrfs filesystem show
Label: none  uuid: 49ac9ad2-b529-4e6e-aef9-1c5b9e8a72f8
        Total devices 1 FS bytes used 28.26GiB
        devid    1 size 79.69GiB used 41.03GiB path /dev/sda3

warning, device 1 is missing
warning, device 1 is missing
warning devid 1 not found already
warning devid 5 not found already
Label: none  uuid: ecdff84d-b4a2-4286-a1c1-cd7e5396901c
        Total devices 5 FS bytes used 1.46TiB
        devid    2 size 931.51GiB used 767.00GiB path /dev/sdd
        devid    3 size 931.51GiB used 745.03GiB path /dev/sdc
        devid    4 size 931.51GiB used 767.00GiB path /dev/sdb
        *** Some devices missing

btrfs-progs v4.1.2



On Wed, Aug 12, 2015 at 4:27 PM, Timothy Normand Miller
<theosib@gmail.com> wrote:
> It resumed on its own.  Weird.
>
> On Wed, Aug 12, 2015 at 4:23 PM, Timothy Normand Miller
> <theosib@gmail.com> wrote:
>> On Wed, Aug 12, 2015 at 2:10 PM, Chris Murphy <lists@colorremedies.com> wrote:
>>
>>>
>>> Anyway it looks like it's hardware related, but I don't know what
>>> device ata4.00 is, so maybe this helps:
>>> http://superuser.com/questions/617192/mapping-ata-device-number-to-logical-device-name
>>
>> # ata=4; ls -l /sys/block/sd* | grep $(grep $ata
>> /sys/class/scsi_host/host*/unique_id | awk -F'/' '{print $5}')
>> lrwxrwxrwx 1 root root 0 Aug 12 16:21 /sys/block/sde ->
>> ../devices/pci0000:00/0000:00:1f.5/ata4/host3/target3:0:0/3:0:0:0/block/sde
>>
>> sde is the newly attached drive, replacing the one that had appeared
>> to have bad sectors.  So it looks like either this new motherboard has
>> a bad connector, or the cable is bad.  I'm going to swap it out for a
>> different SATA cable.  How do I resume the failed operation?  And
>> should I reboot because of the OOPSes?
>>
>> --
>> Timothy Normand Miller, PhD
>> Assistant Professor of Computer Science, Binghamton University
>> http://www.cs.binghamton.edu/~millerti/
>> Open Graphics Project
>
>
>
> --
> Timothy Normand Miller, PhD
> Assistant Professor of Computer Science, Binghamton University
> http://www.cs.binghamton.edu/~millerti/
> Open Graphics Project



-- 
Timothy Normand Miller, PhD
Assistant Professor of Computer Science, Binghamton University
http://www.cs.binghamton.edu/~millerti/
Open Graphics Project
