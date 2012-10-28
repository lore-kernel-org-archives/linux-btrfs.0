Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:42546 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785Ab2J1K5j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Oct 2012 06:57:39 -0400
Message-ID: <508D0FC5.1020404@inwind.it>
Date: Sun, 28 Oct 2012 11:58:13 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>, cwillu <cwillu@cwillu.com>,
        Chris Murphy <lists@colorremedies.com>,
        Hugo Mills <hugo@carfax.org.uk>,
        =?ISO-8859-1?Q?Michael_Kj=F6rling?= <michael@kjorling.se>
Subject: Re: [RFC] New attempt to a better "btrfs fi df"
References: <50899151.1070503@inwind.it> <508CF469.5070407@inwind.it> (sfid-20121028_112200_809835_E2621924) <201210281133.10571.Martin@lichtvoll.de>
In-Reply-To: <201210281133.10571.Martin@lichtvoll.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2012-10-28 11:33, Martin Steigerwald wrote:
> Am Sonntag, 28. Oktober 2012 schrieb Goffredo Baroncelli:
[...]
>> $ sudo ./btrfs fi df /mnt/btrfs1/
>> Path: /mnt/btrfs1
>> Summary:
>>   Disk_size:		  21.00GB
>>   Disk_allocated:	   1.83GB
>>   Disk_unallocated:	  19.17GB
>>   Used:			 284.00KB
>>   Free_(Estimated):	  15.76GB	(Max: 20.54GB, min: 10.96GB)
>>   Data_to_disk_ratio:	     75 %
> 
> Okay, so that btrfs fi df.
> 
> Which is a summary.
> 
> I think much more wouldn´t be a summary anymore, so thats okay.
> 
> 
> And the following
> 
>> Allocated_area:
>>   Data,Single: Size:8.00MB, Used:0.00
>>      /dev/vdb	    8.00MB
>>
>>   Data,RAID0: Size:921.75MB, Used:256.00KB
>>      /dev/vdb	  307.25MB
[...]
> 
> is detail shown by btrfs filesystem disk-usage?

Yes

> 
> While
> 
>> Disks:
>>   /dev/vdb	    3.00GB
>>      Data,Single:              8.00MB
>>      Data,RAID0:             307.25MB
>>      Metadata,Single:          8.00MB
>>      Metadata,RAID1:         460.94MB
[...]

> 
> will be btrfs device disk-usage?

yes

> 
> What was your reasoning for not using options to btrfs filesystem df? That 
> df doesn´t show more than "disk free" as well?

My feel is that a switch should change "a bit" a command. In this case
there are very different outputs, for different purposes (how is used a
disk ? where are the chunks ? how many free space I have ? ).


> 
> Then there is a little "inconsistency": "df" versus "disk-usage". I would 
> use either "disk-free" and "disk-usage" or "df" and "du". While regular 
> "du" is not disk-usage but a filesystem directory tree usage command.
> 
> I will think about this a bit more.
> 
> Thanks,


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
