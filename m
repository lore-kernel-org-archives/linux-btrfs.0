From: Marcel Lohmann <marcel.lohmann@googlemail.com>
Subject: Re: btrfs on LVM: Out of space
Date: Wed, 8 Sep 2010 22:35:03 +0200
Message-ID: <AANLkTini5k0cOwCW5WrZuw3M0ynDy8v9MbSyzPGMRmZy@mail.gmail.com>
References: <AANLkTinyfVH7DkOTNW-iSJjKExh5eS9Ea-HX0TY+XJ7b@mail.gmail.com>
	<AANLkTimLFf-GezTk07NCQjNKkB5RyVge81kzhs27=jAb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimLFf-GezTk07NCQjNKkB5RyVge81kzhs27=jAb@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2010/9/8 Zhu Yanhai <zhu.yanhai@gmail.com>:
> Hi,
> Have you ever tried with 'mkfs.btrfs -m single /dev/xxxx'?
> As you had a RAID1 based on LVM, you don't have to keep
> the default duplicated metadata profile in Btrfs.
>
> -zyh
>
> 2010/9/8 Marcel Lohmann <marcel.lohmann@googlemail.com>:
>> In that complete logical volume I created a btrfs partition. And
>> btrfs-show displays 130GB space. Fine.

>> to give me the actual numbers. And that tells me:
>> Data: total=23.97GB, used=23.97GB
>> Metadata: total=53.01GB, used=33.98GB
>> System: total=12.00MB, used=16.00KB

No, I did not try this. I just created it with the defaults
"mkfs.btrfs /dev/mapper/somelogicalvolume". Isn't "-m single" the
default?
So is it right that btrfs "knows" that it is running on a RAID and
changes it's behavior? Why? Normally a FS does not care about the
underlaying (hidden) disk array.
But if it is neccessary to "drop" that duplicate metadata, how can I
arrange this afterwards. And if it is done, then I would have reduced
the Metadata size, but will there really be more space for Data? Where
is the remaining space from 77 GB to 130 GB?

Maybe I was pointing it the wrong way, sorry. I created a mdadm
software RAID1 and on that is a LVM. I did not use btrfs to span over
two disks. The md RAID with LVS was there before and I couldn't change
this.
This is why I have no btrfs-RAID but a md-RAID.

Marcel
