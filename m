Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from licorne.daevel.fr ([178.32.94.222]:36324 "EHLO
	licorne.daevel.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378Ab2JINtD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Oct 2012 09:49:03 -0400
Received: from local.plusdinfo.com ([82.232.160.30] helo=[192.168.0.10])
	by licorne.daevel.fr with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <btrfs.list@daevel.fr>)
	id 1TLaBC-0004tw-1a
	for linux-btrfs@vger.kernel.org; Tue, 09 Oct 2012 15:49:02 +0200
Message-ID: <50742B4D.5060600@daevel.fr>
Date: Tue, 09 Oct 2012 15:49:01 +0200
From: Olivier Bonvalet <btrfs.list@daevel.fr>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [solved] Re: Frozen transaction
References: <5073D44C.7000601@daevel.fr> <20121009095205.GL4405@twin.jikos.cz> <5073F758.6080507@daevel.fr> <20121009123249.GO4405@twin.jikos.cz>
In-Reply-To: <20121009123249.GO4405@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/10/2012 14:32, David Sterba wrote:
> On Tue, Oct 09, 2012 at 12:07:20PM +0200, Olivier Bonvalet wrote:
>> I didn't see any "stack" entry in /proc/$PID/ ; I will try to find which
>> kernel option export that.
>
> CONFIG_STACKTRACE

CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
# CONFIG_DEBUG_STACKOVERFLOW is not set

I suppose it's CONFIG_DEBUG_STACK_USAGE ?

>
>>> If the problem persists accross reboots, how long after mount does it
>>> take to get to this state? Cleaner usually kicks in after the 30 second
>>> transaction commit period, so this should be easy to verify if it's
>>> immediate or if it requires some load to get into the dead state.
>>
>> The cleaner process get it's state D between 30 and 60 seconds after the
>> reboot. But that cleaner process should not throw a lot of write access ?
>
> It needs to update the references so does both reads and writes.
>
>> This time I tried to remount with the space-cache enabled, there is a lot of
>> read access now. Does that space cache will help to find "free locations" ?
>
> Yes.
>
> As for the reads, the free space needs to fill the memory structures, if
> the disk is almost full there are also quite some data to read before
> it's complete. But reads are not the problem.

Well... I don't know if it is related to that space cache, but the 
cleanup process is now working : it makes a lot of write requests, and I 
have now 30Go of free space. So it will be solved soon.

Any chance that it can be related to that space cache feature ?


>> I suppose I can't resize the FS without solving that cleanup deadlock before
>> ?
>
> Probably no, although if you're fast enough and add another device before
> the cleaner starts, it could work :)

Ho it's possible, it's a virtualized system, so the device can easily grow.

> Other than that, these are the patches that should fix the deadlock:
>
> https://patchwork.kernel.org/patch/1383951/
> https://patchwork.kernel.org/patch/1383941/
>
> (it touches vfs and needs recompiling whole kernel, not just btrfs)
>

I was starting to patch my kernel before to see it's now solved.

Thanks for your answers !

Olivier
