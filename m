From: Marcel Lohmann <marcel.lohmann@googlemail.com>
Subject: Re: btrfs on LVM: Out of space
Date: Fri, 10 Sep 2010 21:46:49 +0200
Message-ID: <AANLkTinNr4-6ONKiHehRKZVTZfa47jAby-X0NR3mGroj@mail.gmail.com>
References: <AANLkTinyfVH7DkOTNW-iSJjKExh5eS9Ea-HX0TY+XJ7b@mail.gmail.com>
	<AANLkTimLFf-GezTk07NCQjNKkB5RyVge81kzhs27=jAb@mail.gmail.com>
	<AANLkTini5k0cOwCW5WrZuw3M0ynDy8v9MbSyzPGMRmZy@mail.gmail.com>
	<AANLkTim2y=nV7eeKBGKJ1ynz1OTwo-q6BtF+BuEvX0c=@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTim2y=nV7eeKBGKJ1ynz1OTwo-q6BtF+BuEvX0c=@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2010/9/9 Zhu Yanhai <zhu.yanhai@gmail.com>:
> 2010/9/9 Marcel Lohmann <marcel.lohmann@googlemail.com>:
>> 2010/9/8 Zhu Yanhai <zhu.yanhai@gmail.com>:
>>> Hi,
>>> Have you ever tried with 'mkfs.btrfs -m single /dev/xxxx'?
>>> As you had a RAID1 based on LVM, you don't have to keep
>>> the default duplicated metadata profile in Btrfs.
>>>
>> No, I did not try this. I just created it with the defaults
>> "mkfs.btrfs /dev/mapper/somelogicalvolume". Isn't "-m single" the
>> default?
>
> No, it's not by default. Btrfs will write two copies of the Metadata into
> disk by default, with only one copy of Data -- something similar with
> RAID1, but not the same.
> Anyway, you don't need this, since you already have a standard RAID1
> array setup by LVM.
> '-m single' makes Btrfs write exactly one copy of Metadata, instead of
> two by default.
>

To set this thread to SOLVED:
I recreated the filesystem with "mkfs.btrfs -m single -d single
/dev/mapper/xxx" and mounted it "compress"ed.
After copying only 12,000,000 small files I have 5.13GB in Data and
15.15GB in Metadata. This is far away from good, but this is better
than before. I can live with that because the estimated number of
final files will be 60,000,000 which should fit well on the partition.

> 53 * 2 + 24 = 130. The size of Metadata reported by "btrfs filesystem df"
> is 53GB, however it occupies 53 * 2 = 106GB on 'disk' physically.
> So yes, there will be more space for Data.

There really IS more space for Data. 15.15 * 1 + 5.13 < 130. And yes
this size is also reported by "df -h"

Trying to use "-l 2048" during mkfs was rejected as being invalid. But
who cares...?

Marcel
