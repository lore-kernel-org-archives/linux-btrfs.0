Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:48630 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707Ab2JIMcx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Oct 2012 08:32:53 -0400
Date: Tue, 9 Oct 2012 14:32:49 +0200
From: David Sterba <dave@jikos.cz>
To: Olivier Bonvalet <btrfs.list@daevel.fr>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Frozen transaction
Message-ID: <20121009123249.GO4405@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <5073D44C.7000601@daevel.fr>
 <20121009095205.GL4405@twin.jikos.cz>
 <5073F758.6080507@daevel.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5073F758.6080507@daevel.fr>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 09, 2012 at 12:07:20PM +0200, Olivier Bonvalet wrote:
> I didn't see any "stack" entry in /proc/$PID/ ; I will try to find which
> kernel option export that.

CONFIG_STACKTRACE

> >If the problem persists accross reboots, how long after mount does it
> >take to get to this state? Cleaner usually kicks in after the 30 second
> >transaction commit period, so this should be easy to verify if it's
> >immediate or if it requires some load to get into the dead state.
> 
> The cleaner process get it's state D between 30 and 60 seconds after the
> reboot. But that cleaner process should not throw a lot of write access ?

It needs to update the references so does both reads and writes.

> This time I tried to remount with the space-cache enabled, there is a lot of
> read access now. Does that space cache will help to find "free locations" ?

Yes.

As for the reads, the free space needs to fill the memory structures, if
the disk is almost full there are also quite some data to read before
it's complete. But reads are not the problem.

> I suppose I can't resize the FS without solving that cleanup deadlock before
> ?

Probably no, although if you're fast enough and add another device before
the cleaner starts, it could work :)

Other than that, these are the patches that should fix the deadlock:

https://patchwork.kernel.org/patch/1383951/
https://patchwork.kernel.org/patch/1383941/

(it touches vfs and needs recompiling whole kernel, not just btrfs)


david
