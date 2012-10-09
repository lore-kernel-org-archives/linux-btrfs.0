Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from licorne.daevel.fr ([178.32.94.222]:33011 "EHLO
	licorne.daevel.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276Ab2JIKHY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Oct 2012 06:07:24 -0400
Received: from local.plusdinfo.com ([82.232.160.30] helo=[192.168.0.10])
	by licorne.daevel.fr with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <btrfs.list@daevel.fr>)
	id 1TLWig-0004rV-AB
	for linux-btrfs@vger.kernel.org; Tue, 09 Oct 2012 12:07:22 +0200
Message-ID: <5073F758.6080507@daevel.fr>
Date: Tue, 09 Oct 2012 12:07:20 +0200
From: Olivier Bonvalet <btrfs.list@daevel.fr>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Frozen transaction
References: <5073D44C.7000601@daevel.fr> <20121009095205.GL4405@twin.jikos.cz>
In-Reply-To: <20121009095205.GL4405@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for your reply.

On 09/10/2012 11:52, David Sterba wrote:
> On Tue, Oct 09, 2012 at 09:37:48AM +0200, Olivier Bonvalet wrote:
>> on one system I have a "frozen transaction" since more than 24 hours,
>> without any IO.
>> I can't umount the partition, delete a snapshot or write anything.
>> I try to reboot the system, but the problem is still present.
>
> The processes could point at the cleaner deadlock, though I'm not
> completely sure without looking at the process stacks (/proc/PID/stack).

I didn't see any "stack" entry in /proc/$PID/ ; I will try to find which 
kernel option export that.


>
> If the problem persists accross reboots, how long after mount does it
> take to get to this state? Cleaner usually kicks in after the 30 second
> transaction commit period, so this should be easy to verify if it's
> immediate or if it requires some load to get into the dead state.

The cleaner process get it's state D between 30 and 60 seconds after the 
reboot. But that cleaner process should not throw a lot of write access ?

This time I tried to remount with the space-cache enabled, there is a 
lot of read access now. Does that space cache will help to find "free 
locations" ?


>
>> The partition is mounted with this options :
>> # mount | grep btrfs
>> /dev/mapper/vg--sofia-backup on /backup type btrfs
>> (rw,noatime,compress-force=zlib,nossd)
>
> So you don't mount with autodefrag, hmm. The deadlock I had in mind
> is more likely with autodefrag but also requires umount.
>
>> The disk is near full :
>> # btrfs fi df /backup/
>> Data: total=482.68GB, used=480.89GB
>
> Quite full.

Yes, it's the problem.


>
>> System, DUP: total=32.00MB, used=72.00KB
>> System: total=4.00MB, used=0.00
>> Metadata, DUP: total=10.12GB, used=8.82GB
>>
>> But one of the last actions was the removing of some big subvolumes (near
>> 50GB).
>
> Given the amount of free space left, this creates high pressure on data
> writes and makes the deadlock more likely.
>
>> There is no error in logs, the frozen transaction was started from a 3.5*
>> kernel (from GIT), and the system is now running on a 3.6.1 kernel
>> (vanilla).
>>
>> Is there something I can do to solve that problem ?
>
> No, there's a patch sent out in order to fix the deadlocks but it's
> unfortunatelly still unmerged.
>
>

I suppose I can't resize the FS without solving that cleanup deadlock 
before ?


> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

