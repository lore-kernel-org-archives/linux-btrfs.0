Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:14367 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752221AbaLJBKz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Dec 2014 20:10:55 -0500
Message-ID: <54879CFE.1090909@cn.fujitsu.com>
Date: Wed, 10 Dec 2014 09:08:14 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: <kreijack@inwind.it>
CC: <lists@colorremedies.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: get more accurate output in fd command.
References: <B3CDA0F0-14F7-4539-B7FF-B2D2E5F7CAF2@colorremedies.com> <1418124037-8210-1-git-send-email-yangds.fnst@cn.fujitsu.com> <548743CE.1020403@inwind.it>
In-Reply-To: <548743CE.1020403@inwind.it>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/10/2014 02:47 AM, Goffredo Baroncelli wrote:
> Hi Dongsheng
> On 12/09/2014 12:20 PM, Dongsheng Yang wrote:
>> When function btrfs_statfs() calculate the tatol size of fs, it is calculating
>> the total size of disks and then dividing it by a factor. But in some usecase,
>> the result is not good to user.
>>
>> Example:
>> 	# mkfs.btrfs -f /dev/vdf1 /dev/vdf2 -d raid1
>> 	# mount /dev/vdf1 /mnt
>> 	# dd if=/dev/zero of=/mnt/zero bs=1M count=1000
>> 	# df -h /mnt
>> Filesystem      Size  Used Avail Use% Mounted on
>> /dev/vdf1       3.0G 1018M  1.3G  45% /mnt
>>
>> 	# btrfs fi show /dev/vdf1
>> Label: none  uuid: f85d93dc-81f4-445d-91e5-6a5cd9563294
>> 	Total devices 2 FS bytes used 1001.53MiB
>> 	devid    1 size 2.00GiB used 1.85GiB path /dev/vdf1
>> 	devid    2 size 4.00GiB used 1.83GiB path /dev/vdf2
>>
>> a. df -h should report Size as 2GiB rather than as 3GiB.
>> Because this is 2 device raid1, the limiting factor is devid 1 @2GiB.
> I agree
>
>> b. df -h should report Avail as 0.15GiB or less, rather than as 1.3GiB.
>> 2 - 1.85 = 0.15
> I cannot agree; the avail should be:
>      1.85           (the capacity of the allocated chunk)
>     -1.018          (the file stored)
>     +(2-1.85=0.15)  (the residual capacity of the disks
>                      considering a raid1 fs)
>     ---------------
> =   0.97

My bad here. It should be 0.97. My mistake in this changelog.
I will update it in next version.
>> This patch drops the factor at all and calculate the size observable to
>> user without considering which raid level the data is in and what's the
>> size exactly in disk.
>>
>> After this patch applied:
>> 	# mkfs.btrfs -f /dev/vdf1 /dev/vdf2 -d raid1
>> 	# mount /dev/vdf1 /mnt
>> 	# dd if=/dev/zero of=/mnt/zero bs=1M count=1000
>> 	# df -h /mnt
>> Filesystem      Size  Used Avail Use% Mounted on
>> /dev/vdf1       2.0G 1018M  713M  59% /mnt
> I am confused: in this example you reported as Avail 713MB, when previous
> you stated that the right value should be 150MB...

As you pointed above, the right value should be 970MB or less (Some 
space is used for metadata and system).
And the 713MB is my result of it.
>
> What happens when the filesystem is RAID5/RAID6 or Linear ?

The original df did not consider the RAID5/6. So it still does not work 
well with
this patch applied. But I will update this patch to handle these 
scenarios in V2.

Thanx
Yang

  [...]

