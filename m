Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:61510 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751412AbeA2OEz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Jan 2018 09:04:55 -0500
Subject: Re: btrfs check: backref lost, mismatch with its hash -- can't repair
To: "^m'e" <marcoep@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <CAAxOLF8pwZ5jcZxB4=h-bPZBxsnCV7sB=LOghGfa0HhRqgJfSg@mail.gmail.com>
 <CAAxOLF_DB4_5wBem3qgU-B97Hq8xkmE67_qD-7Fe2=my-FN_iw@mail.gmail.com>
 <CAAxOLF8KgC=_LoaEaKft2Q7gUhKL3Fp8OLizbnnA9v4h_cSprQ@mail.gmail.com>
 <CAAxOLF9k3WJ-JPJsCEaW4ZD+XMzhRdaRXouaWLwX1JBSM1Xnxw@mail.gmail.com>
 <6d5bfa3f-3c49-1380-2bcf-d6eeca57020a@gmx.com>
 <CAAxOLF_wRCxgebwXUy7A5AqKtKchGLz46DKNiM-iPejVpfjbFg@mail.gmail.com>
 <0662a08f-5869-3eb3-5ab2-391ba9603095@gmx.com>
 <CAAxOLF8wt98KCONdEJXMvUuzxeB5_GwigGhCzEE6hSpmurXRNw@mail.gmail.com>
 <80321b99-a89c-fadf-8f1a-26ed8f598a66@gmx.com>
 <CAAxOLF9wYwUzT_AAx1Wa12XyCwACo7vp021BytHn-VaANC--=Q@mail.gmail.com>
 <802534f4-55cd-8404-5c21-4f383468c7e5@gmx.com>
 <CAAxOLF9_N0zEhED9ZQfitcNu8j=8krYbWAYNqr271o_LnMKfmw@mail.gmail.com>
 <1e6c6814-d120-144b-bed7-c1dac0d140d3@gmx.com>
 <CAAxOLF-sp1nbhbBu7TeNwfvjwRuX9i7QrRGx3Jbm=wh1n+2zQA@mail.gmail.com>
 <365e746e-de87-2977-daee-7b2335c545b1@gmx.com>
 <CAAxOLF82tDaCa8+MBNnyWXDTWX2v-H=7a9qwFtBoehGW8Q=TyA@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <f0a66bee-f648-9f00-b56b-b59646c06779@gmx.com>
Date: Mon, 29 Jan 2018 22:04:47 +0800
MIME-Version: 1.0
In-Reply-To: <CAAxOLF82tDaCa8+MBNnyWXDTWX2v-H=7a9qwFtBoehGW8Q=TyA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="LhogRrMEjYUflRJ0uPOse8XXQLh1McC9W"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LhogRrMEjYUflRJ0uPOse8XXQLh1McC9W
Content-Type: multipart/mixed; boundary="exEln211J20vkRXAOiAlSVYuHoUbZSCYp";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: ^m'e <marcoep@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <f0a66bee-f648-9f00-b56b-b59646c06779@gmx.com>
Subject: Re: btrfs check: backref lost, mismatch with its hash -- can't repair
References: <CAAxOLF8pwZ5jcZxB4=h-bPZBxsnCV7sB=LOghGfa0HhRqgJfSg@mail.gmail.com>
 <CAAxOLF9Hqnbc6g20dPasrtXW+Es562mOBujc7ve7Fc6LzG7tcQ@mail.gmail.com>
 <03ba8382-3271-6c11-b217-a48d1423e684@gmx.com>
 <CAAxOLF_DB4_5wBem3qgU-B97Hq8xkmE67_qD-7Fe2=my-FN_iw@mail.gmail.com>
 <CAAxOLF8KgC=_LoaEaKft2Q7gUhKL3Fp8OLizbnnA9v4h_cSprQ@mail.gmail.com>
 <CAAxOLF9k3WJ-JPJsCEaW4ZD+XMzhRdaRXouaWLwX1JBSM1Xnxw@mail.gmail.com>
 <6d5bfa3f-3c49-1380-2bcf-d6eeca57020a@gmx.com>
 <CAAxOLF_wRCxgebwXUy7A5AqKtKchGLz46DKNiM-iPejVpfjbFg@mail.gmail.com>
 <0662a08f-5869-3eb3-5ab2-391ba9603095@gmx.com>
 <CAAxOLF8wt98KCONdEJXMvUuzxeB5_GwigGhCzEE6hSpmurXRNw@mail.gmail.com>
 <80321b99-a89c-fadf-8f1a-26ed8f598a66@gmx.com>
 <CAAxOLF9wYwUzT_AAx1Wa12XyCwACo7vp021BytHn-VaANC--=Q@mail.gmail.com>
 <802534f4-55cd-8404-5c21-4f383468c7e5@gmx.com>
 <CAAxOLF9_N0zEhED9ZQfitcNu8j=8krYbWAYNqr271o_LnMKfmw@mail.gmail.com>
 <1e6c6814-d120-144b-bed7-c1dac0d140d3@gmx.com>
 <CAAxOLF-sp1nbhbBu7TeNwfvjwRuX9i7QrRGx3Jbm=wh1n+2zQA@mail.gmail.com>
 <365e746e-de87-2977-daee-7b2335c545b1@gmx.com>
 <CAAxOLF82tDaCa8+MBNnyWXDTWX2v-H=7a9qwFtBoehGW8Q=TyA@mail.gmail.com>
In-Reply-To: <CAAxOLF82tDaCa8+MBNnyWXDTWX2v-H=7a9qwFtBoehGW8Q=TyA@mail.gmail.com>

--exEln211J20vkRXAOiAlSVYuHoUbZSCYp
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8829=E6=97=A5 21:58, ^m'e wrote:
> Thanks for the advice, Qu!
>=20
> I used the system for a while, did some package upgrades -- writing in
> the suspect corrupted area. Then tried a btrfs-send to my backup vol,
> and it failed miserably with a nice kernel oops.
>=20
> So I went for a lowmem repair:
> -----------------------------------------------------------------------=
-----------------
> # ./btrfsck.static check --repair --mode=3Dlowmem /dev/sdb3 2>&1 | tee
> /mnt/custom/rescue/btrfs-recovery/btrfs-repair.BTR-POOL.1.log
> WARNING: low-memory mode repair support is only partial
> Fixed 0 roots.
> checking extents
> checking free space cache
> checking fs roots
> ERROR: failed to add inode 28891726 as orphan item root 257
> ERROR: root 257 INODE[28891726] is orphan item

At least I need dig the kernel code further to determine if the orphan
inode handling in btrfs-progs is correct or not.

So there won't be more dirty fix soon.

Hopefully you could get some good backup and restore the system.

At least the problem is limited to a very small range, and it's
something we could handle easily.

Thanks for all your report,
Qu

> ERROR: failed to add inode 28892766 as orphan item root 257
> ERROR: root 257 INODE[28892766] is orphan item
> ERROR: failed to add inode 28892768 as orphan item root 257
> ERROR: root 257 INODE[28892768] is orphan item
> ERROR: failed to add inode 28893017 as orphan item root 257
> ERROR: root 257 INODE[28893017] is orphan item
> ERROR: failed to add inode 28893132 as orphan item root 257
> ERROR: root 257 INODE[28893132] is orphan item
> ERROR: failed to add inode 28893724 as orphan item root 257
> ERROR: root 257 INODE[28893724] is orphan item
> ERROR: failed to add inode 28893744 as orphan item root 257
> ERROR: root 257 INODE[28893744] is orphan item
> ERROR: failed to add inode 28893858 as orphan item root 257
> ERROR: root 257 INODE[28893858] is orphan item
> ERROR: failed to add inode 28893860 as orphan item root 257
> ERROR: root 257 INODE[28893860] is orphan item
> ERROR: failed to add inode 28894007 as orphan item root 257
> ERROR: root 257 INODE[28894007] is orphan item
> ERROR: failed to add inode 28894011 as orphan item root 257
> ERROR: root 257 INODE[28894011] is orphan item
> ERROR: failed to add inode 28894084 as orphan item root 257
> ERROR: root 257 INODE[28894084] is orphan item
> ERROR: failed to add inode 28894145 as orphan item root 257
> ERROR: root 257 INODE[28894145] is orphan item
> ERROR: failed to add inode 28894223 as orphan item root 257
> ERROR: root 257 INODE[28894223] is orphan item
> ERROR: failed to add inode 28894249 as orphan item root 257
> ERROR: root 257 INODE[28894249] is orphan item
> ERROR: failed to add inode 28895101 as orphan item root 257
> ERROR: root 257 INODE[28895101] is orphan item
> ERROR: failed to add inode 44565472 as orphan item root 257
> ERROR: root 257 INODE[44565472] is orphan item
> ERROR: failed to add inode 44565473 as orphan item root 257
> ERROR: root 257 INODE[44565473] is orphan item
> ERROR: failed to add inode 44565474 as orphan item root 257
> ERROR: root 257 INODE[44565474] is orphan item
> ERROR: failed to add inode 44565475 as orphan item root 257
> ERROR: root 257 INODE[44565475] is orphan item
> ERROR: failed to add inode 44565477 as orphan item root 257
> ERROR: root 257 INODE[44565477] is orphan item
> ERROR: failed to add inode 44565478 as orphan item root 257
> ERROR: root 257 INODE[44565478] is orphan item
> ERROR: failed to add inode 44565486 as orphan item root 257
> ERROR: root 257 INODE[44565486] is orphan item
> ERROR: failed to add inode 44565487 as orphan item root 257
> ERROR: root 257 INODE[44565487] is orphan item
> ERROR: failed to add inode 44565489 as orphan item root 257
> ERROR: root 257 INODE[44565489] is orphan item
> ERROR: failed to add inode 44773502 as orphan item root 257
> ERROR: root 257 INODE[44773502] is orphan item
> ERROR: failed to add inode 44773506 as orphan item root 257
> ERROR: root 257 INODE[44773506] is orphan item
> ERROR: failed to add inode 44773507 as orphan item root 257
> ERROR: root 257 INODE[44773507] is orphan item
> ERROR: failed to add inode 44773508 as orphan item root 257
> ERROR: root 257 INODE[44773508] is orphan item
> ERROR: failed to add inode 44825557 as orphan item root 257
> ERROR: root 257 INODE[44825557] is orphan item
> ERROR: failed to add inode 47300728 as orphan item root 257
> ERROR: root 257 INODE[47300728] is orphan item
> ERROR: failed to add inode 47300730 as orphan item root 257
> ERROR: root 257 INODE[47300730] is orphan item
> ERROR: failed to add inode 47300732 as orphan item root 257
> ERROR: root 257 INODE[47300732] is orphan item
> ERROR: failed to add inode 47300733 as orphan item root 257
> ERROR: root 257 INODE[47300733] is orphan item
> ERROR: failed to add inode 47333260 as orphan item root 257
> ERROR: root 257 INODE[47333260] is orphan item
> ERROR: failed to add inode 47347678 as orphan item root 257
> ERROR: root 257 INODE[47347678] is orphan item
> ERROR: failed to add inode 47499572 as orphan item root 257
> ERROR: root 257 INODE[47499572] is orphan item
> enabling repair mode
> Checking filesystem on /dev/sdb3
> UUID: de1723e2-150c-4448-bb36-be14d7d96093
> No device size related problem found
> cache and super generation don't match, space cache will be invalidated=

> Can't find file name for inode 47353519, use 47353519 instead
> Moving file '47353519' to 'lost+found' dir since it has no valid backre=
f
> Fixed nlink of inode 257 root 47353519 name 47353519 filetype 2
> Can't find file name for inode 47353521, use 47353521 instead
> Moving file '47353521' to 'lost+found' dir since it has no valid backre=
f
> Fixed nlink of inode 257 root 47353521 name 47353521 filetype 2
> Can't find file name for inode 47411510, use 47411510 instead
> Moving file '47411510' to 'lost+found' dir since it has no valid backre=
f
> Fixed nlink of inode 257 root 47411510 name 47411510 filetype 2
> Can't find file name for inode 47413179, use 47413179 instead
> Moving file '47413179' to 'lost+found' dir since it has no valid backre=
f
> Fixed nlink of inode 257 root 47413179 name 47413179 filetype 2
> Can't find file name for inode 47417030, use 47417030 instead
> Moving file '47417030' to 'lost+found' dir since it has no valid backre=
f
> Fixed nlink of inode 257 root 47417030 name 47417030 filetype 2
> Can't find file name for inode 47417033, use 47417033 instead
> Moving file '47417033' to 'lost+found' dir since it has no valid backre=
f
> Fixed nlink of inode 257 root 47417033 name 47417033 filetype 2
> Can't find file name for inode 47417866, use 47417866 instead
> Moving file '47417866' to 'lost+found' dir since it has no valid backre=
f
> Fixed nlink of inode 257 root 47417866 name 47417866 filetype 2
> Can't find file name for inode 47430048, use 47430048 instead
> Moving file '47430048' to 'lost+found' dir since it has no valid backre=
f
> Fixed nlink of inode 257 root 47430048 name 47430048 filetype 2
> Can't find file name for inode 47430050, use 47430050 instead
> Moving file '47430050' to 'lost+found' dir since it has no valid backre=
f
> Fixed nlink of inode 257 root 47430050 name 47430050 filetype 2
> Can't find file name for inode 47431474, use 47431474 instead
> Moving file '47431474' to 'lost+found' dir since it has no valid backre=
f
> Fixed nlink of inode 257 root 47431474 name 47431474 filetype 2
> Can't find file name for inode 47431522, use 47431522 instead
> Moving file '47431522' to 'lost+found' dir since it has no valid backre=
f
> Fixed nlink of inode 257 root 47431522 name 47431522 filetype 2
> Can't find file name for inode 47431745, use 47431745 instead
> Moving file '47431745' to 'lost+found' dir since it has no valid backre=
f
> Fixed nlink of inode 257 root 47431745 name 47431745 filetype 2
> Can't find file name for inode 47431747, use 47431747 instead
> Moving file '47431747' to 'lost+found' dir since it has no valid backre=
f
> Fixed nlink of inode 257 root 47431747 name 47431747 filetype 2
> Can't find file name for inode 47440642, use 47440642 instead
> Moving file '47440642' to 'lost+found' dir since it has no valid backre=
f
> Fixed nlink of inode 257 root 47440642 name 47440642 filetype 2
> Can't find file name for inode 47440645, use 47440645 instead
> Moving file '47440645' to 'lost+found' dir since it has no valid backre=
f
> Fixed nlink of inode 257 root 47440645 name 47440645 filetype 2
> Can't find file name for inode 47440647, use 47440647 instead
> Moving file '47440647' to 'lost+found' dir since it has no valid backre=
f
> Fixed nlink of inode 257 root 47440647 name 47440647 filetype 2
> Can't find file name for inode 47440667, use 47440667 instead
> Moving file '47440667' to 'lost+found' dir since it has no valid backre=
f
> Fixed nlink of inode 257 root 47440667 name 47440667 filetype 2
> Can't find file name for inode 47831628, use 47831628 instead
> Moving file '47831628' to 'lost+found' dir since it has no valid backre=
f
> Fixed nlink of inode 257 root 47831628 name 47831628 filetype 2
> Can't find file name for inode 47831630, use 47831630 instead
> Moving file '47831630' to 'lost+found' dir since it has no valid backre=
f
> Fixed nlink of inode 257 root 47831630 name 47831630 filetype 2
> Can't find file name for inode 47833987, use 47833987 instead
> Moving file '47833987' to 'lost+found' dir sincERROR: ROOT_REF[228621
> 72057594038112278] couldn't find relative ref
> ERROR: errors found in fs roots
> e it has no valid backref
> Fixed nlink of inode 257 root 47833987 name 47833987 filetype 2
> Can't find file name for inode 47833988, use 47833988 instead
> Moving file '47833988' to 'lost+found' dir since it has no valid backre=
f
> Fixed nlink of inode 257 root 47833988 name 47833988 filetype 2
> Can't find file name for inode 47833989, use 47833989 instead
> Moving file '47833989' to 'lost+found' dir since it has no valid backre=
f
> Fixed nlink of inode 257 root 47833989 name 47833989 filetype 2
> Can't find file name for inode 47833990, use 47833990 instead
> Moving file '47833990' to 'lost+found' dir since it has no valid backre=
f
> Fixed nlink of inode 257 root 47833990 name 47833990 filetype 2
> Can't find file name for inode 47833993, use 47833993 instead
> Moving file '47833993' to 'lost+found' dir since it has no valid backre=
f
> Fixed nlink of inode 257 root 47833993 name 47833993 filetype 2
> Can't find file name for inode 47833999, use 47833999 instead
> Moving file '47833999' to 'lost+found' dir since it has no valid backre=
f
> Fixed nlink of inode 257 root 47833999 name 47833999 filetype 2
> Can't find file name for inode 47834000, use 47834000 instead
> Moving file '47834000' to 'lost+found' dir since it has no valid backre=
f
> Fixed nlink of inode 257 root 47834000 name 47834000 filetype 2
> found 107441020928 bytes used, error(s) found
> total csum bytes: 102422976
> total tree bytes: 15472656384
> total fs tree bytes: 15243919360
> total extent tree bytes: 92798976
> btree space waste bytes: 3363742740
> file data blocks allocated: 384446418944
>  referenced 335525724160
> -----------------------------------------------------------------------=
-----------------
>=20
> Then tried to mount the rootfs subvol:
>=20
> # mount -o subvol=3Drootfs /dev/sdb3 /mnt/gentoo/
> mount: /mnt/gentoo: wrong fs type, bad option, bad superblock on
> /dev/sdb3, missing codepage or helper program, or other error.
>=20
> kernel says:
> -----------------------------------------------------------------------=
-----------------
> [ 2172.296994] ------------[ cut here ]------------
> [ 2172.297001] WARNING: CPU: 6 PID: 3576 at fs/btrfs/inode.c:3585
> btrfs_orphan_cleanup+0x2d7/0x3e6
> [ 2172.297002] Modules linked in: ccm binfmt_misc rmi_smbus rmi_core
> arc4 iwlmvm mac80211 intel_rapl iTCO_wdt iTCO_vendor_support mei_wdt
> x86_pkg_temp_thermal intel_powerclamp joydev iwlwifi btusb btrtl btbcm
> btintel coretemp tpm_tis bluetooth serio_raw cfg80211 crct10dif_pclmul
> crc32_pclmul thinkpad_acpi tpm_tis_core tpm ecdh_generic crc32c_intel
> ghash_clmulni_intel rfkill i2c_i801 intel_cstate shpchp mei_me
> wmi_bmof intel_uncore mei ie31200_edac lpc_ich intel_rapl_perf raid10
> raid456 async_raid6_recov async_pq async_xor async_memcpy async_tx
> raid1 raid0 multipath linear uas usb_storage nouveau i915 rtsx_pci_ms
> memstick rtsx_pci_sdmmc mmc_core ttm drm_kms_helper drm rtsx_pci r8169
> i2c_algo_bit mxm_wmi mii wmi video
> [ 2172.297052] CPU: 6 PID: 3576 Comm: mount Not tainted 4.14.8-std520-a=
md64 #2
> [ 2172.297053] Hardware name: LENOVO 20C6003AMZ/20C6003AMZ, BIOS
> J9ET9FWW (2.25 ) 09/13/2017
> [ 2172.297054] task: ffff979c2c8e0000 task.stack: ffffa716c31dc000
> [ 2172.297056] RIP: 0010:btrfs_orphan_cleanup+0x2d7/0x3e6
> [ 2172.297057] RSP: 0018:ffffa716c31df960 EFLAGS: 00210a87
> [ 2172.297059] RAX: 0000000000084000 RBX: ffff979c71994000 RCX: 0000000=
000000000
> [ 2172.297060] RDX: ffffffffa30061e8 RSI: 0000000000000000 RDI: ffffa71=
6c31df8a8
> [ 2172.297061] RBP: ffffa716c31df9d0 R08: ffffffffa30061e0 R09: fffffff=
fa24123c1
> [ 2172.297063] R10: ffffa716c31df8a0 R11: fffff4bdc447c580 R12: ffff979=
b51f16a80
> [ 2172.297064] R13: ffff979c6f9c01f0 R14: ffff979c2cb88000 R15: 0000000=
000000000
> [ 2172.297066] FS:  0000000000000000(0000) GS:ffff979c7e380000(0063)
> knlGS:00000000f7cf0b00
> [ 2172.297067] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
> [ 2172.297068] CR2: 00000000086a5424 CR3: 00000001eed41003 CR4: 0000000=
0001606e0
> [ 2172.297069] Call Trace:
> [ 2172.297074]  btrfs_lookup_dentry+0x37b/0x3b1
> [ 2172.297076]  btrfs_lookup+0xd/0x2b
> [ 2172.297080]  lookup_slow+0xce/0x103
> [ 2172.297083]  walk_component+0x6c/0xdd
> [ 2172.297085]  ? path_init+0xa5/0x259
> [ 2172.297088]  path_lookupat+0xde/0x186
> [ 2172.297091]  ? wake_up_bit+0x19/0x1b
> [ 2172.297095]  ? slab_pre_alloc_hook+0x19/0x1f
> [ 2172.297099]  ? idr_get_free_cmn+0x3d/0x25e
> [ 2172.297101]  filename_lookup+0x78/0xf5
> [ 2172.297106]  ? _raw_spin_unlock_irqrestore+0xf/0x11
> [ 2172.297108]  ? slab_pre_alloc_hook+0x19/0x1f
> [ 2172.297110]  ? kmem_cache_alloc+0x97/0x122
> [ 2172.297112]  ? getname_kernel+0x28/0xe4
> [ 2172.297114]  vfs_path_lookup+0x36/0x3d
> [ 2172.297116]  ? vfs_path_lookup+0x36/0x3d
> [ 2172.297120]  mount_subtree+0x3a/0x79
> [ 2172.297123]  btrfs_mount+0x69f/0xadd
> [ 2172.297127]  ? find_next_bit+0xb/0xd
> [ 2172.297131]  ? pcpu_next_unpop+0x36/0x42
> [ 2172.297135]  mount_fs+0x62/0x10c
> [ 2172.297137]  vfs_kern_mount+0x66/0xd0
> [ 2172.297139]  do_mount+0x6ef/0x96e
> [ 2172.297142]  compat_SyS_mount+0x180/0x1a9
> [ 2172.297147]  do_fast_syscall_32+0xb7/0xfe
> [ 2172.297150]  entry_SYSENTER_compat+0x4c/0x5b
> [ 2172.297151] RIP: 0023:0xf7f88c29
> [ 2172.297152] RSP: 002b:00000000ff9aa530 EFLAGS: 00000296 ORIG_RAX:
> 0000000000000015
> [ 2172.297154] RAX: ffffffffffffffda RBX: 00000000085bc498 RCX: 0000000=
0085bc170
> [ 2172.297155] RDX: 00000000085c57d0 RSI: 00000000c0ed0000 RDI: 0000000=
0085bc468
> [ 2172.297156] RBP: 00000000ff9aa5f8 R08: 0000000000000000 R09: 0000000=
000000000
> [ 2172.297157] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000=
000000000
> [ 2172.297158] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000=
000000000
> [ 2172.297160] Code: 45 a8 f0 41 80 8d 20 ff ff ff 20 f0 ff 83 dc 03
> 00 00 41 83 7d 48 00 0f 84 91 00 00 00 41 8b 45 00 66 25 00 f0 66 3d
> 00 80 74 0f <0f> ff 4c 89 ef e8 8c 45 d9 ff e9 e7 fe ff ff be 01 00 00
> 00 48
> [ 2172.297193] ---[ end trace c4a78519a58b55de ]---
> -----------------------------------------------------------------------=
-----------------
>=20
> More luck without the subvol opt, though with errors
> -----------------------------------------------------------------------=
-----------------
> [ 2172.297200] BTRFS error (device sdb3): Error removing orphan entry,
> stopping orphan cleanup
> [ 2172.297202] BTRFS error (device sdb3): could not do orphan cleanup -=
22
> [ 2172.308961] BTRFS info (device sdb3): inode 47834000 still on the or=
phan list
> [ 2203.992802] BTRFS info (device sdb3): disk space caching is enabled
> [ 2203.992804] BTRFS info (device sdb3): has skinny extents
> [ 2204.027064] BTRFS info (device sdb3): enabling ssd optimizations
> -----------------------------------------------------------------------=
-----------------
>=20
> I could check some stuff in "lost+found", didn't do any write.
> Unmounted it, but something bad must have happened, as mount now fails
> (whatever I try -- 'ro,recovery,clear_cache,check_int_data'') as with
> the first attempt:
> -----------------------------------------------------------------------=
-----------------
> [ 2378.813926] BTRFS info (device sdb3): disk space caching is enabled
> [ 2378.813927] BTRFS info (device sdb3): has skinny extents
> [ 2378.837456] BTRFS error (device sdb3): parent transid verify failed
> on 180409597952 wanted 463700 found 463765
> [ 2378.837462] BTRFS error (device sdb3): failed to read block groups: =
-5
> [ 2378.857965] BTRFS error (device sdb3): open_ctree failed
> -----------------------------------------------------------------------=
-----------------
>=20
> Subsequent lowmem repairs attempts *crash*:
> -----------------------------------------------------------------------=
-----------------
> # ./btrfsck.static check --repair --mode=3Dlowmem /dev/sdb3
> WARNING: low-memory mode repair support is only partial
> parent transid verify failed on 180409597952 wanted 463700 found 463765=

> parent transid verify failed on 180409597952 wanted 463700 found 463765=

> Ignoring transid failure
> parent transid verify failed on 180409597952 wanted 463700 found 463765=

> Ignoring transid failure
> Fixed 0 roots.
> checking extents
> parent transid verify failed on 180409597952 wanted 463700 found 463765=

> Ignoring transid failure
> ERROR: chunk[143902375936 144976117760) did not find the related block
> group item
> parent transid verify failed on 180409597952 wanted 463700 found 463765=

> Ignoring transid failure
> -----------------------------------------------------------------------=
-----------------
> [ 2552.772433] btrfsck.static[3797]: segfault at f6 ip
> 00000000004029d8 sp 00007ffee2bc8960 error 6 in
> btrfs.static[400000+1c5000]
> -----------------------------------------------------------------------=
-----------------
>=20
> Standard repair still goes:
> -----------------------------------------------------------------------=
-----------------
> # ./btrfsck.static check --repair /dev/sdb3
> parent transid verify failed on 180409597952 wanted 463700 found 463765=

> parent transid verify failed on 180409597952 wanted 463700 found 463765=

> Ignoring transid failure
> parent transid verify failed on 180409597952 wanted 463700 found 463765=

> Ignoring transid failure
> Fixed 0 roots.
> checking extents
> parent transid verify failed on 180409597952 wanted 463700 found 463765=

> Ignoring transid failure
> bad block 180409597952
> ERROR: errors found in extent allocation tree or chunk allocation
> checking free space cache
> checking fs roots
> checking csums
> parent transid verify failed on 180409597952 wanted 463700 found 463765=

> Ignoring transid failure
> There are no extents for csum range 143880400896-143883313152
> Csum exists for 143880400896-143883313152 but there is no extent record=

> parent transid verify failed on 180409597952 wanted 463700 found 463765=

> Ignoring transid failure
> There are no extents for csum range 143884201984-143884873728
> Csum exists for 143884201984-143884873728 but there is no extent record=

> parent transid verify failed on 180409597952 wanted 463700 found 463765=

> Ignoring transid failure
> There are no extents for csum range 143885082624-143886172160
> Csum exists for 143885082624-143886172160 but there is no extent record=

> parent transid verify failed on 180409597952 wanted 463700 found 463765=

> Ignoring transid failure
> There are no extents for csum range 143886176256-143891030016
> Csum exists for 143886176256-143891030016 but there is no extent record=

> parent transid verify failed on 180409597952 wanted 463700 found 463765=

> Ignoring transid failure
> There are no extents for csum range 143891054592-143895662592
> Csum exists for 143891054592-143895662592 but there is no extent record=

> parent transid verify failed on 180409597952 wanted 463700 found 463765=

> Ignoring transid failure
> There are no extents for csum range 143895982080-143896252416
> Csum exists for 143895982080-143896252416 but there is no extent record=

> parent transid verify failed on 180409597952 wanted 463700 found 463765=

> Ignoring transid failure
> There are no extents for csum range 143899418624-143900753920
> Csum exists for 143899418624-143900753920 but there is no extent record=

> parent transid verify failed on 180409597952 wanted 463700 found 463765=

> Ignoring transid failure
> There are no extents for csum range 143902375936-143906275328
> Csum exists for 143902375936-143906275328 but there is no extent record=

> parent transid verify failed on 180409597952 wanted 463700 found 463765=

> Ignoring transid failure
> There are no extents for csum range 143907614720-143907672064
> Csum exists for 143907614720-143907672064 but there is no extent record=

> parent transid verify failed on 180409597952 wanted 463700 found 463765=

> Ignoring transid failure
> There are no extents for csum range 143907938304-143910674432
> Csum exists for 143907938304-143910674432 but there is no extent record=

> parent transid verify failed on 180409597952 wanted 463700 found 463765=

> Ignoring transid failure
> There are no extents for csum range 143910744064-143916498944
> Csum exists for 143910744064-143916498944 but there is no extent record=

> parent transid verify failed on 180409597952 wanted 463700 found 463765=

> Ignoring transid failure
> There are no extents for csum range 143916601344-143916675072
> Csum exists for 143916601344-143916675072 but there is no extent record=

> parent transid verify failed on 180409597952 wanted 463700 found 463765=

> Ignoring transid failure
> There are no extents for csum range 143916781568-143918166016
> Csum exists for 143916781568-143918166016 but there is no extent record=

> parent transid verify failed on 180409597952 wanted 463700 found 463765=

> Ignoring transid failure
> There are no extents for csum range 143918206976-143918305280
> Csum exists for 143918206976-143918305280 but there is no extent record=

> parent transid verify failed on 180409597952 wanted 463700 found 463765=

> Ignoring transid failure
> There are no extents for csum range 143918325760-143921917952
> Csum exists for 143918325760-143921917952 but there is no extent record=

> parent transid verify failed on 180409597952 wanted 463700 found 463765=

> Ignoring transid failure
> There are no extents for csum range 143922094080-143924146176
> Csum exists for 143922094080-143924146176 but there is no extent record=

> parent transid verify failed on 180409597952 wanted 463700 found 463765=

> Ignoring transid failure
> There are no extents for csum range 143924269056-143925121024
> Csum exists for 143924269056-143925121024 but there is no extent record=

> parent transid verify failed on 180409597952 wanted 463700 found 463765=

> Ignoring transid failure
> There are no extents for csum range 143925137408-143928786944
> Csum exists for 143925137408-143928786944 but there is no extent record=

> ERROR: errors found in csum tree
> extent buffer leak: start 180416380928 len 16384
> extent buffer leak: start 180416380928 len 16384
> extent buffer leak: start 180416380928 len 16384
> extent buffer leak: start 180416380928 len 16384
> extent buffer leak: start 180416380928 len 16384
> extent buffer leak: start 180416380928 len 16384
> extent buffer leak: start 180416380928 len 16384
> extent buffer leak: start 180416380928 len 16384
> extent buffer leak: start 180416380928 len 16384
> extent buffer leak: start 180416380928 len 16384
> extent buffer leak: start 180416380928 len 16384
> extent buffer leak: start 180416380928 len 16384
> extent buffer leak: start 180416380928 len 16384
> extent buffer leak: start 180416380928 len 16384
> extent buffer leak: start 180416380928 len 16384
> extent buffer leak: start 180416380928 len 16384
> extent buffer leak: start 180416380928 len 16384
> extent buffer leak: start 180416380928 len 16384
> extent buffer leak: start 180416380928 len 16384
> extent buffer leak: start 44046696448 len 16384
> extent buffer leak: start 44046696448 len 16384
> extent buffer leak: start 44046696448 len 16384
> extent buffer leak: start 44046696448 len 16384
> extent buffer leak: start 44046696448 len 16384
> extent buffer leak: start 44046696448 len 16384
> extent buffer leak: start 44046696448 len 16384
> extent buffer leak: start 44046696448 len 16384
> extent buffer leak: start 44046696448 len 16384
> extent buffer leak: start 44046696448 len 16384
> extent buffer leak: start 44046696448 len 16384
> extent buffer leak: start 44046696448 len 16384
> extent buffer leak: start 44046696448 len 16384
> extent buffer leak: start 44046696448 len 16384
> extent buffer leak: start 44046696448 len 16384
> extent buffer leak: start 44046696448 len 16384
> extent buffer leak: start 44046696448 len 16384
> extent buffer leak: start 44046696448 len 16384
> extent buffer leak: start 44046696448 len 16384
> enabling repair mode
> Checking filesystem on /dev/sdb3
> UUID: de1723e2-150c-4448-bb36-be14d7d96093
> found 70715043840 bytes used, error(s) found
> total csum bytes: 0
> total tree bytes: 77332480
> total fs tree bytes: 0
> total extent tree bytes: 77201408
> btree space waste bytes: 20938256
> file data blocks allocated: 18350080
>  referenced 18350080
> -----------------------------------------------------------------------=
-----------------
>=20
> Mmh, smells like Dip Sheet (TM)... :-(
>=20


--exEln211J20vkRXAOiAlSVYuHoUbZSCYp--

--LhogRrMEjYUflRJ0uPOse8XXQLh1McC9W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpvKf8XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgOBwf/b8fVZYanhyh9pyD5xiAuxJT7
doXJoY2okQ+OzlsonLNj9ZN/VTsabHmb9Cl1lBRL64fsmgWqDTrr4vV70if2GqnB
5hcsGQ3wgXA+5s8u/2pECOpCpuNFkdSIa3IcntaidkicJGQPcWmAAKw7FouqVLPZ
Hli/kgHg/bdlpKpfXctOSTpkq+JCVKnY1uxkvS9cxc6ueorfVnl7TZl1V3B76Oui
a/f2EHwqSmh4jY9P43TPN1Aa0lYCt5THGuiMBThxsxgAu+aaRu3dA17V1IBe2Gmo
0BPW4JXeLcTe9Wr9bKHi9EASGIMyFc3HNfNiNdH3+ui0pLNhQrcY6ed98CWihg==
=USEb
-----END PGP SIGNATURE-----

--LhogRrMEjYUflRJ0uPOse8XXQLh1McC9W--
