Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:59155 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751509AbaGNBYU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Jul 2014 21:24:20 -0400
Message-ID: <53C3313B.1080500@cn.fujitsu.com>
Date: Mon, 14 Jul 2014 09:24:11 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>, "Andrew E. Mileski" <andrewm@isoar.ca>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs is  related to OOM death problems on my 8GB server with
 both 3.15.1 and 3.14?
References: <20140704011938.GO11539@merlins.org> <53B801DD.5040704@isoar.ca> <20140705144318.GT26932@merlins.org> <20140706145815.GD15009@merlins.org> <20140713142918.GH10641@merlins.org>
In-Reply-To: <20140713142918.GH10641@merlins.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: btrfs is related to OOM death problems on my 8GB server 
with both 3.15.1 and 3.14?
From: Marc MERLIN <marc@merlins.org>
To: Andrew E. Mileski <andrewm@isoar.ca>
Date: 2014年07月13日 22:29
> On Sun, Jul 06, 2014 at 07:58:15AM -0700, Marc MERLIN wrote:
>>> As an update, after 1.7 days of scrubbing, the system has started
>>> getting sluggish, I'm getting synchronization problems/crashes in some of
>>> my tools that talk to serial ports (likely due to mini deadlocks in the
>>> kernel), and I'm now getting a few btrfs hangs.
>> Predictably, it died yesterday afternoon after going into memory death
>> (it was answering pings, but userspace was dead, and even sysrq-o did
>> not respond, I had to power cycle the power outlet).
>>
>> This happened just before my 3rd scrub finished, so I'm now 2 out of 2:
>> running scrub on my 3 filesystems kills the system half way through the
>> 3rd scrub.
> Ok, I now changed the subject line to confirm that btrfs is to blame.
>
> I had my system booted 6 days and it held steady at 6.4GB free.
> I mounted 2 of my 4 btrfs filesystems (one by one) and waited a few
> days, and no problems with RAM going down.
>
> Then I mounted my 3rd btrfs filesystem, the one that holds many files
> that has rsync backups running, and I lost 1.4GB of RAM overnight.
> I've just umounted one of its mountpoints, the one where all the backups
> happen while leaving its main pool mounted and will see if RAM keeps
> going down or not (i.e. whether the memory leak is due to rsync activity
> or some other background btrfs process).
>
> But generally, is there a tool to locate which kernel function allocated
> all that RAM that seems to get allocated and forgotten?
This can be done by kernel memleak detection.
Location:
-> Kernel hacking
     -> Memory Debugging
         -> Kernel memory leak detector

Then you can check /sys/kernel/debug/memleak to see which function call 
caused the problem.

Thanks,
Qu
>
> Is /proc/slabinfo supposed to show anything useful?
>
> This is the filesystem in question:
> gargamel:~# btrfs fi df /mnt/btrfs_pool2/
> Data, single: total=3.34TiB, used=3.32TiB
> System, DUP: total=8.00MiB, used=400.00KiB
> System, single: total=4.00MiB, used=0.00
> Metadata, DUP: total=77.50GiB, used=59.87GiB
> Metadata, single: total=8.00MiB, used=0.00
>
>
> Thanks,
> Marc

