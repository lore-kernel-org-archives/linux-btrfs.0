Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail.fujitsu.co.jp ([164.71.1.133]:52809 "EHLO
	fgwmail.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbaF0I5H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jun 2014 04:57:07 -0400
Received: from kw-mxq.gw.nic.fujitsu.com (unknown [10.0.237.131])
	by fgwmail.fujitsu.co.jp (Postfix) with ESMTP id 5F3A63EE0D1
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Jun 2014 17:57:05 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.nic.fujitsu.com [10.0.50.93])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 7F54FAC0111
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Jun 2014 17:57:04 +0900 (JST)
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 36C611DB8038
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Jun 2014 17:57:04 +0900 (JST)
Message-ID: <53AD319E.7080504@jp.fujitsu.com>
Date: Fri, 27 Jun 2014 17:55:58 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: <franziska.naepelt@hiperscan.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: cancel btrfs delete job
References: <1403596252.4221.9.camel@hsew-frn.HIPERSCAN>		 <53ABC90A.9040800@jp.fujitsu.com>	 <1403777123.7657.5.camel@hsew-frn.HIPERSCAN>	 <53AC013E.5000702@jp.fujitsu.com> <1403782463.7657.20.camel@hsew-frn.HIPERSCAN> <53ACACCF.8040609@jp.fujitsu.com>
In-Reply-To: <53ACACCF.8040609@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Franziska,

> (2014/06/26 20:34), Franziska Näpelt wrote:
>> Hi Satoru,
>>
>> I'm sorry, but the boot process is always runnig(i hope so), i can't
>> login until now. So therefore i have currently no logs.
>> I don't want to interrupt these process, because there are a lot of
>> fileactions on the harddrive (LED is blinking).
>>
>> I'm not sure about the mkfs.btrfs option, because the system was set up
>> more than one year ago.
>>
>> mount-options in fstab:
>> LABEL=btrfs-pool /mnt/btrfs btrfs compress=lzo,degraded 0 1
>>
>> kernel version is 3.15 on a Debian Whezzy with current btrfs-tools
>> installed
>>
>> Can you estimate, how long the boot-process (repairing btrfs?) could
>> take? The boot-process works for five hours now.
>
> To do so, I'll try to follow your steps with the system which similar
> to your environment as possible. Unfortunately I don't have plenty
> of disks.

Although you've already succeeded to mount your btrfs now,
I share "how long does Franziska's operations take" anyway.

Please note that I measured not "balance after reset
during balance triggered by delete", but "balance
triggered by delete". Since most required time of both work
are balance, the result of former would be similar
to the latter.



Environment:
- x86_64 fedora20 KVM guest on x86_64 fedora20 host
- RAM: 4GiB
- kernel: 3.15.2
- Storage: 50GB virt-io disk
   - small devices: /dev/vd[d-g]
   - large devices: /dev/vd[hi]

   # All of these virtual devices are backed by
   # files on a real HDD in the host.

Operations:
  1. Make a Btrfs filesystem
  2. Make a junk file in the filesystem.
  3. Add a large device
  4. Remove a small device and measure how long it takes.

Script:
===============================================================================
#!/bin/bash

MOUNTPOINT=/home/sat/mnt

MEGABYTES=4096

mkfs.btrfs -f /dev/vdd /dev/vde /dev/vdf /dev/vdg
mount -o compress=lzo /dev/vdd /home/sat/mnt
dd if=/dev/urandom of=/home/sat/mnt/junk oflag=direct bs=1MiB count="$MEGABYTES"
btrfs dev add -f /dev/vdh /home/sat/mnt
time btrfs dev del /dev/vdg /home/sat/mnt
umount /home/sat/mnt
===============================================================================

Test factors:
   - Device size
      - small: 2GB, large: 3GB
      - small: 4GB, large: 6GB
   - The size of junk file # MEGABYTES parameter of script
     - 1/2 GB
     - 1 GB
     - 2 GB
     - 4 GB

Result (*1):

device size[GB]| junk file |         | time/junk
------+--------+ size [GB] | time[s] | file size
small | large  |           |         |    [s/GB]
======+========+===========+=========+===========
     2 |      3 |       1/2 |     5.3 |    10.6
       |        |         1 |     9.6 |     9.6
       |        |         2 |    19.0 |     9.5
------+--------+-----------+---------+-----------
     4 |      6 |       1/2 |     5.1 |    10.2
       |        |         1 |     9.4 |     9.4
       |        |         2 |    17.0 |     8.5
       |        |         4 |    39.3 |     9.8

*1) This data is the average of three tries.

So, it seems that how long delete (and balance)
takes is proportional to the used size (the size
of junk file here). In my case, delete work seems
to take about 10 [s/GB]. If the storage size
are 2TB for small devices and 3TB for large devices,
and junk file size is 2TB, this operation would take
5.4 hours.

Of course, it's a too simplified case and it wouldn't
apply to your case cleanly. However, this kind of
measurement would help to estimate the required time
to your next balance operation.

Thanks,
Satoru

>
>>
>> best regards,
>> Franziska
>>
>>
>>
>> Hi Franziska,
>>
>> (2014/06/26 19:05), Franziska Näpelt wrote:
>>> Hello Satoru,
>>>
>>> here are your requested informations:
>>>
>>> environment:
>>>
>>> - four 2 TB disks: /dev/sd[c-f]
>>> - two 3 TB disks: /dev/sdg (but until now, only one is connected)
>>>
>>> filesystem consists of/dev/sd[c-f]
>>>
>>> I wanted to replace /dev/sdc by /dev/sdg ( with commands add and after
>>> that delete.
>>> In the second step, I wanted to replace the next disk.
>>>
>>> But it hanged during btrfs delete command (after successfull add).
>>> The delete process was still in progress, but with iotop it seems to me, that there is was no data transfer.
>>
>> Hm, them something bad would happen on Btrfs.
>>
>>> Today in the morning the hole computer hangs and there was no other possibility than reset :(
>>
>> So, unfortunately any debug info like sysrq-w can't be get.
>>
>>>
>>> Until now, he tries to boot with a lot of erros. But I can see, that there are fileactions on the harddrive.
>>>
>>> There are a lot of following messages:
>>> btrfs free space inode generation (0) did not match free space cache generation
>>
>> And doesn't finish to mount process?
>>
>> Your filesystem is in inconsistent state since you
>> reset during rebalancing filesystem which triggered by
>> device deletion.
>>
>> The following link would help you. But I'm not sure whether
>> your data can be restored or not.
>>
>> https://btrfs.wiki.kernel.org/index.php/Btrfsck
>>
>> Could you tell me your mkfs.btrfs options, mount options,
>> and kernel version, if possible? I'd like to try to
>> reproduce your problem anyway.
>>
>> Thanks,
>> Satoru
>>
>>>
>>>
>>> best regards,
>>> Franziska
>>>
>>> -------- Weitergeleitete Nachricht --------
>>> Von: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>>> An: franziska.naepelt@hiperscan.com, linux-btrfs@vger.kernel.org
>>> <linux-btrfs@vger.kernel.org>
>>> Betreff: Re: cancel btrfs delete job
>>> Datum: Thu, 26 Jun 2014 16:17:30 +0900
>>>
>>> Hi Franziska,
>>>
>>> (2014/06/24 16:50), Franziska Näpelt wrote:
>>>> Hi,
>>>>
>>>> i want to expand a btrfs filesystem. In the moment I have four 2 TB HDDs
>>>> for one btrfs pool.
>>>> I want to replace two of the HDDs with 3 TB devices. For this reason i
>>>> added as first one 3 TB device. After that, i do the btrfs delete job.
>>>> This job lasts since 4 days and it seems, that it hangs.
>>>>
>>>> Is it possible to cancel a btrfs delete job?
>>>> And when so, how can i do that?
>>>
>>> Unfortunately you can't cancel btrfs delete.
>>>
>>> Q1. Does your environment and operations are as follows?
>>>
>>> Environment:
>>>     - You have six disks.
>>>       - four 2TB disks: /dev/sd[a-d]
>>>       - two 3TB disks: /dev/sd[ef]
>>>     - Currently your btrfs filesystem consists of /dev/sd[a-d].
>>>     - You want to replace /dev/sd[cd] with /dev/[ef].
>>>
>>> Your operation:
>>>     1. Add one 3TB disk, /dev/sde.     # It works correctly.
>>>     2. Delete one 2TB disk, /dev/sdc   # Hanged up happens here!
>>>
>>> Q2. Does I/Os for delete still in progress, or there is no I/O?
>>>
>>> Thanks,
>>> Satoru
>>>
>>>>
>>>> Best regards,
>>>> Franziska
>>>>
>>>>
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>
>>>
>>>
>>>
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

