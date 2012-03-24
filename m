From: Sander <sander@humilis.net>
Subject: Re: "Invalid argument" when mounting a btrfs raid1 filesystem
Date: Sat, 24 Mar 2012 19:16:44 +0100
Message-ID: <20120324181644.GA28243@attic.humilis.net>
References: <87vclt99tg.fsf@falma.de>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Christoph Groth <cwg@falma.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <87vclt99tg.fsf@falma.de>
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Groth wrote (ao):
> I'm trying to install current Debian testing (=kernel version 3.2) with
> btrfs as the root file system.  There is also a small ext3 /boot
> partition.
> 
> I create a btrfs raid1 file system with the command
> 
> mkfs.btrfs -d raid1 /dev/sda2 /dev/sdb2
> 
> Then I can mount it and finish the installation successfully.  Booting
> doesn't work, however: initrd complains that it cannot mount /dev/sda2:
> "Invalid argument".
> 
> The funny thing is, that in the initrd console I can mount /dev/sdb2!
> So I changed the kernel parameter in grub.cfg to mount /dev/sdb2
> instead, but the problem persists: Now I can mount /dev/sda2 in the
> initrd console!
> 
> In fact, when I boot a rescue system from a thumbdrive, the same thing
> happens:
> 
> # mount -t btrfs /dev/sda2 /mnt
> mount: mounting /dev/sda2 on /mnt failed: Invalid argument
> # mount -t btrfs /dev/sdb2 /mnt
> #
> 
> When I keep trying to mount the same device, it keeps failing.  When I
> start mounting /dev/sdb2, it works for /dev/sda2...
> 
> Isn't this very weird?  Any ideas?

You might need 'btrfs device scan' before you can mount a multi-device
filesystem.

	Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
