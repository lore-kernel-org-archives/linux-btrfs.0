Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:35894 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbcHODqg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Aug 2016 23:46:36 -0400
Received: by mail-wm0-f48.google.com with SMTP id q128so70195358wma.1
        for <linux-btrfs@vger.kernel.org>; Sun, 14 Aug 2016 20:46:36 -0700 (PDT)
Subject: Re: Likelihood of read error, recover device failure raid10
To: Chris Murphy <lists@colorremedies.com>,
        Wolfgang Mader <Wolfgang_Mader@brain-frog.de>
References: <2336793.AMaAIAxWk4@discus>
 <CAJCQCtR1odXy1WjR3+tWZsb=d1=VFdpZiFk90oPeykoDTvw1Uw@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <75e9c7f4-db49-1673-2d93-543968bd661c@gmail.com>
Date: Mon, 15 Aug 2016 06:46:32 +0300
MIME-Version: 1.0
In-Reply-To: <CAJCQCtR1odXy1WjR3+tWZsb=d1=VFdpZiFk90oPeykoDTvw1Uw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

14.08.2016 19:20, Chris Murphy пишет:
...
> 
> This volume now has about a dozen chunks created by kernel code, and
> the stripe X to devid Y mapping is identical. Using dd and hexdump,
> I'm finding that stripe 0 and 1 are mirrored pairs, they contain
> identical information. And stripe 2 and 3 are mirrored pairs. And the
> raid0 striping happens across 01 and 23 such that odd-numbered 64KiB
> (default) stripe elements go on 01, and even-numbered stripe elements
> go on 23. If the stripe to devid pairing were always consistent, I
> could lose more than one device and still have a viable volume, just
> like a conventional raid10. Of course you can't lose both of any
> mirrored pair, but you could lose one of every mirrored pair. That's
> why raid10 is considered scalable.
> 
> But apparently the pairing is different between mkfs and kernel code.

My understanding is, that chunk allocation code is using devices in
order they have been discovered. Which implies that that can change
between reboots or even during system run if devices are added/removed.

Also I think code may skip devices under some condition (most obvious
being not enough space, may happen if you mix allocation profiles).

So the only thing that is guaranteed right now is that every stripe
element will be on different device.

