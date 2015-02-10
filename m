Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34974 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbbBJHuG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 02:50:06 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YL5a8-0006yt-Gh
	for linux-btrfs@vger.kernel.org; Tue, 10 Feb 2015 08:50:04 +0100
Received: from ip18864262.dynamic.kabel-deutschland.de ([24.134.66.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 08:50:04 +0100
Received: from hurikhan77 by ip18864262.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 08:50:04 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: btrfs performance, sudden drop to 0 IOPs
Date: Tue, 10 Feb 2015 07:58:29 +0100
Message-ID: <lpmoqb-t9q.ln1@hurikhan77.spdns.de>
References: <CABdHLQ7QPjUbzqNdzCfR0QxC-0coYs0dofuFvsROYXy-M9u4ig@mail.gmail.com> <d0gnqb-u59.ln1@hurikhan77.spdns.de> <CABdHLQ7baX58W1UnkYUo0_g3f+0dhAs5QuBCDA3U4sduRkTv5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

P. Remek <p.remek1@googlemail.com> schrieb:

> Not sure if it helps, but here is it:
> 
> root@lab1:/mnt/vol1# btrfs filesystem df /mnt/vol1/
> Data, RAID10: total=116.00GiB, used=110.03GiB
> Data, single: total=8.00MiB, used=0.00
> System, RAID1: total=8.00MiB, used=16.00KiB
> System, single: total=4.00MiB, used=0.00
> Metadata, RAID1: total=2.00GiB, used=563.72MiB
> Metadata, single: total=8.00MiB, used=0.00
> unknown, single: total=192.00MiB, used=0.00

This looks completely different to my output. Do you use the latest btrfs-
progs?

$ btrfs --version
Btrfs v3.18.2

$ btrfs fi us /
Overall:
    Device size:                   2.71TiB
    Device allocated:              1.50TiB
    Device unallocated:            1.21TiB
    Used:                          1.37TiB
    Free (estimated):              1.33TiB      (min: 745.87GiB)
    Data ratio:                       1.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,RAID0: Size:1.49TiB, Used:1.36TiB
   /dev/bcache0  507.00GiB
   /dev/bcache1  507.00GiB
   /dev/bcache2  507.00GiB

Metadata,RAID1: Size:6.00GiB, Used:3.99GiB
   /dev/bcache0    4.00GiB
   /dev/bcache1    4.00GiB
   /dev/bcache2    4.00GiB

System,RAID1: Size:32.00MiB, Used:100.00KiB
   /dev/bcache1   32.00MiB
   /dev/bcache2   32.00MiB

Unallocated:
   /dev/bcache0  414.51GiB
   /dev/bcache1  414.48GiB
   /dev/bcache2  414.48GiB


> On Mon, Feb 9, 2015 at 8:56 PM, Kai Krakow <hurikhan77@gmail.com> wrote:
>> P. Remek <p.remek1@googlemail.com> schrieb:
>>
>>> Hello,
>>>
>>> I am benchmarking Btrfs and when benchmarking random writes with fio
>>> utility, I noticed following two things:
>>>
>>> 1) On first run when target file doesn't exist yet, perfromance is
>>> about 8000 IOPs. On second, and every other run, performance goes up
>>> to 70000 IOPs. Its massive difference. The target file is the one
>>> created during the first run.
>>>
>>> 2) There are windows during the test where IOPs drop to 0 and stay 0
>>> about 10 seconds and then it goes back again, and after couple of
>>> seconds again to 0. This is reproducible 100% times.
>>>
>>> Can somobody shred some light on what's happening?
>>
>> I'm not an expert or dev but it's probably due to btrfs doing some
>> housekeeping under the hood. Could you check the output of "btrfs
>> filesystem usage /mountpoint" while running the test? I'd guess there's
>> some pressure on the global reserve during those times.
>>
>>> Command: fio --randrepeat=1 --ioengine=libaio --direct=1
>>> --gtod_reduce=1 --name=test9 --filename=test9 --bs=4k --iodepth=256
>>> --size=10G --numjobs=1 --readwrite=randwrite
>>>
>>> Environment:
>>> CPU: dual socket: E5-2630 v2
>>>    RAM: 32 GB ram
>>>    OS: Ubuntu server 14.10
>>>    Kernel: 3.19.0-031900rc2-generic
>>>    btrfs tools: Btrfs v3.14.1
>>>    2x LSI 9300 HBAs - SAS3 12/Gbs
>>>    8x SSD Ultrastar SSD1600MM 400GB SAS3 12/Gbs
>>>
>>> Regards,
>>> Premek
>>
>> --
>> Replies to list only preferred.
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Replies to list only preferred.

