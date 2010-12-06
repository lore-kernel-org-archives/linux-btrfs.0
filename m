From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: 800 GByte free, but "no space left"
Date: 06 Dec 2010 13:42:00 +0100
Message-ID: <BbNRVN1y1uB@helmut.hullen.de>
References: <20101206114309.GB4273@carfax.org.uk>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101206114309.GB4273@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 06.12.10:

>>> After running "balance" it looks better:

>>> Label: 'MM2'  uuid: ad7c0668-316c-4a79-ba00-3b505b9d99b4
>>> 	Total devices 2 FS bytes used 2.39TB
>>> 	devid    2 size 1.35TB used 1.20TB path /dev/sdc3
>>> 	devid    1 size 1.81TB used 1.20TB path /dev/sdf2
>>
>> And now:
>>
>> Filesystem           1K-blocks      Used Available Use% Mounted on
>> /dev/sdc3            3400799848 2569770888 831028960  76% /srv/MM
>>
>> But after copying about 300 MByte (part of a 1.5-GByte *.mpg) I got
>> "no space left on device". Looks like balancing has stolen about 300
>> GByte.

>    This sounds exactly like a problem I've had. What output do you
> get from "btrfs fi df /srv/MM"?

I've just written a script for gathering the (perhaps) interesting data  
...

# btrfs filesystem show
Label: 'MM2'  uuid: ad7c0668-316c-4a79-ba00-3b505b9d99b4
	Total devices 2 FS bytes used 2.37TB
	devid    2 size 1.35TB used 1.20TB path /dev/sdc3
	devid    1 size 1.81TB used 1.20TB path /dev/sdf2

Btrfs Btrfs v0.19

# btrfs filesystem df /srv/MM
Data: total=2.39TB, used=2.37TB
Metadata: total=5.25GB, used=3.51GB
System: total=12.00MB, used=188.00KB

# df -t btrfs
Filesystem    Type   1K-blocks      Used Available Use% Mounted on
/dev/sdc3    btrfs   3400799848 2547059672 853740176  75% /srv/MM

# fdisk -l
/dev/sdc3            1569      182401  1452541072+  83  Linux
/dev/sdf2             655      243201  1948258777+  83  Linux

# ----------------------------------------

I've moved about 50 Gbyte away from "srv/MM" in the meantime, before  
running the script with this output.

And I don't dare running "balance" again - maybe it reduces the  
available space again and again.

Viele Gruesse!
Helmut
