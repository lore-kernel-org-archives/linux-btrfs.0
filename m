Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.jrs-s.net ([173.230.137.22]:58716 "EHLO mail.jrs-s.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385AbaACXK4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jan 2014 18:10:56 -0500
Message-ID: <52C74415.3020407@jrs-s.net>
Date: Fri, 03 Jan 2014 18:13:25 -0500
From: Jim Salter <jim@jrs-s.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Joshua_Sch=FCler?= <joshua.schueler@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfs raid1 and btrfs raid10 arrays NOT REDUNDANT
References: <52C73987.7000106@jrs-s.net> <52C73D1A.8060805@gmail.com> <52C7402A.7050605@jrs-s.net> <52C741F5.7030106@gmail.com>
In-Reply-To: <52C741F5.7030106@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry - where do I put this in GRUB? /boot/grub/grub.cfg is still kinda 
black magic to me, and I don't think I'm supposed to be editing it 
directly at all anymore anyway, if I remember correctly...
>> HOWEVER - this won't allow a root filesystem to mount. How do you deal
>> with this if you'd set up a btrfs-raid1 or btrfs-raid10 as your root
>> filesystem? Few things are scarier than seeing the "cannot find init"
>> message in GRUB and being faced with a BusyBox prompt... which is
>> actually how I initially got my scare; I was trying to do a walkthrough
>> for setting up a raid1 / for an article in a major online magazine and
>> it wouldn't boot at all after removing a device; I backed off and tested
>> with a non root filesystem before hitting the list.
> Add -o degraded to the boot-options in GRUB.

