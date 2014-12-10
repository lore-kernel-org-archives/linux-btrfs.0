Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-10v.sys.comcast.net ([69.252.207.42]:57561 "EHLO
	resqmta-ch2-10v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932527AbaLJUgU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 15:36:20 -0500
Message-ID: <5488AEBD.7030601@pobox.com>
Date: Wed, 10 Dec 2014 12:36:13 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: get more accurate output in fd command.
References: <B3CDA0F0-14F7-4539-B7FF-B2D2E5F7CAF2@colorremedies.com>	<1418124037-8210-1-git-send-email-yangds.fnst@cn.fujitsu.com>	<548743CE.1020403@inwind.it> <54879CFE.1090909@cn.fujitsu.com>	<54882634.4000809@pobox.com> <pan$5a1c1$2e13a998$8c1ffe18$ead381f2@cox.net>
In-Reply-To: <pan$5a1c1$2e13a998$8c1ffe18$ead381f2@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/10/2014 05:21 AM, Duncan wrote:
> Robert White posted on Wed, 10 Dec 2014 02:53:40 -0800 as excerpted:
>
>> On 12/09/2014 05:08 PM, Dongsheng Yang wrote:
>>> On 12/10/2014 02:47 AM, Goffredo Baroncelli wrote:
>>>> Hi Dongsheng On 12/09/2014 12:20 PM, Dongsheng Yang wrote:
>>>>> When function btrfs_statfs() calculate the tatol size of fs, it is
>>>>> calculating the total size of disks and then dividing it by a factor.
>>>>> But in some usecase, the result is not good to user.
>>>>>
>>>>> Example:
>>>>>      # mkfs.btrfs -f /dev/vdf1 /dev/vdf2 -d raid1
>>>>>      # mount /dev/vdf1 /mnt
>>>>>      # dd if=/dev/zero of=/mnt/zero bs=1M count=1000
>>>>>      # df -h /mnt
>>>>> Filesystem      Size  Used Avail Use% Mounted on
>>>>> /dev/vdf1       3.0G 1018M  1.3G  45% /mnt
>>>>>
>>>>>      # btrfs fi show /dev/vdf1
>>>>> Label: none  uuid: f85d93dc-81f4-445d-91e5-6a5cd9563294
>>>>>      Total devices 2 FS bytes used 1001.53MiB
>>>>>      devid    1 size 2.00GiB  used 1.85GiB path /dev/vdf1
>>>>>      devid    2 size 4.00GiB  used 1.83GiB path /dev/vdf2
>>>>>
>>>>> a. df -h should report Size as 2GiB rather than as 3GiB.
>>>>> Because this is 2 device raid1, the limiting factor is devid 1 @2GiB.
>>>> I agree
>>
>> NOPE.
>>
>> The model you propose is too simple.
>>
>> While the data portion of the file system is set to RAID1 the metadata
>> portion of the filesystem is still set to the default of DUP.

Well my bad... /D'oh...

Though I'd say the documentation needs to be updated. The only mention 
of changes from the default is this bit.

 From man mkfs.btrfs as distributed in the source tree:

[QUOTE]
        -m|--metadata <profile>
            Specify how metadata must be spanned across the devices 
specified. Valid values are raid0, raid1, raid5, raid6, raid10, single 
or dup.

            Single device will have dup set by default except in the 
case of SSDs which will default to single. This is because SSDs can 
remap blocks internally so duplicate blocks could end up in the same 
erase block which negates the benefits of doing metadata duplication.
[/QUOTE]

No mention is made of RAID1 for a multi-device FS, the two defaults are 
listed as DUP and Single.

ASIDE: The wiki page mentions RAID1 but doesn't mention the SSD fallback 
to single; and it's annotated as potentially out of date. But I never 
looked there because I had the manual page locally.

I tested it and sure enough, it's RAID1...

I also noticed that the default for data goes from single to RAID0 in a 
two slice build.

I generally don't expect defaults to change in undocumented ways. 
Particularly since that makes make-plus-add orthogonal to make-as-multi.

Without other guidance I'd been assuming that

mkfs.btrfs d1 d2 d3 ...
--vs--
mkfs.btrfs d1
btrfs dev add d2
btrfs dev add d3
...

would net the same resultant system. I have only ever done the latter 
until today.

Does/Will the defaults change when three, four, or more slices are used 
to build the system?

I'll take a stab at updating the manual page.

-- Rob.


