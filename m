Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.jrs-s.net ([173.230.137.22]:49661 "EHLO mail.jrs-s.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754619AbaADC7R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jan 2014 21:59:17 -0500
Message-ID: <52C77903.9060408@jrs-s.net>
Date: Fri, 03 Jan 2014 21:59:15 -0500
From: Jim Salter <jim@jrs-s.net>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs raid1 and btrfs raid10 arrays NOT REDUNDANT
References: <52C73987.7000106@jrs-s.net>	<52C73D1A.8060805@gmail.com>	<52C7402A.7050605@jrs-s.net> <CAOjFWZ7zC3=4oH6=SBZA+PhZMrSK1KjxoRN6L2vqd=GTBKKTQA@mail.gmail.com> <52C74B00.7080906@jrs-s.net> <03E88FCB-C473-4978-B682-076B90039E0E@colorremedies.com>
In-Reply-To: <03E88FCB-C473-4978-B682-076B90039E0E@colorremedies.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 01/03/2014 07:27 PM, Chris Murphy wrote:
> This is the wrong way to solve this. /etc/grub.d/10_linux is subject 
> to being replaced on updates. It is not recommended it be edited, same 
> as for grub.cfg. The correct way is as I already stated, which is to 
> edit the GRUB_CMDLINE_LINUX= line in /etc/default/grub. 
Fair enough - though since I already have to monkey-patch 00_header, I 
kind of already have an eye on grub.d so it doesn't seem as onerous as 
it otherwise would. There is definitely a lot of work that needs to be 
done on the boot sequence for btrfs IMO.
> I think it's bad advice to recommend always persistently mounting a 
> good volume with this option. There's a reason why degraded is not the 
> default mount option, and why there isn't yet automatic degraded mount 
> functionality. That fstab contains other errors.
What other errors does it contain? Aside from adding the "degraded" 
option, that's a bone-stock fstab entry from an Ubuntu Server installation.
> The correct way to automate this before Btrfs developers get around to 
> it is to create a systemd unit that checks for the mount failure, 
> determines that there's a missing device, and generates a modified 
> sysroot.mount job that includes degraded. 
Systemd is not the boot system in use for my distribution, and using it 
would require me to build a custom kernel, among other things. We're 
going to have to agree to disagree that that's an appropriate 
workaround, I think.
> You're simply dissatisfied with the state of Btrfs development and are 
> suggesting bad hacks as a work around. That's my argument. Again, if 
> your use case requires automatic degraded mounts, use a technology 
> that's mature and well tested for that use case. Don't expect a lot of 
> sympathy if these bad hacks cause you problems later. 
You're suggesting the wrong alternatives here (mdraid, LVM, etc) - they 
don't provide the features that I need or are accustomed to (true 
snapshots, copy on write, self-correcting redundant arrays, and on down 
the line). If you're going to shoo me off, the correct way to do it is 
to wave me in the direction of ZFS, in which case I can tell you I've 
been a happy user of ZFS for 5+ years now on hundreds of systems. ZFS 
and btrfs are literally the *only* options available that do what I want 
to do, and have been doing for years now. (At least aside from 
six-figure-and-up proprietary systems, which I have neither the budget 
nor the inclination for.)

I'm testing btrfs heavily in throwaway virtual environments and in a few 
small, heavily-monitored "test production" instances because ZFS on 
Linux has its own set of problems, both technical and licensing, and I 
think it's clear btrfs is going to take the lead in the very near future 
- in many ways, it does already.
>>   I'll set up a Nagios module to check for degraded arrays using btrfs fi list instead, thanks…
> That's a good idea, except that it's show rather than list.
Yup, that's what I meant all right. I frequently still get the syntax 
backwards between btrfs fi show and btrfs subv list.
