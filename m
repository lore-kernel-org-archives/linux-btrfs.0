Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42826 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751157AbaAWFrU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jan 2014 00:47:20 -0500
Message-ID: <1390456022.3651.143.camel@deadeye.wl.decadent.org.uk>
Subject: Re: Bug#736227: linux-headers-3.12-1-amd64: general protection
 fault when using aptitude
From: Ben Hutchings <ben@decadent.org.uk>
To: Giorgos Pallas <gpall@ccf.auth.gr>, 736227@bugs.debian.org
Cc: linux-btrfs@vger.kernel.org
Date: Thu, 23 Jan 2014 05:47:02 +0000
In-Reply-To: <20140121090046.25804.36940.reportbug@localhost>
References: <20140121090046.25804.36940.reportbug@localhost>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-MZVU4IrbU7tBR0gi4chs"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-MZVU4IrbU7tBR0gi4chs
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm sending this on to the btrfs developers to see if they can help.

On Tue, 2014-01-21 at 11:00 +0200, Giorgos Pallas wrote:
[...]
> I just installed 3.12-amd64 stock kernel. It booted OK, I opened a konsol=
e
> and just tried to installed the kernel headers.  Just as aptitude tried t=
o
> start downloading packages, I got:
> E: Method http has died unexpectedly!
> E: Sub-process http received a segmentation fault.
> and btrfs has crashed as seen in dmesg.
>=20
> It should be noted that I use btrfs without problems with 3.7-trunk-amd64
> for almost a year.
[...]

The full message can be seen at <http://bugs.debian.org/736227>; here is
the crash log:

> [  322.368186] general protection fault: 0000 [#1] SMP=20
> [  322.368233] Modules linked in: cpufreq_userspace cpufreq_stats cpufreq=
_powersave cpufreq_conservative xt_multiport uinput ib_iser rdma_cm ib_addr=
 iw_cm ib_cm ib_sa ib_mad ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_tran=
sport_iscsi fuse ip6table_filter ip6table_mangle ip6_tables xt_tcpudp iptab=
le_filter iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat n=
f_conntrack iptable_mangle ip_tables x_tables ext4 crc16 mbcache jbd2 loop =
firewire_sbp2 uvcvideo arc4 videobuf2_vmalloc videobuf2_memops videobuf2_co=
re videodev media b43 joydev bcma snd_hda_codec_hdmi mac80211 cfg80211 snd_=
hda_codec_idt ir_lirc_codec rfkill snd_hda_intel snd_hda_codec rng_core iTC=
O_wdt snd_hwdep snd_pcm r852 lirc_dev iTCO_vendor_support ir_mce_kbd_decode=
r snd_page_alloc snd_seq ir_sony_decoder ir_sanyo_decoder dell_wmi ir_jvc_d=
ecoder sm_common nand ir_nec_decoder ir_rc6_decoder ir_rc5_decoder nand_ecc=
 rc_rc6_mce nand_ids mtd lpc_ich i2c_i801 dell_laptop coretemp acpi_cpufreq=
 snd_seq_device !
>  r592 snd_timer mfd_core sparse_keymap dcdbas psmouse snd ite_cir rc_core=
 memstick soundcore processor pcspkr wmi serio_raw battery ac evdev btrfs x=
or raid6_pq crc32c libcrc32c sha256_generic cbc dm_crypt dm_mod sg sd_mod c=
rct10dif_generic sr_mod crc_t10dif cdrom crct10dif_common firewire_ohci sdh=
ci_pci sdhci firewire_core crc_itu_t thermal ahci libahci tg3 libata ssb mm=
c_core pcmcia i915 ptp pps_core libphy pcmcia_core video scsi_mod ehci_pci =
uhci_hcd ehci_hcd button i2c_algo_bit drm_kms_helper drm i2c_core thermal_s=
ys usbcore usb_common
> [  322.369458] CPU: 0 PID: 4353 Comm: http Not tainted 3.12-1-amd64 #1 De=
bian 3.12.6-2
> [  322.369493] Hardware name: Dell Inc. Studio 1737/0P792H, BIOS A09 04/1=
4/2011
> [  322.369534] task: ffff880036e80840 ti: ffff88009bf7e000 task.ti: ffff8=
8009bf7e000
> [  322.369569] RIP: 0010:[<ffffffff812713e2>]  [<ffffffff812713e2>] memcp=
y+0x12/0x110
> [  322.369615] RSP: 0018:ffff88009bf7f968  EFLAGS: 00010202
> [  322.369646] RAX: ffff88008e2eaf39 RBX: 0000000000000001 RCX: 000000000=
0000001
> [  322.369679] RDX: 0000000000000001 RSI: db73880000000000 RDI: ffff88008=
e2eaf39
> [  322.369711] RBP: ffff880131ca9770 R08: 0000000000001000 R09: ffff88009=
bf7f978
> [  322.369744] R10: 0000000000000000 R11: 0000000000000000 R12: 6db6db6db=
6db6db7
> [  322.369776] R13: 0000160000000000 R14: ffff88008e2eaf3a R15: 000000000=
0000001
> [  322.369810] FS:  00007f00804a4720(0000) GS:ffff88013fc00000(0000) knlG=
S:0000000000000000
> [  322.369855] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  322.369881] CR2: ffffffffff600400 CR3: 000000009d52b000 CR4: 000000000=
00007f0
> [  322.369914] Stack:
> [  322.369928]  ffffffffa034a568 0000000000000000 ffff8801378a0000 000000=
0000000000
> [  322.369980]  ffff88013b3a9250 ffff88008e2ea000 ffff8800aa637d50 ffff88=
00925c3260
> [  322.370032]  ffffffffa032f510 0000000000001000 ffff880131ca96a0 ffffea=
0001f1a330
> [  322.370085] Call Trace:
> [  322.370119]  [<ffffffffa034a568>] ? read_extent_buffer+0xc8/0x120 [btr=
fs]
> [  322.370164]  [<ffffffffa032f510>] ? btrfs_get_extent+0x910/0x990 [btrf=
s]
> [  322.370214]  [<ffffffffa03469b8>] ? __do_readpage+0x398/0x780 [btrfs]
> [  322.370256]  [<ffffffffa032ec00>] ? btrfs_real_readdir+0x550/0x550 [bt=
rfs]
> [  322.370307]  [<ffffffffa0347142>] ? __extent_readpages.constprop.43+0x=
2d2/0x2f0 [btrfs]
> [  322.370355]  [<ffffffffa032ec00>] ? btrfs_real_readdir+0x550/0x550 [bt=
rfs]
> [  322.370406]  [<ffffffffa0348de2>] ? extent_readpages+0x182/0x190 [btrf=
s]
> [  322.370457]  [<ffffffffa032ec00>] ? btrfs_real_readdir+0x550/0x550 [bt=
rfs]
> [  322.370499]  [<ffffffff8115ba6b>] ? kmem_getpages+0x15b/0x1a0
> [  322.370527]  [<ffffffff811554ad>] ? alloc_pages_current+0x9d/0x160
> [  322.370565]  [<ffffffff8111dbc3>] ? __do_page_cache_readahead+0x193/0x=
240
> [  322.370598]  [<ffffffff8111e07a>] ? ondemand_readahead+0x14a/0x280
> [  322.370636]  [<ffffffff81113986>] ? generic_file_aio_read+0x4a6/0x6f0
> [  322.370668]  [<ffffffff81172a07>] ? do_sync_read+0x57/0x90
> [  322.370701]  [<ffffffff81172f94>] ? vfs_read+0x94/0x160
> [  322.370726]  [<ffffffff81173a83>] ? SyS_read+0x43/0xa0
> [  322.370759]  [<ffffffff81499b39>] ? system_call_fastpath+0x16/0x1b
> [  322.370795] Code: 43 58 48 2b 43 50 88 43 4e eb e9 90 90 90 90 90 90 9=
0 90 90 90 90 90 90 90 48 89 f8 48 89 d1 48 c1 e9 03 83 e2 07 f3 48 a5 89 d=
1 <f3> a4 c3 20 4c 8b 06 4c 8b 4e 08 4c 8b 56 10 4c 8b 5e 18 48 8d=20
> [  322.371118] RIP  [<ffffffff812713e2>] memcpy+0x12/0x110
> [  322.371154]  RSP <ffff88009bf7f968>
> [  322.378460] ---[ end trace 4d0836c03317ee9d ]---

--=20
Ben Hutchings
compatible: Gracefully accepts erroneous data from any source

--=-MZVU4IrbU7tBR0gi4chs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUuCs1ue/yOyVhhEJAQqu2xAAxYRcOYLe1bCbkJIbRNFQc7uw3KUpHk46
CXkOt3h62atiHpHdiTrUk6y+NYCo/hlItFq7ROMcpGckmJkfxX70Ql721NUmXjaR
bdUoq2I5I3K0xgLgCpMe5lHnNvImlxqwHa0HRpygWLVyTjQSIjtB+89SZemPKzRi
NcYSf1od98BDPcYf5cjrEbfOoK5MEfhEYPDB6XXLvA1JKc6LHO3ng/GXgX5iwUi3
A2+4ZJzbnTiKqHklv3SKedGXTqzPd7UMERXs1wl2lLpZEYSkO8zPPXiBGguSqHND
u8+NGoDxUtlBhJz9OkXxnYk8AZtSifKvka1m06YVrjd6+X3S/cU7uWrdccN4Li/Y
nlSsdGV1uRO0Psv8/dW+QJJ3A65RHwUldjc3Xb8W6Wt+eHd4689s7/NTx4HsfiaV
wDdUU/LCElZ+oo/VQd7Et+6snLybEZmSsF4FM8JH4rv0gjNZ4Tut/mKK7DaOQGtf
VV5cEZjtXa+gQZlq8yCAyc0UeuGGXxhW6ZJGC9jFnlnCFmvcYhvpbvEQineh8sdn
XhVfqNCuyCkpcW1H3RAAtDbCZf8JagBr4krh0m6ce/3bZtkw/PmV4nj2DjVnSWYR
QOw2hHzI1og4N8HTnBFhkC4eZ2C0dmUp9F/mA0NEgzNb2S93l7q/2EkS+qgpFMy2
RHoTPBe6VKI=
=9kmU
-----END PGP SIGNATURE-----

--=-MZVU4IrbU7tBR0gi4chs--
