Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:38243 "EHLO
        mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751503AbdIJTO5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Sep 2017 15:14:57 -0400
Received: by mail-lf0-f54.google.com with SMTP id q132so14037644lfe.5
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Sep 2017 12:14:56 -0700 (PDT)
Subject: Re: Help me understand what is going on with my RAID1 FS
To: Kai Krakow <hurikhan77@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAOsOv4morDsVyrWEitL8L+7mXjS+0mXXsd9213Y8cdR44qrLYg@mail.gmail.com>
 <20170910174750.544a4146@jupiter.sol.kaishome.de>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <4375e286-5f28-3ee1-91a7-cfa012e09b9d@gmail.com>
Date: Sun, 10 Sep 2017 22:14:53 +0300
MIME-Version: 1.0
In-Reply-To: <20170910174750.544a4146@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

10.09.2017 18:47, Kai Krakow пишет:
> Am Sun, 10 Sep 2017 15:45:42 +0200
> schrieb FLJ <feci2048@gmail.com>:
> 
>> Hello all,
>>
>> I have a BTRFS RAID1 volume running for the past year. I avoided all
>> pitfalls known to me that would mess up this volume. I never
>> experimented with quotas, no-COW, snapshots, defrag, nothing really.
>> The volume is a RAID1 from day 1 and is working reliably until now.
>>
>> Until yesterday it consisted of two 3 TB drives, something along the
>> lines:
>>
>> Label: 'BigVault'  uuid: a37ad5f5-a21b-41c7-970b-13b6c4db33db
>>         Total devices 2 FS bytes used 2.47TiB
>>         devid    1 size 2.73TiB used 2.47TiB path /dev/sdb
>>         devid    2 size 2.73TiB used 2.47TiB path /dev/sdc
>>
>> Yesterday I've added a new drive to the FS and did a full rebalance
>> (without filters) over night, which went through without any issues.
>>
>> Now I have:
>>  Label: 'BigVault'  uuid: a37ad5f5-a21b-41c7-970b-13b6c4db33db
>>         Total devices 3 FS bytes used 2.47TiB
>>         devid    1 size 2.73TiB used 1.24TiB path /dev/sdb
>>         devid    2 size 2.73TiB used 1.24TiB path /dev/sdc
>>         devid    3 size 7.28TiB used 2.48TiB path /dev/sda
>>
>> # btrfs fi df /mnt/BigVault/
>> Data, RAID1: total=2.47TiB, used=2.47TiB
>> System, RAID1: total=32.00MiB, used=384.00KiB
>> Metadata, RAID1: total=4.00GiB, used=2.74GiB
>> GlobalReserve, single: total=512.00MiB, used=0.00B
>>
>> But still df -h is giving me:
>> Filesystem           Size  Used Avail Use% Mounted on
>> /dev/sdb             6.4T  2.5T  1.5T  63% /mnt/BigVault
>>
>> Although I've heard and read about the difficulty in reporting free
>> space due to the flexibility of BTRFS, snapshots and subvolumes, etc.,
>> but I only have a single volume, no subvolumes, no snapshots, no
>> quotas and both data and metadata are RAID1.
>>
>> My expectation would've been that in case of BigVault Size == Used +
>> Avail.
>>
>> Actually based on http://carfax.org.uk/btrfs-usage/index.html I
>> would've expected 6 TB of usable space. Here I get 6.4 which is odd,

Total size is estimation which in this case is computed as (sum of
device sizes)/2 which is approximately 6.4TiB.

>> but that only 1.5 TB is available is even stranger.
>>
>> Could anyone explain what I did wrong or why my expectations are
>> wrong?
>>
>> Thank you in advance
> 
> Btrfs reports estimated free space from the free space of the smallest
> member as it can only guarantee that.

It's not exactly true. For three devices with free space of 1TiB, 2TiB
and 3TiB it would return 2TiB as available space. But it is not
sophisticated enough to notice that it actually has 3TiB available.

I wonder if this is only free space calculation or actual allocation
algorithm behaves similar (effectively ignoring part of available space).

