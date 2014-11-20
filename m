Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-36-i2.italiaonline.it ([212.48.25.210]:55802 "EHLO
	smtp-36.italiaonline.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755623AbaKTKRN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Nov 2014 05:17:13 -0500
Message-ID: <546DBFCB.4090506@inwind.it>
Date: Thu, 20 Nov 2014 11:17:47 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: =?UTF-8?B?SmFrb2IgU2Now7xyeg==?= <wertstoffe@nurfuerspam.de>,
        linux-btrfs@vger.kernel.org
Subject: Re: systemd.setenv and a mount.unit
References: <gbjvjb-oqp.ln1@venus.xundeenergie.ssh22.net>
In-Reply-To: <gbjvjb-oqp.ln1@venus.xundeenergie.ssh22.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-11-19 23:48, Jakob Schürz wrote:
> Hi there!
> 
> Another challenge... I'm using btrfs. So i make snapshots from my
> system. And in a script, I make a symlink (for example:
> @system.CURRENT and @system.LAST) for the current and the last
> snapshot.

Interesting, I was unaware that I could mount a subvolume passing
a "soft" link.

> 
> So i want to add 2 entries in grub2 from which i can boot into the
> current and the last snapshot.
> 
> I tried to pass an environmental variable with
> systemd.setenv=BOOTSNAP=@system.CURRENT, and i have a mount-unit
> containing the option
> 
> Options=defaults,nofail,subvol=archive-local/@system.$BOOTSNAP
> 
> but it doesn't work. If i change $BOOTSNAP to CURRENT, the mount
> works. So i made a test.service, containing only StartExec=/bin/echo
> $BOOTSNAP I get the value @system.CURRENT in the logs...

This is more a systemd related question. However it seems that ExecStart 
supports "...basic environment variable substitution..."; but the mount unit
doesn't. This explain your difficulties. Anyway I suggest you to contact the 
systemd developers to get further support; maybe that this could be a add as
TODO item.

> How can I do this mounts?

For the boot, I used the "rootflags=" command line options. This 
usually is interpreted by the initrd/initramfs as option to pass
to the mount command. In my case I have:

	rootflags=subvol=debian

so, the subvol=debian option is passed to mount. When grub-mkconfig
generates the grub menu entries, does so.


> jakob
BR
G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
