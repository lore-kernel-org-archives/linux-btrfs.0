From: Matt Brown <shadowfax@gmx.com>
Subject: Mounting raid without a btrfsctl scan
Date: Sat, 15 May 2010 05:11:54 -0600
Message-ID: <4BEE817A.7060604@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Would it be possible and feasible to support mounting btrfs
raid/multi-device filesystems without having to run 'btrfsctl -a'?

Currently, as you may know, if a one wants to attach a btrfs raid
filesystem to a system (usb, hotswap, reboot, etc), the user or program
has to run:

btrfsctl -a (or similar)
mount /dev/sdb1 /mount/point

While this works, it will require patching of various subsystems
involved with managing disks, such as udev, mkinitrd, dracut, hal, and
others. Each one will have to know to scan, then mount.

For example, I have a system that has a btrfs raid1 as root. However, I
had to patch the boot loader (dracut) so during boot it would scan just
before mounting the root filesystem.

I filed a bug with dracut, but the more I think of it, the more it seems
that either mount.btrfs should be taking care of this, or another part
of btrfs.

Any thoughts or plans on the matter?

Thanks,
Matt

