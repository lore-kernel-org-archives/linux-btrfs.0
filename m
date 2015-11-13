Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bender.boerde.de ([83.223.75.23]:39878 "EHLO bender.boerde.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932281AbbKMQWV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 11:22:21 -0500
Received: from hunapu.boerde.de (darkwing.home.local [IPv6:2a01:30:2802:1:2ad2:44ff:feb0:8e38])
	by bender.boerde.de (Postfix) with ESMTPSA id 5D8D21454101
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2015 17:15:03 +0100 (CET)
Date: Fri, 13 Nov 2015 17:15:01 +0100
From: Georg Lukas <georg@op-co.de>
To: linux-btrfs@vger.kernel.org
Subject: btrfs-replace OOM on 2GB machine
Message-ID: <20151113161501.GA29604@ovgu.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

while evaluating btrfs for production use I ended up with a degraded
two-disk RAID1 with one disk missing, and wanted to perform a "btrfs
replace" to rebuild the RAID1. However, the replace operation causes
most of my userland to be OOM-killed and aborts eventually, at about
30% progress, on a box with 2GB of physical RAM.

My setup is:

Linux-4.3 with the following patches applied:
 - http://www.spinics.net/lists/linux-btrfs/msg46123.html
   (needed for degraded mount of RAID1)
 - http://git.kernel.org/cgit/linux/kernel/git/mkp/linux.git/patch/?id=3D7c=
4fbd50bfece00abf529bc96ac989dd2bb83ca4
   (needed for the Seagate SMRs)

btrfs-progs v4.2.3

A btrfs RAID1 initially built on two dm-crypt containers on top of two
Seagate 8TB SMR disks. For testing purposes, I unmounted the fs,
reformatted one of the two crypto containers, mounted the fs in degraded
mode (which required Anand's patch), and tried different approaches to
get it back to full operation (rebalance to m=3Dd=3Dsingle, remove the
missing drive, finally a replace), all without success.

The current status is as follows:

# btrfs dev usage /media/archive/
/dev/mapper/archive1, ID: 1
   Device size:             7.28TiB
   Data,single:           837.00GiB
   Data,RAID0:              1.17TiB
   Data,RAID1:            959.00GiB
   Data,DUP:                2.17TiB
   Metadata,single:         2.00GiB
   Metadata,RAID1:          4.00GiB
   Metadata,DUP:            5.00GiB
   System,RAID1:           32.00MiB
   System,DUP:            192.00MiB
   Unallocated:             2.17TiB

missing, ID: 2
   Device size:               0.00B
   Data,RAID0:              1.17TiB
   Data,RAID1:            959.00GiB
   Metadata,RAID1:          4.00GiB
   System,RAID1:           32.00MiB
   Unallocated:             5.17TiB

I then start the replace:

# btrfs replace start 2 /dev/mapper/archive2 /media/archive/

That takes a while, OOM-kills half of my userspace in the process (it
seems like the kernel is allocating and freeing large chunks of memory
during the replace:

             total       used       free     shared    buffers     cached
Mem:          1.9G       1.6G       342M       784K       1.8M        14M
-/+ buffers/cache:       1.6G       358M
Swap:         4.0G        48M       4.0G

(5 second pause)
             total       used       free     shared    buffers     cached
Mem:          1.9G       157M       1.8G       808K       6.6M        32M
-/+ buffers/cache:       118M       1.8G
Swap:         4.0G        46M       4.0G

(another 5 seconds)
             total       used       free     shared    buffers     cached
Mem:          1.9G       1.1G       835M       808K       6.7M        37M
-/+ buffers/cache:       1.1G       879M
Swap:         4.0G        46M       4.0G

That seems to be kernel memory, as the swap is hardly used, despite
default swappiness settings. Furthermore, /proc/meminfo and slabtop have
no indication of how the memory is used; it just vanishes from the
"available" pool.

Eventually, the replace aborts:

[64326.700731] BTRFS: btrfs_scrub_dev(<missing disk>, 2, /dev/mapper/archiv=
e2) failed -12
[64326.700986] ------------[ cut here ]------------
[64326.701024] WARNING: CPU: 1 PID: 36251 at fs/btrfs/dev-replace.c:428 btr=
fs_dev_replace_start+0x36b/0x390 [btrfs]()
[64326.701062] Modules linked in: btrfs dm_crypt loop sha256_ssse3 sha256_g=
eneric hmac drbg ansi_cprng xts gf128mul algif_skcipher af_alg cpuid nfsd a=
uth_rpcgss oid_registry nfs_acl nfs lockd grace fscache sunrpc xor raid6_pq=
 intel_rapl iosf_mbi x86_pkg_temp_thermal iTCO_wdt intel_powerclamp iTCO_ve=
ndor_support kvm_intel kvm evdev crct10dif_pclmul crc32_pclmul cryptd snd_p=
cm snd_timer snd soundcore pcspkr psmouse serio_raw hpwdt hpilo lpc_ich mfd=
_core 8250_fintek shpchp acpi_power_meter button pcc_cpufreq acpi_cpufreq p=
rocessor coretemp ipmi_watchdog dm_mod ipmi_si ipmi_poweroff ipmi_devintf i=
pmi_msghandler fuse autofs4 ext4 crc16 mbcache jbd2 sg sd_mod usb_storage h=
id_generic usbhid hid crc32c_intel uhci_hcd thermal ahci libahci libata scs=
i_mod tg3 ptp pps_core libphy ehci_pci ehci_hcd xhci_pci xhci_hcd
[64326.701579]  usbcore usb_common [last unloaded: btrfs]
[64326.701611] CPU: 1 PID: 36251 Comm: btrfs Tainted: G        W       4.3.=
0-gl+ #42
[64326.701647] Hardware name: HP ProLiant MicroServer Gen8, BIOS J06 06/06/=
2014
[64326.701671]  ffffffffa06e8b71 ffffffff8129eac3 0000000000000000 ffffffff=
8106891c
[64326.701720]  00000000fffffff4 ffff880079079800 ffff880006f1a000 ffff8800=
74e2e000
[64326.701769]  ffff880006f1aec8 ffffffffa06da7db 00007ffc00000001 ffff8800=
71c42400
[64326.701818] Call Trace:
[64326.701840]  [<ffffffff8129eac3>] ? dump_stack+0x40/0x5d
[64326.701864]  [<ffffffff8106891c>] ? warn_slowpath_common+0x7c/0xb0
[64326.701896]  [<ffffffffa06da7db>] ? btrfs_dev_replace_start+0x36b/0x390 =
[btrfs]
[64326.701939]  [<ffffffffa06a6bbe>] ? btrfs_ioctl+0x1b6e/0x27b0 [btrfs]
[64326.701964]  [<ffffffff8116b83a>] ? page_add_file_rmap+0x2a/0x50
[64326.706074]  [<ffffffff81160379>] ? do_set_pte+0x99/0xc0
[64326.706100]  [<ffffffff81135f49>] ? filemap_map_pages+0x219/0x220
[64326.706123]  [<ffffffff81162127>] ? handle_mm_fault+0xdd7/0x16c0
[64326.706149]  [<ffffffff811b0b0e>] ? do_vfs_ioctl+0x2be/0x490
[64326.706174]  [<ffffffff811b0d51>] ? SyS_ioctl+0x71/0x80
[64326.706198]  [<ffffffff815000ee>] ? entry_SYSCALL_64_fastpath+0x12/0x71
[64326.706222] ---[ end trace 37fc29aa3c600bcf ]---

I'm not sure how to proceed from here, or how to debug this issue. While
the disks are not holding critical data, I'm sure it would benefit the
community (and btrfs' reputation) if this issue could be sorted out.


Kind regards,

Georg
--=20
|| http://op-co.de ++  GCS d--(++) s: a C+++ UL+++ !P L+++ !E W+++ N  ++
|| gpg: 0x962FD2DE ||  o? K- w---() O M V? PS+ PE-- Y++ PGP+ t+ 5 R+  ||
|| Ge0rG: euIRCnet ||  X(+++) tv+ b+(++) DI+++ D- G e++++ h- r++ y?   ||
++ IRCnet OFTC OPN ||_________________________________________________||

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBVkYMhWBRyWxizTQeAQKTWQ/6AnYBrd4yoGEWpAXjK6k/3tCsjqiViaxx
lkq767WvF3UH27K/tVaVYDOA6tuViW8uEw8ZgGOG0QkxZFzj52rCrs3gchkWCbLr
cJgm7oOkiPKzj4KyWHYiTz7HEG48ECdgDmfM0sl6juS+wIPPpaP9fIAAXp/NDDau
ESRz5ZUG+EmEbHor6/PkEcrpb8y0Nd8Tz3toIpNigInnvMxxaTbML5ru3RPVMESz
BthcQa422evY4Ej/p2E7Ir5VEyda9gXu/28QHwGKo89J4SFdAVqSkOLysv7T2iep
7iDQGIdiZ45pqOXRdzqXN5cOkIeIlVmMBwNeZsnod/ypFoSaPRJy3mi96HDvuaOt
iORj+nei+uTRYppT9EgU/lwx3yHSJXUzjcy7933s/crx1UUBWR7VNmNsAuyFzbx4
Sh6B+7xBdmOTAmRfUNWmJFpzRRDAIZ/FfGFTgyuo+MAAh6ZEEkWxbPyeed3vSG4A
QnzNnlMQwqTeD7i570SssfDWqnqPykYH6FNC72zeEwSI5hYk4T/NKna4aqwTsOxL
Z7Oq8gSRzqCeNT2iPkc/cyd+vt0tK1wSM93gkP3pqAs8LPMymRgiAfVDP5mvPEWz
MTm8bJ1Cipf47alb/pn70CNqJgM+C9LrSTBjqQYzGFPse4L1cwi+IP6DVOXR/tK4
TRS6LmZ9xS8=
=OE+M
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
