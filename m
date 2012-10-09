Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:50258 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184Ab2JIOHU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Oct 2012 10:07:20 -0400
Date: Tue, 9 Oct 2012 16:07:16 +0200
From: David Sterba <dave@jikos.cz>
To: Olivier Bonvalet <btrfs.list@daevel.fr>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [solved] Re: Frozen transaction
Message-ID: <20121009140716.GQ4405@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <5073D44C.7000601@daevel.fr>
 <20121009095205.GL4405@twin.jikos.cz>
 <5073F758.6080507@daevel.fr>
 <20121009123249.GO4405@twin.jikos.cz>
 <50742B4D.5060600@daevel.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50742B4D.5060600@daevel.fr>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 09, 2012 at 03:49:01PM +0200, Olivier Bonvalet wrote:
> On 09/10/2012 14:32, David Sterba wrote:
> >On Tue, Oct 09, 2012 at 12:07:20PM +0200, Olivier Bonvalet wrote:
> >>I didn't see any "stack" entry in /proc/$PID/ ; I will try to find which
> >>kernel option export that.
> >
> >CONFIG_STACKTRACE
> 
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
> CONFIG_CC_STACKPROTECTOR=y
> # CONFIG_DEBUG_STACK_USAGE is not set
> CONFIG_USER_STACKTRACE_SUPPORT=y
> # CONFIG_DEBUG_STACKOVERFLOW is not set
> 
> I suppose it's CONFIG_DEBUG_STACK_USAGE ?

I looked into the sources which config option enables the /proc/./stack
output, but I don't know which one is it in the menuconfig.

> Well... I don't know if it is related to that space cache, but the cleanup
> process is now working : it makes a lot of write requests, and I have now
> 30Go of free space. So it will be solved soon.

Great, looks like it was able to do some progress and free more space
for further work.

> Any chance that it can be related to that space cache feature ?

The problem is that if the space is tight, it slows down operations that
depend on it. I've seen very slow snapshot cleaning in similar
situation, free-space was constantly working. So it is related, but also
expected and IMHO unavoidable.

> >Probably no, although if you're fast enough and add another device before
> >the cleaner starts, it could work :)
> 
> Ho it's possible, it's a virtualized system, so the device can easily grow.

That makes a difference of course :)

> I was starting to patch my kernel before to see it's now solved.


Glad to hear that,
david
