Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:42242 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751599AbaJXBYt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Oct 2014 21:24:49 -0400
Date: Thu, 23 Oct 2014 21:24:48 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Robert White <rwhite@pobox.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Check tree block failed, want=17716610236416, have=0
Message-ID: <20141024012448.GC17380@hungrycats.org>
References: <20141023231622.GC17395@hungrycats.org>
 <54499D4A.9050204@pobox.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p2kqVDKq5asng8Dg"
In-Reply-To: <54499D4A.9050204@pobox.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--p2kqVDKq5asng8Dg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 23, 2014 at 05:28:58PM -0700, Robert White wrote:
> Is this related to your 5k snapshot drive and your attempt to go
> back kernel revs from 3.17.0 etc?

This filesystem has four subvolumes:  a mostly empty root subvolume,
one containing ~13TB of data, and two read-write snapshot subvolumes
taken from the big data subvolume.

I have a dozen or so btrfs filesystems representing a variety of
workloads.  One of them blows up about once a week, usually due to
some bug that was fixed a few days before.  :-/

> I see that you are using 3.17.1 kernel. Are you also up to the 3.17
> version of the btrfs tools?

I was running tools 3.16.2, but I'll build 3.17 now that I found the
git repo it lives in.   :-P

> You may be in deep error land from the long use of 3.10... that
> said, the --init-csum-tree or --init-extent-tree options may be your
> friend here. The backtrace shows you are in "open_ctree" so the
> former is more likely the better bet.

This filesystem was built on 3.12 or 3.14.  I build stable kernels the
same day they come out, so this machine is reasonably up to date.

Now that I think about it, my 3.17.1-zb64 kernel also has these commits
in it:

	d379730 Revert "Btrfs: race free update of commit root for ro snapshots"
	4238302 Btrfs: fix race in WAIT_SYNC ioctl
	75bfb9a Btrfs: cleanup error handling in build_backref_tree
	bbe9051 Btrfs: fix build_backref_tree issue with multiple shared blocks
	32be3a1 btrfs: Fix the wrong condition judgment about subset extent map
	1d52c78 Btrfs: try not to ENOSPC on log replay
	f6acfd5 Btrfs: don't do async reclaim during log replay
	e6c4efd btrfs: Fix and enhance merge_extent_mapping() to insert best fitte=
d extent map
	4d1a40c Btrfs: fix up bounds checking in lseek
	78a017a Btrfs: add missing compression property remove in btrfs_ioctl_setf=
lags
	12b894c btrfs: Fix a deadlock in btrfs_dev_replace_finishing()
	0b4699d btrfs: don't go readonly on existing qgroup items
	2fad4e8 btrfs: wake up transaction thread from SYNC_FS ioctl

These came from a list posted by Chris recently for the stable kernels.

> Do make _sure_ you are using a fairly recent (3.14.x at least?)
> version of btrfs tools. You might want to download and compile the
> latest (3.17) of the tools for this task even if you don't feel
> comfortable installing them (without an rpm etc).
>=20
> On 10/23/2014 04:16 PM, Zygo Blaxell wrote:
> >I attempted to run btrfs check --repair, but it got stuck spinning
> >in what appeared to be an infinite loop.  strace and ltrace revealed
> >nothing, and gdb wasn't particularly helpful, so I rebuilt btrfs with
> >debug symbols and tried again.
> >
> >Now I get this from btrfs check:
> >
> >	Couldn't map the block 17716610236416
> >	No mapping for 17716610236416-17716610252800
> >	Couldn't map the block 17716610236416
> >	Check tree block failed, want=3D17716610236416, have=3D0
> >	read block failed check_tree_block
> >	Couldn't read chunk root
> >
> >Mount fails too:
> >
> >	Oct 23 18:19:38 testhost kernel: [  388.193783] BTRFS: device label vgs=
2-md0 devid 3 transid 282186 /dev/dm-11
> >	Oct 23 18:19:38 testhost kernel: [  388.232892] BTRFS: device label vgs=
2-md0 devid 1 transid 282186 /dev/mapper/md15
> >	Oct 23 18:19:38 testhost kernel: [  388.233305] BTRFS: device label vgs=
2-md0 devid 2 transid 282186 /dev/mapper/md16
> >	Oct 23 18:19:38 testhost kernel: [  388.234459] BTRFS: device label vgs=
2-md0 devid 4 transid 282186 /dev/mapper/md18
> >	Oct 23 18:19:38 testhost kernel: [  388.759456] BTRFS info (device dm-1=
2): disk space caching is enabled
> >	Oct 23 18:19:38 testhost kernel: [  388.759462] BTRFS: has skinny exten=
ts
> >	Oct 23 18:19:38 testhost kernel: [  388.760576] BTRFS critical (device =
dm-12): unable to find logical 17716610236416 len 4096
> >	Oct 23 18:19:38 testhost kernel: [  388.760733] ------------[ cut here =
]------------
> >	Oct 23 18:19:38 testhost kernel: [  388.760807] kernel BUG at fs/btrfs/=
inode.c:1659!
> >	Oct 23 18:19:38 testhost kernel: [  388.760880] invalid opcode: 0000 [#=
1] PREEMPT SMP
> >	Oct 23 18:19:38 testhost kernel: [  388.761063] Modules linked in: tun =
cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative soft=
dog nfsd auth_rpcgss nfs_acl nfs lockd fscache sunrpc dummy ipt_MASQUERADE =
xt_nat xt_tcpudp xt_state iptable_mangle nf_log_ipv4 nf_log_common xt_LOG x=
t_limit iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_=
conntrack ip6table_filter ip6_tables iptable_filter ip_tables x_tables sch_=
fq_codel tcp_illinois dm_crypt snd_hda_codec_realtek snd_hda_codec_generic =
snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm snd_seq sn=
d_seq_device snd_timer kvm_amd eeepc_wmi snd kvm asus_wmi sparse_keymap rfk=
ill soundcore evdev pcspkr i2c_piix4 parport_pc i2c_core acpi_cpufreq k10te=
mp parport rtc_cmos video processor wmi button thermal_sys k8temp hwmon_vid=
 hwmon btrfs xor raid6_pq dm_mod raid1 md_mod af_packet ipv6 nbd sg uas crc=
t10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes=
_x86_64 lrw gf128mul glu
> e
> _helper ablk_helper cryptd microc
> >	Oct 23 18:19:38 testhost kernel: ode r8169 mii firmware_class ehci_pci =
ohci_pci ohci_hcd ehci_hcd
> >	Oct 23 18:19:38 testhost kernel: [  388.765409] CPU: 0 PID: 25132 Comm:=
 mount Tainted: G        W      3.17.1-zb64+ #1
> >	Oct 23 18:19:38 testhost kernel: [  388.765516] Hardware name: System m=
anufacturer System Product Name/A55BM-E, BIOS 0902 11/14/2013
> >	Oct 23 18:19:38 testhost kernel: [  388.765625] task: ffff8800a3108000 =
ti: ffff8804083c8000 task.ti: ffff8804083c8000
> >	Oct 23 18:19:38 testhost kernel: [  388.765733] RIP: 0010:[<ffffffffc02=
7ea80>]  [<ffffffffc027ea80>] btrfs_merge_bio_hook+0x80/0x90 [btrfs]
> >	Oct 23 18:19:38 testhost kernel: [  388.765905] RSP: 0018:ffff8804083cb=
8b8  EFLAGS: 00010282
> >	Oct 23 18:19:38 testhost kernel: [  388.765979] RAX: 00000000ffffffea R=
BX: 0000000000001000 RCX: 0000000000000000
> >	Oct 23 18:19:38 testhost kernel: [  388.766055] RDX: 0000000000000001 R=
SI: ffffffff8179e4f9 RDI: ffffffff810ca45a
> >	Oct 23 18:19:38 testhost kernel: [  388.766135] RBP: ffff8804083cb8d8 R=
08: 0000000000000000 R09: ffff8800000bc1a0
> >	Oct 23 18:19:38 testhost kernel: [  388.766211] R10: ffff8800000b9cc0 R=
11: 000000000000b7c0 R12: 0000000000001000
> >	Oct 23 18:19:38 testhost kernel: [  388.766287] R13: ffff8803f6ca30e8 R=
14: 000000080e7c2148 R15: ffff8803fae7cbf8
> >	Oct 23 18:19:38 testhost kernel: [  388.766363] FS:  00007fdb1e9bd800(0=
000) GS:ffff88041ec00000(0000) knlGS:0000000000000000
> >	Oct 23 18:19:38 testhost kernel: [  388.766470] CS:  0010 DS: 0000 ES: =
0000 CR0: 000000008005003b
> >	Oct 23 18:19:38 testhost kernel: [  388.766544] CR2: 00007fff6ae70ec8 C=
R3: 00000003feb6c000 CR4: 00000000000407f0
> >	Oct 23 18:19:38 testhost kernel: [  388.766620] Stack:
> >	Oct 23 18:19:38 testhost kernel: [  388.766690]  ffff8804083cb8d8 00000=
00000001000 ffff8804083cbb28 0000000000001000
> >	Oct 23 18:19:38 testhost kernel: [  388.766942]  ffff8804083cb938 fffff=
fffc0299539 ffff8803fae7cbf8 0000002000000000
> >	Oct 23 18:19:38 testhost kernel: [  388.767193]  0000000000000000 ffffe=
a000df7c2d0 ffff880406cb0330 0000101cf8429000
> >	Oct 23 18:19:38 testhost kernel: [  388.767444] Call Trace:
> >	Oct 23 18:19:38 testhost kernel: [  388.767541]  [<ffffffffc0299539>] s=
ubmit_extent_page.isra.34+0x159/0x1f0 [btrfs]
> >	Oct 23 18:19:38 testhost kernel: [  388.767672]  [<ffffffffc029af60>] _=
_do_readpage+0x470/0x770 [btrfs]
> >	Oct 23 18:19:38 testhost kernel: [  388.767770]  [<ffffffffc0299ed0>] ?=
 repair_io_failure+0x200/0x200 [btrfs]
> >	Oct 23 18:19:38 testhost kernel: [  388.767864]  [<ffffffffc0271310>] ?=
 verify_parent_transid+0x210/0x210 [btrfs]
> >	Oct 23 18:19:38 testhost kernel: [  388.767963]  [<ffffffffc0295602>] ?=
 btrfs_lookup_ordered_extent+0x82/0xd0 [btrfs]
> >	Oct 23 18:19:38 testhost kernel: [  388.768093]  [<ffffffffc029b320>] _=
_extent_read_full_page+0xc0/0xd0 [btrfs]
> >	Oct 23 18:19:38 testhost kernel: [  388.768188]  [<ffffffffc0271310>] ?=
 verify_parent_transid+0x210/0x210 [btrfs]
> >	Oct 23 18:19:38 testhost kernel: [  388.768282]  [<ffffffffc0271310>] ?=
 verify_parent_transid+0x210/0x210 [btrfs]
> >	Oct 23 18:19:38 testhost kernel: [  388.768381]  [<ffffffffc029d9d3>] r=
ead_extent_buffer_pages+0x253/0x330 [btrfs]
> >	Oct 23 18:19:38 testhost kernel: [  388.768506]  [<ffffffffc0271310>] ?=
 verify_parent_transid+0x210/0x210 [btrfs]
> >	Oct 23 18:19:38 testhost kernel: [  388.768601]  [<ffffffffc02730c1>] b=
tree_read_extent_buffer_pages.constprop.120+0xb1/0x110 [btrfs]
> >	Oct 23 18:19:38 testhost kernel: [  388.768728]  [<ffffffffc02737aa>] r=
ead_tree_block+0x3a/0x60 [btrfs]
> >	Oct 23 18:19:38 testhost kernel: [  388.768822]  [<ffffffffc0277bbd>] o=
pen_ctree+0x12cd/0x1f00 [btrfs]
> >	Oct 23 18:19:38 testhost kernel: [  388.768904]  [<ffffffff813c724a>] ?=
 disk_name+0xba/0xc0
> >	Oct 23 18:19:38 testhost kernel: [  388.768993]  [<ffffffffc024d403>] b=
trfs_mount+0x6d3/0x9a0 [btrfs]
> >	Oct 23 18:19:38 testhost kernel: [  388.769077]  [<ffffffff811c8ec3>] ?=
 alloc_pages_current+0xb3/0x180
> >	Oct 23 18:19:38 testhost kernel: [  388.769161]  [<ffffffff811f6443>] m=
ount_fs+0x43/0x1b0
> >	Oct 23 18:19:38 testhost kernel: [  388.769240]  [<ffffffff81211e24>] v=
fs_kern_mount+0x74/0x130
> >	Oct 23 18:19:38 testhost kernel: [  388.769319]  [<ffffffff81214292>] d=
o_mount+0x262/0xb40
> >	Oct 23 18:19:38 testhost kernel: [  388.769397]  [<ffffffff8117e56e>] ?=
 __get_free_pages+0xe/0x50
> >	Oct 23 18:19:38 testhost kernel: [  388.769473]  [<ffffffff81213eba>] ?=
 copy_mount_options+0x3a/0x160
> >	Oct 23 18:19:38 testhost kernel: [  388.769550]  [<ffffffff81214e4e>] S=
yS_mount+0x8e/0xe0
> >	Oct 23 18:19:38 testhost kernel: [  388.769627]  [<ffffffff817a842d>] s=
ystem_call_fastpath+0x1a/0x1f
> >	Oct 23 18:19:38 testhost kernel: [  388.769702] Code: c9 45 31 c0 89 fe=
 48 89 c7 4c 89 65 e8 e8 99 79 02 00 85 c0 78 15 4c 01 e3 31 c0 48 3b 5d e8=
 0f 97 c0 48 83 c4 10 5b 41 5c 5d c3 <0f> 0b 66 66 66 66 66 2e 0f 1f 84 00 =
00 00 00 00 66 66 66 66 90
> >	Oct 23 18:19:38 testhost kernel: [  388.772243] RIP  [<ffffffffc027ea80=
>] btrfs_merge_bio_hook+0x80/0x90 [btrfs]
> >	Oct 23 18:19:38 testhost kernel: [  388.772373]  RSP <ffff8804083cb8b8>
> >	Oct 23 18:19:38 testhost kernel: [  388.772490] ---[ end trace 40d6c9d5=
d219b0fe ]---
> >
> >Before I mkfs and restore, I'd like to try repairing it.  Any suggestion=
s?
> >
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--p2kqVDKq5asng8Dg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlRJqmAACgkQgfmLGlazG5yOTgCfST8RkD+Rpb5cIoqz6H1FOE/x
QRcAnjgtNZzV8TfUMmqIxQFRnEdPnckp
=E6ZI
-----END PGP SIGNATURE-----

--p2kqVDKq5asng8Dg--
