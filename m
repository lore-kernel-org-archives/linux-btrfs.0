Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.jrs-s.net ([173.230.137.22]:33029 "EHLO mail.jrs-s.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754002AbaACXk0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jan 2014 18:40:26 -0500
Message-ID: <52C74B00.7080906@jrs-s.net>
Date: Fri, 03 Jan 2014 18:42:56 -0500
From: Jim Salter <jim@jrs-s.net>
MIME-Version: 1.0
To: Freddie Cash <fjwcash@gmail.com>
CC: =?UTF-8?B?Sm9zaHVhIFNjaMO8bGVy?= <joshua.schueler@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Chris Murphy <lists@colorremedies.com>
Subject: Re: btrfs raid1 and btrfs raid10 arrays NOT REDUNDANT
References: <52C73987.7000106@jrs-s.net>	<52C73D1A.8060805@gmail.com>	<52C7402A.7050605@jrs-s.net> <CAOjFWZ7zC3=4oH6=SBZA+PhZMrSK1KjxoRN6L2vqd=GTBKKTQA@mail.gmail.com>
In-Reply-To: <CAOjFWZ7zC3=4oH6=SBZA+PhZMrSK1KjxoRN6L2vqd=GTBKKTQA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For anybody else interested, if you want your system to automatically 
boot a degraded btrfs array, here are my crib notes, verified working:

***************************** boot degraded

1. edit /etc/grub.d/10_linux, add degraded to the rootflags

     GRUB_CMDLINE_LINUX="rootflags=degraded,subvol=${rootsubvol} 
${GRUB_CMDLINE_LINUX}


2. add degraded to options in /etc/fstab also

UUID=bf9ea9b9-54a7-4efc-8003-6ac0b344c6b5 /               btrfs 
defaults,degraded,subvol=@       0       1


3. Update and reinstall GRUB to all boot disks

update-grub
grub-install /dev/vda
grub-install /dev/vdb

Now you have a system which will automatically start a degraded array.


******************************************************

Side note: sorry, but I absolutely don't buy the argument that "the 
system won't boot without you driving down to its physical location, 
standing in front of it, and hammering panickily at a BusyBox prompt" is 
the best way to find out your array is degraded.  I'll set up a Nagios 
module to check for degraded arrays using btrfs fi list instead, thanks...


On 01/03/2014 06:06 PM, Freddie Cash wrote:
> Why is manual intervention even needed?  Why isn't the filesystem 
> "smart" enough to mount in a degraded mode automatically?​
>
> -- 
> Freddie Cash
> fjwcash@gmail.com <mailto:fjwcash@gmail.com>

