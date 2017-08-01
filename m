Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:37635 "EHLO
        mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752335AbdHAUlO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2017 16:41:14 -0400
Received: by mail-io0-f174.google.com with SMTP id c74so12804974iod.4
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Aug 2017 13:41:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170801202157.rdirjulcvmosuxze@tiamat>
References: <20170731183047.x2p4vyqd2pvf7t4g@tiamat> <pan$1eb89$fa81c30b$fe750acd$9555f678@cox.net>
 <20170801064305.b6pgarooqu73gg3o@tiamat> <CAJtFHURKa-9oUty5Q4=oMGVVFR62AEH-qxo38VG0O5WCVziXqg@mail.gmail.com>
 <20170801202157.rdirjulcvmosuxze@tiamat>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Tue, 1 Aug 2017 23:40:32 +0300
Message-ID: <CAGqmi76+8iP9tVsjziBY=ecrsDCCeqRv88jUz=6WB1b4D1mwwA@mail.gmail.com>
Subject: Re: Slow mounting raid1
To: Leonidas Spyropoulos <artafinde@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-08-01 23:21 GMT+03:00 Leonidas Spyropoulos <artafinde@gmail.com>:
> On 01/08/17, E V wrote:
>> In general I think btrfs takes time proportional to the size of your
>> metadata to mount. Bigger and/or fragmented metadata leads to longer
>> mount times. My big backup fs with >300GB of metadata takes over
>> 20minutes to mount, and that's with the space tree which is
>> significantly faster then space cache v1.
>>
> Hmm my raid1 doesn't seem near to full or has a significant Metadata so
> I don't I'm on this case:
>   # btrfs fi show /media/raid1/
>   Label: 'raid1'  uuid: c9db91e6-0ba8-4ae6-b471-8fd4ff7ee72d
>          Total devices 2 FS bytes used 516.18GiB
>          devid    1 size 931.51GiB used 518.03GiB path /dev/sdd
>          devid    2 size 931.51GiB used 518.03GiB path /dev/sde
>
>   # btrfs fi df /media/raid1/
>   Data, RAID1: total=513.00GiB, used=512.21GiB
>   System, RAID1: total=32.00MiB, used=112.00KiB
>   Metadata, RAID1: total=5.00GiB, used=3.97GiB
>   GlobalReserve, single: total=512.00MiB, used=0.00B
>
> I tried the space_cache=v2 just to see if it would do any
> difference but nothing changed
>   # cat /etc/fstab | grep raid1
>   UUID=c9db91e6-0ba8-4ae6-b471-8fd4ff7ee72d   /media/raid1 btrfs   rw,noatime,compress=lzo,space_cache=v2         0 0
>   # time umount /media/raid1 && time mount /media/raid1/
>
>   real    0m0.807s
>   user    0m0.237s
>   sys     0m0.441s
>
>   real    0m5.494s
>   user    0m0.618s
>   sys     0m0.116s
>
> I did a couple of rebalances on metadata and data and it improved a bit:
>   # btrfs balance start -musage=100 /media/raid1/
>   # btrfs balance start -dusage=10 /media/raid1/
>   [.. incremental dusage 10 -> 95]
>   # btrfs balance start -dusage=95 /media/raid1
>
> Down to 3.7 sec
>   # time umount /media/raid1 && time mount /media/raid1/
>
>   real    0m0.807s
>   user    0m0.237s
>   sys     0m0.441s
>
>   real    0m3.790s
>   user    0m0.430s
>   sys     0m0.031s
>
> I think maybe the next step is to disable compression if I want to mount
> it faster. Is this normal for BTRFS that performance would degrade after
> some time?
>
> Regards,
>
> --
> Leonidas Spyropoulos
>
> A: Because it messes up the order in which people normally read text.
> Q: Why is it such a bad thing?
> A: Top-posting.
> Q: What is the most annoying thing on usenet and in e-mail?
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

AFAIK, for space_cache=v2, you need do something like:
btrfs check --clear-space-cache v1 /dev/sdd
mount -o space_cache=v2 /dev/sdd <mount_point>
First mount will be very slow, because that require rebuild of space_cache

Thanks.
-- 
Have a nice day,
Timofey.
