Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:63418 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753395AbdBKKSt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 11 Feb 2017 05:18:49 -0500
Received: from thetick.localnet ([93.181.44.247]) by mail.gmx.com (mrgmx002
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0MAgvb-1cinMs2adv-00BpoI for
 <linux-btrfs@vger.kernel.org>; Sat, 11 Feb 2017 11:18:46 +0100
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: [4.7.2] btrfs_run_delayed_refs:2963: errno=-17 Object already exists
Date: Sat, 11 Feb 2017 11:18:39 +0100
Message-ID: <2380483.tGrojfQH67@thetick>
In-Reply-To: <20170211030139.7bff427e@jupiter.sol.kaishome.de>
References: <20160828152908.6e1325b5@jupiter.sol.kaishome.de> <2314132.jQCgNOg6dG@thetick> <20170211030139.7bff427e@jupiter.sol.kaishome.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart5153843.KHxGCnNXpU"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart5153843.KHxGCnNXpU
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Saturday 11 February 2017 03:01:39 Kai Krakow wrote:
> Am Fri, 10 Feb 2017 23:15:03 +0100
>=20
> schrieb Marc Joliet <marcec@gmx.de>:
> > # btrfs filesystem df /media/MARCEC_BACKUP/
> > Data, single: total=3D851.00GiB, used=3D831.36GiB
> > System, DUP: total=3D64.00MiB, used=3D120.00KiB
> > Metadata, DUP: total=3D13.00GiB, used=3D10.38GiB
> > Metadata, single: total=3D1.12GiB, used=3D0.00B
> > GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
> >=20
> > Hmm, I take it that the single metadata is a leftover from running
> > --repair?
>=20
> It's more probably a remnant of an incomplete balance operation or an=

> older mkfs version. I'd simply rebalance metadata to fix this.
>=20
> I don't think that btrfs-repair would migrate missing metadata
> duplicates back to single profile, it would more likely trigger
> recreating the missing duplicates. But I'm not sure.

I'm fairly certain it's from the repair operation, the device didn't ha=
ve any=20
single metadata before (and it still didn't really, notice that used=3D=
0.00B). =20
So my best guess is that it was allocated during the --repair.

> If it is a result of the repair operation, that could be an
> interesting clue. Could it explain "error -17" from your logs? But th=
at
> would mean the duplicates were already missing before the repair
> operation and triggered that problem. So the question is, why are tho=
se
> duplicates missing in the first place as a result of normal operation=
?
> From your logs:

I certainly didn't create them myself, the device has always had metada=
ta=3Ddup=20
(you can check previous threads of mine, which also contain "btrfs fi d=
f"=20
output).  So I don't think it has anything to do with the failures.

> ---8<--- snip
> Feb 02 22:49:14 thetick kernel: BTRFS: device label MARCEC_BACKUP dev=
id
> 1 transid 283903 /dev/sdd2
> Feb 02 22:49:19 thetick kernel: EXT4-fs (sdd1): mounted filesystem wi=
th
> ordered data mode. Opts: (null)
> Feb 03 00:18:52 thetick kernel: BTRFS info (device sdd2): use zlib
> compression Feb 03 00:18:52 thetick kernel: BTRFS info (device sdd2):=

> disk space caching is enabled
> Feb 03 00:18:52 thetick kernel: BTRFS info (device sdd2): has skinny
> extents Feb 03 00:20:09 thetick kernel: BTRFS info (device sdd2): The=

> free space cache file (3967375376384) is invalid. skip it
> Feb 03 01:05:58 thetick kernel: ------------[ cut here ]------------
> Feb 03 01:05:58 thetick kernel: WARNING: CPU: 1 PID: 26544 at
> fs/btrfs/extent- tree.c:2967 btrfs_run_delayed_refs+0x26c/0x290
> Feb 03 01:05:58 thetick kernel: BTRFS: Transaction aborted (error -17=
)
> --->8--- snap
>=20
> "error -17" being "object already exists". My only theory would be th=
is
> has a direct connection to you finding the single metadata profile.
> Like in "the kernel thinks the objects already exists when it really
> didn't, and as a result the object is there only once now" aka "singl=
e
> metadata".
>=20
> But I'm no dev and no expert on the internals.

Again, I don't think it has anything to do with the single metadata.  A=
 "btrfs=20
balance start -mprofile=3Dsingle" got rid of the (empty) single metadat=
a blocks.

What I *can* say is that the error seems to be transient.  For example,=
 I ran=20
an rsync last night that failed with the same error as before.  After=20=

unmounting and mounting the FS again, I could run it to completion (and=
=20
verified some files).

Anyway, here's the whole log since this morning.  I can't correlate ind=
ividual=20
stack traces to specific actions any more, but the rough order of actio=
ns on=20
my part (not counting unmount/mount cycles, those are easy enough to fi=
nd):

=2D backups from the home server run, then
=2D btrfs-cleaner drops old snapshots, after which
=2D I run rsync (which fails), then
=2D I run rsync again (which succeeds), then
=2D I run "balance start -mprofile=3Dsingle", which succeeds (I might hav=
e run=20
this before rsync, I'm not sure), after which
=2D I start backups on my laptop (which fails after I finally went to bed=
, at=20
about 3:58).

After that I just try "btrbk -r run" a few times, which managed to tran=
sfer=20
the first two snapshots before failing.

Feb 11 00:00:06 diefledermaus kernel: usb 1-1: new high-speed USB devic=
e=20
number 4 using ehci-pci
Feb 11 00:00:06 diefledermaus kernel: usb 1-1: New USB device found,=20=

idVendor=3D0480, idProduct=3Dd010
Feb 11 00:00:06 diefledermaus kernel: usb 1-1: New USB device strings: =
Mfr=3D1,=20
Product=3D2, SerialNumber=3D3
Feb 11 00:00:06 diefledermaus kernel: usb 1-1: Product: External USB 3.=
0
Feb 11 00:00:06 diefledermaus kernel: usb 1-1: Manufacturer: Toshiba
Feb 11 00:00:06 diefledermaus kernel: usb 1-1: SerialNumber: 2013042102=
0612
Feb 11 00:00:07 diefledermaus kernel: usb-storage 1-1:1.0: USB Mass Sto=
rage=20
device detected
Feb 11 00:00:07 diefledermaus kernel: usb-storage 1-1:1.0: Quirks match=
 for=20
vid 0480 pid d010: 20000000
Feb 11 00:00:07 diefledermaus kernel: scsi host6: usb-storage 1-1:1.0
Feb 11 00:00:07 diefledermaus kernel: usbcore: registered new interface=
 driver=20
usb-storage
Feb 11 00:00:16 diefledermaus kernel: scsi 6:0:0:0: Direct-Access     T=
oshiba =20
External USB 3.0 0201 PQ: 0 ANSI: 6
Feb 11 00:00:16 diefledermaus kernel: sd 6:0:0:0: Attached scsi generic=
 sg2=20
type 0
Feb 11 00:00:16 diefledermaus kernel: sd 6:0:0:0: [sdb] Very big device=
.=20
Trying to use READ CAPACITY(16).
Feb 11 00:00:16 diefledermaus kernel: sd 6:0:0:0: [sdb] 732566645 4096-=
byte=20
logical blocks: (3.00 TB/2.73 TiB)
Feb 11 00:00:16 diefledermaus kernel: sd 6:0:0:0: [sdb] Assuming Write =
Enabled
Feb 11 00:00:16 diefledermaus kernel: sd 6:0:0:0: [sdb] Assuming drive =
cache:=20
write back
Feb 11 00:00:16 diefledermaus kernel:  sdb: sdb1 sdb2
Feb 11 00:00:16 diefledermaus kernel: sd 6:0:0:0: [sdb] Attached SCSI d=
isk
Feb 11 00:00:16 diefledermaus kernel: BTRFS: device label MARCEC_BACKUP=
 devid=20
1 transid 284246 /dev/sdb2
Feb 11 00:00:16 diefledermaus kernel: BTRFS info (device sdb2): use zli=
b=20
compression
Feb 11 00:00:16 diefledermaus kernel: BTRFS info (device sdb2): disk sp=
ace=20
caching is enabled
Feb 11 00:00:16 diefledermaus kernel: BTRFS info (device sdb2): has ski=
nny=20
extents
Feb 11 00:00:17 diefledermaus kernel: EXT4-fs (sdb1): mounted filesyste=
m with=20
ordered data mode. Opts: (null)
Feb 11 00:01:21 diefledermaus kernel: BTRFS warning (device sdb2): bloc=
k group=20
3831010164736 has wrong amount of free space
Feb 11 00:01:21 diefledermaus kernel: BTRFS warning (device sdb2): fail=
ed to=20
load free space cache for block group 3831010164736, rebuilding it now
Feb 11 00:01:21 diefledermaus kernel: BTRFS warning (device sdb2): bloc=
k group=20
3831547035648 has wrong amount of free space
Feb 11 00:01:21 diefledermaus kernel: BTRFS warning (device sdb2): fail=
ed to=20
load free space cache for block group 3831547035648, rebuilding it now
Feb 11 00:01:21 diefledermaus kernel: BTRFS warning (device sdb2): bloc=
k group=20
3833694519296 has wrong amount of free space
Feb 11 00:01:21 diefledermaus kernel: BTRFS warning (device sdb2): fail=
ed to=20
load free space cache for block group 3833694519296, rebuilding it now
Feb 11 00:01:22 diefledermaus kernel: BTRFS warning (device sdb2): bloc=
k group=20
4649738305536 has wrong amount of free space
Feb 11 00:01:22 diefledermaus kernel: BTRFS warning (device sdb2): fail=
ed to=20
load free space cache for block group 4649738305536, rebuilding it now
Feb 11 00:01:27 diefledermaus kernel: BTRFS warning (device sdb2): bloc=
k group=20
4607325503488 has wrong amount of free space
Feb 11 00:01:27 diefledermaus kernel: BTRFS warning (device sdb2): fail=
ed to=20
load free space cache for block group 4607325503488, rebuilding it now
Feb 11 00:01:37 diefledermaus kernel: BTRFS warning (device sdb2): bloc=
k group=20
3832083906560 has wrong amount of free space                           =
                                                                       =
                                                 =20
Feb 11 00:01:37 diefledermaus kernel: BTRFS warning (device sdb2): fail=
ed to=20
load free space cache for block group 3832083906560, rebuilding it now =
                                                                       =
                                                   =20
Feb 11 00:01:37 diefledermaus kernel: BTRFS warning (device sdb2): bloc=
k group=20
3832620777472 has wrong amount of free space                           =
                                                                       =
                                                 =20
Feb 11 00:01:37 diefledermaus kernel: BTRFS warning (device sdb2): fail=
ed to=20
load free space cache for block group 3832620777472, rebuilding it now =
                                                                       =
                                                   =20
Feb 11 00:01:38 diefledermaus kernel: BTRFS warning (device sdb2): bloc=
k group=20
3833157648384 has wrong amount of free space                           =
                                                                       =
                                                 =20
Feb 11 00:01:38 diefledermaus kernel: BTRFS warning (device sdb2): fail=
ed to=20
load free space cache for block group 3833157648384, rebuilding it now =
                                                                       =
                                                   =20
Feb 11 00:03:06 diefledermaus kernel: BTRFS warning (device sdb2): bloc=
k group=20
3829936422912 has wrong amount of free space                           =
                                                                       =
                                                 =20
Feb 11 00:03:06 diefledermaus kernel: BTRFS warning (device sdb2): fail=
ed to=20
load free space cache for block group 3829936422912, rebuilding it now =
                                                                       =
                                                   =20
Feb 11 00:06:26 diefledermaus kernel: BTRFS warning (device sdb2): bloc=
k group=20
4735906086912 has wrong amount of free space                           =
                                                                       =
                                                 =20
Feb 11 00:06:26 diefledermaus kernel: BTRFS warning (device sdb2): fail=
ed to=20
load free space cache for block group 4735906086912, rebuilding it now =
                                                                       =
                                                   =20
Feb 11 00:06:53 diefledermaus kernel: BTRFS warning (device sdb2): bloc=
k group=20
4736442957824 has wrong amount of free space                           =
                                                                       =
                                                 =20
Feb 11 00:06:53 diefledermaus kernel: BTRFS warning (device sdb2): fail=
ed to=20
load free space cache for block group 4736442957824, rebuilding it now =
                                                                       =
                                                   =20
Feb 11 00:06:55 diefledermaus kernel: BTRFS warning (device sdb2): bloc=
k group=20
3830473293824 has wrong amount of free space                           =
                                                                       =
                                                 =20
Feb 11 00:06:55 diefledermaus kernel: BTRFS warning (device sdb2): fail=
ed to=20
load free space cache for block group 3830473293824, rebuilding it now =
                                                                       =
                                                   =20
Feb 11 00:07:11 diefledermaus kernel: BTRFS warning (device sdb2): bloc=
k group=20
4745066446848 has wrong amount of free space                           =
                                                                       =
                                                 =20
Feb 11 00:07:11 diefledermaus kernel: BTRFS warning (device sdb2): fail=
ed to=20
load free space cache for block group 4745066446848, rebuilding it now =
                                                                       =
                                                   =20
Feb 11 00:47:39 diefledermaus kernel: ------------[ cut here ]---------=
=2D--                                                                    =
                                                                       =
                                                         =20
Feb 11 00:47:39 diefledermaus kernel: WARNING: CPU: 1 PID: 8963 at=20
fs/btrfs/extent-tree.c:2967 btrfs_run_delayed_refs+0x278/0x2b0         =
                                                                       =
                                                             =20
Feb 11 00:47:39 diefledermaus kernel: BTRFS: error (device sdb2) in=20
btrfs_run_delayed_refs:2967: errno=3D-17 Object already exists         =
                                                                       =
                                                              =20
Feb 11 00:47:39 diefledermaus kernel: BTRFS info (device sdb2): forced=20=

readonly                                                               =
                                                                       =
                                                         =20
Feb 11 00:47:39 diefledermaus kernel: BTRFS: Transaction aborted (error=
 -17)                                                                  =
                                                                       =
                                                         =20
Feb 11 00:47:39 diefledermaus kernel: Modules linked in: usb_storage ms=
r ctr=20
ccm tun arc4 snd_hda_codec_idt snd_hda_codec_generic ath5k applesmc=20
snd_hda_intel input_polldev snd_hda_codec mac80211 hwmon ath snd_hda_co=
re=20
snd_pcm cfg80211 sky2 rfkill snd_timer acpi_cpufreq video snd backlight=
=20
soundcore processor button sg sr_mod cdrom ata_generic pata_acpi uhci_h=
cd ahci=20
libahci ata_piix libata ehci_pci ehci_hcd                              =
                                                                       =
                             =20
Feb 11 00:47:39 diefledermaus kernel: CPU: 1 PID: 8963 Comm: kworker/u4=
:4 Not=20
tainted 4.9.7-gentoo #1                                                =
                                                                       =
                                                  =20
Feb 11 00:47:39 diefledermaus kernel: Hardware name: Apple Inc.=20
Macmini2,1/Mac-F4208EAA, BIOS     MM21.88Z.009A.B00.0706281359 06/28/07=
                                                                       =
                                                                =20
Feb 11 00:47:39 diefledermaus kernel: Workqueue: btrfs-extent-refs=20
btrfs_extent_refs_helper                                               =
                                                                       =
                                                             =20
Feb 11 00:47:39 diefledermaus kernel:  0000000000000000 ffffffff812cf8f=
9=20
ffffc900051a7d60 0000000000000000                                      =
                                                                       =
                                                       =20
Feb 11 00:47:39 diefledermaus kernel:  ffffffff8104908a ffff88007edc63c=
0=20
ffffc900051a7db0 0000000000001732
Feb 11 00:47:39 diefledermaus kernel:  ffff88008f47a1f8 ffff8800beac370=
0=20
0000000000000000 ffffffff810490fa
Feb 11 00:47:39 diefledermaus kernel: Call Trace:
Feb 11 00:47:39 diefledermaus kernel:  [<ffffffff812cf8f9>] ?=20
dump_stack+0x46/0x5d
Feb 11 00:47:39 diefledermaus kernel:  [<ffffffff8104908a>] ? __warn+0x=
ba/0xe0
Feb 11 00:47:39 diefledermaus kernel:  [<ffffffff810490fa>] ?=20
warn_slowpath_fmt+0x4a/0x50
Feb 11 00:47:39 diefledermaus kernel:  [<ffffffff81202188>] ?=20
btrfs_run_delayed_refs+0x278/0x2b0
Feb 11 00:47:39 diefledermaus kernel:  [<ffffffff81202244>] ?=20
delayed_ref_async_start+0x84/0xa0
Feb 11 00:47:39 diefledermaus kernel:  [<ffffffff8105ce76>] ?=20
process_one_work+0x126/0x310
Feb 11 00:47:39 diefledermaus kernel:  [<ffffffff8105d0a5>] ?=20
worker_thread+0x45/0x450
Feb 11 00:47:39 diefledermaus kernel:  [<ffffffff8105d060>] ?=20
process_one_work+0x310/0x310
Feb 11 00:47:39 diefledermaus kernel:  [<ffffffff81061c99>] ?=20
kthread+0xb9/0xd0
Feb 11 00:47:39 diefledermaus kernel:  [<ffffffff81061be0>] ?=20
kthread_park+0x50/0x50
Feb 11 00:47:39 diefledermaus kernel:  [<ffffffff814f6412>] ?=20
ret_from_fork+0x22/0x30
Feb 11 00:47:39 diefledermaus kernel: ---[ end trace ba59f5981cc5a675 ]=
=2D--
Feb 11 00:47:39 diefledermaus kernel: BTRFS: error (device sdb2) in=20
btrfs_run_delayed_refs:2967: errno=3D-17 Object already exists
Feb 11 01:07:43 diefledermaus kernel: BTRFS error (device sdb2): cleane=
r=20
transaction attach returned -30
Feb 11 01:07:43 diefledermaus kernel: ------------[ cut here ]---------=
=2D--
Feb 11 01:07:43 diefledermaus kernel: WARNING: CPU: 0 PID: 9450 at=20
fs/btrfs/extent-tree.c:134 btrfs_put_block_group+0x55/0x60
Feb 11 01:07:43 diefledermaus kernel: Modules linked in: usb_storage ms=
r ctr=20
ccm tun arc4 snd_hda_codec_idt snd_hda_codec_generic ath5k applesmc=20
snd_hda_intel input_polldev snd_hda_codec mac80211 hwmon ath snd_hda_co=
re=20
snd_pcm cfg80211 sky2 rfkill snd_timer acpi_cpufreq video snd backlight=
=20
soundcore processor button sg sr_mod cdrom ata_generic pata_acpi uhci_h=
cd ahci=20
libahci ata_piix libata ehci_pci ehci_hcd
Feb 11 01:07:43 diefledermaus kernel: CPU: 0 PID: 9450 Comm: umount Tai=
nted: G       =20
W       4.9.7-gentoo #1
Feb 11 01:07:43 diefledermaus kernel: Hardware name: Apple Inc.=20
Macmini2,1/Mac-F4208EAA, BIOS     MM21.88Z.009A.B00.0706281359 06/28/07=

Feb 11 01:07:43 diefledermaus kernel:  0000000000000000 ffffffff812cf8f=
9=20
0000000000000000 0000000000000000
Feb 11 01:07:43 diefledermaus kernel:  ffffffff8104908a ffff88004203b20=
0=20
ffff88004203b200 ffff8800174160a0
Feb 11 01:07:43 diefledermaus kernel:  ffff880017416000 ffff88001741609=
0=20
ffff8800371193f8 ffffffff811f9e05
Feb 11 01:07:43 diefledermaus kernel: Call Trace:
Feb 11 01:07:43 diefledermaus kernel:  [<ffffffff812cf8f9>] ?=20
dump_stack+0x46/0x5d
Feb 11 01:07:43 diefledermaus kernel:  [<ffffffff8104908a>] ? __warn+0x=
ba/0xe0
Feb 11 01:07:43 diefledermaus kernel:  [<ffffffff811f9e05>] ?=20
btrfs_put_block_group+0x55/0x60
Feb 11 01:07:43 diefledermaus kernel:  [<ffffffff81201295>] ?=20
btrfs_free_block_groups+0xf5/0x420
Feb 11 01:07:43 diefledermaus kernel:  [<ffffffff8121231b>] ?=20
close_ctree+0xfb/0x320
Feb 11 01:07:43 diefledermaus kernel:  [<ffffffff8111105f>] ?=20
generic_shutdown_super+0x5f/0xe0
Feb 11 01:07:43 diefledermaus kernel:  [<ffffffff811112e9>] ?=20
kill_anon_super+0x9/0x20
Feb 11 01:07:43 diefledermaus kernel:  [<ffffffff811e70ed>] ?=20
btrfs_kill_super+0xd/0x90
Feb 11 01:07:43 diefledermaus kernel:  [<ffffffff811114bf>] ?=20
deactivate_locked_super+0x2f/0x60
Feb 11 01:07:43 diefledermaus kernel:  [<ffffffff8112b006>] ?=20
cleanup_mnt+0x36/0x80
Feb 11 01:07:43 diefledermaus kernel:  [<ffffffff810605cd>] ?=20
task_work_run+0x6d/0x90
Feb 11 01:07:43 diefledermaus kernel:  [<ffffffff81000fe6>] ?=20
exit_to_usermode_loop+0x66/0x70
Feb 11 01:07:43 diefledermaus kernel:  [<ffffffff810012ee>] ?=20
syscall_return_slowpath+0x4e/0x50
Feb 11 01:07:43 diefledermaus kernel:  [<ffffffff814f625f>] ?=20
entry_SYSCALL_64_fastpath+0x92/0x94
Feb 11 01:07:43 diefledermaus kernel: ---[ end trace ba59f5981cc5a676 ]=
=2D--
Feb 11 01:07:43 diefledermaus kernel: ------------[ cut here ]---------=
=2D--
Feb 11 01:07:43 diefledermaus kernel: WARNING: CPU: 0 PID: 9450 at=20
fs/btrfs/extent-tree.c:10045 btrfs_free_block_groups+0x28d/0x420
Feb 11 01:07:43 diefledermaus kernel: Modules linked in: usb_storage ms=
r ctr=20
ccm tun arc4 snd_hda_codec_idt snd_hda_codec_generic ath5k applesmc=20
snd_hda_intel input_polldev snd_hda_codec mac80211 hwmon ath snd_hda_co=
re=20
snd_pcm cfg80211 sky2 rfkill snd_timer acpi_cpufreq video snd backlight=
=20
soundcore processor button sg sr_mod cdrom ata_generic pata_acpi uhci_h=
cd ahci=20
libahci ata_piix libata ehci_pci ehci_hcd
Feb 11 01:07:43 diefledermaus kernel: CPU: 0 PID: 9450 Comm: umount Tai=
nted: G       =20
W       4.9.7-gentoo #1
Feb 11 01:07:43 diefledermaus kernel: Hardware name: Apple Inc.=20
Macmini2,1/Mac-F4208EAA, BIOS     MM21.88Z.009A.B00.0706281359 06/28/07=

Feb 11 01:07:43 diefledermaus kernel:  0000000000000000 ffffffff812cf8f=
9=20
0000000000000000 0000000000000000
Feb 11 01:07:43 diefledermaus kernel:  ffffffff8104908a ffff8800bbcc680=
0=20
0000000000000000 ffff8800bbcc6888
Feb 11 01:07:43 diefledermaus kernel:  ffff880017416000 ffff8800bb6569f=
8=20
ffff880017416a70 ffffffff8120142d
Feb 11 01:07:43 diefledermaus kernel: Call Trace:
Feb 11 01:07:43 diefledermaus kernel:  [<ffffffff812cf8f9>] ?=20
dump_stack+0x46/0x5d
Feb 11 01:07:43 diefledermaus kernel:  [<ffffffff8104908a>] ? __warn+0x=
ba/0xe0
Feb 11 01:07:43 diefledermaus kernel:  [<ffffffff8120142d>] ?=20
btrfs_free_block_groups+0x28d/0x420
Feb 11 01:07:43 diefledermaus kernel:  [<ffffffff8121231b>] ?=20
close_ctree+0xfb/0x320
Feb 11 01:07:43 diefledermaus kernel:  [<ffffffff8111105f>] ?=20
generic_shutdown_super+0x5f/0xe0
Feb 11 01:07:43 diefledermaus kernel:  [<ffffffff811112e9>] ?=20
kill_anon_super+0x9/0x20
Feb 11 01:07:43 diefledermaus kernel:  [<ffffffff811e70ed>] ?=20
btrfs_kill_super+0xd/0x90
Feb 11 01:07:43 diefledermaus kernel:  [<ffffffff811114bf>] ?=20
deactivate_locked_super+0x2f/0x60
Feb 11 01:07:43 diefledermaus kernel:  [<ffffffff8112b006>] ?=20
cleanup_mnt+0x36/0x80
Feb 11 01:07:43 diefledermaus kernel:  [<ffffffff810605cd>] ?=20
task_work_run+0x6d/0x90
Feb 11 01:07:43 diefledermaus kernel:  [<ffffffff81000fe6>] ?=20
exit_to_usermode_loop+0x66/0x70
Feb 11 01:07:43 diefledermaus kernel:  [<ffffffff810012ee>] ?=20
syscall_return_slowpath+0x4e/0x50
Feb 11 01:07:43 diefledermaus kernel:  [<ffffffff814f625f>] ?=20
entry_SYSCALL_64_fastpath+0x92/0x94
Feb 11 01:07:43 diefledermaus kernel: ---[ end trace ba59f5981cc5a677 ]=
=2D--
Feb 11 01:07:43 diefledermaus kernel: BTRFS info (device sdb2): space_i=
nfo 4=20
has 2744418304 free, is not full
Feb 11 01:07:43 diefledermaus kernel: BTRFS info (device sdb2): space_i=
nfo=20
total=3D15166603264, used=3D11214192640, pinned=3D0, reserved=3D32768, =
may_use=3D0,=20
readonly=3D1207959552
Feb 11 01:07:57 diefledermaus kernel: BTRFS info (device sdb2): use zli=
b=20
compression
Feb 11 01:07:57 diefledermaus kernel: BTRFS info (device sdb2): disk sp=
ace=20
caching is enabled
Feb 11 01:07:57 diefledermaus kernel: BTRFS info (device sdb2): has ski=
nny=20
extents
Feb 11 02:02:58 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757540306944 flags 4
Feb 11 02:03:06 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757531918336 flags 4
Feb 11 02:03:07 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757523529728 flags 4
Feb 11 02:03:08 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757515141120 flags 4
Feb 11 02:03:08 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757506752512 flags 4
Feb 11 02:03:09 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757498363904 flags 4
Feb 11 02:03:10 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757489975296 flags 4
Feb 11 02:03:11 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757481586688 flags 4
Feb 11 02:03:12 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757473198080 flags 4
Feb 11 02:03:13 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757464809472 flags 4
Feb 11 02:03:14 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757456420864 flags 4
Feb 11 02:03:15 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757448032256 flags 4
Feb 11 02:03:16 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757439643648 flags 4
Feb 11 02:03:18 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757431255040 flags 4
Feb 11 02:03:19 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757422866432 flags 4
Feb 11 02:03:23 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757414477824 flags 4
Feb 11 02:03:25 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757406089216 flags 4
Feb 11 02:03:28 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757397700608 flags 4
Feb 11 02:03:30 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757389312000 flags 4
Feb 11 02:03:33 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757380923392 flags 4
Feb 11 02:03:35 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757372534784 flags 4
Feb 11 02:03:38 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757364146176 flags 4
Feb 11 02:03:40 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757355757568 flags 4
Feb 11 02:03:43 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757347368960 flags 4
Feb 11 02:03:45 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757338980352 flags 4
Feb 11 02:03:47 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757330591744 flags 4
Feb 11 02:03:49 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757322203136 flags 4
Feb 11 02:03:51 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757313814528 flags 4
Feb 11 02:03:53 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757305425920 flags 4
Feb 11 02:03:55 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757297037312 flags 4
Feb 11 02:03:57 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757288648704 flags 4
Feb 11 02:03:59 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757280260096 flags 4
Feb 11 02:04:01 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757271871488 flags 4
Feb 11 02:04:03 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757263482880 flags 4
Feb 11 02:04:06 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757255094272 flags 4
Feb 11 02:04:07 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757246705664 flags 4
Feb 11 02:04:09 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757238317056 flags 4
Feb 11 02:04:11 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757229928448 flags 4
Feb 11 02:04:12 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757221539840 flags 4
Feb 11 02:04:13 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757213151232 flags 4
Feb 11 02:04:15 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757204762624 flags 4
Feb 11 02:04:16 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757196374016 flags 4
Feb 11 02:04:17 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757187985408 flags 4
Feb 11 02:04:19 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757179596800 flags 4
Feb 11 02:04:20 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757171208192 flags 4
Feb 11 02:04:21 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757162819584 flags 4
Feb 11 02:04:22 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757154430976 flags 4
Feb 11 02:04:24 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757146042368 flags 4
Feb 11 02:04:25 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757137653760 flags 4
Feb 11 02:04:26 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757129265152 flags 4
Feb 11 02:04:27 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757120876544 flags 4
Feb 11 02:04:28 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757112487936 flags 4
Feb 11 02:04:29 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757104099328 flags 4
Feb 11 02:04:30 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757095710720 flags 4
Feb 11 02:04:31 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757087322112 flags 4
Feb 11 02:04:37 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757078933504 flags 4
Feb 11 02:04:38 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757070544896 flags 4
Feb 11 02:04:39 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757062156288 flags 4
Feb 11 02:04:40 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757053767680 flags 4
Feb 11 02:04:41 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757045379072 flags 4
Feb 11 02:04:42 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757036990464 flags 4
Feb 11 02:04:43 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757028601856 flags 4
Feb 11 02:04:44 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757020213248 flags 4
Feb 11 02:04:45 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757011824640 flags 4
Feb 11 02:04:47 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4757003436032 flags 4
Feb 11 02:04:47 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756995047424 flags 4
Feb 11 02:04:48 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756986658816 flags 4
Feb 11 02:04:49 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756978270208 flags 4
Feb 11 02:04:50 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756969881600 flags 4
Feb 11 02:04:50 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756961492992 flags 4
Feb 11 02:04:51 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756953104384 flags 4
Feb 11 02:04:52 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756944715776 flags 4
Feb 11 02:04:53 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756936327168 flags 4
Feb 11 02:04:53 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756927938560 flags 4
Feb 11 02:04:54 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756919549952 flags 4
Feb 11 02:04:55 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756911161344 flags 4
Feb 11 02:04:57 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756902772736 flags 4
Feb 11 02:04:58 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756894384128 flags 4
Feb 11 02:04:58 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756885995520 flags 4
Feb 11 02:05:00 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756877606912 flags 4
Feb 11 02:05:01 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756869218304 flags 4
Feb 11 02:05:03 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756860829696 flags 4
Feb 11 02:05:04 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756852441088 flags 4
Feb 11 02:05:04 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756844052480 flags 4
Feb 11 02:05:05 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756835663872 flags 4
Feb 11 02:05:06 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756827275264 flags 4
Feb 11 02:05:06 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756818886656 flags 4
Feb 11 02:05:07 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756810498048 flags 4
Feb 11 02:05:08 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756802109440 flags 4
Feb 11 02:05:09 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756793720832 flags 4
Feb 11 02:05:09 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756785332224 flags 4
Feb 11 02:05:10 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756776943616 flags 4
Feb 11 02:05:11 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756768555008 flags 4
Feb 11 02:05:13 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756760166400 flags 4
Feb 11 02:05:13 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756751777792 flags 4
Feb 11 02:05:14 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756743389184 flags 4
Feb 11 02:05:15 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756735000576 flags 4
Feb 11 02:05:15 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756726611968 flags 4
Feb 11 02:05:16 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756718223360 flags 4
Feb 11 02:05:17 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756709834752 flags 4
Feb 11 02:05:20 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756701446144 flags 4
Feb 11 02:05:20 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756693057536 flags 4
Feb 11 02:05:22 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756684668928 flags 4
Feb 11 02:05:23 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756676280320 flags 4
Feb 11 02:05:24 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756667891712 flags 4
Feb 11 02:05:26 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756659503104 flags 4
Feb 11 02:05:27 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756651114496 flags 4
Feb 11 02:05:45 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756642725888 flags 4
Feb 11 02:05:46 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756634337280 flags 4
Feb 11 02:05:48 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756625948672 flags 4
Feb 11 02:05:49 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756617560064 flags 4
Feb 11 02:05:51 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756609171456 flags 4
Feb 11 02:05:52 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756600782848 flags 4
Feb 11 02:05:54 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756592394240 flags 4
Feb 11 02:05:56 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756584005632 flags 4
Feb 11 02:05:58 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756575617024 flags 4
Feb 11 02:05:59 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756567228416 flags 4
Feb 11 02:06:01 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756558839808 flags 4
Feb 11 02:06:02 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756550451200 flags 4
Feb 11 02:06:04 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4756542062592 flags 4
Feb 11 02:06:05 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4751164964864 flags 4
Feb 11 02:06:07 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4751156576256 flags 4
Feb 11 02:06:09 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4751148187648 flags 4
Feb 11 02:06:10 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4751139799040 flags 4
Feb 11 02:06:12 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4751131410432 flags 4
Feb 11 02:06:13 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4751123021824 flags 4
Feb 11 02:06:15 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4751114633216 flags 4
Feb 11 02:06:17 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4751106244608 flags 4
Feb 11 02:06:18 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4751097856000 flags 4
Feb 11 02:06:20 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4751089467392 flags 4
Feb 11 02:06:21 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4751081078784 flags 4
Feb 11 02:06:22 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4751072690176 flags 4
Feb 11 02:06:24 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4751064301568 flags 4
Feb 11 02:06:25 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4751055912960 flags 4
Feb 11 02:06:26 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4751047524352 flags 4
Feb 11 02:06:27 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4751039135744 flags 4
Feb 11 02:06:28 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4751030747136 flags 4
Feb 11 02:06:29 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4751022358528 flags 4
Feb 11 02:06:30 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4751013969920 flags 4
Feb 11 02:06:32 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4751005581312 flags 4
Feb 11 02:06:33 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4750997192704 flags 4
Feb 11 02:06:34 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4750988804096 flags 4
Feb 11 02:06:35 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4750980415488 flags 4
Feb 11 02:06:36 diefledermaus kernel: BTRFS info (device sdb2): relocat=
ing=20
block group 4750972026880 flags 4
Feb 11 02:27:34 diefledermaus kernel: ------------[ cut here ]---------=
=2D--
Feb 11 02:27:35 diefledermaus kernel: WARNING: CPU: 0 PID: 10268 at=20
fs/btrfs/extent-tree.c:2967 btrfs_run_delayed_refs+0x278/0x2b0
Feb 11 02:27:35 diefledermaus kernel: BTRFS: error (device sdb2) in=20
btrfs_run_delayed_refs:2967: errno=3D-17 Object already exists
Feb 11 02:27:35 diefledermaus kernel: BTRFS info (device sdb2): forced=20=

readonly
Feb 11 02:27:35 diefledermaus kernel: BTRFS: Transaction aborted (error=
 -17)
Feb 11 02:27:35 diefledermaus kernel: Modules linked in: usb_storage ms=
r ctr=20
ccm tun arc4 snd_hda_codec_idt snd_hda_codec_generic ath5k applesmc=20
snd_hda_intel input_polldev snd_hda_codec mac80211 hwmon ath snd_hda_co=
re=20
snd_pcm cfg80211 sky2 rfkill snd_timer acpi_cpufreq video snd backlight=
=20
soundcore processor button sg sr_mod cdrom ata_generic pata_acpi uhci_h=
cd ahci=20
libahci ata_piix libata ehci_pci ehci_hcd
Feb 11 02:27:35 diefledermaus kernel: CPU: 0 PID: 10268 Comm: kworker/u=
4:4=20
Tainted: G        W       4.9.7-gentoo #1
Feb 11 02:27:35 diefledermaus kernel: Hardware name: Apple Inc.=20
Macmini2,1/Mac-F4208EAA, BIOS     MM21.88Z.009A.B00.0706281359 06/28/07=

Feb 11 02:27:35 diefledermaus kernel: Workqueue: btrfs-extent-refs=20
btrfs_extent_refs_helper
Feb 11 02:27:35 diefledermaus kernel:  0000000000000000 ffffffff812cf8f=
9=20
ffffc90005fe3d60 0000000000000000
Feb 11 02:27:35 diefledermaus kernel:  ffffffff8104908a ffff880052a738c=
0=20
ffffc90005fe3db0 00000000000001c2
Feb 11 02:27:35 diefledermaus kernel:  ffff880019a0ea50 ffff8800bc583c0=
0=20
0000000000000000 ffffffff810490fa
Feb 11 02:27:35 diefledermaus kernel: Call Trace:
Feb 11 02:27:35 diefledermaus kernel:  [<ffffffff812cf8f9>] ?=20
dump_stack+0x46/0x5d
Feb 11 02:27:35 diefledermaus kernel:  [<ffffffff8104908a>] ? __warn+0x=
ba/0xe0
Feb 11 02:27:35 diefledermaus kernel:  [<ffffffff810490fa>] ?=20
warn_slowpath_fmt+0x4a/0x50
Feb 11 02:27:35 diefledermaus kernel:  [<ffffffff81202188>] ?=20
btrfs_run_delayed_refs+0x278/0x2b0
Feb 11 02:27:35 diefledermaus kernel:  [<ffffffff81202244>] ?=20
delayed_ref_async_start+0x84/0xa0
Feb 11 02:27:35 diefledermaus kernel:  [<ffffffff8105ce76>] ?=20
process_one_work+0x126/0x310
Feb 11 02:27:35 diefledermaus kernel:  [<ffffffff8105d0a5>] ?=20
worker_thread+0x45/0x450
Feb 11 02:27:35 diefledermaus kernel:  [<ffffffff8105d060>] ?=20
process_one_work+0x310/0x310
Feb 11 02:27:35 diefledermaus kernel:  [<ffffffff8105d060>] ?=20
process_one_work+0x310/0x310
Feb 11 02:27:35 diefledermaus kernel:  [<ffffffff81061c99>] ?=20
kthread+0xb9/0xd0
Feb 11 02:27:35 diefledermaus kernel:  [<ffffffff81061be0>] ?=20
kthread_park+0x50/0x50
Feb 11 02:27:35 diefledermaus kernel:  [<ffffffff814f6412>] ?=20
ret_from_fork+0x22/0x30
Feb 11 02:27:35 diefledermaus kernel: ---[ end trace ba59f5981cc5a678 ]=
=2D--
Feb 11 02:27:35 diefledermaus kernel: BTRFS: error (device sdb2) in=20
btrfs_run_delayed_refs:2967: errno=3D-17 Object already exists
Feb 11 02:29:09 diefledermaus kernel: BTRFS error (device sdb2): cleane=
r=20
transaction attach returned -30
Feb 11 02:29:11 diefledermaus kernel: BTRFS info (device sdb2): use zli=
b=20
compression
Feb 11 02:29:11 diefledermaus kernel: BTRFS info (device sdb2): disk sp=
ace=20
caching is enabled
Feb 11 02:29:11 diefledermaus kernel: BTRFS info (device sdb2): has ski=
nny=20
extents
Feb 11 02:54:20 diefledermaus kernel: ------------[ cut here ]---------=
=2D--
Feb 11 02:54:20 diefledermaus kernel: WARNING: CPU: 0 PID: 10382 at=20
fs/btrfs/extent-tree.c:2967 btrfs_run_delayed_refs+0x278/0x2b0
Feb 11 02:54:20 diefledermaus kernel: BTRFS: Transaction aborted (error=
 -17)
Feb 11 02:54:20 diefledermaus kernel: Modules linked in: usb_storage ms=
r ctr=20
ccm tun arc4 snd_hda_codec_idt snd_hda_codec_generic ath5k applesmc=20
snd_hda_intel input_polldev snd_hda_codec mac80211 hwmon ath snd_hda_co=
re=20
snd_pcm cfg80211 sky2 rfkill snd_timer acpi_cpufreq video snd backlight=
=20
soundcore processor button sg sr_mod cdrom ata_generic pata_acpi uhci_h=
cd ahci=20
libahci ata_piix libata ehci_pci ehci_hcd
Feb 11 02:54:20 diefledermaus kernel: CPU: 0 PID: 10382 Comm: btrfs-cle=
aner=20
Tainted: G        W       4.9.7-gentoo #1
Feb 11 02:54:20 diefledermaus kernel: Hardware name: Apple Inc.=20
Macmini2,1/Mac-F4208EAA, BIOS     MM21.88Z.009A.B00.0706281359 06/28/07=

Feb 11 02:54:20 diefledermaus kernel:  0000000000000000 ffffffff812cf8f=
9=20
ffffc9000601bd28 0000000000000000
Feb 11 02:54:20 diefledermaus kernel:  ffffffff8104908a ffff8800037f378=
0=20
ffffc9000601bd78 00000000000003a0
Feb 11 02:54:20 diefledermaus kernel:  ffff88005b83d3b0 ffff8800225f19d=
f=20
ffff8800037f3780 ffffffff810490fa
Feb 11 02:54:20 diefledermaus kernel: Call Trace:
Feb 11 02:54:20 diefledermaus kernel:  [<ffffffff812cf8f9>] ?=20
dump_stack+0x46/0x5d
Feb 11 02:54:20 diefledermaus kernel:  [<ffffffff8104908a>] ? __warn+0x=
ba/0xe0
Feb 11 02:54:20 diefledermaus kernel:  [<ffffffff810490fa>] ?=20
warn_slowpath_fmt+0x4a/0x50
Feb 11 02:54:20 diefledermaus kernel:  [<ffffffff81202188>] ?=20
btrfs_run_delayed_refs+0x278/0x2b0
Feb 11 02:54:20 diefledermaus kernel:  [<ffffffff81215dda>] ?=20
btrfs_should_end_transaction+0x3a/0x60
Feb 11 02:54:20 diefledermaus kernel:  [<ffffffff81200787>] ?=20
btrfs_drop_snapshot+0x417/0x7b0
Feb 11 02:54:20 diefledermaus kernel:  [<ffffffff81217012>] ?=20
btrfs_clean_one_deleted_snapshot+0xb2/0xe0
Feb 11 02:54:20 diefledermaus kernel:  [<ffffffff8120e04f>] ?=20
cleaner_kthread+0x13f/0x1b0
Feb 11 02:54:20 diefledermaus kernel:  [<ffffffff8120df10>] ?=20
btrfs_destroy_pinned_extent+0xc0/0xc0
Feb 11 02:54:20 diefledermaus kernel:  [<ffffffff81061c99>] ?=20
kthread+0xb9/0xd0
Feb 11 02:54:20 diefledermaus kernel:  [<ffffffff8104b678>] ?=20
do_exit+0x698/0xa70
Feb 11 02:54:20 diefledermaus kernel:  [<ffffffff81061be0>] ?=20
kthread_park+0x50/0x50
Feb 11 02:54:20 diefledermaus kernel:  [<ffffffff814f6412>] ?=20
ret_from_fork+0x22/0x30
Feb 11 02:54:20 diefledermaus kernel: ---[ end trace ba59f5981cc5a679 ]=
=2D--
Feb 11 02:54:20 diefledermaus kernel: BTRFS: error (device sdb2) in=20
btrfs_run_delayed_refs:2967: errno=3D-17 Object already exists
Feb 11 02:54:20 diefledermaus kernel: BTRFS info (device sdb2): forced=20=

readonly
Feb 11 02:55:18 diefledermaus kernel: BTRFS error (device sdb2): cleane=
r=20
transaction attach returned -30
Feb 11 02:55:21 diefledermaus kernel: BTRFS info (device sdb2): use zli=
b=20
compression
Feb 11 02:55:21 diefledermaus kernel: BTRFS info (device sdb2): disk sp=
ace=20
caching is enabled
Feb 11 02:55:21 diefledermaus kernel: BTRFS info (device sdb2): has ski=
nny=20
extents
Feb 11 03:04:21 diefledermaus kernel: BTRFS info (device sdb2): use zli=
b=20
compression
Feb 11 03:04:21 diefledermaus kernel: BTRFS info (device sdb2): disk sp=
ace=20
caching is enabled
Feb 11 03:04:21 diefledermaus kernel: BTRFS info (device sdb2): has ski=
nny=20
extents
Feb 11 03:30:30 diefledermaus kernel: ------------[ cut here ]---------=
=2D--
Feb 11 03:30:30 diefledermaus kernel: WARNING: CPU: 0 PID: 10620 at=20
fs/btrfs/extent-tree.c:2967 btrfs_run_delayed_refs+0x278/0x2b0
Feb 11 03:30:30 diefledermaus kernel: BTRFS: Transaction aborted (error=
 -17)
Feb 11 03:30:30 diefledermaus kernel: Modules linked in: usb_storage ms=
r ctr=20
ccm tun arc4 snd_hda_codec_idt snd_hda_codec_generic ath5k applesmc=20
snd_hda_intel input_polldev snd_hda_codec mac80211 hwmon ath snd_hda_co=
re=20
snd_pcm cfg80211 sky2 rfkill snd_timer acpi_cpufreq video snd backlight=
=20
soundcore processor button sg sr_mod cdrom ata_generic pata_acpi uhci_h=
cd ahci=20
libahci ata_piix libata ehci_pci ehci_hcd
Feb 11 03:30:30 diefledermaus kernel: CPU: 0 PID: 10620 Comm: kworker/u=
4:4=20
Tainted: G        W       4.9.7-gentoo #1
Feb 11 03:30:30 diefledermaus kernel: Hardware name: Apple Inc.=20
Macmini2,1/Mac-F4208EAA, BIOS     MM21.88Z.009A.B00.0706281359 06/28/07=

Feb 11 03:30:30 diefledermaus kernel: Workqueue: btrfs-extent-refs=20
btrfs_extent_refs_helper
Feb 11 03:30:30 diefledermaus kernel:  0000000000000000 ffffffff812cf8f=
9=20
ffffc9000645bd60 0000000000000000
Feb 11 03:30:31 diefledermaus kernel:  ffffffff8104908a ffff8800b7bd5a0=
0=20
ffffc9000645bdb0 0000000000000020
Feb 11 03:30:31 diefledermaus kernel:  ffff880003394898 ffff8800bc58350=
0=20
0000000000000000 ffffffff810490fa
Feb 11 03:30:31 diefledermaus kernel: Call Trace:
Feb 11 03:30:31 diefledermaus kernel:  [<ffffffff812cf8f9>] ?=20
dump_stack+0x46/0x5d
Feb 11 03:30:31 diefledermaus kernel:  [<ffffffff8104908a>] ? __warn+0x=
ba/0xe0
Feb 11 03:30:31 diefledermaus kernel:  [<ffffffff810490fa>] ?=20
warn_slowpath_fmt+0x4a/0x50
Feb 11 03:30:31 diefledermaus kernel:  [<ffffffff81202188>] ?=20
btrfs_run_delayed_refs+0x278/0x2b0
Feb 11 03:30:31 diefledermaus kernel:  [<ffffffff81202244>] ?=20
delayed_ref_async_start+0x84/0xa0
Feb 11 03:30:31 diefledermaus kernel:  [<ffffffff8105ce76>] ?=20
process_one_work+0x126/0x310
Feb 11 03:30:31 diefledermaus kernel:  [<ffffffff8105a893>] ?=20
pwq_activate_delayed_work+0x33/0x60
Feb 11 03:30:31 diefledermaus kernel:  [<ffffffff8105d0a5>] ?=20
worker_thread+0x45/0x450
Feb 11 03:30:31 diefledermaus kernel:  [<ffffffff8105d060>] ?=20
process_one_work+0x310/0x310
Feb 11 03:30:31 diefledermaus kernel:  [<ffffffff81061c99>] ?=20
kthread+0xb9/0xd0
Feb 11 03:30:31 diefledermaus kernel:  [<ffffffff81061be0>] ?=20
kthread_park+0x50/0x50
Feb 11 03:30:31 diefledermaus kernel:  [<ffffffff814f6412>] ?=20
ret_from_fork+0x22/0x30
Feb 11 03:30:31 diefledermaus kernel: ---[ end trace ba59f5981cc5a67a ]=
=2D--
Feb 11 03:30:31 diefledermaus kernel: BTRFS: error (device sdb2) in=20
btrfs_run_delayed_refs:2967: errno=3D-17 Object already exists
Feb 11 03:30:31 diefledermaus kernel: BTRFS info (device sdb2): forced=20=

readonly
Feb 11 03:31:39 diefledermaus kernel: BTRFS error (device sdb2): cleane=
r=20
transaction attach returned -30
Feb 11 03:31:41 diefledermaus kernel: BTRFS info (device sdb2): use zli=
b=20
compression
Feb 11 03:31:41 diefledermaus kernel: BTRFS info (device sdb2): disk sp=
ace=20
caching is enabled
Feb 11 03:31:41 diefledermaus kernel: BTRFS info (device sdb2): has ski=
nny=20
extents
Feb 11 03:58:38 diefledermaus kernel: ------------[ cut here ]---------=
=2D--
Feb 11 03:58:38 diefledermaus kernel: WARNING: CPU: 0 PID: 11174 at=20
fs/btrfs/extent-tree.c:2967 btrfs_run_delayed_refs+0x278/0x2b0
Feb 11 03:58:38 diefledermaus kernel: BTRFS: Transaction aborted (error=
 -17)
Feb 11 03:58:38 diefledermaus kernel: Modules linked in: usb_storage ms=
r ctr=20
ccm tun arc4 snd_hda_codec_idt snd_hda_codec_generic ath5k applesmc=20
snd_hda_intel input_polldev snd_hda_codec mac80211 hwmon ath snd_hda_co=
re=20
snd_pcm cfg80211 sky2 rfkill snd_timer acpi_cpufreq video snd backlight=
=20
soundcore processor button sg sr_mod cdrom ata_generic pata_acpi uhci_h=
cd ahci=20
libahci ata_piix libata ehci_pci ehci_hcd
Feb 11 03:58:38 diefledermaus kernel: CPU: 0 PID: 11174 Comm: btrfs Tai=
nted: G       =20
W       4.9.7-gentoo #1
Feb 11 03:58:38 diefledermaus kernel: Hardware name: Apple Inc.=20
Macmini2,1/Mac-F4208EAA, BIOS     MM21.88Z.009A.B00.0706281359 06/28/07=

Feb 11 03:58:38 diefledermaus kernel:  0000000000000000 ffffffff812cf8f=
9=20
ffffc90006bfbb88 0000000000000000
Feb 11 03:58:38 diefledermaus kernel:  ffffffff8104908a ffff880047adb1e=
0=20
ffffc90006bfbbd8 0000000000000000
Feb 11 03:58:38 diefledermaus kernel:  ffff88000a6f8898 0000000000000a3=
4=20
ffff880023d59240 ffffffff810490fa
Feb 11 03:58:38 diefledermaus kernel: Call Trace:
Feb 11 03:58:38 diefledermaus kernel:  [<ffffffff812cf8f9>] ?=20
dump_stack+0x46/0x5d
Feb 11 03:58:38 diefledermaus kernel:  [<ffffffff8104908a>] ? __warn+0x=
ba/0xe0
Feb 11 03:58:38 diefledermaus kernel:  [<ffffffff810490fa>] ?=20
warn_slowpath_fmt+0x4a/0x50
Feb 11 03:58:38 diefledermaus kernel:  [<ffffffff81202188>] ?=20
btrfs_run_delayed_refs+0x278/0x2b0
Feb 11 03:58:38 diefledermaus kernel:  [<ffffffff812170eb>] ?=20
btrfs_commit_transaction.part.25+0x5b/0x970
Feb 11 03:58:38 diefledermaus kernel:  [<ffffffff8124c04d>] ?=20
btrfs_mksubvol+0x45d/0x470
Feb 11 03:58:38 diefledermaus kernel:  [<ffffffff810796b0>] ?=20
wake_up_bit+0x20/0x20
Feb 11 03:58:38 diefledermaus kernel:  [<ffffffff8124c1f5>] ?=20
btrfs_ioctl_snap_create_transid+0x195/0x1a0
Feb 11 03:58:38 diefledermaus kernel:  [<ffffffff8110bfcd>] ?=20
__check_object_size+0x11d/0x1d2
Feb 11 03:58:38 diefledermaus kernel:  [<ffffffff8124c38a>] ?=20
btrfs_ioctl_snap_create_v2+0xfa/0x150
Feb 11 03:58:38 diefledermaus kernel:  [<ffffffff8124f386>] ?=20
btrfs_ioctl+0x656/0x22b0
Feb 11 03:58:38 diefledermaus kernel:  [<ffffffff8111d7ad>] ?=20
do_filp_open+0x8d/0xd0
Feb 11 03:58:38 diefledermaus kernel:  [<ffffffff810ecf92>] ?=20
handle_mm_fault+0xd42/0xdb0
Feb 11 03:58:38 diefledermaus kernel:  [<ffffffff8110bfcd>] ?=20
__check_object_size+0x11d/0x1d2
Feb 11 03:58:38 diefledermaus kernel:  [<ffffffff8111f756>] ?=20
do_vfs_ioctl+0x86/0x5c0
Feb 11 03:58:38 diefledermaus kernel:  [<ffffffff8111fcc6>] ?=20
SyS_ioctl+0x36/0x70
Feb 11 03:58:38 diefledermaus kernel:  [<ffffffff814f61e0>] ?=20
entry_SYSCALL_64_fastpath+0x13/0x94
Feb 11 03:58:38 diefledermaus kernel: ---[ end trace ba59f5981cc5a67b ]=
=2D--
Feb 11 03:58:38 diefledermaus kernel: BTRFS: error (device sdb2) in=20
btrfs_run_delayed_refs:2967: errno=3D-17 Object already exists
Feb 11 03:58:39 diefledermaus kernel: BTRFS info (device sdb2): forced=20=

readonly
Feb 11 09:47:57 diefledermaus kernel: BTRFS error (device sdb2): cleane=
r=20
transaction attach returned -30
Feb 11 09:48:10 diefledermaus kernel: BTRFS info (device sdb2): use zli=
b=20
compression
Feb 11 09:48:10 diefledermaus kernel: BTRFS info (device sdb2): disk sp=
ace=20
caching is enabled
Feb 11 09:48:10 diefledermaus kernel: BTRFS info (device sdb2): has ski=
nny=20
extents
Feb 11 10:06:46 diefledermaus kernel: ------------[ cut here ]---------=
=2D--
Feb 11 10:06:46 diefledermaus kernel: WARNING: CPU: 1 PID: 12677 at=20
fs/btrfs/extent-tree.c:2967 btrfs_run_delayed_refs+0x278/0x2b0
Feb 11 10:06:46 diefledermaus kernel: BTRFS: Transaction aborted (error=
 -17)
Feb 11 10:06:46 diefledermaus kernel: Modules linked in: usb_storage ms=
r ctr=20
ccm tun arc4 snd_hda_codec_idt snd_hda_codec_generic ath5k applesmc=20
snd_hda_intel input_polldev snd_hda_codec mac80211 hwmon ath snd_hda_co=
re=20
snd_pcm cfg80211 sky2 rfkill snd_timer acpi_cpufreq video snd backlight=
=20
soundcore processor button sg sr_mod cdrom ata_generic pata_acpi uhci_h=
cd ahci=20
libahci ata_piix libata ehci_pci ehci_hcd
Feb 11 10:06:46 diefledermaus kernel: CPU: 1 PID: 12677 Comm: kworker/u=
4:6=20
Tainted: G        W       4.9.7-gentoo #1
Feb 11 10:06:46 diefledermaus kernel: Hardware name: Apple Inc.=20
Macmini2,1/Mac-F4208EAA, BIOS     MM21.88Z.009A.B00.0706281359 06/28/07=

Feb 11 10:06:46 diefledermaus kernel: Workqueue: btrfs-extent-refs=20
btrfs_extent_refs_helper
Feb 11 10:06:46 diefledermaus kernel:  0000000000000000 ffffffff812cf8f=
9=20
ffffc90001c73d60 0000000000000000
Feb 11 10:06:46 diefledermaus kernel:  ffffffff8104908a ffff8800258696e=
0=20
ffffc90001c73db0 0000000000000020
Feb 11 10:06:46 diefledermaus kernel:  ffff8800214131f8 ffff880087de7f0=
0=20
0000000000000000 ffffffff810490fa
Feb 11 10:06:46 diefledermaus kernel: Call Trace:
Feb 11 10:06:46 diefledermaus kernel:  [<ffffffff812cf8f9>] ?=20
dump_stack+0x46/0x5d
Feb 11 10:06:46 diefledermaus kernel:  [<ffffffff8104908a>] ? __warn+0x=
ba/0xe0
Feb 11 10:06:46 diefledermaus kernel:  [<ffffffff810490fa>] ?=20
warn_slowpath_fmt+0x4a/0x50
Feb 11 10:06:46 diefledermaus kernel:  [<ffffffff81202188>] ?=20
btrfs_run_delayed_refs+0x278/0x2b0
Feb 11 10:06:46 diefledermaus kernel:  [<ffffffff81202244>] ?=20
delayed_ref_async_start+0x84/0xa0
Feb 11 10:06:46 diefledermaus kernel:  [<ffffffff8105ce76>] ?=20
process_one_work+0x126/0x310
Feb 11 10:06:46 diefledermaus kernel:  [<ffffffff8105d0a5>] ?=20
worker_thread+0x45/0x450
Feb 11 10:06:46 diefledermaus kernel:  [<ffffffff8105d060>] ?=20
process_one_work+0x310/0x310
Feb 11 10:06:46 diefledermaus kernel:  [<ffffffff81061c99>] ?=20
kthread+0xb9/0xd0
Feb 11 10:06:46 diefledermaus kernel:  [<ffffffff81061be0>] ?=20
kthread_park+0x50/0x50
Feb 11 10:06:46 diefledermaus kernel:  [<ffffffff814f6412>] ?=20
ret_from_fork+0x22/0x30
Feb 11 10:06:46 diefledermaus kernel: ---[ end trace ba59f5981cc5a67c ]=
=2D--
Feb 11 10:06:46 diefledermaus kernel: BTRFS: error (device sdb2) in=20
btrfs_run_delayed_refs:2967: errno=3D-17 Object already exists
Feb 11 10:06:46 diefledermaus kernel: BTRFS info (device sdb2): forced=20=

readonly
Feb 11 10:18:06 diefledermaus kernel: BTRFS error (device sdb2): cleane=
r=20
transaction attach returned -30
Feb 11 10:18:19 diefledermaus kernel: BTRFS info (device sdb2): use zli=
b=20
compression
Feb 11 10:18:19 diefledermaus kernel: BTRFS info (device sdb2): disk sp=
ace=20
caching is enabled
Feb 11 10:18:19 diefledermaus kernel: BTRFS info (device sdb2): has ski=
nny=20
extents
Feb 11 10:24:09 diefledermaus kernel: BTRFS info (device sdb2): The fre=
e space=20
cache file (3833157648384) is invalid. skip it

Greetings
=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who kno=
w we
don't" - Bjarne Stroustrup

--nextPart5153843.KHxGCnNXpU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJYnuT/AAoJEL/Q5oYsiHj0/MoP/jf62QPfn7/XXEFXPdrOEull
7ZENukqhUf6dJPXlRh6oqi3NCV80bZQPZWMHl77uH0klq7RJFtyg6kJT6XjII1n/
ceyQpqIIFPQ3tXtRekDQb2TPhhUpYiuPpDcu6RpsGZEHpBzX4NyrZ5aFmFJP8bBU
O6CpixlU9aOjvdM8Kk1y5oEiofaaWmSx15W7f5W7TgcZvcZ2wicIXD1reyTwh4nl
m+x30gi40NMTuUtq9an2De/Ty/cWkirXjovtsEdHvpz/2cfr2CdcIJ33hAW+L2d/
Pu7mwn8VNU58Dp6MzVMlYWq79FNzjvmm03KFzrMohWT+j5usPHInK6NWIULxbnJM
bALdubHej9WJCI03Ro+Fk4WQxluOWFhRrUwfJ7BQdYVfWqtdprtXg9bFByemovR2
AbK3KxDCTnXe1gdTg5B3+1MEnoJc+Nr/R9T7UQBcZS8kjAO4ukA4B7uWoalZREDW
n3W0AEFtGkyPzBDQOBp7gB0NvFEz7DEYI1KfrHdoINrG8GTqAAyfFYnLnv82Tp10
Lltq8nV58vSmVJbeqw+7RRPHG1cy4zGJQ/bJ7dflcyQhkBI9lTEakgd46Z8c74mD
9SMntyZx3pVumvncI1HHh5DxiPMoIERL6a82tc9wwXNUh+J5KIAV1JFpUv2b5VIE
NHqzgG9CXg8byxMulrAX
=tyHi
-----END PGP SIGNATURE-----

--nextPart5153843.KHxGCnNXpU--

