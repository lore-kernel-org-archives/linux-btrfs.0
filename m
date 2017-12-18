Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:42028 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932764AbdLRTnw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Dec 2017 14:43:52 -0500
Date: Mon, 18 Dec 2017 20:43:51 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Unexpected raid1 behaviour
Message-ID: <20171218194351.GA25245@polanet.pl>
References: <5A357909.8010206@yandex.ru>
 <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
 <23094.37316.66397.431081@tree.ty.sabi.co.uk>
 <91965e24-3b94-7334-c249-d8de5f585f29@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <91965e24-3b94-7334-c249-d8de5f585f29@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 18, 2017 at 08:06:57 -0500, Austin S. Hemmelgarn wrote:

> The fact is, the only cases where this is really an issue is if you've 
> either got intermittently bad hardware, or are dealing with external 

Well, the RAID1+ is all about the failing hardware.

> storage devices.  For the majority of people who are using multi-device 
> setups, the common case is internally connected fixed storage devices 
> with properly working hardware, and for that use case, it works 
> perfectly fine.

If you're talking about "RAID"-0 or storage pools (volume management)
that is true.
But if you imply, that RAID1+ "works perfectly fine as long as hardware
works fine" this is fundamentally wrong. If the hardware needs to work
properly for the RAID to work properly, noone would need this RAID in
the first place.

> that BTRFS should not care.  At the point at which a device is dropping 
> off the bus and reappearing with enough regularity for this to be an 
> issue, you have absolutely no idea how else it's corrupting your data, 
> and support of such a situation is beyond any filesystem (including ZFS).

Support for such situation is exactly what RAID performs. So don't blame
people for expecting this to be handled as long as you call the
filesystem feature a 'RAID'.

If this feature is not going to mitigate hardware hiccups by design (as
opposed to "not implemented yet, needs some time", which is perfectly
understandable), just don't call it 'RAID'.

All the features currently working, like bit-rot mitigation for
duplicated data (dup/raid*) using checksums, are something different
than RAID itself. RAID means "survive failure of N devices/controllers"
- I got one "RAID1" stuck in r/o after degraded mount, not nice... Not
_expected_ to happen after single disk failure (without any reappearing).

-- 
Tomasz Pala <gotar@pld-linux.org>
