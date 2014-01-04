Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:38747 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753866AbaADA1t convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jan 2014 19:27:49 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs raid1 and btrfs raid10 arrays NOT REDUNDANT
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52C74B00.7080906@jrs-s.net>
Date: Fri, 3 Jan 2014 17:27:47 -0700
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, Hugo Mills <hugo@carfax.org.uk>
Message-Id: <03E88FCB-C473-4978-B682-076B90039E0E@colorremedies.com>
References: <52C73987.7000106@jrs-s.net>	<52C73D1A.8060805@gmail.com>	<52C7402A.7050605@jrs-s.net> <CAOjFWZ7zC3=4oH6=SBZA+PhZMrSK1KjxoRN6L2vqd=GTBKKTQA@mail.gmail.com> <52C74B00.7080906@jrs-s.net>
To: Jim Salter <jim@jrs-s.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 3, 2014, at 4:42 PM, Jim Salter <jim@jrs-s.net> wrote:

> For anybody else interested, if you want your system to automatically boot a degraded btrfs array, here are my crib notes, verified working:
> 
> ***************************** boot degraded
> 
> 1. edit /etc/grub.d/10_linux, add degraded to the rootflags
> 
>    GRUB_CMDLINE_LINUX="rootflags=degraded,subvol=${rootsubvol} ${GRUB_CMDLINE_LINUX}

This is the wrong way to solve this. /etc/grub.d/10_linux is subject to being replaced on updates. It is not recommended it be edited, same as for grub.cfg. The correct way is as I already stated, which is to edit the GRUB_CMDLINE_LINUX= line in /etc/default/grub.


> 2. add degraded to options in /etc/fstab also
> 
> UUID=bf9ea9b9-54a7-4efc-8003-6ac0b344c6b5 /               btrfs defaults,degraded,subvol=@       0       1


I think it's bad advice to recommend always persistently mounting a good volume with this option. There's a reason why degraded is not the default mount option, and why there isn't yet automatic degraded mount functionality. That fstab contains other errors.

The correct way to automate this before Btrfs developers get around to it is to create a systemd unit that checks for the mount failure, determines that there's a missing device, and generates a modified sysroot.mount job that includes degraded.


> Side note: sorry, but I absolutely don't buy the argument that "the system won't boot without you driving down to its physical location, standing in front of it, and hammering panickily at a BusyBox prompt" is the best way to find out your array is degraded.

You're simply dissatisfied with the state of Btrfs development and are suggesting bad hacks as a work around. That's my argument. Again, if your use case requires automatic degraded mounts, use a technology that's mature and well tested for that use case. Don't expect a lot of sympathy if these bad hacks cause you problems later.


>  I'll set up a Nagios module to check for degraded arrays using btrfs fi list instead, thanks…

That's a good idea, except that it's show rather than list.



Chris Murphy