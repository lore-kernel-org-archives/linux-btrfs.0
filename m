Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:27727 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbaCCGwZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Mar 2014 01:52:25 -0500
Message-ID: <53142639.3030600@cn.fujitsu.com>
Date: Mon, 03 Mar 2014 14:50:33 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: linux-btrfs@vger.kernel.org
Subject: Re: 3.14.0-rc3 btrfs scrub is preventing my laptop from going to
 sleep
References: <20140227190656.GA28338@merlins.org> <530FE3CE.70809@cn.fujitsu.com> <20140301050937.GD18300@merlins.org> <20140301152235.GA26926@merlins.org> <5313F45F.9090709@cn.fujitsu.com> <20140303052147.GB24835@merlins.org>
In-Reply-To: <20140303052147.GB24835@merlins.org>
Content-Type: multipart/mixed;
 boundary="------------090601000501020500060306"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090601000501020500060306
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed

On 03/03/2014 01:21 PM, Marc MERLIN wrote:
> On Mon, Mar 03, 2014 at 11:17:51AM +0800, Wang Shilong wrote:
>> Hi Marc,
>>
>> On 03/01/2014 11:22 PM, Marc MERLIN wrote:
>>> On Fri, Feb 28, 2014 at 09:09:37PM -0800, Marc MERLIN wrote:
>>>> On Fri, Feb 28, 2014 at 09:18:06AM +0800, Wang Shilong wrote:
>>>>> Could you run the following command when scrub is blocked, we can know more
>>>>> why scrub is blocked here.
>>>>>
>>>>> # echo w >  /proc/sysrq-trigger
>>>>> # dmesg
>>> Yes, there you go:
>>>
>>> (attached because it's too big for the list)
>>>
>>> http://marc.merlins.org/tmp/btrfs_nofreeze.txt
>> Could you please try the following patch, and let's see if it helps:
>>
>> https://patchwork.kernel.org/patch/3680431/
> I just applied your patch, along with the other btrfs send patch to
> 3.14.0-rc5
>
> I didn't help with ACPI sleep. Do you have a laptop you can try this on?
> It'll likely be faster than me doing this remotely :)
>
> Here's the log of failure:
> http://marc.merlins.org/tmp/btrfs_nofreeze2.txt

Unfortunately, i could not reproduce this problem here.

It should not be the problem that i addressed before, there is not 
deadlock here.
try the attached patch and hopely it could solve your problem.(I know 
this is
not polite:-) )

If the attached patch could not solve your problem, i will find a laptop and
try to reproduce myself.

>   
>> This patch addressed a deadlock for device replace, but i guess scrub
>> may also trigger this problem if there are errors related to the disk.
> Hope the log above helps.
>   
>> BTW, is there  some errors related to scrub device, something like:
>>
>> # btrfs device stat <device>
> You mean this?
> legolas:~# btrfs scrub stat /dev/mapper/cryptroot
> scrub status for 4850ee22-bf32-4131-a841-02abdb4a5ba6
> 	scrub started at Sun Mar  2 20:52:21 2014, running for 1587 seconds
> 	total bytes scrubbed: 298.96GiB with 1 errors
> 	error details: csum=1
> 	corrected errors: 0, uncorrectable errors: 1, unverified errors: 0
BTW, I suppose you should use datacow option for btrfs, but here scrub 
time is a little longer.
(1578s for 300g).. Was your filesystem on pressure while running scrub.

Thanks,
Wang
>
>   
> Thanks,
> Marc


--------------090601000501020500060306
Content-Transfer-Encoding: 7bit
Content-Type: text/x-patch;
 name="0001-Btrfs-add-schedule-points-for-scrub.patch"
Content-Disposition: attachment;
 filename="0001-Btrfs-add-schedule-points-for-scrub.patch"

>From 7c0564d5604581dc0ed868de4dbb1ed8d8fbd55f Mon Sep 17 00:00:00 2001
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Date: Mon, 3 Mar 2014 14:34:07 +0800
Subject: [PATCH] Btrfs: add schedule points for scrub

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/scrub.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 682ec3fc..0a00db0 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2064,6 +2064,7 @@ leave_nomem:
 			scrub_block_put(sblock);
 			return ret;
 		}
+		cond_resched();
 	}
 
 	if (force)
@@ -2229,6 +2230,7 @@ behind_scrub_pages:
 		logical += l;
 		physical += l;
 		physical_for_dev_replace += l;
+		cond_resched();
 	}
 	return 0;
 }
-- 
1.9.0


--------------090601000501020500060306--
