From: Hullen@t-online.de (Helmut Hullen)
Subject: failed disk (was: kernel 3.3.4 damages filesystem (?))
Date: 09 May 2012 15:04:00 +0200
Message-ID: <C8XIEzzeCXB@helmut.hullen.de>
References: <20120507184448.GH8938@carfax.org.uk>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120507184448.GH8938@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 07.05.12:

>>>    mkfs.btrfs -m raid1 -d single should give you that.

>> What's the difference to
>>
>>      mkfs.btrfs -m raid1 -d raid0

>  - RAID-0 stripes each piece of data across all the disks.
>  - single puts data on one disk at a time.

[...]


>    In fact, this is probably a good argument for having the option to
> put back the old allocator algorithm, which would have ensured that
> the first disk would fill up completely first before it touched the
> next one...

The actual version seems to oscillate from disk to disk:

Copying about 160 GiByte shows

Label: none  uuid: fd0596c6-d819-42cd-bb4a-420c38d2a60b
	Total devices 2 FS bytes used 155.64GB
	devid    2 size 136.73GB used 114.00GB path /dev/sdl1
	devid    1 size 68.37GB used 45.04GB path /dev/sdk1

Btrfs Btrfs v0.19

------------------------

Watching the amount showed that both disks are filled nearly  
simultaneously.

That would be more difficult to restore ...

Viele Gruesse!
Helmut
