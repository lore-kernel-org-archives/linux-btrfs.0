Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f182.google.com ([209.85.160.182]:43672 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbbBIWVq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Feb 2015 17:21:46 -0500
Received: by mail-yk0-f182.google.com with SMTP id q9so12707838ykb.13
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Feb 2015 14:21:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <d0gnqb-u59.ln1@hurikhan77.spdns.de>
References: <CABdHLQ7QPjUbzqNdzCfR0QxC-0coYs0dofuFvsROYXy-M9u4ig@mail.gmail.com>
	<d0gnqb-u59.ln1@hurikhan77.spdns.de>
Date: Mon, 9 Feb 2015 23:21:45 +0100
Message-ID: <CABdHLQ7baX58W1UnkYUo0_g3f+0dhAs5QuBCDA3U4sduRkTv5g@mail.gmail.com>
Subject: Re: btrfs performance, sudden drop to 0 IOPs
From: "P. Remek" <p.remek1@googlemail.com>
To: Kai Krakow <hurikhan77@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Not sure if it helps, but here is it:

root@lab1:/mnt/vol1# btrfs filesystem df /mnt/vol1/
Data, RAID10: total=116.00GiB, used=110.03GiB
Data, single: total=8.00MiB, used=0.00
System, RAID1: total=8.00MiB, used=16.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, RAID1: total=2.00GiB, used=563.72MiB
Metadata, single: total=8.00MiB, used=0.00
unknown, single: total=192.00MiB, used=0.00

On Mon, Feb 9, 2015 at 8:56 PM, Kai Krakow <hurikhan77@gmail.com> wrote:
> P. Remek <p.remek1@googlemail.com> schrieb:
>
>> Hello,
>>
>> I am benchmarking Btrfs and when benchmarking random writes with fio
>> utility, I noticed following two things:
>>
>> 1) On first run when target file doesn't exist yet, perfromance is
>> about 8000 IOPs. On second, and every other run, performance goes up
>> to 70000 IOPs. Its massive difference. The target file is the one
>> created during the first run.
>>
>> 2) There are windows during the test where IOPs drop to 0 and stay 0
>> about 10 seconds and then it goes back again, and after couple of
>> seconds again to 0. This is reproducible 100% times.
>>
>> Can somobody shred some light on what's happening?
>
> I'm not an expert or dev but it's probably due to btrfs doing some
> housekeeping under the hood. Could you check the output of "btrfs filesystem
> usage /mountpoint" while running the test? I'd guess there's some pressure
> on the global reserve during those times.
>
>> Command: fio --randrepeat=1 --ioengine=libaio --direct=1
>> --gtod_reduce=1 --name=test9 --filename=test9 --bs=4k --iodepth=256
>> --size=10G --numjobs=1 --readwrite=randwrite
>>
>> Environment:
>> CPU: dual socket: E5-2630 v2
>>    RAM: 32 GB ram
>>    OS: Ubuntu server 14.10
>>    Kernel: 3.19.0-031900rc2-generic
>>    btrfs tools: Btrfs v3.14.1
>>    2x LSI 9300 HBAs - SAS3 12/Gbs
>>    8x SSD Ultrastar SSD1600MM 400GB SAS3 12/Gbs
>>
>> Regards,
>> Premek
>
> --
> Replies to list only preferred.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
