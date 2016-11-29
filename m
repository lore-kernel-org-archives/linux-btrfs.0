Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wj0-f177.google.com ([209.85.210.177]:35109 "EHLO
        mail-wj0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751917AbcK2Wes (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Nov 2016 17:34:48 -0500
Received: by mail-wj0-f177.google.com with SMTP id v7so158194770wjy.2
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Nov 2016 14:34:47 -0800 (PST)
From: Wilson Meier <wilson.meier@gmail.com>
Subject: Re: Convert from RAID 5 to 10
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
References: <10bbbf97-7f43-c972-a832-4a8cf054d5e5@xgm.de>
 <4ef63089-407d-0f18-b182-74c631874a02@gmail.com>
Message-ID: <0d3d3ecd-44a4-fb7f-8f68-aca342d89d04@googlemail.com>
Date: Tue, 29 Nov 2016 23:34:45 +0100
MIME-Version: 1.0
In-Reply-To: <4ef63089-407d-0f18-b182-74c631874a02@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 29.11.2016 18:54, Austin S. Hemmelgarn wrote:
> On 2016-11-29 12:20, Florian Lindner wrote:
>> Hello,
>>
>> I have 4 harddisks with 3TB capacity each. They are all used in a
>> btrfs RAID 5. It has come to my attention, that there
>> seem to be major flaws in btrfs' raid 5 implementation. Because of
>> that, I want to convert the the raid 5 to a raid 10
>> and I have several questions.
>>
>> * Is that possible as an online conversion?
> Yes, as long as you have a complete array to begin with (converting from
> a degraded raid5/6 array has the same issues as rebuilding a degraded
> raid5/6 array).
>>
>> * Since my effective capacity will shrink during conversions, does
>> btrfs check if there is enough free capacity to
>> convert? As you see below, right now it's probably too full, but I'm
>> going to delete some stuff.
> No, you'll have to do the math yourself.  This would be a great project
> idea to place on the wiki though.
>>
>> * I understand the command to convert is
>>
>> btrfs balance start -dconvert=raid10 -mconvert=raid10 /mnt
>>
>> Correct?
> Yes, but I would personally convert first metadata then data.  The
> raid10 profile gets better performance than raid5, so converting the
> metadata first (by issuing a balance just covering the metadata) should
> speed up the data conversion a bit).
>>
>> * What disks are allowed to fail? My understanding of a raid 10 is
>> like that
>>
>> disks = {a, b, c, d}
>>
>> raid0( raid1(a, b), raid1(c, d) )
>>
>> This way (a XOR b) AND (c XOR d) are allowed to fail without the raid
>> to fail (either a or b and c or d are allowed to fail)
>>
>> How is that with a btrfs raid 10?
> A BTRFS raid10 can only sustain one disk failure.  Ideally, it would
> work like you show, but in practice it doesn't.
I'm a little bit concerned right now. I migrated my 4 disk raid6 to
raid10 because of the known raid5/6 problems. I assumed that btrfs
raid10 can handle 2 disk failures as longs as they occur in different
stripes.
Could you please point out why it cannot sustain 2 disk failures?

Thanks
>>
>> * Any other advice? ;-)
> You'll actually get significantly better performance with no loss of
> data safety by running BTRFS in raid1 mode on top of two RAID0 volumes
> (LVM/MD/hardware doesn't matter much).  I do this myself and see roughly
> 10-20% improved performance on average with my workloads.
> 
> If you do decide to do this, it's theoretically possible to do so
> online, but it's kind of tricky, so I won't post any instructions for
> that here unless someone asks for them.
>>
>> Thanks a lot,
>>
>> Florian
>>
>>
>> Some information of my filesystem:
>>
>> # btrfs filesystem show /
>> Label: 'data'  uuid: 57e5b9e9-01ae-4f9e-8a3d-9f42204d7005
>>         Total devices 4 FS bytes used 7.57TiB
>>         devid    1 size 2.72TiB used 2.72TiB path /dev/sda4
>>         devid    2 size 2.72TiB used 2.72TiB path /dev/sdb4
>>         devid    3 size 2.72TiB used 2.72TiB path /dev/sdc4
>>         devid    4 size 2.72TiB used 2.72TiB path /dev/sdd4
>>
>> # btrfs filesystem df /
>> Data, RAID5: total=8.14TiB, used=7.56TiB
>> System, RAID5: total=96.00MiB, used=592.00KiB
>> Metadata, RAID5: total=12.84GiB, used=11.06GiB
>> GlobalReserve, single: total=512.00MiB, used=0.00B
> Based on this output, you will need to delete some data  before you can
> convert to raid10.  With 4 2.72TiB drives, you're looking at roughly
> 5.44TiB of usable space, so you're probably going to have to delete at
> least 2-3TiB of data from this filesystem before converting.
> 
> If you're not already using transparent compression, it could probably
> help some with this, but it likely won't save you more than a few
> hundred GB unless you are storing lots of data that compresses very well.
>>
>> # df -h
>> Filesystem      Size  Used Avail Use% Mounted on
>>
>> /dev/sda4        11T  7.6T  597G  93% /
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
