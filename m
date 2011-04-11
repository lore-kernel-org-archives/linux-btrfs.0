From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: btrfs balancing start - and stop?
Date: 11 Apr 2011 11:14:00 +0200
Message-ID: <BjeBv3gi1uB@helmut.hullen.de>
References: <chaz20110411084217.GB5587@seebyte.com>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <chaz20110411084217.GB5587@seebyte.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Stephane,

Du meintest am 11.04.11:

>> [780504.726067] btrfs: relocating block group 3917710622720 flags 20
> [...]
>> At this rate, the balancing would be over in about 8 years.
> [...]

> Hurray! The btrfs balance eventually ran through after almost exactly
> 2 weeks. It didn't get down to 0:

Congratulations!

> There hasn't been any change in allocation though:

> # df -h /backup
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/sda4             8.2T  3.5T  3.2T  53% /backup

> # btrfs fi df /backup
> Data, RAID0: total=3.42TB, used=3.41TB
> System, RAID1: total=16.00MB, used=228.00KB
> Metadata, RAID1: total=28.00GB, used=20.47GB

> Still 1.5TB missing.

Seems to be the same problem I've just mourned about.

Just expand "available" to "at least available". And ignore the value in  
"Data, RAID0: total=3.42TB".

Viele Gruesse!
Helmut
