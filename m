Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:35634 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751542AbaJWXQX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Oct 2014 19:16:23 -0400
Date: Thu, 23 Oct 2014 19:16:22 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: linux-btrfs@vger.kernel.org
Subject: Check tree block failed, want=17716610236416, have=0
Message-ID: <20141023231622.GC17395@hungrycats.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p2kqVDKq5asng8Dg"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--p2kqVDKq5asng8Dg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I attempted to run btrfs check --repair, but it got stuck spinning
in what appeared to be an infinite loop.  strace and ltrace revealed
nothing, and gdb wasn't particularly helpful, so I rebuilt btrfs with
debug symbols and tried again.

Now I get this from btrfs check:

	Couldn't map the block 17716610236416
	No mapping for 17716610236416-17716610252800
	Couldn't map the block 17716610236416
	Check tree block failed, want=3D17716610236416, have=3D0
	read block failed check_tree_block
	Couldn't read chunk root

Mount fails too:

	Oct 23 18:19:38 testhost kernel: [  388.193783] BTRFS: device label vgs2-m=
d0 devid 3 transid 282186 /dev/dm-11
	Oct 23 18:19:38 testhost kernel: [  388.232892] BTRFS: device label vgs2-m=
d0 devid 1 transid 282186 /dev/mapper/md15
	Oct 23 18:19:38 testhost kernel: [  388.233305] BTRFS: device label vgs2-m=
d0 devid 2 transid 282186 /dev/mapper/md16
	Oct 23 18:19:38 testhost kernel: [  388.234459] BTRFS: device label vgs2-m=
d0 devid 4 transid 282186 /dev/mapper/md18
	Oct 23 18:19:38 testhost kernel: [  388.759456] BTRFS info (device dm-12):=
 disk space caching is enabled
	Oct 23 18:19:38 testhost kernel: [  388.759462] BTRFS: has skinny extents
	Oct 23 18:19:38 testhost kernel: [  388.760576] BTRFS critical (device dm-=
12): unable to find logical 17716610236416 len 4096
	Oct 23 18:19:38 testhost kernel: [  388.760733] ------------[ cut here ]--=
----------
	Oct 23 18:19:38 testhost kernel: [  388.760807] kernel BUG at fs/btrfs/ino=
de.c:1659!
	Oct 23 18:19:38 testhost kernel: [  388.760880] invalid opcode: 0000 [#1] =
PREEMPT SMP
	Oct 23 18:19:38 testhost kernel: [  388.761063] Modules linked in: tun cpu=
freq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative softdog=
 nfsd auth_rpcgss nfs_acl nfs lockd fscache sunrpc dummy ipt_MASQUERADE xt_=
nat xt_tcpudp xt_state iptable_mangle nf_log_ipv4 nf_log_common xt_LOG xt_l=
imit iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_con=
ntrack ip6table_filter ip6_tables iptable_filter ip_tables x_tables sch_fq_=
codel tcp_illinois dm_crypt snd_hda_codec_realtek snd_hda_codec_generic snd=
_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm snd_seq snd_s=
eq_device snd_timer kvm_amd eeepc_wmi snd kvm asus_wmi sparse_keymap rfkill=
 soundcore evdev pcspkr i2c_piix4 parport_pc i2c_core acpi_cpufreq k10temp =
parport rtc_cmos video processor wmi button thermal_sys k8temp hwmon_vid hw=
mon btrfs xor raid6_pq dm_mod raid1 md_mod af_packet ipv6 nbd sg uas crct10=
dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x8=
6_64 lrw gf128mul glue_helper ablk_helper cryptd microc
	Oct 23 18:19:38 testhost kernel: ode r8169 mii firmware_class ehci_pci ohc=
i_pci ohci_hcd ehci_hcd
	Oct 23 18:19:38 testhost kernel: [  388.765409] CPU: 0 PID: 25132 Comm: mo=
unt Tainted: G        W      3.17.1-zb64+ #1
	Oct 23 18:19:38 testhost kernel: [  388.765516] Hardware name: System manu=
facturer System Product Name/A55BM-E, BIOS 0902 11/14/2013
	Oct 23 18:19:38 testhost kernel: [  388.765625] task: ffff8800a3108000 ti:=
 ffff8804083c8000 task.ti: ffff8804083c8000
	Oct 23 18:19:38 testhost kernel: [  388.765733] RIP: 0010:[<ffffffffc027ea=
80>]  [<ffffffffc027ea80>] btrfs_merge_bio_hook+0x80/0x90 [btrfs]
	Oct 23 18:19:38 testhost kernel: [  388.765905] RSP: 0018:ffff8804083cb8b8=
  EFLAGS: 00010282
	Oct 23 18:19:38 testhost kernel: [  388.765979] RAX: 00000000ffffffea RBX:=
 0000000000001000 RCX: 0000000000000000
	Oct 23 18:19:38 testhost kernel: [  388.766055] RDX: 0000000000000001 RSI:=
 ffffffff8179e4f9 RDI: ffffffff810ca45a
	Oct 23 18:19:38 testhost kernel: [  388.766135] RBP: ffff8804083cb8d8 R08:=
 0000000000000000 R09: ffff8800000bc1a0
	Oct 23 18:19:38 testhost kernel: [  388.766211] R10: ffff8800000b9cc0 R11:=
 000000000000b7c0 R12: 0000000000001000
	Oct 23 18:19:38 testhost kernel: [  388.766287] R13: ffff8803f6ca30e8 R14:=
 000000080e7c2148 R15: ffff8803fae7cbf8
	Oct 23 18:19:38 testhost kernel: [  388.766363] FS:  00007fdb1e9bd800(0000=
) GS:ffff88041ec00000(0000) knlGS:0000000000000000
	Oct 23 18:19:38 testhost kernel: [  388.766470] CS:  0010 DS: 0000 ES: 000=
0 CR0: 000000008005003b
	Oct 23 18:19:38 testhost kernel: [  388.766544] CR2: 00007fff6ae70ec8 CR3:=
 00000003feb6c000 CR4: 00000000000407f0
	Oct 23 18:19:38 testhost kernel: [  388.766620] Stack:
	Oct 23 18:19:38 testhost kernel: [  388.766690]  ffff8804083cb8d8 00000000=
00001000 ffff8804083cbb28 0000000000001000
	Oct 23 18:19:38 testhost kernel: [  388.766942]  ffff8804083cb938 ffffffff=
c0299539 ffff8803fae7cbf8 0000002000000000
	Oct 23 18:19:38 testhost kernel: [  388.767193]  0000000000000000 ffffea00=
0df7c2d0 ffff880406cb0330 0000101cf8429000
	Oct 23 18:19:38 testhost kernel: [  388.767444] Call Trace:
	Oct 23 18:19:38 testhost kernel: [  388.767541]  [<ffffffffc0299539>] subm=
it_extent_page.isra.34+0x159/0x1f0 [btrfs]
	Oct 23 18:19:38 testhost kernel: [  388.767672]  [<ffffffffc029af60>] __do=
_readpage+0x470/0x770 [btrfs]
	Oct 23 18:19:38 testhost kernel: [  388.767770]  [<ffffffffc0299ed0>] ? re=
pair_io_failure+0x200/0x200 [btrfs]
	Oct 23 18:19:38 testhost kernel: [  388.767864]  [<ffffffffc0271310>] ? ve=
rify_parent_transid+0x210/0x210 [btrfs]
	Oct 23 18:19:38 testhost kernel: [  388.767963]  [<ffffffffc0295602>] ? bt=
rfs_lookup_ordered_extent+0x82/0xd0 [btrfs]
	Oct 23 18:19:38 testhost kernel: [  388.768093]  [<ffffffffc029b320>] __ex=
tent_read_full_page+0xc0/0xd0 [btrfs]
	Oct 23 18:19:38 testhost kernel: [  388.768188]  [<ffffffffc0271310>] ? ve=
rify_parent_transid+0x210/0x210 [btrfs]
	Oct 23 18:19:38 testhost kernel: [  388.768282]  [<ffffffffc0271310>] ? ve=
rify_parent_transid+0x210/0x210 [btrfs]
	Oct 23 18:19:38 testhost kernel: [  388.768381]  [<ffffffffc029d9d3>] read=
_extent_buffer_pages+0x253/0x330 [btrfs]
	Oct 23 18:19:38 testhost kernel: [  388.768506]  [<ffffffffc0271310>] ? ve=
rify_parent_transid+0x210/0x210 [btrfs]
	Oct 23 18:19:38 testhost kernel: [  388.768601]  [<ffffffffc02730c1>] btre=
e_read_extent_buffer_pages.constprop.120+0xb1/0x110 [btrfs]
	Oct 23 18:19:38 testhost kernel: [  388.768728]  [<ffffffffc02737aa>] read=
_tree_block+0x3a/0x60 [btrfs]
	Oct 23 18:19:38 testhost kernel: [  388.768822]  [<ffffffffc0277bbd>] open=
_ctree+0x12cd/0x1f00 [btrfs]
	Oct 23 18:19:38 testhost kernel: [  388.768904]  [<ffffffff813c724a>] ? di=
sk_name+0xba/0xc0
	Oct 23 18:19:38 testhost kernel: [  388.768993]  [<ffffffffc024d403>] btrf=
s_mount+0x6d3/0x9a0 [btrfs]
	Oct 23 18:19:38 testhost kernel: [  388.769077]  [<ffffffff811c8ec3>] ? al=
loc_pages_current+0xb3/0x180
	Oct 23 18:19:38 testhost kernel: [  388.769161]  [<ffffffff811f6443>] moun=
t_fs+0x43/0x1b0
	Oct 23 18:19:38 testhost kernel: [  388.769240]  [<ffffffff81211e24>] vfs_=
kern_mount+0x74/0x130
	Oct 23 18:19:38 testhost kernel: [  388.769319]  [<ffffffff81214292>] do_m=
ount+0x262/0xb40
	Oct 23 18:19:38 testhost kernel: [  388.769397]  [<ffffffff8117e56e>] ? __=
get_free_pages+0xe/0x50
	Oct 23 18:19:38 testhost kernel: [  388.769473]  [<ffffffff81213eba>] ? co=
py_mount_options+0x3a/0x160
	Oct 23 18:19:38 testhost kernel: [  388.769550]  [<ffffffff81214e4e>] SyS_=
mount+0x8e/0xe0
	Oct 23 18:19:38 testhost kernel: [  388.769627]  [<ffffffff817a842d>] syst=
em_call_fastpath+0x1a/0x1f
	Oct 23 18:19:38 testhost kernel: [  388.769702] Code: c9 45 31 c0 89 fe 48=
 89 c7 4c 89 65 e8 e8 99 79 02 00 85 c0 78 15 4c 01 e3 31 c0 48 3b 5d e8 0f=
 97 c0 48 83 c4 10 5b 41 5c 5d c3 <0f> 0b 66 66 66 66 66 2e 0f 1f 84 00 00 =
00 00 00 66 66 66 66 90
	Oct 23 18:19:38 testhost kernel: [  388.772243] RIP  [<ffffffffc027ea80>] =
btrfs_merge_bio_hook+0x80/0x90 [btrfs]
	Oct 23 18:19:38 testhost kernel: [  388.772373]  RSP <ffff8804083cb8b8>
	Oct 23 18:19:38 testhost kernel: [  388.772490] ---[ end trace 40d6c9d5d21=
9b0fe ]---

Before I mkfs and restore, I'd like to try repairing it.  Any suggestions?


--p2kqVDKq5asng8Dg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlRJjEYACgkQgfmLGlazG5yJOACffUrq+XGY6aIJhYS1+zRWLBZ9
G4cAoMapMxcdV9mMmx/En1ApFdAOXeQw
=o3vP
-----END PGP SIGNATURE-----

--p2kqVDKq5asng8Dg--
