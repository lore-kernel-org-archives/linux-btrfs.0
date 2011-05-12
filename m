From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: btrfs device scan
Date: 12 May 2011 08:25:00 +0200
Message-ID: <BljOne7T1uB@helmut.hullen.de>
References: <4DCB7195.30208@gmail.com>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DCB7195.30208@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Victor,

Du meintest am 12.05.11:

>>> I have a couple computers running 2.6.38
>>> (Ubuntu Natty 2.6.38-8-generic), and on both of them
>>> "btrfs device scan" comes back with nothing other than
>>> "failed to read /dev/sr0"

[..]

> $ btrfs device scan
> Scanning for Btrfs filesystems
> failed to read /dev/sr0

That's a "well known" error; "scan" tries block devices which really  
cannot contain a btrfs filesystem.
People who don't use "udev" get a lot of more "failed to read" messages;  
"scan" seems to try every block device which exists in "/dev".

Maybe it's more reliable if "scan" doesn't look into "dev" but uses "/ 
proc/partitions".

> $ btrfs filesystem show
> failed to read /dev/sr0
> Label: 'server-backup'  uuid: b927ead9-2e5b-4ee8-b9f4-7209177c49d8
> 	Total devices 2 FS bytes used 603.17GB
> 	devid    1 size 1.36TB used 605.28GB path /dev/sdb1
> 	devid    2 size 1.36TB used 605.26GB path /dev/sdc1

That shows that (in this case) you can ignore the "scan" message.

Viele Gruesse!
Helmut
