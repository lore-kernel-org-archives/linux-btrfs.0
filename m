Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29300 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722AbaLJCsi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Dec 2014 21:48:38 -0500
Message-ID: <5487B523.10708@oracle.com>
Date: Wed, 10 Dec 2014 10:51:15 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Konstantinos Skarlatos <k.skarlatos@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfs scrub status misreports as "interrupted"
References: <20141122131318.05609d5f@marcec.fritz.box> <5486E82A.6080301@gmail.com>
In-Reply-To: <5486E82A.6080301@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



  Is there any relevant log in the dmegs ?


On 09/12/2014 20:16, Konstantinos Skarlatos wrote:
> I've got the exact same problem, with a 4 drive RAID1. kernel 3.18-git
> and btrfs tools-git, all built yesterday.
>
> On 22/11/2014 2:13 μμ, Marc Joliet wrote:
>> Hi all,
>>
>> While I haven't gotten any "scrub already running" type errors any
>> more, I do
>> get one strange case of state misreport.  When running scrub on /home
>> (btrfs
>> RAID10), after 3 of 4 drives have completed, the 4th drive (sdb) will
>> report as
>> interrupted, despite still running:
>>
>> # btrfs scrub status -d /home
>> scrub status for 472c9290-3ff2-4096-9c47-0612d3a52cef
>> scrub device /dev/sda (id 1) history
>>     scrub started at Sat Nov 22 11:57:34 2014 and finished after 3380
>> seconds
>>     total bytes scrubbed: 252.86GiB with 0 errors
>> scrub device /dev/sdb (id 2) status
>>     scrub started at Sat Nov 22 11:57:34 2014, interrupted after 3698
>> seconds, not running
>>     total bytes scrubbed: 217.50GiB with 0 errors
>> scrub device /dev/sdc (id 3) history
>>     scrub started at Sat Nov 22 11:57:34 2014 and finished after 3013
>> seconds
>>     total bytes scrubbed: 252.85GiB with 0 errors
>> scrub device /dev/sdd (id 4) history
>>     scrub started at Sat Nov 22 11:57:34 2014 and finished after 2994
>> seconds
>>     total bytes scrubbed: 252.85GiB with 0 errors
>>
>> The funny thing is, the time will still update as the scrub keeps going:
>>
>> # btrfs scrub status -d /home
>> scrub status for 472c9290-3ff2-4096-9c47-0612d3a52cef
>> scrub device /dev/sda (id 1) history
>>     scrub started at Sat Nov 22 11:57:34 2014 and finished after 3380
>> seconds
>>     total bytes scrubbed: 252.86GiB with 0 errors
>> scrub device /dev/sdb (id 2) status
>>     scrub started at Sat Nov 22 11:57:34 2014, interrupted after 4136
>> seconds, not running
>>                                      ^^^^^^^^^^^^
>>     total bytes scrubbed: 239.44GiB with 0 errors
>> scrub device /dev/sdc (id 3) history
>>     scrub started at Sat Nov 22 11:57:34 2014 and finished after 3013
>> seconds
>>     total bytes scrubbed: 252.85GiB with 0 errors
>> scrub device /dev/sdd (id 4) history
>>     scrub started at Sat Nov 22 11:57:34 2014 and finished after 2994
>> seconds
>>     total bytes scrubbed: 252.85GiB with 0 errors
>>
>> This has happened a few times, and when sdb finally finishes, the
>> status is then
>> reported correctly as "finished":
>>
>> # btrfs scrub status -d /home
>> scrub status for 472c9290-3ff2-4096-9c47-0612d3a52cef
>> scrub device /dev/sda (id 1) history
>>     scrub started at Sat Nov 22 11:57:34 2014 and finished after 3380
>> seconds
>>     total bytes scrubbed: 252.86GiB with 0 errors
>> scrub device /dev/sdb (id 2) history
>>     scrub started at Sat Nov 22 11:57:34 2014 and finished after 4426
>> seconds
>>     total bytes scrubbed: 252.88GiB with 0 errors
>> scrub device /dev/sdc (id 3) history
>>     scrub started at Sat Nov 22 11:57:34 2014 and finished after 3013
>> seconds
>>     total bytes scrubbed: 252.85GiB with 0 errors
>> scrub device /dev/sdd (id 4) history
>>     scrub started at Sat Nov 22 11:57:34 2014 and finished after 2994
>> seconds
>>     total bytes scrubbed: 252.85GiB with 0 errors
>>
>> Kernel and btrfs-progs version:
>>
>> # uname -a
>> Linux marcec 3.16.7-gentoo #1 SMP PREEMPT Fri Oct 31 22:45:54 CET 2014
>> x86_64 AMD Athlon(tm) 64 X2 Dual Core Processor 4200+ AuthenticAMD
>> GNU/Linux
>>
>> # btrfs --version
>> Btrfs v3.17.1
>>
>> Should I open a report on bugzilla?
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
