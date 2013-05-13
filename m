Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nm1-vm0.bullet.mail.ird.yahoo.com ([77.238.189.95]:35726 "HELO
	nm1-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750985Ab3EMOjJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 May 2013 10:39:09 -0400
Message-ID: <5190F9C7.1080904@influence-pc.fr>
Date: Mon, 13 May 2013 16:33:43 +0200
From: Vincent <vincent@influence-pc.fr>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Remove a materially failed device from a Btrfs "single-raid"
 using partitions
References: <5190F59F.405@influence-pc.fr> <CAFWF=akT1vSPSXkAKCf9y3Ej63XSmBGC_MZKk0BCRxz2diCHFg@mail.gmail.com>
In-Reply-To: <CAFWF=akT1vSPSXkAKCf9y3Ej63XSmBGC_MZKk0BCRxz2diCHFg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 13/05/2013 16:29, Harald Glatt a écrit :
> On Mon, May 13, 2013 at 4:15 PM, Vincent <vincent@influence-pc.fr> wrote:
>> Hello,
>>
>> I am on Ubuntu Server 13.04 with Linux 3.8.
>>
>> I've created a "single-raid" using /dev/sd{a,b,c,d}{1,3}. One of my hard
>> drives has failed, I mean it's materially dead.
>>
>> :~$ sudo btrfs filesystem show
>> Label: none  uuid: 40886f51-8c9b-4be1-8721-83bf5653d2a0
>>      Total devices 5 FS bytes used 226.90GB
>>      devid    4 size 37.27GB used 31.01GB path /dev/sdd1
>>      devid    3 size 37.27GB used 31.01GB path /dev/sdc1
>>      devid    2 size 37.31GB used 31.00GB path /dev/sdb1
>>      devid    1 size 139.73GB used 132.02GB path /dev/sda3
>>      *** Some devices missing
>>
>>
>> Many tutorials I found about it never mention the simple deletion of a
>> non-remountable disk in case of a "single-raid" (where the datas doesn't
>> matter, I've used the only "d=single" option, insinuating "m=mirrored").
>>
>> I've read this page http://www.howtoforge.com/a-beginners-guide-to-btrfs
>> until "8 Adding/Deleting Hard Drives To/From A btrfs File System" section.
>> But this page want to make me mount the drive, but it's dead.
>>
>> When my Btrfs partition is not mounted and when I do:
>> :~$ sudo btrfs device delete missing
>> btrfs device delete: too few arguments
>> or
>> :~$ sudo btrfs device delete missing /media/single-raid/
>> Nothing happen.
>>
>> If I try to mount the failed device, and remove /dev/sde1 from the
>> mountpoint, my console doesn't respond anymore.
>>
>> I've also read the official documentation
>> https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices#Removing_devices
>> using degraded mode: mount -o degraded /dev/sda3 /media/single-raid/
>>
>> The fstab line is however: /dev/sda3 /media/single-raid/
>> btrfs device=/dev/sda3,device=/dev/sdb1,device=/dev/sdc1,device=/dev/sdd1 0
>> 2
>>
>> Then perform :~$ sudo btrfs filesystem show
>> Label: none  uuid: 40886f51-8c9b-4be1-8721-83bf5653d2a0
>>      Total devices 5 FS bytes used 226.30GB
>>      devid    4 size 37.27GB used 31.01GB path /dev/sdd1
>>      devid    3 size 37.27GB used 31.01GB path /dev/sdc1
>>      devid    2 size 37.31GB used 31.00GB path /dev/sdb1
>>      devid    1 size 139.73GB used 132.02GB path /dev/sda3
>> **** Some devices missing*
>>
>> I don't understand why in degraded mode I can't remove the failed device.
>> Could you help me please?
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> If you have used d=single, it means that the data that was on the
> drive that failed is now gone. I think btrfs refuses to remove devices
> if it means data loss, but I could be wrong here..

I've no problem with data loss, I just want to have a kind of sharing 
area, but data on other drive are always here, why couldn't I retrieve 
them alive?
