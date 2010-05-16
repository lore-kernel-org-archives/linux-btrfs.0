From: Tomasz Torcz <tomek@pipebreaker.pl>
Subject: Re: Mounting raid without a btrfsctl scan
Date: Sun, 16 May 2010 02:02:58 +0200
Message-ID: <20100516000257.GB651@mother.pipebreaker.pl>
References: <4BEE817A.7060604@gmx.com>
 <201005151636.08437.kreijack@libero.it>
 <AANLkTilwCv-RZvdyVyX9ymamEIXUY0P1cozI0R0Aqa07@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTilwCv-RZvdyVyX9ymamEIXUY0P1cozI0R0Aqa07@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 15, 2010 at 06:47:22PM +0200, Sebastian 'gonX' Jensen wrote:
> >> Would it be possible and feasible to support mounting btrfs
> >> raid/multi-device filesystems without having to run 'btrfsctl -a'?
> >>
> >> Currently, as you may know, if a one wants to attach a btrfs raid
> >> filesystem to a system (usb, hotswap, reboot, etc), the user or program
> >> has to run:
> >>
> >> btrfsctl -a (or similar)
> >> mount /dev/sdb1 /mount/point
> >>
> >> While this works, it will require patching of various subsystems
> >> involved with managing disks, such as udev, mkinitrd, dracut, hal, and
> >> others. Each one will have to know to scan, then mount.
> >
> > In a my previous post ([RFC] btrfs, udev and btrfs - 16/April 2010), I
> > suggested a solution for this kind of problem. I a Debian/Ubuntu system it is
> > not necessary to patch anything, it is only required to put some files in the
> > initramfs-tool configure directories.
> >
> > IIRC, also the md (RAID) subsystem require a scan from the user space to find
> > and activate the volumes. I think also dm (LVM) subsystem requires the same.
> >
> 
> md does not require a scan from userspace with at least both RAID-0
> and RAID-1. There's a setting in the kernel config you can set, which
> will automatically detect all RAID drives with the FD partition flag
> set. DM may however be true.


  MD will only detect RAID on MS-DOS partitions (seldom used when RAIDing
whole devices, not possible to use with devices >2 TiB) and metadata
0.90, which is not default. Userspace probing is general way kernel 
subsystem are going, it is more flexible.
  And dracut already has btrfs module.

-- 
Tomasz Torcz              ,,If you try to upissue this patchset I shall be seeking
xmpp: zdzichubg@chrome.pl   an IP-routable hand grenade.'' -- Andrew Morton (LKML)

