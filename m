Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31722 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752148AbaBJQnc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 11:43:32 -0500
Message-ID: <52F901AE.1080908@fb.com>
Date: Mon, 10 Feb 2014 11:43:26 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: John Navitsky <john@navitsky.org>, <linux-btrfs@vger.kernel.org>
Subject: Re: system stuck with flush-btrfs-4 at 100% after filesystem resize
References: <52F67926.7060209@navitsky.org>
In-Reply-To: <52F67926.7060209@navitsky.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/08/2014 01:36 PM, John Navitsky wrote:
> Hello,
>
> I have a large file system that has been growing.  We've resized it a
> couple of times with the following approach:
>
>    lvextend -L +800G /dev/raid/virtual_machines
>    btrfs filesystem resize +800G /vms
>
> I think the FS started out at 200G, we increased it by 200GB a time or
> two, then by 800GB and everything worked fine.
>
> The filesystem hosts a number of virtual machines so the file system is
> in use, although the VMs individually tend not to be overly active.
>
> VMs tend to be in subvolumes, and some of those subvolumes have snapshots.
>
> This time, I increased it by another 800GB, and it it has hung for many
> hours (over night) with flush-btrfs-4 near 100% cpu all that time.
>
> I'm not clear at this point that it will finish or where to go from here.
>
> Any pointers would be much appreciated.
>
> Thanks,
>
> -john (newbie to BTRFS)
>
>
> -------- procedure log ----------
>
> romulus:/home/users/johnn # lvextend -L +800G /dev/raid/virtual_machines
> romulus:/home/users/johnn #  btrfs filesystem resize +800G /vms
> Resize '/vms' of '+800G'
> [hangs]
>
>
> top - 12:21:53 up 136 days,  2:45, 13 users,  load average: 30.39,
> 30.37, 30.37
> Tasks:   1 total,   1 running,   0 sleeping,   0 stopped,   0 zombie
> %Cpu(s):  2.4 us,  2.3 sy,  0.0 ni, 95.1 id,  0.1 wa,  0.0 hi,  0.0 si,
>   0.0 st
> MiB Mem:    129147 total,   127427 used,     1720 free,      264 buffers
> MiB Swap:   262143 total,      661 used,   261482 free,    93666 cached
>
>     PID USER      PR  NI  VIRT  RES  SHR S  %CPU %MEM     TIME+ COMMAND
>   48809 root      20   0     0    0    0 R  99.3  0.0   1449:14
> flush-btrfs-4
>
> ------- misc info -----------
>
> romulus:/home/users/johnn # cat /etc/SuSE-release
> openSUSE 12.3 (x86_64)
> VERSION = 12.3
> CODENAME = Dartmouth
> romulus:/home/users/johnn # uname -a
> Linux romulus.us.redacted.com 3.7.10-1.16-desktop #1 SMP PREEMPT Fri May
> 31 20:21:23 UTC 2013 (97c14ba) x86_64 x86_64 x86_64 GNU/Linux
> romulus:/home/users/johnn #

Found your problem!  Basically if you are going to run btrfs you should 
at the very least keep up with the stable kernels.  3.11.whatever is 
fine, 3.12.whatever is better.  Thanks,

Josef
