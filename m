Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from licorne.daevel.fr ([178.32.94.222]:36665 "EHLO
	licorne.daevel.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab2JIOM4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Oct 2012 10:12:56 -0400
Received: from local.plusdinfo.com ([82.232.160.30] helo=[192.168.0.10])
	by licorne.daevel.fr with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <btrfs.list@daevel.fr>)
	id 1TLaYJ-0006fw-4i
	for linux-btrfs@vger.kernel.org; Tue, 09 Oct 2012 16:12:55 +0200
Message-ID: <507430E6.8040107@daevel.fr>
Date: Tue, 09 Oct 2012 16:12:54 +0200
From: Olivier Bonvalet <btrfs.list@daevel.fr>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: [solved] Re: Frozen transaction
References: <5073D44C.7000601@daevel.fr> <20121009095205.GL4405@twin.jikos.cz> <5073F758.6080507@daevel.fr> <20121009123249.GO4405@twin.jikos.cz> <50742B4D.5060600@daevel.fr> <20121009140716.GQ4405@twin.jikos.cz>
In-Reply-To: <20121009140716.GQ4405@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/10/2012 16:07, David Sterba wrote:
> On Tue, Oct 09, 2012 at 03:49:01PM +0200, Olivier Bonvalet wrote:
>> On 09/10/2012 14:32, David Sterba wrote:
>>> On Tue, Oct 09, 2012 at 12:07:20PM +0200, Olivier Bonvalet wrote:
>>>> I didn't see any "stack" entry in /proc/$PID/ ; I will try to find which
>>>> kernel option export that.
>>>
>>> CONFIG_STACKTRACE
>>
>> CONFIG_STACKTRACE_SUPPORT=y
>> CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
>> CONFIG_CC_STACKPROTECTOR=y
>> # CONFIG_DEBUG_STACK_USAGE is not set
>> CONFIG_USER_STACKTRACE_SUPPORT=y
>> # CONFIG_DEBUG_STACKOVERFLOW is not set
>>
>> I suppose it's CONFIG_DEBUG_STACK_USAGE ?
>
> I looked into the sources which config option enables the /proc/./stack
> output, but I don't know which one is it in the menuconfig.
>

Ok, I will search for that, thanks.

>> Well... I don't know if it is related to that space cache, but the cleanup
>> process is now working : it makes a lot of write requests, and I have now
>> 30Go of free space. So it will be solved soon.
>
> Great, looks like it was able to do some progress and free more space
> for further work.
>
>> Any chance that it can be related to that space cache feature ?
>
> The problem is that if the space is tight, it slows down operations that
> depend on it. I've seen very slow snapshot cleaning in similar
> situation, free-space was constantly working. So it is related, but also
> expected and IMHO unavoidable.
>

What I didn't understand, is that since 24 hours, there was near 0 IO 
request done on that device. The cleanup processes was just «frozen», 
not doing anything visible (no CPU and no IO) ; like a deadlock.


>>> Probably no, although if you're fast enough and add another device before
>>> the cleaner starts, it could work :)
>>
>> Ho it's possible, it's a virtualized system, so the device can easily grow.
>
> That makes a difference of course :)
>
>> I was starting to patch my kernel before to see it's now solved.
>
>
> Glad to hear that,
> david
>

