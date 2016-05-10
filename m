Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24853 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbcEJLAG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 May 2016 07:00:06 -0400
Subject: Re: [PATCH 1/2] btrfs: create degraded-RAID1 chunks
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, clm@fb.com
References: <1461812780-538-1-git-send-email-anand.jain@oracle.com>
 <1461812780-538-2-git-send-email-anand.jain@oracle.com>
 <20160429164234.GE29353@suse.cz> <5726EF6B.7010404@oracle.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <5731BF39.50009@oracle.com>
Date: Tue, 10 May 2016 19:00:09 +0800
MIME-Version: 1.0
In-Reply-To: <5726EF6B.7010404@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



>>> -        .devs_min    = 2,
>>> +        .devs_min    = 1,


>> I think we should introduce another way how to determine the lower limit
>> for the degraded mounts. We need the proper raidX constraints and use
>> the degraded limits only if in case of the degraded mount.

>>>           .tolerated_failures = 1,

>> Which is exactly the tolerated_failures:
>>
>>    degraded_devs_min == devs_min - tolerated_failures

>   that is devs_min is actually healthy_devs_min.

>> which works for all raid levels with redundancy.

> But not for RAID5 and RAID6.

> Here is a (simulation?) tool which gives some ready ans.
> I have added devs_min - tolerated_failures to it.
>
> https://github.com/asj/btrfs-raid-cal.git

I have copied the state table from the above repo and
modified to add the above equation.


[x1                 = devs_increment * sub_stripes]
[ndevs'             = ndevs - ndevs % devs_increment]
[num_stripes        = ndevs' * dev_stripes]
[data_stripes       = num_stripes / ncopies]
[missing_mirror_dev = x1 - ndevs']
[Y                  = devs_min - tolerated_failures ]


		R10 R1 DUP R0 Sn R5 R6
.sub_stripes	= 2, 1, 1, 1, 1, 1, 1
.dev_stripes	= 1, 1, 2, 1, 1, 1, 1
.devs_max	= 0, 2, 1, 0, 1, 0, 0
.devs_min	= 4, 1, 1, 2, 1, 2, 3
.tolerated_fails= 1, 1, 0, 0, 0, 1, 2
.devs_increment	= 2, 2, 1, 1, 1, 1, 1
.ncopies	= 2, 2, 2, 1, 1, 2, 3
  x1             = 4, 2, 1, 1, 1, 1, 1
  Y              = 3, 0, 1, 2, 1, 1, 1

[ndevs = 9]
ndevs		= 9, 9, 9, 9, 9, 9, 9
ndevs'		= 8, 2, 1, 9, 9, 9, 9
num_stripes	= 8, 2, 2, 9, 1, 9, 9
data_stripes	= 4, 1, 1, 9, 1, 8, 7

[ndevs = tolerated_fails + devs_min]
ndevs		= 5, 2, 1, 2, 1, 3, 5
ndevs'		= 4, 2, 1, 2, 1, 3, 5
num_stripes	= 4, 2, 2, 2, 1, 3, 5
data_stripes	= 2, 1, 1, 2, 1, 1, 1

[ndevs = devs_min]
ndevs		= 3, 1, 1, 2, 1, 2, 3
ndevs'		= 2, 0, 1, 2, 1, 2, 3
num_stripes	= -, -, 2, 2, 1, 2, 3
data_stripes	= -, -, 1, 2, 1, 1, 1


[ndevs = devs_min, with RAID1 patch fix]
ndevs		= 3, 1, 1, 2, 1, 2, 3
ndevs'		= 3, 1, 1, 2, 1, 2, 3
num_stripes	= 3, 1, 2, 2, 1, 2, 3
data_stripes	= ?, 1, 1, 2, 1, 1, 1



 > I am seeing problem as this:
 > RAID5&6 devs_min values are in the context of degraded volume.
 > RAID1&10.. devs_min values are in the context of healthy volume.
 >
 > RAID56 is correct. We already have devs_max to know the number
 > of devices in a healthy volumes. RAID1 is devs_min is wrong so
 > it ended up being same as devs_max.


Thanks, Anand


