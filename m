Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lhtechnologies.de ([52.1.245.147]:44811 "EHLO lhtechnologies.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821AbbFGL6B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 7 Jun 2015 07:58:01 -0400
Received: from [192.168.15.10] (unknown [192.168.15.10])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	(Authenticated sender: ludger.heide@lhtechnologies.de)
	by lhtechnologies.de (Postfix) with ESMTPSA id 034D2201C7
	for <linux-btrfs@vger.kernel.org>; Sun,  7 Jun 2015 11:45:11 +0000 (UTC)
From: Ludger Heide <ludger.heide@lhtechnologies.de>
Content-Type: multipart/signed; boundary="Apple-Mail=_6FE3FF37-696C-452B-AE8B-9A84A87126AE"; protocol="application/pgp-signature"; micalg=pgp-sha256
Subject: kernel BUG at /build/buildd/linux-lts-utopic-3.16.0/fs/btrfs/relocation.c:3417!
Date: Sun, 7 Jun 2015 13:45:11 +0200
Message-Id: <129498A1-FE2E-4BF4-88A2-72F0AC3ADC18@lhtechnologies.de>
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Apple-Mail=_6FE3FF37-696C-452B-AE8B-9A84A87126AE
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

I am getting the BUG from the subject line when trying to balance my =
BTRFS file system.
The layout is RAID1 over four devices with varying size. I previously =
had some hard disk changes that went without problems.
Yesterday I tried to swap a hard disk. I deleted the device from the FS, =
put the new HDD in and added it to the FS again. Then I ran balance to =
spread the chunks out again.
Balance ran quite long (average speed was about half of what the =
hardware usually does) and hung at 2 chunks of 650ish left. The process =
couldn=E2=80=99t be canceled, paused or otherwise interacted with. I got =
the BUG shown below.
I actually ran the balance twice, once with fairly heavy load and once =
without any load to the filesystem. I got the same issues in both cases. =
I was able to recover by cycling power and remounting with skip_balance.

Regards,
Ludger Heide

System details:
$ uname-a
Linux ludgerserver 3.16.0-38-generic #52~14.04.1-Ubuntu SMP Fri May 8 =
09:43:57 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

$ btrfs fi show
Label: root  uuid: 6c964c5f-f556-4fb5-a665-1a39b675ebae
        Total devices 2 FS bytes used 16.26GiB
        devid    1 size 38.63GiB used 19.03GiB path /dev/sda2
        devid    2 size 38.59GiB used 19.03GiB path /dev/sdb2

Label: data  uuid: 43e14dc1-5f6f-4c92-976d-ce44dff09f5d
        Total devices 4 FS bytes used 650.53GiB
        devid    1 size 255.07GiB used 196.00GiB path /dev/sdb5
        devid    4 size 426.65GiB used 366.00GiB path /dev/sda3
        devid    5 size 931.51GiB used 652.03GiB path /dev/sdd1
        devid    6 size 149.05GiB used 90.03GiB path /dev/sdc1

Btrfs v3.12

$ btrfs fi df /mnt/data
Data, RAID1: total=3D643.00GiB, used=3D642.38GiB
System, RAID1: total=3D32.00MiB, used=3D128.00KiB
Metadata, RAID1: total=3D9.00GiB, used=3D8.15GiB
unknown, single: total=3D512.00MiB, used=3D0.00


[52338.892003] ------------[ cut here ]------------
[52338.892043] kernel BUG at =
/build/buildd/linux-lts-utopic-3.16.0/fs/btrfs/relocation.c:3417!
[52338.892098] invalid opcode: 0000 [#1] SMP
[52338.892130] Modules linked in: vhost_net vhost macvtap macvlan =
xt_CHECKSUM iptable_mangle ebtable_nat ebtables bridge stp llc =
nls_iso8859_1 ip6t_REJECT xt_hl ip6t_rt nf_conntrack_ipv6 nf_defrag_ipv6 =
ipt_REJECT xt_comment xt_multiport xt_limit xt_tcpudp xt_addrtype =
ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_conntrack_ipv4 nf_defrag_ipv4 =
xt_conntrack ip6table_filter ip6_tables nf_conntrack_netbios_ns =
nf_conntrack_broadcast nf_nat_ftp nf_nat nf_conntrack_ftp nf_conntrack =
iptable_filter ip_tables x_tables snd_hda_codec_hdmi intel_rapl =
x86_pkg_temp_thermal intel_powerclamp kvm_intel kvm crct10dif_pclmul =
crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul =
glue_helper ablk_helper cryptd ir_lirc_codec lirc_dev ir_mce_kbd_decoder =
ir_sharp_decoder ir_sanyo_decoder ir_sony_decoder snd_hda_codec_realtek =
i915 snd_hda_codec_generic ir_jvc_decoder mei_me ir_rc6_decoder mei =
ir_rc5_decoder ir_nec_decoder snd_hda_intel snd_hda_controller lpc_ich =
snd_hda_codec drm_kms_helper drm snd_hwdep nct6775 hwmon_vid =
i2c_algo_bit coretemp rc_rc6_mce lp snd_soc_rt5640 nuvoton_cir parport =
snd_soc_rl6231 rc_core snd_soc_core snd_compress snd_pcm_dmaengine =
snd_pcm i2c_hid snd_timer hid snd soundcore dw_dmac dw_dmac_core =
i2c_designware_platform video spi_pxa2xx_platform snd_soc_sst_acpi =
i2c_designware_core 8250_dw mac_hid btrfs xor raid6_pq uas usb_storage =
e1000e ahci ptp libahci pps_core sdhci_acpi sdhci
[52338.893143] CPU: 1 PID: 26877 Comm: btrfs Not tainted =
3.16.0-38-generic #52~14.04.1-Ubuntu
[52338.893170] Hardware name:                  /D54250WYB, BIOS =
WYLPT10H.86A.0025.2014.0303.1008 03/03/2014
[52338.893200] task: ffff88003c7a7010 ti: ffff8800c826c000 task.ti: =
ffff8800c826c000
[52338.893224] RIP: 0010:[<ffffffffc02c72d5>]  [<ffffffffc02c72d5>] =
__add_tree_block+0x1c5/0x1e0 [btrfs]
[52338.893270] RSP: 0018:ffff8800c826f9d0  EFLAGS: 00010202
[52338.893287] RAX: 0000000000000001 RBX: ffff8800ccaa8800 RCX: =
00000000ffffffff
[52338.893310] RDX: 0000000000000000 RSI: 0000000000000000 RDI: =
0000000000000000
[52338.893333] RBP: ffff8800c826fa28 R08: ffff8800c826f98c R09: =
ffff8800c826f8b8
[52338.893356] R10: 0000000000000000 R11: 0000000000000b3c R12: =
0000000000004000
[52338.893379] R13: ffff8800ad8b4090 R14: 0000000000000000 R15: =
0000028e6c920000
[52338.893402] FS:  00007fcfcb55b880(0000) GS:ffff88011fa80000(0000) =
knlGS:0000000000000000
[52338.893428] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[52338.893446] CR2: 00007ffe28fd3fe8 CR3: 00000000c823a000 CR4: =
00000000001427e0
[52338.893469] Stack:
[52338.893476]  ffff8800c826fac8 0000ffffc028f859 00a80000028e6c92 =
0000000000000040
[52338.893504]  0000000000001000 0000000000001000 0000000000003359 =
ffff8800ad7ee870
[52338.893531]  ffff88007ae46250 ffff8800ccaa8800 00000000000000b8 =
ffff8800c826fa98
[52338.893558] Call Trace:
[52338.893578]  [<ffffffffc02c813c>] add_data_references+0x24c/0x2e0 =
[btrfs]
[52338.893609]  [<ffffffffc02c9313>] relocate_block_group+0x603/0x670 =
[btrfs]
[52338.893640]  [<ffffffffc02c9556>] =
btrfs_relocate_block_group+0x1d6/0x2e0 [btrfs]
[52338.893674]  [<ffffffffc029e91f>] =
btrfs_relocate_chunk.isra.27+0x6f/0x730 [btrfs]
[52338.893708]  [<ffffffffc02996fb>] ? release_extent_buffer+0x2b/0xd0 =
[btrfs]
[52338.893739]  [<ffffffffc0299b9f>] ? free_extent_buffer+0x4f/0xa0 =
[btrfs]
[52338.893770]  [<ffffffffc02a17d3>] __btrfs_balance+0x4d3/0x8a0 [btrfs]
[52338.893799]  [<ffffffffc02a1f4a>] btrfs_balance+0x3aa/0x680 [btrfs]
[52338.893829]  [<ffffffffc02a94b4>] btrfs_ioctl_balance+0x164/0x520 =
[btrfs]
[52338.894831]  [<ffffffffc02ae22c>] btrfs_ioctl+0x58c/0x2b10 [btrfs]
[52338.895822]  [<ffffffff811e3fb9>] ? putname+0x29/0x40
[52338.896810]  [<ffffffff811e4c2f>] ? user_path_at_empty+0x5f/0x90
[52338.897827]  [<ffffffff8105af5c>] ? __do_page_fault+0x20c/0x560
[52338.898798]  [<ffffffff81192fb8>] ? __vma_link_rb+0xb8/0xe0
[52338.899759]  [<ffffffff811930a1>] ? vma_link+0xc1/0xd0
[52338.900709]  [<ffffffff811b78b2>] ? kmem_cache_alloc+0x1b2/0x1e0
[52338.901657]  [<ffffffff811e7360>] do_vfs_ioctl+0x2e0/0x4c0
[52338.902586]  [<ffffffff811e75c1>] SyS_ioctl+0x81/0xa0
[52338.903496]  [<ffffffff8176da4d>] system_call_fastpath+0x1a/0x1f
[52338.904384] Code: ff 48 8b 4d a8 48 8d 75 b6 4c 89 ea 48 89 df e8 52 =
e7 ff ff 4c 89 ef 89 45 a8 e8 a7 8a f8 ff 8b 45 a8 e9 69 ff ff ff 85 c0 =
74 d6 <0f> 0b 66 0f 1f 84 00 00 00 00 00 b8 f4 ff ff ff e9 50 ff ff ff
[52338.906228] RIP  [<ffffffffc02c72d5>] __add_tree_block+0x1c5/0x1e0 =
[btrfs]
[52338.907110]  RSP <ffff8800c826f9d0>
[52338.911316] ---[ end trace d14816f3a92b021f ]---


Ludger Heide
Kaiserdamm 87
14057 Berlin
Germany
ludger.heide@lhtechnologies.de
PGP: 0x5D7EDDA9
Threema: 6SN8P3SK
+49 30 95623375
+49 170 9847562


--Apple-Mail=_6FE3FF37-696C-452B-AE8B-9A84A87126AE
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJVdC7HAAoJEP7v4ZDu7lf6l84QAJYdXZKF32IBnybo+TW+RFQx
BjfZxiJ13TOWESSSK1+5PBpL3jhtOYUpXfUYL8hfzLfvVWh8j8GrDd9tcS6jZkkt
o2+SA4CjMk/TAC5b+FIbo+OQMqu/yn08X2BTTK81Ewr+2eLOJet5iNmRbL98mF6s
CrDUXZhd/LYYPpB10u3KZUmFhTlHG2/adYIoj151PCg2lJ3rK0OkGaOwFryq4l6j
ugr+uqRqP97bOaBqaqfxrBBnqjbUEcee8AzGeAGa5/MrWBQoOSdTza/ghl8Y66Ni
zZbZ1O6XZHfU3DpY10M2THY48KbiCAGCuukd/M+GDDAZ3dRE2SnNzg+zpbuKsF9O
Eo8ngUQhOSfaWckogg6RzaI0vlaa0xw9ncFWSj2kBuWnVN7AWzaVOBLeCwO1b41y
eKkeHeydN0YiwOb4lVIoHFQF2Osv89UETqSqVL6JNeMrP7xt4+9UILz1ZlceNuxd
nIzDu8ccb89d8lYvB+xdWDu4b+fbTBbFyJqaWg+R4fxpt8g+Lfh1Y1sd2yGGyuCW
xp0SMc6TMrSqlbM0NZGQGRrH2JSxACZmgPxUCB5+AlM9fu8rXnJ6nrg0qfB4n7wD
n6pS3chqDnpVjVR6Yz+PunLjHEIGIwIxZMgDzOTvhoCVwVeGaOQODgkeM4iMPUAE
+c1sPQPSfAK9BY8nMX9g
=Bai8
-----END PGP SIGNATURE-----

--Apple-Mail=_6FE3FF37-696C-452B-AE8B-9A84A87126AE--
