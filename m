Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:43582 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbcCLPs4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 12 Mar 2016 10:48:56 -0500
Received: from natsu (unknown [IPv6:fd39::e9:9eff:fe8f:1bcf])
	by meiko.romanrm.net (Postfix) with SMTP id 3F54512472D
	for <linux-btrfs@vger.kernel.org>; Sat, 12 Mar 2016 15:48:51 +0000 (UTC)
Date: Sat, 12 Mar 2016 20:48:47 +0500
From: Roman Mamedov <rm@romanrm.net>
To: linux-btrfs@vger.kernel.org
Subject: parent transid verify failed on snapshot deletion
Message-ID: <20160312204847.2092f3f3@natsu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/SXvf+kvH1zuijJ5H+N57Ehf"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/SXvf+kvH1zuijJ5H+N57Ehf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

The system was seemingly running just fine for days or weeks, then I
routinely deleted a bunch of old snapshots, and suddenly got hit with:

[Sat Mar 12 20:17:10 2016] BTRFS error (device dm-0): parent transid verify=
 failed on 7483566862336 wanted 410578 found 404133
[Sat Mar 12 20:17:10 2016] BTRFS error (device dm-0): parent transid verify=
 failed on 7483566862336 wanted 410578 found 404133
[Sat Mar 12 20:17:10 2016] ------------[ cut here ]------------
[Sat Mar 12 20:17:10 2016] WARNING: CPU: 0 PID: 217 at fs/btrfs/extent-tree=
.c:6549 __btrfs_free_extent.isra.67+0x2c2/0xd40 [btrfs]()
[Sat Mar 12 20:17:10 2016] BTRFS: Transaction aborted (error -5)
[Sat Mar 12 20:17:10 2016] Modules linked in: xt_tcpudp xt_multiport xt_lim=
it xt_length xt_conntrack ip6t_rpfilter ipt_rpfilter ip6table_raw ip6table_=
mangle iptable_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4=
 nf_nat nf_conntrack ip6table_filter ip6_tables iptable_filter ip_tables x_=
tables cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservati=
ve cfg80211 rfkill arc4 ecb md4 hmac nls_utf8 cifs dns_resolver fscache 802=
1q garp mrp bridge stp llc tcp_illinois ext4 crc16 mbcache jbd2 fuse kvm_am=
d kvm irqbypass serio_raw evdev pcspkr joydev snd_hda_codec_realtek k10temp=
 snd_hda_codec_generic snd_hda_codec_hdmi snd_hda_intel snd_hda_codec snd_h=
da_core snd_hwdep acpi_cpufreq sp5100_tco snd_pcm snd_timer tpm_tis snd tpm=
 shpchp soundcore i2c_piix4 button processor btrfs dm_mod raid1 raid456
[Sat Mar 12 20:17:10 2016]  async_raid6_recov async_memcpy async_pq async_x=
or async_tx xor raid6_pq libcrc32c crc32c_generic md_mod sg ata_generic sd_=
mod hid_generic usbhid hid uas usb_storage ohci_pci xhci_pci xhci_hcd r8169=
 mii sata_mv ahci libahci pata_atiixp ehci_pci ohci_hcd ehci_hcd libata usb=
core usb_common scsi_mod
[Sat Mar 12 20:17:10 2016] CPU: 0 PID: 217 Comm: btrfs-cleaner Tainted: G  =
      W       4.4.4-rm1+ #108
[Sat Mar 12 20:17:10 2016] Hardware name: Gigabyte Technology Co., Ltd. GA-=
E350N-USB3/GA-E350N-USB3, BIOS F2 09/19/2011
[Sat Mar 12 20:17:10 2016]  0000000000000286 000000007223a131 ffff880406bef=
a88 ffffffff81315721
[Sat Mar 12 20:17:10 2016]  ffff880406befad0 ffffffffa03539b2 ffff880406bef=
ac0 ffffffff8107e735
[Sat Mar 12 20:17:10 2016]  0000000183c9c000 00000000fffffffb ffff88032dbc0=
e01 0000069c4f95b000
[Sat Mar 12 20:17:10 2016] Call Trace:
[Sat Mar 12 20:17:10 2016]  [<ffffffff81315721>] dump_stack+0x63/0x82
[Sat Mar 12 20:17:10 2016]  [<ffffffff8107e735>] warn_slowpath_common+0x95/=
0xe0
[Sat Mar 12 20:17:10 2016]  [<ffffffff8107e7dc>] warn_slowpath_fmt+0x5c/0x80
[Sat Mar 12 20:17:10 2016]  [<ffffffffa02b2e42>] __btrfs_free_extent.isra.6=
7+0x2c2/0xd40 [btrfs]
[Sat Mar 12 20:17:10 2016]  [<ffffffffa02b6f12>] __btrfs_run_delayed_refs+0=
x412/0x1230 [btrfs]
[Sat Mar 12 20:17:10 2016]  [<ffffffff8133edad>] ? __percpu_counter_add+0x5=
d/0x80
[Sat Mar 12 20:17:10 2016]  [<ffffffffa02bab4e>] btrfs_run_delayed_refs+0x7=
e/0x2b0 [btrfs]
[Sat Mar 12 20:17:10 2016]  [<ffffffffa02cfd08>] btrfs_should_end_transacti=
on+0x68/0x70 [btrfs]
[Sat Mar 12 20:17:10 2016]  [<ffffffffa02b932d>] btrfs_drop_snapshot+0x45d/=
0x840 [btrfs]
[Sat Mar 12 20:17:10 2016]  [<ffffffff815d1ee5>] ? __schedule+0x355/0xa30
[Sat Mar 12 20:17:10 2016]  [<ffffffffa02d020d>] btrfs_clean_one_deleted_sn=
apshot+0xbd/0x120 [btrfs]
[Sat Mar 12 20:17:10 2016]  [<ffffffffa02c7e6d>] cleaner_kthread+0x17d/0x21=
0 [btrfs]
[Sat Mar 12 20:17:10 2016]  [<ffffffffa02c7cf0>] ? check_leaf+0x370/0x370 [=
btrfs]
[Sat Mar 12 20:17:10 2016]  [<ffffffff8109db9a>] kthread+0xea/0x100
[Sat Mar 12 20:17:10 2016]  [<ffffffff8109dab0>] ? kthread_park+0x60/0x60
[Sat Mar 12 20:17:10 2016]  [<ffffffff815d6c4f>] ret_from_fork+0x3f/0x70
[Sat Mar 12 20:17:10 2016]  [<ffffffff8109dab0>] ? kthread_park+0x60/0x60
[Sat Mar 12 20:17:10 2016] ---[ end trace 4a0a05309f1c27f4 ]---
[Sat Mar 12 20:17:10 2016] BTRFS: error (device dm-0) in __btrfs_free_exten=
t:6549: errno=3D-5 IO failure
[Sat Mar 12 20:17:10 2016] BTRFS info (device dm-0): forced readonly
[Sat Mar 12 20:17:10 2016] BTRFS: error (device dm-0) in btrfs_run_delayed_=
refs:2927: errno=3D-5 IO failure
[Sat Mar 12 20:17:10 2016] pending csums is 103825408

Now this happens after each reboot too, causing the FS to be remounted read=
-only.

I wonder what's the best way to proceed here. Maybe try btrfs-zero-log? But
the difference between transid numbers of 6 thousands is concerning.

Also puzzling why did this happen in the first place, I don't think this
filesystem had any crashes or storage device-related issues recently.

--=20
With respect,
Roman

--Sig_/SXvf+kvH1zuijJ5H+N57Ehf
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlbkOmIACgkQTLKSvz+PZwhdFQCfQRAUcrC2r+a3JzA7E+txkMOd
1cYAn14/LJZjDhXdCL2i07NbNQSHDkmq
=xBHK
-----END PGP SIGNATURE-----

--Sig_/SXvf+kvH1zuijJ5H+N57Ehf--
