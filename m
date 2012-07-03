Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-2.hut.fi ([130.233.228.92]:37328 "EHLO smtp-2.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326Ab2GCWxD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Jul 2012 18:53:03 -0400
Date: Wed, 4 Jul 2012 01:47:56 +0300
From: Sami Liedes <sami.liedes@iki.fi>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs GPF in read_extent_buffer() while scrubbing with kernel
 3.4.2
Message-ID: <20120703224756.GA21647@sli.dy.fi>
References: <20120702230121.GD12755@sli.dy.fi>
 <4FF2EF68.6090401@jan-o-sch.net>
 <20120703135824.GA8908@sli.dy.fi>
 <4FF3032D.1010007@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="gBBFr7Ir9EOA20Yy"
In-Reply-To: <4FF3032D.1010007@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 03, 2012 at 04:35:25PM +0200, Jan Schmidt wrote:
> On 03.07.2012 15:58, Sami Liedes wrote:
> > I think I might try setting up that netconsole to see if there are any
> > interesting console messages before the oops... As I said, I also was
> > able to reproduce this on 3.4.4, so ATM I assume I'm able to reproduce
> > this at will.
>=20
> That would be helpful. It's good that it's reproducible. Please paste the=
 entire
> output if possible.
>=20
> If there's nothing immediately useful in there, I'll try to make up some
> debugging patches for that problem.

There's certainly something there; unfortunately netconsole eats most
of it. (Is there a better way to capture full dmesg from panic?
Assuming a computer without a serial port.)

I've seen this before: An overly long "Modules linked in:" line causes
a large gap in netconsole output.

Hovever perhaps the most interesting piece is there:

   [30846.822395] WARNING: at fs/btrfs/extent_io.c:4522 read_extent_buffer+=
0xe6/0x110 [btrfs]()

Unfortunately, no backtrace for that :( Ideas?

	Sami


------------------------------------------------------------
[30638.258946] netpoll: netconsole: local port 4444
[30638.258950] netpoll: netconsole: local IP 192.168.1.2
[30638.258952] netpoll: netconsole: interface 'eth0'
[30638.258953] netpoll: netconsole: remote port 1194
[30638.258954] netpoll: netconsole: remote IP 192.168.1.73
[30638.258956] netpoll: netconsole: remote ethernet address 00:1c:10:44:47:=
2c
[30638.259002] console [netcon0] enabled
[30638.259004] netconsole: network logging started
[30846.822356] ------------[ cut here ]------------
[30846.822395] WARNING: at fs/btrfs/extent_io.c:4522 read_extent_buffer+0xe=
6/0x110 [btrfs]()
[30846.822400] Hardware name: System Product Name
[30846.822402] Modules linked in: netconsole configfs tun cn ip6_tables ebt=
able_nat ebtables parport_pc ppdev lp parport bnep rfcomm cpufreq_userspace=
 cpufreq_stats cpufreq_powersave cpufreq_conservative binfmt_misc nfsd nfs =
nfs_acl auth_rpcgss fscache lockd sunrpc iptable_filter ipt_MASQUERADE ipt_=
REDIRECT iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack i=
p_tables x_tables xfs ext4 jbd2 mbcache radeon drm_kms_helper ttm drm i2c_a=
lgo_bit loop fuse kvm_intel kvm snd_hda_codec_hdmi snd_hda_codec_realtek sn=
d_usb_audio snd_hda_intel snd_usbmidi_lib snd_hda_codec snd_hwdep snd_pcm_o=
ss joydev snd_mixer_oss snd_pcm snd_page_alloc eeepc_wmi90 90 90 48 89 f8 4=
8 89 90 48 c1 e9 03 83 e2 07 <f3> 48 a5 89 d1 f3 a4 c3 20 4c 8b 06 4c 8b 4e=
 08 4c 8b 56 10 4c=20
[30846.825219] RIP  [<ffffffff811e84dd>] memcpy+0xd/0x110
[30846.825248]  RSP <ffff88009ecebba8>
 xord1  raid6_pq md_mod nbd btrfs libcrc32c zlib_deflate sd_mod crc_t10dif =
ahci libahci crc32c_intel r8169 pci_hotplug bluetooth snd_seq_device snd_ti=
mer snd intel_agp acpi_cpufreq mperf mxm_wmi psmouse wmi coretemp soundcore=
 processor serio_raw i2c_i801 iTCO_wdt video rfkill microcode crc16 evdev i=
2c_core button intel_gtt[30846.822679]  [<ffffffffa0249841>] btree_readpage=
_end_io_hook+0x111/0x260 [btrfs]
 sha256_generic dm_crypt dm_mod raid456 async_raid6_recov async_memcpy asyn=
c_pq async_xor xor async_tx[30846.822773]  [<ffffffff81419120>] ? gs_change=
+0x13/0x13
 md_mod nbd btrfs libcrc32c zlib_deflate sd_mod crc_t10dif ahci libahci rai=
d6_pq r8169 mii firewire_ohci ghash_clmulni_intel firewire_core aesni_intel=
 crc_itu_t aes_x86_64 bnep aes_generic cryptd scsi_mod e1000e fan thermal n=
fsd thermal_sys [last unloaded: netconsole] auth_rpcgss[30846.823704] Pid: =
16224, comm: btrfs-endio-met Tainted: G        W    3.4.4 #1 System manufac=
turer System Product Name/P8P67 EVO
[30846.823767] RIP: 0010:[<ffffffff811e84dd>]  [<ffffffff811e84dd>] memcpy+=
0xd/0x110
[30846.823805] RSP: 0000:ffff88009ecebba8  EFLAGS: 00010202
[30846.823830] RAX: ffff88009ecebc8f RBX: 0000000000000011 RCX: 00000000000=
00002
[30846.823865] RDX: 0000000000000001 RSI: 0005080000000003 RDI: ffff88009ec=
ebc8f

[30846.823933] R10: ffff88001d2395c0 R11: ffff8801f198c780 R12: ffff88009ec=
ebca0
[30846.823968] R13: ffff88008eb01178 R14: 0000000000000048 R15: 00000000000=
00011
[30846.824002] FS:  0000000000000000(0000) GS:ffff88021ec80000(0000) knlGS:=
0000000000000000
[30846.824042] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[30846.824069] CR2: 000000000add813c CR3: 0000000163305000 CR4: 00000000000=
407e0
[30846.823694]=20
[30846.824101] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[30846.824136] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[30846.824171] Process btrfs-endio-met (pid: 16224, threadinfo ffff88009ece=
a000, task ffff88020f3142f0)
[30846.824225]  ffffffffa0275d5b ffff880167d30000 0000000000008003 00000000=
00001000
[30846.824273]  ffff88009ecebc58 00000000000003dd[30846.824214] Stack:
 ffff880099cdea20
[30846.824318]  6172745f69706d20 ffff88009ecebc00 ffffffffa026d03d ffff8800=
9ecebc58 ffff88009ecebcd0
[30846.824363] Call Trace:
[30846.824434]  [<ffffffffa026d03d>] btrfs_node_key+0x1d/0x20 [btrfs]
[30846.824474]  [<ffffffffa02a34d0>] __readahead_hook.isra.5+0x3c0/0x420 [b=
trfs]
[30846.824517]  [<ffffffffa02a385f>] btree_readahead_hook+0x1f/0x40 [btrfs]
[30846.824556]  [<ffffffffa0249841>] btree_readpage_end_io_hook+0x111/0x260=
 [btrfs]
[30846.824602]  [<ffffffffa0271442>] ? find_first_extent_bit_state+0x22/0x8=
0 [btrfs]
[30846.824647]  [<ffffffffa027208b>] end_bio_extent_readpage+0xcb/0xa30 [bt=
rfs]
[30846.824391]  [<ffffffffa0275d5b>] ? read_extent_buffer+0xbb/0x110 [btrfs]
[30846.824690]  [<ffffffffa0248e61>] ? end_workqueue_fn+0x31/0x50 [btrfs]
[30846.824756]  [<ffffffffa0248e6c>] end_workqueue_fn+0x3c/0x50 [btrfs]
[30846.824797]  [<ffffffffa027f847>] worker_loop+0x157/0x560 [btrfs]
[30846.824836]  [<ffffffffa027f6f0>] ? btrfs_queue_worker+0x310/0x310 [btrf=
s]
[30846.824870]  [<ffffffff81058e5e>] kthread+0x8e/0xa0
[30846.824895]  [<ffffffff81419124>] kernel_thread_helper+0x4/0x10
[30846.824925]  [<ffffffff81058dd0>] ? flush_kthread_worker+0x70/0x70
[30846.824957]  [<ffffffff81419120>] ? gs_change+0x13/0x13
[30846.824983] Code: [30846.824724]  [<ffffffff81158a78>] bio_endio+0x18/0x=
30
4e 83 c4 08 5b 5d c3 66 0f 1f 48 44 00 e8 eb fb 00 eb 90 90 90 90 90 [30846=
=2E835959] ---[ end trace e93713a9d40cd06f ]---
[30874.611121] SysRq : Resetting
[30874.611134] ACPI MEMORY or I/O RESET_REG.

--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJP83acAAoJEKLT589SE0a0C4wP/RdUhTrvIdlQT2yjrnTjyJX8
cikQqFt0lB55I211dGOuydAV2XFImiiPPnE12IcfuVYR1bl82lq26hrvAU+dOnn6
hqq26kYvLZXcLA/spPjSC8Go3jux5zo6qv3utLt6rGNlAwCwipperZgup01MuMCm
7leYsWaBZ5jQl5LUB664VktlbMP21Ainn8pm3wydXcXLXTgviwN0u/jWU5AYecwX
0SgUReFlOGhF1pi4hqGgzmBamGAKofpiUUKrAriQ8jjgUrFpgYuGkEIj3PS5Ehsx
S1/COWNnMJX8XM01HjlrT2sx8pBmKrFcD0R0FwSfuQMgha5LsVBZpgv6c21XEhc6
WHP9eoUju8ShgnYi/JkIUQdH6D6sr1zICx3XrkhvTs1EtuZGR0bEEEX8sJF1kdtY
Z7INN7rdxSTbSTjVkRcI1KdH90NMP4RFGWjmIxAAIn+yZhv/pkkn0QHXHzQFI+qq
0rUchWebMTG0iaPccwk8JIcqwMON0E404HSIAaLzKfMzKfqnOxFfqxw+rnI3bj3T
hrKjhACa0nVTiZzX1k5U1kPdkCWf7YfdEcr/IVORHBqyWXhk1V6YMSJy8e3Zh1Yr
SVElx6AdLjSmypBbDN+FiLMQ9XMnV40s705oPd9Gfr2G4O/I3cQEydHtQ16Me+2u
/ikqTOkUsxtc+YgUHfnq
=WPTU
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--
