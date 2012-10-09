Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:46315 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754519Ab2JIJwJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Oct 2012 05:52:09 -0400
Date: Tue, 9 Oct 2012 11:52:05 +0200
From: David Sterba <dave@jikos.cz>
To: Olivier Bonvalet <btrfs.list@daevel.fr>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Frozen transaction
Message-ID: <20121009095205.GL4405@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <5073D44C.7000601@daevel.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5073D44C.7000601@daevel.fr>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 09, 2012 at 09:37:48AM +0200, Olivier Bonvalet wrote:
> on one system I have a "frozen transaction" since more than 24 hours,
> without any IO.
> I can't umount the partition, delete a snapshot or write anything.
> I try to reboot the system, but the problem is still present.

The processes could point at the cleaner deadlock, though I'm not
completely sure without looking at the process stacks (/proc/PID/stack).

If the problem persists accross reboots, how long after mount does it
take to get to this state? Cleaner usually kicks in after the 30 second
transaction commit period, so this should be easy to verify if it's
immediate or if it requires some load to get into the dead state.

> The partition is mounted with this options :
> # mount | grep btrfs
> /dev/mapper/vg--sofia-backup on /backup type btrfs
> (rw,noatime,compress-force=zlib,nossd)

So you don't mount with autodefrag, hmm. The deadlock I had in mind
is more likely with autodefrag but also requires umount.

> The disk is near full :
> # btrfs fi df /backup/
> Data: total=482.68GB, used=480.89GB

Quite full.

> System, DUP: total=32.00MB, used=72.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=10.12GB, used=8.82GB
> 
> But one of the last actions was the removing of some big subvolumes (near
> 50GB).

Given the amount of free space left, this creates high pressure on data
writes and makes the deadlock more likely.

> There is no error in logs, the frozen transaction was started from a 3.5*
> kernel (from GIT), and the system is now running on a 3.6.1 kernel
> (vanilla).
> 
> Is there something I can do to solve that problem ?

No, there's a patch sent out in order to fix the deadlocks but it's
unfortunatelly still unmerged.


david
