Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-65-41-216-221.sta.embarqhsd.net ([65.41.216.221]:20073 "EHLO
	greer.hardwarefreak.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab3K1HQS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Nov 2013 02:16:18 -0500
Message-ID: <5296EDBD.8030905@hardwarefreak.com>
Date: Thu, 28 Nov 2013 01:16:13 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
Reply-To: stan@hardwarefreak.com
MIME-Version: 1.0
To: David Brown <david.brown@hesbynett.no>, James Plank <plank@cs.utk.edu>,
        Ric Wheeler <rwheeler@redhat.com>
CC: Andrea Mazzoleni <amadvance@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org,
        David Smith <creamyfish@gmail.com>
Subject: Re: Triple parity and beyond
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>	<528A90B7.5010905@zytor.com>	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>	<528AA1EB.3010909@zytor.com> <CAGKKSfVEMuRYf-L5Nfy0Q4SHKcks0VhPJkj73vy+krsNhSkruA@mail.gmail.com> <528BCA2D.5010500@redhat.com> <73BEB41F-0FAC-4108-BEA9-DB6D921F6F55@cs.utk.edu> <528D61C5.70902@hardwarefreak.com> <528DCD36.1060808@hesbynett.no> <528F17FB.60909@hardwarefreak.com> <528F5AF4.60803@hesbynett.no>
In-Reply-To: <528F5AF4.60803@hesbynett.no>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Late reply.  This one got lost in the flurry of activity...

On 11/22/2013 7:24 AM, David Brown wrote:
> On 22/11/13 09:38, Stan Hoeppner wrote:
>> On 11/21/2013 3:07 AM, David Brown wrote:
>>
>>> For example, with 20 disks at 1 TB each, you can have:
>>
...
>> Maximum:
>>
>> RAID 10 = 10 disk redundancy
>> RAID 15 = 11 disk redundancy
> 
> 12 disks maximum (you have 8 with data, the rest are mirrors, parity, or
> mirrors of parity).
> 
>> RAID 16 = 12 disk redundancy
> 
> 14 disks maximum (you have 6 with data, the rest are mirrors, parity, or
> mirrors of parity).

We must follow different definitions of "redundancy".  I view redundancy
as the number of drives that can fail without taking down the array.  In
the case of the above 20 drive RAID15 that maximum is clearly 11
drives-- one of every mirror and both of one mirror can fail.  The 12th
drive failure kills the array.

>> Range:
>>
>> RAID 10 = 1-10 disk redundancy
>> RAID 15 = 3-11 disk redundancy
>> RAID 16 = 5-12 disk redundancy
>
> Yes, I know these are the minimum redundancies.  But that's a vital
> figure for reliability (even if the range is important for statistical
> averages).  When one disk in a raid10 array fails, your main concern is
> about failures or URE's in the other half of the pair - it doesn't help
> to know that another nine disks can "safely" fail too.

Knowing this is often critical from an architectural standpoint David.
It is quite common to create the mirrors of a RAID10 across two HBAs and
two JBOD chassis.  Some call this "duplexing".  With RAID10 you know you
can lose one HBA, one cable, one JBOD (PSU, expander, etc) and not skip
a beat.  "RAID15" would work the same in this scenario.

This architecture is impossible with RAID5/6.  Any of the mentioned
failures will kill the array.

-- 
Stan
