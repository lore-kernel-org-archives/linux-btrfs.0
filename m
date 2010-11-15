From: Ian Kent <raven@themaw.net>
Subject: Re: Reproducible kernel (2.6.36) oops with several simultaneus
 btrfs mounts
Date: Mon, 15 Nov 2010 09:01:45 +0800
Message-ID: <1289782905.3248.9.camel@localhost>
References: <20101113201536.29617c0d@sacrilege>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-btrfs@vger.kernel.org,
	Gustavo Sverzut Barbieri <barbieri@profusion.mobi>
To: Mike Kazantsev <mk.fraggod@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101113201536.29617c0d@sacrilege>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2010-11-13 at 20:15 +0500, Mike Kazantsev wrote:
> Good day.
> 
> 
> I'm experiencing a kernel oops when systemd tries to fsck and mount
> several btrfs filesystems pretty much simultaneously on boot.
> Oops is highly reproducible for me and causes system to hang, sometimes
> triggering some kind of oops-loop, dumping backtraces into console
> until the power is killed.
> 
> I've mentioned systemd (init system, like sysvinit or upstart), because
> I haven't encountered the issue until I've installed it, and then I've
> got it right on the first (successful) systemd boot.
> Also, looks like I'm not alone in this, since the issue was raised on
> systemd-devel mailing list:
>   http://thread.gmane.org/gmane.comp.sysutils.systemd.devel/704
>   http://article.gmane.org/gmane.comp.sysutils.systemd.devel/721
> 
> Since I've used vm (qemu-kvm) replica of physical machine to test
> systemd migration, that's where I've first encountered it.
> 
> Symptoms are exactly the same on real hardware, so I doubt it's related
> to my specs, but since vm is nearly identical (rsync'ed from) to the
> real setup, guess it might be related to some particular initrd / lvm /
> whatever setup.
> 
> I believe I've seen it first with 2.6.36-rc8, and now wih 2.6.36
> mainline kernel. Haven't tried 2.6.35, because systemd seem to rely on
> newer kernel features.
> Uname -a (I use same kernel for physical machine and vm):
>   Linux sacrilege 2.6.36-fg.roam #9 SMP PREEMPT Wed Oct 27 14:22:03 YEKST 2010 i686 GNU/Linux
> 
> Keywords: btrfs, systemd, init, boot, fsck, mount, oops, hang, loop, 2.6.36
> 
> 
> 
> Oops message (both links lead to the same data):
>   http://fraggod.net/share/systemd_btrfs_oops/oops.txt
>   http://paste.pocoo.org/raw/290857/

Yes, this was reported on this list recently against a 2.6.35 based
kernel.

I know what causes it and I'm working on it but I'm not yet sure of the
best way to fix it.

> 
> 
> 
> There's also a kernel/initrd/disk-image combo, which demonstrates the
> issue. It's i686 (32-bit) exherbo linux setup with all fs's on lvm
> volumes.
> 
> Multiple btrfs mounts are a bit archaic and unnecessary here, and I'll
> probably get rid of these in a nearby future, but guess that's not the
> reason it shouldn't work or crash like that.
>   http://fraggod.net/share/systemd_btrfs_oops/vm-kernel-2.6.36.img
>   http://fraggod.net/share/systemd_btrfs_oops/vm-initrd.lzma
>   http://fraggod.net/share/systemd_btrfs_oops/vm-disk.qcow2.xz
> 
> Also, you can get all these via bittorrent (I may be able to add a few
> extra seeds there, for greater download speeds):
>   http://fraggod.net/share/systemd_btrfs_oops/systemd_btrfs_oops_vm.torrent
>   http://linuxtracker.org/download.php?id=a9f34f3c871b4d177dc1f8384bd2bb3f261a1297&f=systemd_btrfs_oops_vm.torrent
> 
> I've cleaned disk image from most of the unrelated stuff (it was a
> desktop setup, after all), but it's still 250M download (with xz
> compression) and 1.5G uncompressed.
> 
> I can reliably reproduce the issue with the following commands:
>   qemu-system-x86_64 -kernel vm-kernel-2.6.36.img -initrd vm-initrd.lzma\
>    -append 'ro root=/dev/ram0 lvroot=LABEL=root lvetc=LABEL=etc console=ttyS0'\
>    -drive file=vm-disk.qcow2,if=virtio -nographic -monitor null -serial pty &
>   screen /dev/pty/X
>    (to attach to pty device, echoed by qemu)
> 
> You can omit -nographic, -serial and -monitor qemu options and
> "console=" cmdline to run qemu with sdl window.
> 
> If it doesn't crash and gets to getty login prompt, try killing vm (so
> filesystems won't be cleanly unmounted, although it doesn't seem to be
> the cause for me) and restarting it with the same command.
> 
> 
> Kernel configuration (I use this config for both vm-guest kernel and
> for the real hardware, which hosts vm):
>   http://fraggod.net/share/systemd_btrfs_oops/kconfig.txt
> 
> 
> I'll probably also be able to attach sequence of actions executed by
> systemd (leading to this crash) a bit later.
> If there's any additional information I can provide or any test I
> should run on the setup, I'd be happy to do so.
> 
> 
> Thank you for your attention.
> 
> 


