From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Filesystem not mountable after reset, bad tree block
Date: Sat, 07 Jan 2012 13:05:08 +0100
Message-ID: <k0plt8-ljc.ln1@hurikhan.ath.cx>
References: <201201052359.47932.harv@ruin.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

Michael Andreen <harv@ruin.nu> schrieb:
> The find-root program seems to think there is a root (and poentially some
> older roots?), but not sure how to use that information.
[...]
> Anything else I can do to debug this or potentially recover a few bits
> before reformatting?

You could try the recovery programs from Josefs btrfs-progs tree[1]. You 
could also try using kernel 3.2 which allows mounting in recovery mode. This 
mode tries to find an older tree root. But I think your kernel did not keep 
tree root backups for this purpose as it is AFAIR a feature of later 
kernels.

Better use a newer kernel - best use 3.2. There are bunch of fixes which 
improve the situation with lost file systems after unexpected reboots or 
power outages.

HTH
Kai

[1] https://github.com/josefbacik/btrfs-progs

