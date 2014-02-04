Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from luka.romanrm.net ([213.163.64.74]:51806 "EHLO luka.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbaBDQXR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Feb 2014 11:23:17 -0500
Received: from natsu (unknown [IPv6:fd39::a60:6eff:fef3:b5b3])
	by luka.romanrm.net (Postfix) with ESMTPS id A9E5C40074
	for <linux-btrfs@vger.kernel.org>; Tue,  4 Feb 2014 16:23:14 +0000 (UTC)
Date: Tue, 4 Feb 2014 22:23:10 +0600
From: Roman Mamedov <rm@romanrm.net>
To: linux-btrfs@vger.kernel.org
Subject: btrfs crash with a corrupted(?) filesystem
Message-ID: <20140204222310.65c4a468@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/0T1WeV5P.yc02a9lak0aO48"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/0T1WeV5P.yc02a9lak0aO48
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

My server had a period of instability (PSU-related issues), some lockups,
some strange crashes, and some files became corrupted, and perhaps parts of
a filesystem too. One BTRFS partition now fails with the following errors.

On an attempt to make a snapshot:

[   48.035664] btrfs: corrupt leaf, bad key order: block=3D193529446400,roo=
t=3D1, slot=3D9
[   48.035795] ------------[ cut here ]------------
[   48.035840] kernel BUG at fs/btrfs/inode.c:873!
[   48.035884] invalid opcode: 0000 [#1] SMP=20
[   48.036000] Modules linked in: cpufreq_stats cpufreq_userspace cpufreq_p=
owersave cpufreq_conservative nfsd auth_rpcgss oid_registry nfs_acl nfs loc=
kd dns_resolver fscache sunrpc 8021q garp mrp bridge stp llc fuse ext3 jbd =
it87 hwmon_vid ecryptfs snd_hda_codec_hdmi acpi_cpufreq snd_hda_codec_realt=
ek mperf snd_hda_intel snd_hda_codec kvm_amd snd_pcsp snd_hwdep kvm fglrx(P=
O) snd_pcm_oss sp5100_tco snd_mixer_oss crc32c_intel ghash_clmulni_intel sn=
d_pcm eeepc_wmi aesni_intel asus_wmi sparse_keymap uvcvideo videobuf2_vmall=
oc videobuf2_memops videobuf2_core psmouse rfkill snd_page_alloc video vide=
odev edac_mce_amd snd_timer edac_core aes_x86_64 serio_raw evdev fam15h_pow=
er media snd ablk_helper joydev i2c_piix4 cp210x cryptd processor usbserial=
 k10temp lrw i2c_core mxm_wmi thermal_sys gf128mul wmi glue_helper soundcor=
e ehci_pci button ext4 crc16 jbd2 mbcache btrfs zlib_deflate crc32c libcrc3=
2c dm_mod raid1 raid456 async_raid6_recov async_memcpy async_pq async_xor a=
sync_tx xor raid6_pq md_mod nbd sata_nv sg sd_mod crc_t10dif hid_generic us=
bhid hid sata_promise ohci_hcd ehci_hcd microcode xhci_hcd ahci ata_generic=
 libahci libata usbcore r8169 mii usb_common scsi_mod
[   48.040775] CPU: 4 PID: 4145 Comm: btrfs Tainted: P           O 3.10.28-=
rm1+ #54
[   48.040825] Hardware name: To be filled by O.E.M. To be filled by O.E.M.=
/M5A97 LE R2.0, BIOS 1903 07/11/2013
[   48.040876] task: ffff88040b4dc300 ti: ffff880409c14000 task.ti: ffff880=
409c14000
[   48.040926] RIP: 0010:[<ffffffffa023f225>]  [<ffffffffa023f225>] __cow_f=
ile_range+0x445/0x4e0 [btrfs]
[   48.041042] RSP: 0018:ffff880409c15328  EFLAGS: 00010203
[   48.041086] RAX: 0000000000001000 RBX: 0000000000000000 RCX: 00000000000=
00102
[   48.041131] RDX: 0000000000000103 RSI: ffff88042e16a2e0 RDI: ffff88042e1=
46e50
[   48.041177] RBP: ffff880409c153e8 R08: 0000000000000000 R09: 00000000000=
3ffff
[   48.041222] R10: 0000000000040000 R11: 0000000000000001 R12: ffff8804352=
eb0a0
[   48.041267] R13: 0000000000000000 R14: ffff88042e16a2e0 R15: 00000000000=
00000
[   48.041318] FS:  00007f064ac9e780(0000) GS:ffff88044ed00000(0000) knlGS:=
0000000000000000
[   48.041367] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   48.041411] CR2: 000000000046a9f0 CR3: 00000004388dc000 CR4: 00000000000=
407e0
[   48.041456] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[   48.041532] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[   48.041576] Stack:
[   48.041617]  ffff880409c15388 ffff880430a2e800 ffff8804352eb130 ffff8804=
09c15350
[   48.041813]  000000000003ffff ffff88042e16a100 ffff880409c15350 ffffea00=
0eb312c8
[   48.042006]  ffff88042e146e50 ff00000000ff16a0 ffff8804347c0800 00000000=
00000000
[   48.042200] Call Trace:
[   48.042274]  [<ffffffffa0255a89>] ? free_extent_buffer+0x59/0xa0 [btrfs]
[   48.042348]  [<ffffffffa023f668>] run_delalloc_nocow+0x3a8/0xaf0 [btrfs]
[   48.042421]  [<ffffffffa02401c0>] run_delalloc_range+0x330/0x390 [btrfs]
[   48.042495]  [<ffffffffa0254641>] __extent_writepage+0x2f1/0x750 [btrfs]
[   48.042570]  [<ffffffffa0254d52>] extent_write_cache_pages.isra.31.const=
prop.47+0x2b2/0x3c0 [btrfs]
[   48.042650]  [<ffffffffa02550d7>] extent_writepages+0x47/0x60 [btrfs]
[   48.042752]  [<ffffffffa023bee0>] ? can_nocow_odirect+0x330/0x330 [btrfs]
[   48.042823]  [<ffffffffa0239873>] btrfs_writepages+0x23/0x30 [btrfs]
[   48.042873]  [<ffffffff8110ea19>] do_writepages+0x19/0x40
[   48.042921]  [<ffffffff81104711>] __filemap_fdatawrite_range+0x51/0x60
[   48.042969]  [<ffffffff811054ce>] filemap_fdatawrite_range+0xe/0x10
[   48.043042]  [<ffffffffa024f9e8>] btrfs_wait_ordered_range+0x48/0x110 [b=
trfs]
[   48.043116]  [<ffffffffa027499a>] __btrfs_write_out_cache+0x76a/0x990 [b=
trfs]
[   48.043187]  [<ffffffffa0232405>] ? btrfs_buffer_uptodate+0x65/0x80 [btr=
fs]
[   48.043261]  [<ffffffffa0274ec2>] btrfs_write_out_cache+0xb2/0xf0 [btrfs]
[   48.045346]  [<ffffffffa0255a89>] ? free_extent_buffer+0x59/0xa0 [btrfs]
[   48.045414]  [<ffffffffa0227383>] btrfs_write_dirty_block_groups+0x573/0=
x660 [btrfs]
[   48.045489]  [<ffffffffa02353a4>] commit_cowonly_roots+0x164/0x260 [btrf=
s]
[   48.045560]  [<ffffffffa023724c>] btrfs_commit_transaction+0x59c/0xab0 [=
btrfs]
[   48.045614]  [<ffffffff81075030>] ? finish_wait+0x80/0x80
[   48.045686]  [<ffffffffa026692a>] btrfs_mksubvol.isra.49+0x3aa/0x450 [bt=
rfs]
[   48.045759]  [<ffffffffa0266aba>] btrfs_ioctl_snap_create_transid+0xea/0=
x170 [btrfs]
[   48.045838]  [<ffffffffa0266bfa>] ? btrfs_ioctl_snap_create_v2+0x3a/0x14=
0 [btrfs]
[   48.045917]  [<ffffffffa0266cb9>] btrfs_ioctl_snap_create_v2+0xf9/0x140 =
[btrfs]
[   48.045995]  [<ffffffffa0268cc2>] btrfs_ioctl+0x942/0x1eb0 [btrfs]
[   48.046043]  [<ffffffff8112b111>] ? handle_mm_fault+0x251/0x350
[   48.046091]  [<ffffffff814a6bc4>] ? __do_page_fault+0x254/0x4f0
[   48.046139]  [<ffffffff81307287>] ? tty_ldisc_deref+0x37/0xa0
[   48.046186]  [<ffffffff8108604a>] ? __dequeue_entity+0x2a/0x50
[   48.046232]  [<ffffffff81173c77>] do_vfs_ioctl+0x87/0x560
[   48.046279]  [<ffffffff811741e1>] SyS_ioctl+0x91/0xb0
[   48.046326]  [<ffffffff814a9be9>] system_call_fastpath+0x16/0x1b
[   48.046399] Code: 48 8b 7d 80 4c 89 f6 e8 fa 99 00 00 e9 75 fc ff ff 48 =
85 d2 74 50 80 be 30 fe ff ff 84 48 89 d1 74 44 48 ff c9 0f 84 26 fc ff ff =
<0f> 0b 48 8b 75 90 48 8b 7d 80 41 89 c0 b9 9b 03 00 00 48 c7 c2=20
[   48.048869] RIP  [<ffffffffa023f225>] __cow_file_range+0x445/0x4e0 [btrf=
s]
[   48.048973]  RSP <ffff880409c15328>
[   48.049046] ---[ end trace 59138219c3d9423b ]---

Without trying to make that snapshot, but simply on an attempt to unmount:

[   83.368744] btrfs: corrupt leaf, bad key order: block=3D193529446400,roo=
t=3D1, slot=3D9
[   83.368876] ------------[ cut here ]------------
[   83.368921] kernel BUG at fs/btrfs/inode.c:873!
[   83.368965] invalid opcode: 0000 [#1] SMP=20
[   83.369081] Modules linked in: nfsd auth_rpcgss oid_registry nfs_acl nfs=
 lockd dns_resolver fscache sunrpc 8021q garp mrp bridge stp llc fuse ext3 =
jbd it87 hwmon_vid ecryptfs snd_hda_codec_hdmi fglrx(PO) snd_hda_codec_real=
tek snd_hda_intel snd_hda_codec snd_pcsp snd_hwdep snd_pcm_oss snd_mixer_os=
s snd_pcm acpi_cpufreq mperf eeepc_wmi kvm_amd kvm asus_wmi crc32c_intel ps=
mouse ghash_clmulni_intel uvcvideo snd_page_alloc aesni_intel sparse_keymap=
 serio_raw videobuf2_vmalloc videobuf2_memops videobuf2_core rfkill videode=
v fam15h_power joydev evdev aes_x86_64 ablk_helper video cryptd media sp510=
0_tco snd_timer lrw snd cp210x usbserial mxm_wmi processor gf128mul ehci_pc=
i edac_mce_amd i2c_piix4 glue_helper soundcore k10temp button edac_core i2c=
_core thermal_sys wmi ext4 crc16 jbd2 mbcache btrfs zlib_deflate crc32c lib=
crc32c dm_mod raid1 raid456 async_raid6_recov async_memcpy async_pq async_x=
or async_tx xor raid6_pq md_mod nbd sata_nv sg sd_mod crc_t10dif hid_generi=
c usbhid hid sata_promise microcode ahci libahci ata_generic ohci_hcd libat=
a ehci_hcd scsi_mod xhci_hcd usbcore r8169 usb_common mii
[   83.373704] CPU: 2 PID: 3024 Comm: umount Tainted: P           O 3.10.28=
-rm1+ #54
[   83.373753] Hardware name: To be filled by O.E.M. To be filled by O.E.M.=
/M5A97 LE R2.0, BIOS 1903 07/11/2013
[   83.373804] task: ffff8804386d8400 ti: ffff880439bac000 task.ti: ffff880=
439bac000
[   83.373853] RIP: 0010:[<ffffffffa024b225>]  [<ffffffffa024b225>] __cow_f=
ile_range+0x445/0x4e0 [btrfs]
[   83.373970] RSP: 0018:ffff880439bad458  EFLAGS: 00010207
[   83.374014] RAX: 0000000000001000 RBX: 0000000000000000 RCX: 00000000000=
00121
[   83.374058] RDX: 0000000000000122 RSI: ffff88044dec6c10 RDI: ffff88044de=
6c9f0
[   83.374103] RBP: ffff880439bad518 R08: 0000000000000000 R09: 00000000000=
3ffff
[   83.374177] R10: 0000000000040000 R11: 0000000000000001 R12: ffff88042f6=
c6f40
[   83.374222] R13: 0000000000000000 R14: ffff88044dec6c10 R15: 00000000000=
00000
[   83.374268] FS:  00007f166a7a7800(0000) GS:ffff88044ec80000(0000) knlGS:=
0000000000000000
[   83.374317] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   83.374361] CR2: 00007f033d93648f CR3: 00000004390a9000 CR4: 00000000000=
407e0
[   83.374406] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[   83.374450] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[   83.374494] Stack:
[   83.374536]  ffff880439bad4b8 ffff8804310d0800 ffff88042f6c6eb0 ffff8804=
39bad480
[   83.374729]  000000000003ffff ffff88044dec6a30 ffff880439bad480 ffffea00=
0ea75640
[   83.374922]  ffff88044de6c9f0 ff00000000ff16a0 ffff880431097800 00000000=
00000000
[   83.375115] Call Trace:
[   83.375189]  [<ffffffffa0261a89>] ? free_extent_buffer+0x59/0xa0 [btrfs]
[   83.375261]  [<ffffffffa024b668>] run_delalloc_nocow+0x3a8/0xaf0 [btrfs]
[   83.375333]  [<ffffffffa024c1c0>] run_delalloc_range+0x330/0x390 [btrfs]
[   83.375436]  [<ffffffffa0260641>] __extent_writepage+0x2f1/0x750 [btrfs]
[   83.375510]  [<ffffffffa0260d52>] extent_write_cache_pages.isra.31.const=
prop.47+0x2b2/0x3c0 [btrfs]
[   83.377508]  [<ffffffffa02610d7>] extent_writepages+0x47/0x60 [btrfs]
[   83.377579]  [<ffffffffa0247ee0>] ? can_nocow_odirect+0x330/0x330 [btrfs]
[   83.377649]  [<ffffffffa0245873>] btrfs_writepages+0x23/0x30 [btrfs]
[   83.377699]  [<ffffffff8110ea19>] do_writepages+0x19/0x40
[   83.377747]  [<ffffffff81104711>] __filemap_fdatawrite_range+0x51/0x60
[   83.377824]  [<ffffffff811054ce>] filemap_fdatawrite_range+0xe/0x10
[   83.377897]  [<ffffffffa025b9e8>] btrfs_wait_ordered_range+0x48/0x110 [b=
trfs]
[   83.377971]  [<ffffffffa028099a>] __btrfs_write_out_cache+0x76a/0x990 [b=
trfs]
[   83.378040]  [<ffffffffa023e405>] ? btrfs_buffer_uptodate+0x65/0x80 [btr=
fs]
[   83.378114]  [<ffffffffa0280ec2>] btrfs_write_out_cache+0xb2/0xf0 [btrfs]
[   83.378188]  [<ffffffffa0261a89>] ? free_extent_buffer+0x59/0xa0 [btrfs]
[   83.378255]  [<ffffffffa0233383>] btrfs_write_dirty_block_groups+0x573/0=
x660 [btrfs]
[   83.378329]  [<ffffffffa02413a4>] commit_cowonly_roots+0x164/0x260 [btrf=
s]
[   83.378400]  [<ffffffffa024324c>] btrfs_commit_transaction+0x59c/0xab0 [=
btrfs]
[   83.378452]  [<ffffffff81075030>] ? finish_wait+0x80/0x80
[   83.378520]  [<ffffffffa023e0eb>] btrfs_commit_super+0xbb/0x110 [btrfs]
[   83.378589]  [<ffffffffa023e2f8>] close_ctree+0x1b8/0x260 [btrfs]
[   83.378637]  [<ffffffff8117b609>] ? dispose_list+0x39/0x50
[   83.378684]  [<ffffffff8117c080>] ? evict_inodes+0xb0/0x110
[   83.378753]  [<ffffffffa0215a94>] btrfs_put_super+0x14/0x20 [btrfs]
[   83.378801]  [<ffffffff8116498c>] generic_shutdown_super+0x5c/0xe0
[   83.378852]  [<ffffffff81164aa1>] kill_anon_super+0x11/0x20
[   83.378914]  [<ffffffffa0217f15>] btrfs_kill_super+0x15/0x90 [btrfs]
[   83.378963]  [<ffffffff811652dd>] deactivate_locked_super+0x3d/0x70
[   83.379040]  [<ffffffff811658f9>] deactivate_super+0x49/0x70
[   83.379086]  [<ffffffff8117f6ec>] mntput_no_expire+0xfc/0x160
[   83.379131]  [<ffffffff81180777>] SyS_umount+0x97/0x3a0
[   83.379178]  [<ffffffff81064ef5>] ? sigprocmask+0x45/0x80
[   83.379227]  [<ffffffff814a9be9>] system_call_fastpath+0x16/0x1b
[   83.379270] Code: 48 8b 7d 80 4c 89 f6 e8 fa 99 00 00 e9 75 fc ff ff 48 =
85 d2 74 50 80 be 30 fe ff ff 84 48 89 d1 74 44 48 ff c9 0f 84 26 fc ff ff =
<0f> 0b 48 8b 75 90 48 8b 7d 80 41 89 c0 b9 9b 03 00 00 48 c7 c2=20
[   83.381744] RIP  [<ffffffffa024b225>] __cow_file_range+0x445/0x4e0 [btrf=
s]
[   83.381848]  RSP <ffff880439bad458>
[   83.381908] ---[ end trace 7161f57ab1b05921 ]---

Currently I have it mounted read-only, and all data seems to be accessible.
Short of copying everything away and recreating the FS, how can I bring it =
to
a working order. Is btrfsck a good option here?

Thanks

--=20
With respect,
Roman

--Sig_/0T1WeV5P.yc02a9lak0aO48
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlLxE+4ACgkQTLKSvz+PZwhiowCfeCUQ3i+kQY+umsh9zzQ0X0p/
xtYAniZEFJPgbL2qZPmAKc/YXPj4f+0l
=3yKP
-----END PGP SIGNATURE-----

--Sig_/0T1WeV5P.yc02a9lak0aO48--
