Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49870 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756251AbcARVEp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jan 2016 16:04:45 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aLGyf-0000th-NR
	for linux-btrfs@vger.kernel.org; Mon, 18 Jan 2016 22:04:41 +0100
Received: from ip5f5ae075.dynamic.kabel-deutschland.de ([95.90.224.117])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jan 2016 22:04:41 +0100
Received: from hurikhan77 by ip5f5ae075.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jan 2016 22:04:41 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: space_cache=v2 on root fs
Date: Mon, 18 Jan 2016 22:04:24 +0100
Message-ID: <20160118220424.0a77dc71@jupiter.sol.kaishome.de>
References: <20160118182717.GA321@x4>
	<20160118191243.GA321@x4>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mon, 18 Jan 2016 20:12:43 +0100
schrieb Markus Trippelsdorf <markus@trippelsdorf.de>:

> On 2016.01.18 at 19:27 +0100, Markus Trippelsdorf wrote:
> > Hi,
> > 
> > while testing the new space_cache=v2 mount option it looks like my
> > root fs doesn't automatically create the new space cache.
> > 
> > I'm using the following /etc/fstab:
> > 
> > UUID=7ef56edc-673e-452e-9e05-3fabf074168b       /
> > btrfs           noatime,compress=lzo,space_cache=v2             0 0
> > UUID=6b7d75bf-3d12-409c-88ed-500ac6b78510       /var
> > btrfs           compress=lzo,space_cache=v2                     0 0
> > UUID=24cee7e4-9093-4f86-aa73-d8a59d7f3c6c       /var/tmp
> > btrfs           compress=lzo,space_cache=v2                     0 0
> > 
> > During first mount the space cache was created for /var (/dev/sdb2)
> > and /var/tmp (/dev/sda3), but apparently not for / (/dev/sdc3):
> > 
> > Jan 18 18:48:18 x4 kernel: BTRFS info (device sdb2): enabling free
> > space tree Jan 18 18:48:18 x4 kernel: BTRFS info (device sdb2):
> > using free space tree Jan 18 18:48:18 x4 kernel: BTRFS: creating
> > free space tree Jan 18 18:48:18 x4 kernel: BTRFS info (device
> > sdb2): setting 1 ro feature flag Jan 18 18:48:18 x4 kernel: BTRFS:
> > checking UUID tree Jan 18 18:48:18 x4 kernel: BTRFS info (device
> > sda3): enabling free space tree Jan 18 18:48:18 x4 kernel: BTRFS
> > info (device sda3): using free space tree Jan 18 18:48:18 x4
> > kernel: BTRFS: has skinny extents Jan 18 18:48:18 x4 kernel: BTRFS:
> > detected SSD devices, enabling SSD mode Jan 18 18:48:18 x4 kernel:
> > BTRFS: creating free space tree Jan 18 18:48:18 x4 kernel: BTRFS
> > info (device sda3): setting 1 ro feature flag Jan 18 18:48:18 x4
> > kernel: BTRFS: checking UUID tree Jan 18 18:48:22 x4 kernel: BTRFS
> > info (device sdc3): enabling free space tree Jan 18 18:48:22 x4
> > kernel: BTRFS info (device sdc3): using free space tree
> > 
> > During subsequent boots the "enabling free space tree" message is
> > repeated every time for the root fs.
> > 
> > Jan 18 18:53:48 x4 kernel: BTRFS info (device sdb2): using free
> > space tree Jan 18 18:53:48 x4 kernel: BTRFS info (device sda3):
> > using free space tree Jan 18 18:53:52 x4 kernel: BTRFS info (device
> > sdc3): enabling free space tree Jan 18 18:53:52 x4 kernel: BTRFS
> > info (device sdc3): using free space tree  
> 
> To answer my own question. Adding "rw rootflags=space_cache=v2" to the
> GRUB kernel entry fixes the issue...

This is because the contents of /etc/fstab are not available during
first mount at boot time - for obvious reasons. Actually, the entry for
rootfs in /etc/fstab is more or less a no-op and only there to satisfy
some legacy tools. Some initramfs generators may also use this to
construct a proper grub cmdline. At least dracut seems to rely on other
mechanics, tho. So it's probably obsolete.

There's only one point when it is used: During remount of the fs during
system initialization. But only some mount options can change during
remount, I imagine space_cache is not part of this.

Due to this remount, it is best to keep both in sync: grub cmdline and
fstab.

I think systemd has some efforts of obsoleting the rootfs line from
fstab, however I'm not sure what's the progress here. I still use it
because last time I tried removing it, it had strange effects.

-- 
Regards,
Kai

Replies to list-only preferred.

