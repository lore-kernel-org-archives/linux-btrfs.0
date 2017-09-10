Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:35400 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750709AbdIJQvQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Sep 2017 12:51:16 -0400
Received: by mail-pg0-f44.google.com with SMTP id 188so11662769pgb.2
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Sep 2017 09:51:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170910174750.544a4146@jupiter.sol.kaishome.de>
References: <CAOsOv4morDsVyrWEitL8L+7mXjS+0mXXsd9213Y8cdR44qrLYg@mail.gmail.com>
 <20170910174750.544a4146@jupiter.sol.kaishome.de>
From: Ferenc-Levente Juhos <feci1024@gmail.com>
Date: Sun, 10 Sep 2017 18:50:35 +0200
Message-ID: <CAOsOv4k3LoCUFt0kAg2mvT9hF6NzEE45FrsYghmk1TD=6kLn2g@mail.gmail.com>
Subject: Re: Help me understand what is going on with my RAID1 FS
To: Kai Krakow <hurikhan77@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

@Kai and Dmitrii
thank you for your explanations if I understand you correctly, you're
saying that btrfs makes no attempt to "optimally" use the physical
devices it has in the FS, once a new RAID1 block group needs to be
allocated it will semi-randomly pick two devices with enough space and
allocate two equal sized chunks, one on each. This new chunk may or
may not fall onto my newly added 8 TB drive. Am I understanding this
correctly?
> You will probably need to
>run balance once in a while to evenly redistribute allocated chunks
>across all disks.

Is there some sort of balance filter that would speed up this sort of
balancing? Will balance be smart enough to make the "right" decision?
As far as I read the chunk allocator used during balance is the same
that is used during normal operation. If the allocator is already
sub-optimal during normal operations, what's the guarantee that it
will make a "better" decision during balancing?

When I say "right" and "better" I mean this:
Drive1(8) Drive2(3) Drive3(3)
X1            X1
X2                            X2
X3            X3
X4                            X4
I was convinced until now that the chunk allocator at least tries a
best possible allocation. I'm sure it's complicated to develop a
generic algorithm to fit all setups, but it should be possible.

On Sun, Sep 10, 2017 at 5:47 PM, Kai Krakow <hurikhan77@gmail.com> wrote:
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
>> but that only 1.5 TB is available is even stranger.
>>
>> Could anyone explain what I did wrong or why my expectations are
>> wrong?
>>
>> Thank you in advance
>
> Btrfs reports estimated free space from the free space of the smallest
> member as it can only guarantee that. In your case this is 2.73 minus
> 1.24 free which is roughly around 1.5T. But since this free space
> distributes across three disks with one having much more free space, it
> probably will use up that space at half the rate of actual allocation.
> But due to how btrfs allocates from free space in chunks, that may not
> be possible - thus the low unexpected value. You will probably need to
> run balance once in a while to evenly redistribute allocated chunks
> across all disks.
>
> It may give you better estimates if you combine sdb and sdc into one
> logical device, e.g. using raid0 or jbod via md or lvm.
>
>
> --
> Regards,
> Kai
>
> Replies to list-only preferred.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
