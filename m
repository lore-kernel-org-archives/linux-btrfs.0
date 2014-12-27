Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:37581 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbaL0OOH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Dec 2014 09:14:07 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Robert White <rwhite@pobox.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again
Date: Sat, 27 Dec 2014 15:14:05 +0100
Message-ID: <1779212.Cg9zjTft4U@merkaba>
In-Reply-To: <549EBB90.5070406@pobox.com>
References: <3738341.y7uRQFcLJH@merkaba> <9534911.qSQhRgc3Jg@merkaba> <549EBB90.5070406@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 27. Dezember 2014, 06:00:48 schrieb Robert White:
> On 12/27/2014 05:16 AM, Martin Steigerwald wrote:
> > It can easily be reproduced without even using Virtualbox, just by a nice
> > simple fio job.
> 
> TL;DR: If you want a worst-case example of consuming a BTRFS filesystem
> with one single file...
> 
> #!/bin/bash
> # not tested, so correct any syntax errors
> typeset -i counter
> for ((counter=250;counter>0;counter--)); do
>   dd if=/dev/urandom of=/some/file bs=4k count=$counter
> done
> exit
> 
> 
> Each pass over /some/file is 4k shorter than the previous one, but none
> of the extents can be deallocated. File will be 1MiB in size and usage
> will be something like 125.5MiB (if I've done the math correctly).
> larger values of counter will result in exponentially larger amounts of
> waste.

Robert, I experienced this hang issues even before the defragmenting case. It 
happened while just installed a 400 MiB tax returns application to it (that is 
no joke, it is that big).

It happens while just using the VM.

Yes, I recommend not to use BTRFS for any VM image or any larger database on 
rotating storage for exactly that COW semantics.

But on SSD?

Its busy looping a CPU core and while the flash is basically idling.

I refuse to believe that this is by design.

I do think there is a *bug*.

Either acknowledge it and try to fix it, or say its by design *without even 
looking at it closely enough to be sure that it is not a bug* and limit your 
own possibilities by it.

I´d rather see it treated as a bug for now.

Come on, 254 IOPS on a filesystem with still 17 GiB of free space while 
randomly writing to a 4 GiB file.

People do these kind of things. Ditch that defrag Windows XP VM case, I had 
performance issue even before by just installing things to it. Databases, VMs, 
emulators. And heck even while just *creating* the file with fio as I shown.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
