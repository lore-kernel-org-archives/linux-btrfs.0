From: Mike Kazantsev <mk.fraggod@gmail.com>
Subject: Reproducible kernel (2.6.36) oops with several simultaneus btrfs
 mounts
Date: Sat, 13 Nov 2010 20:15:36 +0500
Message-ID: <20101113201536.29617c0d@sacrilege>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/IUKjrkpxoEQGnUSB2h2fjeC"; protocol="application/pgp-signature"
Cc: Gustavo Sverzut Barbieri <barbieri@profusion.mobi>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/IUKjrkpxoEQGnUSB2h2fjeC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Good day.


I'm experiencing a kernel oops when systemd tries to fsck and mount
several btrfs filesystems pretty much simultaneously on boot.
Oops is highly reproducible for me and causes system to hang, sometimes
triggering some kind of oops-loop, dumping backtraces into console
until the power is killed.

I've mentioned systemd (init system, like sysvinit or upstart), because
I haven't encountered the issue until I've installed it, and then I've
got it right on the first (successful) systemd boot.
Also, looks like I'm not alone in this, since the issue was raised on
systemd-devel mailing list:
  http://thread.gmane.org/gmane.comp.sysutils.systemd.devel/704
  http://article.gmane.org/gmane.comp.sysutils.systemd.devel/721

Since I've used vm (qemu-kvm) replica of physical machine to test
systemd migration, that's where I've first encountered it.

Symptoms are exactly the same on real hardware, so I doubt it's related
to my specs, but since vm is nearly identical (rsync'ed from) to the
real setup, guess it might be related to some particular initrd / lvm /
whatever setup.

I believe I've seen it first with 2.6.36-rc8, and now wih 2.6.36
mainline kernel. Haven't tried 2.6.35, because systemd seem to rely on
newer kernel features.
Uname -a (I use same kernel for physical machine and vm):
  Linux sacrilege 2.6.36-fg.roam #9 SMP PREEMPT Wed Oct 27 14:22:03 YEKST 2=
010 i686 GNU/Linux

Keywords: btrfs, systemd, init, boot, fsck, mount, oops, hang, loop, 2.6.36



Oops message (both links lead to the same data):
  http://fraggod.net/share/systemd_btrfs_oops/oops.txt
  http://paste.pocoo.org/raw/290857/



There's also a kernel/initrd/disk-image combo, which demonstrates the
issue. It's i686 (32-bit) exherbo linux setup with all fs's on lvm
volumes.

Multiple btrfs mounts are a bit archaic and unnecessary here, and I'll
probably get rid of these in a nearby future, but guess that's not the
reason it shouldn't work or crash like that.
  http://fraggod.net/share/systemd_btrfs_oops/vm-kernel-2.6.36.img
  http://fraggod.net/share/systemd_btrfs_oops/vm-initrd.lzma
  http://fraggod.net/share/systemd_btrfs_oops/vm-disk.qcow2.xz

Also, you can get all these via bittorrent (I may be able to add a few
extra seeds there, for greater download speeds):
  http://fraggod.net/share/systemd_btrfs_oops/systemd_btrfs_oops_vm.torrent
  http://linuxtracker.org/download.php?id=3Da9f34f3c871b4d177dc1f8384bd2bb3=
f261a1297&f=3Dsystemd_btrfs_oops_vm.torrent

I've cleaned disk image from most of the unrelated stuff (it was a
desktop setup, after all), but it's still 250M download (with xz
compression) and 1.5G uncompressed.

I can reliably reproduce the issue with the following commands:
  qemu-system-x86_64 -kernel vm-kernel-2.6.36.img -initrd vm-initrd.lzma\
   -append 'ro root=3D/dev/ram0 lvroot=3DLABEL=3Droot lvetc=3DLABEL=3Detc c=
onsole=3DttyS0'\
   -drive file=3Dvm-disk.qcow2,if=3Dvirtio -nographic -monitor null -serial=
 pty &
  screen /dev/pty/X
   (to attach to pty device, echoed by qemu)

You can omit -nographic, -serial and -monitor qemu options and
"console=3D" cmdline to run qemu with sdl window.

If it doesn't crash and gets to getty login prompt, try killing vm (so
filesystems won't be cleanly unmounted, although it doesn't seem to be
the cause for me) and restarting it with the same command.


Kernel configuration (I use this config for both vm-guest kernel and
for the real hardware, which hosts vm):
  http://fraggod.net/share/systemd_btrfs_oops/kconfig.txt


I'll probably also be able to attach sequence of actions executed by
systemd (leading to this crash) a bit later.
If there's any additional information I can provide or any test I
should run on the setup, I'd be happy to do so.


Thank you for your attention.


--=20
Mike Kazantsev // fraggod.net

--Sig_/IUKjrkpxoEQGnUSB2h2fjeC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEARECAAYFAkzeq5sACgkQASbOZpzyXnHesACdHBx3eKsWyhrKnz4bZStF9giO
PpAAn12jUV4APIycLUvQlyGjA0kvDatX
=RVkL
-----END PGP SIGNATURE-----

--Sig_/IUKjrkpxoEQGnUSB2h2fjeC--


