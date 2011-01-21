From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: Adding a disk fails
Date: 21 Jan 2011 11:51:00 +0100
Message-ID: <BeHcMpvT1uB@helmut.hullen.de>
References: <4D38B382.1050709@libero.it>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D38B382.1050709@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Goffredo,

Du meintest am 20.01.11:

> To add another disk you don't have to run mkfs.btrfs. For example:

> # add the first disk
> mkfs.btrfs /dev/sdb
> # mount the disk
> mount /dev/sdb /media/backups

> # add another disk to the first one
> btrfs device add /dev/sdc /media/backup

> Note1: the filesystem has to be mounted
> Note2: the medatada will be in raid1, the data in raid0


Note 3: if the disk has been used (especially under btrfs) you should  
first delete old partitioning data etc:

        dd if=/dev/zero of=/dev/sdb count=1000
        dd if=/dev/zero of=/dev/sdc count=1000

I've just tried your recipe with two devices I had used for other btrfs  
experiments:

        btrfs filesystem show 2>/dev/null

shows my new wishes, and it shows the old settings too.

But writing 1000 blocks seems to be not enough - sometimes I'll try  
bigger numbers. What happens with the old (and now unwanted) settings?

By the way: I nee "2>/dev/null" because the actual git version always  
tries to show all block devices which it finds in "/dev" (no: I don't  
use "udev").

Viele Gruesse!
Helmut
