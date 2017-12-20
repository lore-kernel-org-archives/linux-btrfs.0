Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:35764 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754564AbdLTIv3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Dec 2017 03:51:29 -0500
Date: Wed, 20 Dec 2017 09:51:27 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Unexpected raid1 behaviour
Message-ID: <20171220085127.GA25056@polanet.pl>
References: <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
 <23094.37316.66397.431081@tree.ty.sabi.co.uk>
 <91965e24-3b94-7334-c249-d8de5f585f29@gmail.com>
 <20171218194351.GA25245@polanet.pl>
 <7ff86029-5b0f-1d02-778a-af78c6f3e461@gmail.com>
 <20171219144644.GA9855@polanet.pl>
 <CAJCQCtSwfoSmAfFyP15xp-uysBY1kWyt65Jhf37g68YcPQ2QEA@mail.gmail.com>
 <20171219204155.GB14726@polanet.pl>
 <CAJCQCtQPmov53Q=BTzywawkW2froYx49M+ez9WZsRy2cp-b3+w@mail.gmail.com>
 <20171220083448.GA25687@polanet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <20171220083448.GA25687@polanet.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Errata:

On Wed, Dec 20, 2017 at 09:34:48 +0100, Tomasz Pala wrote:

> /dev/sda -> 'not ready'
> /dev/sdb -> 'not ready'
> /dev/sdc -> 'ready', triggers /dev/sda -> 'not ready' and /dev/sdb - still 'not ready'
> /dev/sdc -> kernel says 'ready', triggers /dev/sda - 'ready' and /dev/sdb -> 'ready'

The last line should start with /dev/sdd.

> After such timeout, I'd like to tell the kernel: "no more devices, give
> me all the remaining btrfs volumes in degraded mode if possible". By

Actually "if possible" means both:
- if technically possible (i.e. required data is available, like half of RAID1),
- AND if allowed for specific volume as there might be different policies.

For example - one might allow rootfs to be started in degraded-rw mode in
order for the system to boot up, /home in degraded read-only for the
users to have access to their files and do not mount /srv degraded at all.
The failed mount can be non-critical with 'nofail' fstab flag.

> "give me btrfs vulumes" I mean "mark them as 'ready'" so the udev could
> fire it's rules. And if there would be anything for udev to distinguish
> 'ready' from 'ready-degraded' one could easily compose some notification
> scripting on top of it, including sending e-mail to sysadmin.

-- 
Tomasz Pala <gotar@pld-linux.org>
