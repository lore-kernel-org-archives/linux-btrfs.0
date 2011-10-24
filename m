From: Stephane CHAZELAS <stephane_chazelas@yahoo.fr>
Subject: Re: how stable are snapshots at the block level?
Date: Mon, 24 Oct 2011 12:36:28 +0000 (UTC)
Message-ID: <slrnjaamuc.jcd.stephane.chazelas@spam.is.invalid>
References: <CAKvOHKABup6D2pwbiZpCfxoHt7Obv6sHAZqcPp=ce9ZcJ8-vuw@mail.gmail.com>
 <000101cc918d$3ffb45b0$bff1d110$@nedharvey.com>
 <CAKvOHKCjxxKTahivOuRBPBB89JBrTwndQ6cCEuFaPbJr8PYtpA@mail.gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

2011-10-23, 17:19(+02), Mathijs Kwik:
[...]
> For this case (my laptop) I can stick to file-based rsync, but I think
> some guarantees should exist at the block level. Many virtual machines
> and cloud hosting services (like ec2) provide block-level snapshots.
> With xfs, I can freeze the filesystem for a short amount of time
> (<100ms), snapshot, unfreeze. I don't think such a lock/freeze feature
> exists for btrfs
[...]

That FS-freeze feature has been moved to the vfs layer so is
available to any filesystem now.

You can either use xfs_io (see -F option to "freeze" for foreign
FS) like for xfs FS or use fsfreeze from util-linux.

Note that you can thaw file systems with a sysrq combination
now. (for instance with xen using "xm sysrq vm j").

For block level snapshots, see also ddsnap (device mapper target
unfortunately no longer maintained) and lvm of course (but
doesn't scale well with several snapshots).

-- 
Stephane

