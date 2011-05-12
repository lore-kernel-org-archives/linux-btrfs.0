From: Victor Roetman <victory747@gmail.com>
Subject: Re: btrfs device scan
Date: Thu, 12 May 2011 13:35:17 +0800
Message-ID: <4DCB7195.30208@gmail.com>
References: <BljOh9kD1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BljOh9kD1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/12/2011 12:46 PM, Helmut Hullen wrote:
> Hallo, Victor,
> 
> Du meintest am 12.05.11:
> 
>> I have a couple computers running 2.6.38
>> (Ubuntu Natty 2.6.38-8-generic), and on both of them
>> "btrfs device scan" comes back with nothing other than
>> "failed to read /dev/sr0"
> 
> What tells
> 
>         ls /dev/sd*
>         ls /dev/md*

$ ls /dev/sd*
/dev/sda  /dev/sda1  /dev/sda2  /dev/sda5  /dev/sdb  /dev/sdb1  /dev/sdc
 /dev/sdc1

$ ls /dev/md*
ls: cannot access /dev/md*: No such file or directory

$ btrfs device scan
Scanning for Btrfs filesystems
failed to read /dev/sr0

$ btrfs filesystem show
failed to read /dev/sr0
Label: 'server-backup'  uuid: b927ead9-2e5b-4ee8-b9f4-7209177c49d8
	Total devices 2 FS bytes used 603.17GB
	devid    1 size 1.36TB used 605.28GB path /dev/sdb1
	devid    2 size 1.36TB used 605.26GB path /dev/sdc1

Btrfs Btrfs v0.19
$
