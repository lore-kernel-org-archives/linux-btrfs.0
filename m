Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:39827 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756885AbdLWCwt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Dec 2017 21:52:49 -0500
Date: Sat, 23 Dec 2017 03:52:47 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Unexpected raid1 behaviour
Message-ID: <20171223025247.GA3427@polanet.pl>
References: <20171218194351.GA25245@polanet.pl>
 <7ff86029-5b0f-1d02-778a-af78c6f3e461@gmail.com>
 <20171219144644.GA9855@polanet.pl>
 <CAJCQCtSwfoSmAfFyP15xp-uysBY1kWyt65Jhf37g68YcPQ2QEA@mail.gmail.com>
 <20171219204155.GB14726@polanet.pl>
 <aac98fbf-c94b-1a88-f191-902146ff544f@gmail.com>
 <CAA91j0X_MZ+EjgZMNGrfChBdFed_G3oLttdpYjCOq-vERzoiKw@mail.gmail.com>
 <94b6b4cb-9f1a-c90b-5ffb-fb4d7385526b@gmail.com>
 <20171222160543.GA4199@polanet.pl>
 <CAJCQCtQ=ybjWxPtwBXcRx6-CS=s-FomWHoGpFR+J76q+gdLM+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <CAJCQCtQ=ybjWxPtwBXcRx6-CS=s-FomWHoGpFR+J76q+gdLM+w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 22, 2017 at 14:04:43 -0700, Chris Murphy wrote:

> I'm pretty sure degraded boot timeout policy is handled by dracut. The

Well, last time I've checked dracut on systemd-system couldn't even
generate systemd-less image.

> kernel doesn't just automatically assemble an md array as soon as it's
> possible (degraded) and then switch to normal operation as other

MD devices are explicitly listed in mdadm.conf (for mdadm --assemble
--scan) or kernel command line or metadata of autodetected partitions (fd).

> devices appear. I have no idea how LVM manages the delay policy for
> multiple devices.

I *guess* it's not about waiting, but simply being executed after the
devices are ready.

And there is a VERY long history of various init systems having problems
to boot systems using multi-layer setups (LVM/MD under or above LUKS,
not to mention remote ones that need networking to be set up).

All of this works reasonably well under systemd - except for the btrfs
that uses single device node to match entire group of devices. Which is
convenient for living person (no need to switch between /dev/mdX and
/dev/sdX), but impossible to guess automatically by userspace tools.
There is only probe IOCTL which doesn't handle degraded mode.

> I don't think the delay policy belongs in the kernel.

That is exactly why the systemd waits for appropriate udev state.

> It's pie in the sky, and unicorns, but it sure would be nice to have
> standardization rather than everyone rolling their own solution. The

There was a de facto standard I think - expose component devices or
require them to be specified. Apparently no such thing in btrfs, so
it must be handled in btrfs-way.

Also note that MD can be assembled by kernel itself, while btrfs cannot
(so initrd is required for rootfs).

-- 
Tomasz Pala <gotar@pld-linux.org>
