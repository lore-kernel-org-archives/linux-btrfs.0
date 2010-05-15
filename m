From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: Mounting raid without a btrfsctl scan
Date: Sat, 15 May 2010 16:36:08 +0200
Message-ID: <201005151636.08437.kreijack@libero.it>
References: <4BEE817A.7060604@gmx.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org
To: Matt Brown <shadowfax@gmx.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4BEE817A.7060604@gmx.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday 15 May 2010, Matt Brown wrote:
> Hi,
Hi Matt,
> 
> Would it be possible and feasible to support mounting btrfs
> raid/multi-device filesystems without having to run 'btrfsctl -a'?
> 
> Currently, as you may know, if a one wants to attach a btrfs raid
> filesystem to a system (usb, hotswap, reboot, etc), the user or program
> has to run:
> 
> btrfsctl -a (or similar)
> mount /dev/sdb1 /mount/point
> 
> While this works, it will require patching of various subsystems
> involved with managing disks, such as udev, mkinitrd, dracut, hal, and
> others. Each one will have to know to scan, then mount.

In a my previous post ([RFC] btrfs, udev and btrfs - 16/April 2010), I 
suggested a solution for this kind of problem. I a Debian/Ubuntu system it is 
not necessary to patch anything, it is only required to put some files in the 
initramfs-tool configure directories.

IIRC, also the md (RAID) subsystem require a scan from the user space to find 
and activate the volumes. I think also dm (LVM) subsystem requires the same.

> 
> For example, I have a system that has a btrfs raid1 as root. However, I
> had to patch the boot loader (dracut) so during boot it would scan just
> before mounting the root filesystem.
> 
> I filed a bug with dracut, but the more I think of it, the more it seems
> that either mount.btrfs should be taking care of this, or another part
> of btrfs.

If it would be mount.btrfs to perform the scan, that means a scan for every 
mounting. I think that is better to separate the two function. The scan has to 
be performed a device discovery time, and not a the mounting time.


> 
> Any thoughts or plans on the matter?
> 
> Thanks,
> Matt

BR
Goffredo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
