From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: migrating drives (device delete)
Date: 10 Nov 2010 12:31:00 +0100
Message-ID: <B$bHV4Xy1uB@helmut.hullen.de>
References: <1289387076.20690.28.camel@jeezo>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1289387076.20690.28.camel@jeezo>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Oliver,

Du meintest am 10.11.10:

> # sudo btrfs filesystem show
> Label: none  uuid: cd4fd4c1-0632-4cbe-bf3b-ba7a9acda1e0
>         Total devices 2 FS bytes used 291.62GB
>         devid    2 size 696.77GB used 146.63GB path /dev/sdb2
>         devid    1 size 147.19GB used 146.64GB path /dev/sda2

What tells "df": about 300 GByte in use?

> Now I want to remove the smaller drive:

> # mount -t btrfs -o remount,degraded /dev/sda2 /
> # mount | grep /dev/sda2
> /dev/sda2 on / type btrfs (rw,degraded)
> # btrfs device delete /dev/sda2 /
> ERROR: error removing the device '/dev/sda2'

I've tried (with the above device names)

        btrfs device delete /dev/sda2 /
        btrfs filesystem balance /

Ok - I don't try these commands under "/" ...
And I haven't told the system to make a "raid0". I've created the first  
btrfs partition only with

        mkfs.btrfs /dev/sdxn

And I haven't used "degraded" after balancing the 2 partitions.

The "balance" command may take a long time; I've just seen about 2 days  
for 1.5 TByte.

As long as "balance" works it throws messages into "/var/log/messages"  
and can be watched with "top".

When "balance" has finished:

        btrfs filesystem show 2>/dev/null

shouldn't show the "deleted" partition.

Viele Gruesse!
Helmut
