Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16-i2.italiaonline.it ([212.48.25.194]:44014 "EHLO
	smtp-16.italiaonline.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751560AbaLISq2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Dec 2014 13:46:28 -0500
Message-ID: <548743CE.1020403@inwind.it>
Date: Tue, 09 Dec 2014 19:47:42 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
CC: lists@colorremedies.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: get more accurate output in fd command.
References: <B3CDA0F0-14F7-4539-B7FF-B2D2E5F7CAF2@colorremedies.com> <1418124037-8210-1-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1418124037-8210-1-git-send-email-yangds.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Dongsheng
On 12/09/2014 12:20 PM, Dongsheng Yang wrote:
> When function btrfs_statfs() calculate the tatol size of fs, it is calculating
> the total size of disks and then dividing it by a factor. But in some usecase,
> the result is not good to user.
> 
> Example:
> 	# mkfs.btrfs -f /dev/vdf1 /dev/vdf2 -d raid1
> 	# mount /dev/vdf1 /mnt
> 	# dd if=/dev/zero of=/mnt/zero bs=1M count=1000
> 	# df -h /mnt
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/vdf1       3.0G 1018M  1.3G  45% /mnt
> 
> 	# btrfs fi show /dev/vdf1
> Label: none  uuid: f85d93dc-81f4-445d-91e5-6a5cd9563294
> 	Total devices 2 FS bytes used 1001.53MiB
> 	devid    1 size 2.00GiB used 1.85GiB path /dev/vdf1
> 	devid    2 size 4.00GiB used 1.83GiB path /dev/vdf2
> 
> a. df -h should report Size as 2GiB rather than as 3GiB.
> Because this is 2 device raid1, the limiting factor is devid 1 @2GiB.

I agree

> b. df -h should report Avail as 0.15GiB or less, rather than as 1.3GiB.
> 2 - 1.85 = 0.15

I cannot agree; the avail should be: 
    1.85           (the capacity of the allocated chunk)
   -1.018          (the file stored)
   +(2-1.85=0.15)  (the residual capacity of the disks
                    considering a raid1 fs)
   ---------------
=   0.97           

> 
> This patch drops the factor at all and calculate the size observable to
> user without considering which raid level the data is in and what's the
> size exactly in disk.
> 
> After this patch applied:
> 	# mkfs.btrfs -f /dev/vdf1 /dev/vdf2 -d raid1
> 	# mount /dev/vdf1 /mnt
> 	# dd if=/dev/zero of=/mnt/zero bs=1M count=1000
> 	# df -h /mnt
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/vdf1       2.0G 1018M  713M  59% /mnt

I am confused: in this example you reported as Avail 713MB, when previous
you stated that the right value should be 150MB...

What happens when the filesystem is RAID5/RAID6 or Linear ?


[...]
-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
