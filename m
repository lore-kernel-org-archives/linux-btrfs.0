Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from neo-zeon.de ([173.228.7.145]:45262 "EHLO neo-zeon.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932641AbbCQR0V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Mar 2015 13:26:21 -0400
Received: from [IPv6:2600:1010:b011:4bb5:c9f3:b83d:f97c:6ea7] ([IPv6:2600:1010:b011:4bb5:c9f3:b83d:f97c:6ea7])
	(authenticated bits=0)
	by neo-zeon.de (8.14.9/8.14.9) with ESMTP id t2HHQIIP033682
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2015 10:26:20 -0700 (PDT)
	(envelope-from cam@neo-zeon.de)
Message-ID: <550863B2.2060609@neo-zeon.de>
Date: Tue, 17 Mar 2015 10:26:10 -0700
From: Cameron Berkenpas <cam@neo-zeon.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: System crash while scrubbing on 3.18.x
References: <54F9005D.5070107@neo-zeon.de> <20150306123054.GB18885@localhost.localdomain> <54FA081A.8010501@neo-zeon.de> <550710AE.4040803@neo-zeon.de>
In-Reply-To: <550710AE.4040803@neo-zeon.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I've figured out at least part of the issue.

I had blk-mq enabled by default (SCSI_MQ_DEFAULT=y). I've since set 
SCSI_MQ_DEFAULT=n, and now I'm completely stable with 4.0-rc4, 3.18.9, 
and presumably all the others. This is on both the bcache and non-bcache 
systems.

All of my systems with btrfs and SCSI_MQ_DEFAULT=y are stable unless 
they're using a 3ware 9750 controller (which I believe is the 3w-sas 
driver from the top of my head). So either there's a bug with 
blk-mq+3w-sas+btrfs, or just blk-mq+3w-sas. I suspect the latter, but if 
I can find the time, I'll try to test with another filesystem.

I suspect other controllers/drivers could be affected as well.

Are any btrfs devs interested in me looking into this further?

As a side note, in spite of all the crashes I've had through out my 
testing etc, bcache+btrfs hasn't given me any issues like I've seen in 
the past. This is just a few weeks worth of testing, but it seems 
there's at least some sort of basic stability with bcache+btrfs now.

-Cameron

On 03/16/2015 10:19 AM, Cameron Berkenpas wrote:
> Minor update:
>
> I've now tested 4.0-rc4 on systems. Both systems lockup during a scrub.
>
> I've also tested a laptop with 4.0-rc4 and I have no issues. It could 
> be that I "only" have 221GB on it, that it's an SSD, and/or the lack 
> of a 3ware controller.
>
> Within the next few days, I hope to have the time to test on a btrfs 
> RAID1 system I have (btrfs RAID) as well.
>
> -Cameron
>
> On 03/06/2015 12:03 PM, Cameron Berkenpas wrote:
>> Hello,
>>
>> I should have mentioned this earlier. I get absolutely nothing in the 
>> logs. I can't look at dmesg either as the system is completely 
>> unresponsive.
>>
>> On 03/06/2015 04:30 AM, Liu Bo wrote:
>>> On Thu, Mar 05, 2015 at 05:18:21PM -0800, Cameron Berkenpas wrote:
>>>> Hello,
>>>>
>>>> Sorry for the long email...
>>>>
>>>> I've found my system locks up when scrubbing with 3.18.x, but not
>>>> with 3.17.8 across 2 systems.
>>>>
>>>> I have the following BTRFS partitions on system 1:
>>>> /  (128GiB, 49GiB used on SSD)
>>>> /home (4.2TiB, 624GB used on HDD RAID volume)
>>>>
>>>> I have the following BTRFS partitions on system 2:
>>>> / (196GiB, 17GiB used on HDD RAID volume)
>>>> /home (7.1TiB, 2.9TiB used on HDD RAID volume)
>>>>
>>>> My OS is Netrunner 15 (which 98% Kubuntu) on system 1, and
>>>> up-to-date debian testing on system 2.
>>>>
>>>> I've never encountered a lock up while scrubbing /. Just with /home.
>>>>
>>>> The systems never lock up immediately, but takes some time. VERY
>>>> rarely I'll see the lockup when the scrub is at <100GiB completed.
>>>> Typically it happens somewhere between 200-350GiB. A few times it's
>>>> gone beyond 500GiB. This is probably why I've never encountered the
>>>> issue with /, it's just not big enough on either system.
>>>>
>>>> Both systems were otherwise idle while performing the scrubs that
>>>> crashed the systems.
>>>>
>>>> /home is on a partition on a RAID10 volume on a 3ware 9740-4i
>>>> controller with 4x 3TB disks on system 1. On system 2, it's the same
>>>> controller but with 4x 4TB disks (and / on system 2 is a partition
>>>> on the same RAID volume rather than a separate disk). Both systems
>>>> have 32GiB memory, and the otherwise the hardware is pretty
>>>> different between the systems (AMD Vs. Intel, etc).
>>>>
>>>> I suspect that the RAID controller probably isn't relevant. Both
>>>> arrays and their drives are healthy.
>>>>
>>>> I've also encountered the issue on a freshly formatted filesystem
>>>> with my data copied from a backup on system 1.
>>>>
>>>> I've tried tried scrubbing with btrfs-progs 3.17 (installed from the
>>>> distribution repos on both systems), and btrfs-progs from git (using
>>>> tag v3.18.x). Neither version made a difference.
>>>>
>>>> In case this is helpful to anyone, here's how I've discovered the 
>>>> issue:
>>>> I decided to test btrfs with bcache on system 1 to see if the
>>>> stability had improved since I'd tried bcache+btrfs about a year
>>>> ago. I backed up /home on system 1 and then freshly formatted it and
>>>> set it to use bcache. I was running Linux 3.18.8 and encountered the
>>>> problem that I've described above. I assumed the bcache+btrfs
>>>> combination was still broken so I formatted the system again (this
>>>> time still using btrfs, but without bcache) and copied all my files
>>>> back. I encountered the same issue without bcache. Realizing the
>>>> issue wasn't bcache related, I did ANOTHER format, this time back to
>>>> bcache+btrfs.
>>>>
>>>>  From here in my testing, I found that system 2 (which has no bcache)
>>>> also crashed when scrubbing with Linux 3.18.8. I decided to try
>>>> 3.17.8 on system 1 (since 3.18.8 seemed to be the common denominator
>>>> between the 2 systems), found that fixed the issue, and then
>>>> downgraded system 2 to use 3.17.8 as well, which also fixed the
>>>> issue there.
>>>>
>>>> (Note: At one point I also tried Linux 3.18.7 and 3.18.5, however,
>>>> those kernels are affected by the scrub/crash issue as well.)
>>>>
>>>> I found something else interesting when I tested against Linux
>>>> 3.19.0. With 3.19.0, the bcache system always crashes fairly early
>>>> in the scrub (<100GiB), but the non-bcache system has no issues.
>>>> This suggests my problem with 3.19.0 is a bcache+btrfs issue (or
>>>> simply an issue with bcache).
>>>>
>>>> I'm not sure if bcache is relevant to the BTRFS devs at this point,
>>>> but I thought I'd put that there for anyone who might find that
>>>> information useful.
>>>>
>>>> To summarize:
>>>> I've tested with 2 systems, and scrubbing caused crashes occurred on
>>>> both with Linux 3.18.8, but not with 3.17.8 for both systems
>>>> I've tested 1 system with and without bcache, and bcache made no
>>>> difference between Linux 3.17.8 and 3.18.8.
>>>> I've tested with 3.19.0, and I crash when scrubbing on the bcache
>>>> system, but not the non-bcache system.
>>> Better to have some stacks about the scrub crash.
>>>
>>> Thanks,
>>>
>>> -liubo
>>> -- 
>>> To unsubscribe from this list: send the line "unsubscribe 
>>> linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

