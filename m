Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57087 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172AbbCaXjC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Mar 2015 19:39:02 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Yd5kI-0008Iz-LX
	for linux-btrfs@vger.kernel.org; Wed, 01 Apr 2015 01:38:58 +0200
Received: from ip18864262.dynamic.kabel-deutschland.de ([24.134.66.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Apr 2015 01:38:58 +0200
Received: from hurikhan77 by ip18864262.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Apr 2015 01:38:58 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: F21 fails to mount root part, btrfs check: Couldn't open file system
Date: Wed, 01 Apr 2015 01:38:35 +0200
Message-ID: <ronrub-mln.ln1@hurikhan77.spdns.de>
References: <CACPiFCJwQTsVcU2CJpSMyGyL1jsEQooMvOHooZriM70SsmGgVA@mail.gmail.com> <CAJCQCtTVAkJM6JE68a8vopKZqaSwfXCL9Bp8mGx-pDqny-h9ZQ@mail.gmail.com> <CAJCQCtQ9PCv5pNMapQabLBKHOS86B+zavcKsQOiR2Q9qOrxv6g@mail.gmail.com> <b5hrub-586.ln1@hurikhan77.spdns.de> <CAJCQCtRn4sjDV1skkpJBjwjfXr18F502Q9G6p_4ZdRg27J4bXg@mail.gmail.com> <CAJCQCtRZuUvmYnZh1_UV7nEkT4rFZprzhs3qfFx1yQCJYBOJ0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy <lists@colorremedies.com> schrieb:

> On Tue, Mar 31, 2015 at 4:15 PM, Chris Murphy <lists@colorremedies.com>
> wrote:
> 
>> The i915 regression right now is really annoying. With a Samsung 840
>> EVO I've  had inexplicable and non-deterministic boot failures.
> 
> Clarification: the boot failures happen following the i915 panic and
> subsequent forced power off.

Yeah I thought that, too, because after hitting "reset" it looked like one 
hard disk didn't appear in dmesg and thus btrfs didn't mount (btrfs-raid). 
So I turned the machine off completely because I had similar issues with 
i915 freezes and strange boot issues during the following boot before. It 
looks like the GPU is not necessarily completely reset when hitting the 
reset button. But that's another story.

In my case the hard disk was there - I didn't just scan hard enough through 
the huge pile of logs. I had to btrfs-zero-log, wrote "reboot" into the 
rescue shell, kernel came back, mount still locking up and sitting there 
until systemd decided to throw me to emergency after 5 minutes of waiting or 
so. I've rebooted again, machine came up. This was a few reboots after the 
machine was powered off, so I'd rule any GPU freeze artifacts out here. I 
just needed multiple reboots to arrange myself with my dracut/systemd combo 
super hero voodoo abilities (read: I cumbersome tried everything until one 
thing worked while swearing at my innocent monitor, well sort of, it's 
powered by the GPU).

On every reboot it felt like bcache was replaying cache transactions - but I 
think this is by design (read: bcache is always dirty, even after a clean 
shutdown, if using write-back mode) and not part of the problem.

-- 
Replies to list only preferred.

