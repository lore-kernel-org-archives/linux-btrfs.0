Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bender.boerde.de ([83.223.75.23]:34287 "EHLO bender.boerde.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbbLJUm7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Dec 2015 15:42:59 -0500
Received: from hunapu.boerde.de (darkwing.home.local [IPv6:2a01:30:2802:1:2ad2:44ff:feb0:8e38])
	by bender.boerde.de (Postfix) with ESMTPSA id 50E731454101
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Dec 2015 21:42:56 +0100 (CET)
Date: Thu, 10 Dec 2015 21:42:54 +0100
From: Georg Lukas <georg@op-co.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: !PageLocked BUG_ON hit in clear_page_dirty_for_io
Message-ID: <20151210204254.GA31395@ovgu.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
In-Reply-To: <20151210190220.GA11257@ret.masoncoding.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Chris Mason <clm@fb.com> [2015-12-10 20:02]:
> Huh, are you able to reproduce at will?  From this code path it should
> mean somebody else is unlocking a page they don't own.

I've got another code path causing this bug that happened during a
"btrfs dev delete missing". Didn't try to reproduce it though, but
downgraded to 4.3 where it doesn't happen:


[10661.929152] BTRFS info (device dm-1): relocating block group 19173384781=
824 flags 17
[10709.050290] ------------[ cut here ]------------
[10709.050316] kernel BUG at mm/page-writeback.c:2654!
[10709.050338] invalid opcode: 0000 [#1] SMP=20
[10709.050366] Modules linked in: dm_crypt loop sha256_ssse3 sha256_generic=
 hmac drbg ansi_cprng xts gf128mul algif_skcipher af_alg cpuid nfsd auth_rp=
cg
ss oid_registry nfs_acl nfs lockd grace fscache sunrpc btrfs xor intel_rapl=
 iosf_mbi x86_pkg_temp_thermal intel_powerclamp kvm_intel kvm irqbypass snd=
_p
cm crct10dif_pclmul snd_timer evdev snd crc32_pclmul iTCO_wdt iTCO_vendor_s=
upport soundcore cryptd psmouse pcspkr serio_raw hpilo hpwdt lpc_ich raid6_=
pq
 8250_fintek mfd_core acpi_power_meter button pcc_cpufreq acpi_cpufreq tpm_=
tis tpm shpchp processor coretemp ipmi_watchdog dm_mod ipmi_si ipmi_powerof=
f ipmi_devintf ipmi_msghandler fuse autofs4 ext4 crc16 mbcache jbd2 hid_gen=
eric usbhid hid sg sd_mod ses enclosure usb_storage crc32c_intel ahci libah=
ci libata scsi_mod uhci_hcd thermal xhci_pci xhci_hcd
[10709.050854]  tg3 ptp pps_core libphy ehci_pci ehci_hcd usbcore usb_common
[10709.050899] CPU: 1 PID: 14215 Comm: btrfs Tainted: G        W       4.4.=
0-rc4-gl+ #44
[10709.050933] Hardware name: HP ProLiant MicroServer Gen8, BIOS J06 06/06/=
2014
[10709.050956] task: ffff8800791e5100 ti: ffff880016a2c000 task.ti: ffff880=
016a2c000
[10709.050989] RIP: 0010:[<ffffffff81142dc3>]  [<ffffffff81142dc3>] clear_p=
age_dirty_for_io+0xd3/0x190
[10709.051030] RSP: 0018:ffff880016a2f7c0  EFLAGS: 00010246
[10709.051051] RAX: 01ffff800000082c RBX: ffffea000185efc0 RCX: ffffea00018=
5efc0
[10709.051073] RDX: 0000000000000000 RSI: ffff880016a2f7c0 RDI: ffffea00018=
5efc0
[10709.051096] RBP: ffff880036a4b700 R08: 0000168a3405fe9c R09: 00000000000=
00000
[10709.051118] R10: 0000000000000000 R11: 00000000000003e5 R12: ffff880036a=
4b700
[10709.051140] R13: ffff880016a2f8a0 R14: ffffffffffffffff R15: ffffea00018=
5efc0
[10709.051162] FS:  00007ff63f1708c0(0000) GS:ffff88007ac20000(0000) knlGS:=
0000000000000000
[10709.051196] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[10709.051217] CR2: 00007fbab82c8000 CR3: 000000002fc60000 CR4: 00000000001=
406e0
[10709.051238] Stack:
[10709.051255]  ffff880016a2f830 ffff880016a2f910 ffff880036a4b700 ffff8800=
16a2f8a0
[10709.051298]  ffffffffffffffff ffffffffa0525bed ffff880016a2f8d8 00000000=
36a4b428
[10709.051340]  0000000000000000 0000000000000002 ffff880036a4b598 00000000=
0000002a
[10709.051384] Call Trace:
[10709.051417]  [<ffffffffa0525bed>] ? extent_write_cache_pages.isra.31.con=
stprop.51+0x14d/0x330 [btrfs]
[10709.051460]  [<ffffffffa0526e38>] ? extent_writepages+0x48/0x60 [btrfs]
[10709.051489]  [<ffffffffa050a660>] ? btrfs_real_readdir+0x4f0/0x4f0 [btrf=
s]
[10709.051513]  [<ffffffff81139d42>] ? __filemap_fdatawrite_range+0xa2/0xe0
[10709.051543]  [<ffffffffa051b5f6>] ? btrfs_fdatawrite_range+0x16/0x40 [bt=
rfs]
[10709.051572]  [<ffffffffa05464e4>] ? __btrfs_write_out_cache.isra.25+0x3c=
4/0x410 [btrfs]
[10709.051613]  [<ffffffffa0547e73>] ? btrfs_write_out_cache+0x83/0xd0 [btr=
fs]
[10709.051641]  [<ffffffffa04f33d2>] ? btrfs_write_dirty_block_groups+0x232=
/0x2a0 [btrfs]
[10709.051679]  [<ffffffffa05771cd>] ? commit_cowonly_roots+0x206/0x2a3 [bt=
rfs]
[10709.051708]  [<ffffffffa0506766>] ? btrfs_commit_transaction+0x516/0x9f0=
 [btrfs]
[10709.051748]  [<ffffffffa0506cd0>] ? start_transaction+0x90/0x480 [btrfs]
[10709.051776]  [<ffffffffa05545a8>] ? relocate_block_group+0x2b8/0x6a0 [bt=
rfs]
[10709.051806]  [<ffffffffa05201a3>] ? btrfs_wait_ordered_roots+0x1a3/0x1c0=
 [btrfs]
[10709.051845]  [<ffffffffa0554b27>] ? btrfs_relocate_block_group+0x197/0x2=
70 [btrfs]
[10709.051886]  [<ffffffffa052c92c>] ? btrfs_relocate_chunk.isra.38+0x3c/0x=
c0 [btrfs]
[10709.051926]  [<ffffffffa052d2d6>] ? btrfs_shrink_device+0x196/0x520 [btr=
fs]
[10709.051955]  [<ffffffffa0533d2e>] ? btrfs_rm_device+0x30e/0x7b0 [btrfs]
[10709.051984]  [<ffffffffa053cd5b>] ? btrfs_ioctl+0x20bb/0x2e10 [btrfs]
[10709.052007]  [<ffffffff8116f3ba>] ? page_add_file_rmap+0xa/0x50
[10709.052029]  [<ffffffff81163b48>] ? do_set_pte+0xc8/0xf0
[10709.052050]  [<ffffffff81139128>] ? filemap_map_pages+0x208/0x210
[10709.052073]  [<ffffffff8119977f>] ? mem_cgroup_try_charge+0x5f/0x1a0
[10709.052095]  [<ffffffff81164f1f>] ? handle_mm_fault+0x11df/0x16a0
[10709.052118]  [<ffffffff811af3da>] ? getname_flags+0x6a/0x1e0
[10709.052140]  [<ffffffff811b2fc3>] ? do_vfs_ioctl+0x293/0x470
[10709.052162]  [<ffffffff811b320f>] ? SyS_ioctl+0x6f/0x80
[10709.052183]  [<ffffffff81506a2e>] ? entry_SYSCALL_64_fastpath+0x12/0x6d
[10709.052205] Code: b4 24 00 01 00 00 f0 0f ba 33 04 72 20 31 db 48 85 ed =
0f 85 9a 00 00 00 4c 89 ef e8 28 1a 05 00 89 d8 5b 5d 41 5c 41 5d 41 5e c3 =
<0f> 0b 4d 85 ed 74 0c 49 8b 85 68 02 00 00 65 48 ff 48 20 be 0b=20
[10709.052472] RIP  [<ffffffff81142dc3>] clear_page_dirty_for_io+0xd3/0x190
[10709.052499]  RSP <ffff880016a2f7c0>
[10709.052860] ---[ end trace d5563d95fa19d835 ]---

Hope that helps,


Georg

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBVmnjzWBRyWxizTQeAQLMig/8D9IVzTY3wt/s7+v0KEC0YAILIXtwbCVR
X2xPcuAQ1ZpiRpYNoAW9aSqw99y5mhr2RqT306JN7XDbsVFXbKUBRQ2NHGs1duUk
+QtD5SEC1Y3zZ1aUW87nk7wTaXyCaeyqDiUgRwjfTRPmfSqENV2Fh292WvOvStRO
A2xJVUimKM7DmFyyxHwUlYFy1LVlIN4LlDAs4NMy1m7ehFmS/iB77ye0THuvzAji
vMn+5QKb1Yd2uz87+EWNQNmR69s9JBzqyBtR1Mw9FxCBD2hUuH9qoZZxsWletzFF
qhGZ+sgN3F0Dpu50k0uwzcm/+cmEb0JKeX2XH89hiNsQbCrbstfq7iGEaIkTMX99
naASAXVw61Rt/TRIw6qgqU7S4WR+50FzU7i2sq6Tkl3CfNPRlNtb075SUm0n2ujy
/jVAij3ZO5AN1hjr1FCPglCbYcw6wtnjklJFUyUhG/o8XL1opcjeEuSKwhqWHRgP
G1dQC4pT3ObcDwuKxHKuZc44EOvRBbhGcM71FESj/dGCJX9r5obdUNm5JoebITRX
jeluMFT/yIa1pF9CInKEOS3bCL8RK95oxXlIDIMUIm5J6TFZt4sK5sMspwxu0Oah
xvcVIIW68fVnQDxPuFjqmOX5rb4YDOkMWFIUfj0GFW67iZM0A4t+yhPQW/C0Qf/O
6o3t6nMj5XM=
=wVrh
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
