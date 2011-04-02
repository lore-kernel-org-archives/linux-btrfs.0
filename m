From: Sergei Trofimovich <slyich@gmail.com>
Subject: Re: v2.6.38-6555-ga44f99c: null pointer dereference on -ENOSPC
Date: Sun, 3 Apr 2011 00:10:28 +0300
Message-ID: <20110403001028.62341746@sf.home>
References: <20110329103224.3fecfd32@sf.vba.domain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/o9sYkzzAHSCRS5bC3pVyVD."; protocol="application/pgp-signature"
Cc: linux-btrfs@vger.kernel.org
To: Sergei Trofimovich <slyich@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110329103224.3fecfd32@sf.vba.domain>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/o9sYkzzAHSCRS5bC3pVyVD.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 29 Mar 2011 10:32:24 +0300
Sergei Trofimovich <slyich@gmail.com> wrote:

> The partition is a physical ~5GB --mixed lzo compressed partition.
>=20
> I run large compiles there. During one of those kernel OOpsed
> (It seems to be reproducible). At the time of OOps and after reboot 'du -=
hs'
> reports 2.5GBs free. Before compiation 'du -hs' reported 3.4GBs free.
>=20
> kernel version: v2.6.38-6555-ga44f99c (a bit outdated linus's master bran=
ch)

This time vanilla 2.6.38. The same type/size of partition, but another box.
Compiled another large project on the FS. df reports 3GB free, btrfs fi df =
reports:
    System: total=3D4.00MB, used=3D4.00KB
    Data: total=3D2.66GB, used=3D1.40GB

[106764.528674] ------------[ cut here ]------------
[106764.528736] kernel BUG at fs/btrfs/extent-tree.c:5452!
[106764.528788] invalid opcode: 0000 [#1] PREEMPT SMP=20
[106764.528849] last sysfs file: /sys/devices/virtual/backlight/acpi_video0=
/uevent
[106764.528919] CPU 0=20
[106764.528942] Modules linked in: sco bnep btusb rfcomm l2cap bluetooth ex=
t2 btrfs zlib_deflate crc32c libcrc32c loop kvm_intel kvm fuse acpi_cpufreq=
 mperf scsi_wait_scan usb_storage tun snd_hda_codec_analog sdhci_pci pcmcia=
 iwlagn sdhci yenta_socket pcmcia_rsrc mmc_core sg snd_hda_intel pcmcia_cor=
e snd_hda_codec iwlcore i915 mac80211 cfg80211 rfkill drm_kms_helper sr_mod=
 drm e1000e i2c_algo_bit cdrom processor thermal battery fan container snd_=
hwdep button ac
[106764.529010]=20
[106764.529010] Pid: 1642, comm: btrfs-endio-wri Not tainted 2.6.38 #102 He=
wlett-Packard HP Compaq 2510p Notebook PC/30C9
[106764.529010] RIP: 0010:[<ffffffffa040d886>]  [<ffffffffa040d886>] alloc_=
reserved_file_extent+0xa2/0x1f3 [btrfs]
[106764.529010] RSP: 0000:ffff8800786cbab0  EFLAGS: 00010286
[106764.529010] RAX: 00000000ffffffe4 RBX: ffff880076b5b750 RCX: ffff880078=
6cb940
[106764.529010] RDX: ffff8800786cb940 RSI: ffff880076b5b750 RDI: 0000000000=
000000
[106764.529010] RBP: ffff8800786cbb40 R08: 0000000000000000 R09: ffffffffff=
ffffff
[106764.529010] R10: 0000000000000001 R11: ffff8800786cbbe0 R12: ffff880078=
6cbbe0
[106764.529010] R13: 00000000000000b2 R14: 0000000000000000 R15: ffff880076=
3775c0
[106764.529010] FS:  0000000000000000(0000) GS:ffff88007e400000(0000) knlGS=
:0000000000000000
[106764.529010] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[106764.529010] CR2: 0000000000432065 CR3: 0000000074f12000 CR4: 0000000000=
0006f0
[106764.529010] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000=
000000
[106764.529010] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000=
000400
[106764.529010] Process btrfs-endio-wri (pid: 1642, threadinfo ffff8800786c=
a000, task ffff880078638000)
[106764.529010] Stack:
[106764.529010]  ffff8800786cbae0 ffff8800780f0000 ffff88000000001d 0000000=
0000c4a88
[106764.529010]  0000000000000000 0000000000000005 ffff8800748be800 fffffff=
f8102fd80
[106764.529010]  ffff8800786cbb10 ffffffff8102fd80 ffff8800786cbb20 0000003=
500000001
[106764.529010] Call Trace:
[106764.529010]  [<ffffffff8102fd80>] ? get_parent_ip+0x11/0x41
[106764.529010]  [<ffffffff8102fd80>] ? get_parent_ip+0x11/0x41
[106764.529010]  [<ffffffffa0413663>] run_clustered_refs+0x650/0x767 [btrfs]
[106764.529010]  [<ffffffffa04382b5>] ? map_private_extent_buffer+0xf0/0x14=
9 [btrfs]
[106764.529010]  [<ffffffffa0413846>] btrfs_run_delayed_refs+0xcc/0x1d1 [bt=
rfs]
[106764.529010]  [<ffffffff810308bc>] ? sub_preempt_count+0x92/0xa5
[106764.529010]  [<ffffffffa041e02c>] __btrfs_end_transaction+0x67/0x1ed [b=
trfs]
[106764.529010]  [<ffffffffa041e1e6>] btrfs_end_transaction+0x10/0x12 [btrf=
s]
[106764.529010]  [<ffffffffa04297a6>] btrfs_finish_ordered_io+0x2ac/0x2cf [=
btrfs]
[106764.529010]  [<ffffffff81093204>] ? mempool_free_slab+0x12/0x14
[106764.529010]  [<ffffffffa04297de>] btrfs_writepage_end_io_hook+0x15/0x17=
 [btrfs]
[106764.529010]  [<ffffffffa045257a>] end_compressed_bio_write+0x6c/0xcc [b=
trfs]
[106764.529010]  [<ffffffff810f37b0>] bio_endio+0x28/0x2a
[106764.529010]  [<ffffffffa041a365>] end_workqueue_fn+0x10c/0x11b [btrfs]
[106764.529010]  [<ffffffffa0443b34>] worker_loop+0x19a/0x4e9 [btrfs]
[106764.529010]  [<ffffffffa044399a>] ? worker_loop+0x0/0x4e9 [btrfs]
[106764.529010]  [<ffffffff8104d6e6>] kthread+0x7d/0x85
[106764.529010]  [<ffffffff81002dd4>] kernel_thread_helper+0x4/0x10
[106764.529010]  [<ffffffff8104d669>] ? kthread+0x0/0x85
[106764.529010]  [<ffffffff81002dd0>] ? kernel_thread_helper+0x0/0x10
[106764.529010] Code: 88 00 00 00 08 83 c2 18 48 8b 71 20 41 b9 01 00 00 00=
 89 55 cc 4c 8d 45 cc 4c 89 e1 48 89 c2 4c 89 ff e8 fb a6 ff ff 85 c0 74 04=
 <0f> 0b eb fe 48 8b 03 48 89 45 b8 48 89 c7 48 63 73 40 48 6b f6=20
[106764.529010] RIP  [<ffffffffa040d886>] alloc_reserved_file_extent+0xa2/0=
x1f3 [btrfs]
[106764.529010]  RSP <ffff8800786cbab0>
[106764.590182] ---[ end trace afeb166ab43211d0 ]---

--=20

  Sergei

--Sig_/o9sYkzzAHSCRS5bC3pVyVD.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk2XkMoACgkQcaHudmEf86qc8ACePP2mLZRWZ9HAom9mUjoWgmLc
afYAn21XzkhFoTzN8VpkiVpN3DLibf6A
=mpFh
-----END PGP SIGNATURE-----

--Sig_/o9sYkzzAHSCRS5bC3pVyVD.--
