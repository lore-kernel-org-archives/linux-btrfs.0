Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:33293 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750962AbdEBN6X (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 May 2017 09:58:23 -0400
Date: Tue, 2 May 2017 15:58:20 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Can I see what device was used to mount btrfs?
Message-ID: <20170502135820.2ft7bsoceeqhnbqf@angband.pl>
References: <1e2e2e5c-5ee8-85c1-1db4-74293d8c9c1e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1e2e2e5c-5ee8-85c1-1db4-74293d8c9c1e@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 30, 2017 at 08:47:43AM +0300, Andrei Borzenkov wrote:
> I'm chasing issue with btrfs mounts under systemd
> (https://github.com/systemd/systemd/issues/5781) - to summarize, systemd
> waits for the final device that makes btrfs complete and mounts it using
> this device name.

Systemd is wrong here -- its approach can possibly work only on clean mounts;
if you need to mount degraded it will hang forever.  Even worse, if it's not
the root filesystem, it will "helpfully" unmount it after you mount manually
(for root fs, it will _try_ to unmount but that obviously fails, resulting
in nothing but some CPU wasted on trying to unmount over and over).

> But in /proc/self/mountinfo we actually see another
> device name. Due to peculiarities of systemd implementation this device
> "does not exist" from systemd PoV.
> 
> Looking at btrfs code I start to suspect that we actually do not know
> what device was used to mount it at all.
> 
> So we always show device with the smallest devid, irrespectively of what
> device was actually used to mount it.

Devices come and go (ok, it's not like you hot-remove disks every day,
but...).  Storing the device that started the mount is pointless: btrfs
can handle removal fine so such a stored device would point nowhere -- or
worse, to some unrelated innocent disk you put in for data recovery (you may
have other plans than re-provisioning that raid).


Meow!
-- 
Don't be racist.  White, amber or black, all beers should be judged based
solely on their merits.  Heck, even if occasionally a cider applies for a
beer's job, why not?
On the other hand, corpo lager is not a race.
