Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:48072 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751787AbeA3Pkn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 10:40:43 -0500
Date: Tue, 30 Jan 2018 16:40:42 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: degraded permanent mount option
Message-ID: <20180130154042.GD7126@polanet.pl>
References: <111ca301-f631-694d-93eb-b73a790f57d4@gmail.com>
 <20180127110619.GA10472@polanet.pl>
 <20180127132641.mhmdhpokqrahgd4n@angband.pl>
 <pan$49d38$869e8d62$c0063169$584b8866@cox.net>
 <20180128003910.GA31699@polanet.pl>
 <CAJCQCtSo12iFeyg3DSWNmOwtXHHk_sdg_MDJUrAM+Q1oaOJcAA@mail.gmail.com>
 <20180128223946.GA26726@polanet.pl>
 <CAJCQCtQi+Lks6SxrGkyQ1xF-_mJM2bDYMiBnQXt6hk7qikuwWA@mail.gmail.com>
 <20180129085404.GA2500@polanet.pl>
 <CAJCQCtSx89hjvQ+030KOPx5Xb2bbW8xc8w0zOf=V3A-QXtvMQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <CAJCQCtSx89hjvQ+030KOPx5Xb2bbW8xc8w0zOf=V3A-QXtvMQg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 29, 2018 at 21:44:23 -0700, Chris Murphy wrote:

> Btrfs is orthogonal to systemd's willingness to wait forever while
> making no progress. It doesn't matter what it is, it shouldn't wait
> forever.

It times out after 90 seconds (by default) and then it fails the mount
entirely.

> It occurs to me there are such systemd service units specifically for
> waiting for example
> 
> systemd-networkd-wait-online.service, systemd-networkd-wait-online -
> Wait for network to
>        come online
> 
>  chrony-wait.service - Wait for chrony to synchronize system clock
> 
> NetworkManager has a version of this. I don't see why there can't be a
> wait for Btrfs to normally mount,

Because mounting degraded btrfs without -o degraded won't WAIT for
anything just immediatelly return failed.

> just simply try to mount, it fails, wait 10, try again, wait 10 try again.

For the last time:

No
	Such
		Logic
			In
				Systemd
						CORE

Every wait/repeat is done using UNITS - as you already noticed
itself. And these are plain, regular UNITS.

Is there anything that prevents YOU, Chris, from writing these UNITS for
btrfs?

I know what makes ME stop writing these units - it's lack of feedback
from btrfs.ko ioctl handler. Without this I am unable to write UNITS
handling fstab mount entries, because the logic would PROBABLY have to
be hardcoded inside systemd-fstab-generator.

And such logic MUST NOT be hardcoded - this MUST be user-configurable,
i.e. made on UNITS level.

You might argue that some-distros-SysV units or some Gentoo-OpenRC have
support for this and if you want to change anything this is only a few
lines of shell code to be altered. But systemd-fstab-generator is
compiled binary and so WON'T allow the behaviour to be user-configurable.

> And then fail the unit so we end up at a prompt.

This can also be easily done, just like emergency-shell spawns
when configured. If only btrfs could accept and keep information about
volume being allowed for degraded mount.


OK, to be honest I _can_ write such rules now, keeping the
'allow-degraded' state somewhere else (in a file for example).

But since this is some non-standarized side-channel, such code won't
be accepted in systemd upstream, especially because it requires the
current udev rule to be slightly changed.

-- 
Tomasz Pala <gotar@pld-linux.org>
