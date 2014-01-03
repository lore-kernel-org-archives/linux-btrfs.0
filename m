Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.jrs-s.net ([173.230.137.22]:59764 "EHLO mail.jrs-s.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbaACXXB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jan 2014 18:23:01 -0500
Message-ID: <52C746EA.7000006@jrs-s.net>
Date: Fri, 03 Jan 2014 18:25:30 -0500
From: Jim Salter <jim@jrs-s.net>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>,
        =?ISO-8859-1?Q?Joshua_Sch=FCler?= <joshua.schueler@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs raid1 and btrfs raid10 arrays NOT REDUNDANT
References: <52C73987.7000106@jrs-s.net> <52C73D1A.8060805@gmail.com> <52C7402A.7050605@jrs-s.net> <52C741F5.7030106@gmail.com> <52C74415.3020407@jrs-s.net> <20140103231821.GJ8913@carfax.org.uk>
In-Reply-To: <20140103231821.GJ8913@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yep - had just figured that out and successfully booted with it, and was 
in the process of typing up instructions for the list (and posterity).

One thing that concerns me is that edits made directly to grub.cfg will 
get wiped out with every kernel upgrade when update-grub is run - any 
idea where I'd put this in /etc/grub.d to have a persistent change?

I have to tell you, I'm not real thrilled with this behavior either way 
- it means I can't have the option to automatically mount degraded 
filesystems without the filesystems in question ALWAYS showing as being 
mounted degraded, whether the disks are all present and working fine or 
not. That's kind of blecchy. =\


On 01/03/2014 06:18 PM, Hugo Mills wrote:
> On Fri, Jan 03, 2014 at 06:13:25PM -0500, Jim Salter wrote:
>> Sorry - where do I put this in GRUB? /boot/grub/grub.cfg is still
>> kinda black magic to me, and I don't think I'm supposed to be
>> editing it directly at all anymore anyway, if I remember
>> correctly...
>     You don't need to edit grub.cfg -- when you boot, grub has an edit
> option, so you can do it at boot time without having to use a rescue
> disk.
>
>     Regardless, the thing you need to edit is the line starting
> "linux", and will look something like this:
>
> linux /vmlinuz-3.11.0-rc2-dirty root=UUID=1b6ec419-211a-445e-b762-ae7da27b6e8a ro single rootflags=subvol=fs-root
>
>     If there's a rootflags= option already (as above), add ",degraded"
> to the end. If there isn't, add "rootflags=degraded".
>
>     Hugo.
>
>>>> HOWEVER - this won't allow a root filesystem to mount. How do you deal
>>>> with this if you'd set up a btrfs-raid1 or btrfs-raid10 as your root
>>>> filesystem? Few things are scarier than seeing the "cannot find init"
>>>> message in GRUB and being faced with a BusyBox prompt... which is
>>>> actually how I initially got my scare; I was trying to do a walkthrough
>>>> for setting up a raid1 / for an article in a major online magazine and
>>>> it wouldn't boot at all after removing a device; I backed off and tested
>>>> with a non root filesystem before hitting the list.
>>> Add -o degraded to the boot-options in GRUB.

