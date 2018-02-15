Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:40581 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754879AbeBOHih (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 02:38:37 -0500
Subject: Re: fatal database corruption with btrfs "out of space" with ~50 GB
 left
To: Tomasz Chmielewski <tch@virtall.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <de1fdabb35ffe14eb92433ef444494e7@virtall.com>
 <72c2c665-97f1-3356-6d65-66ba162736de@gmx.com>
 <f77a1a28c2cbf08efd24577088a29de0@virtall.com>
 <58ea1e02-6f38-97f7-34aa-e993a1aa261b@gmx.com>
 <57960c49a431cdfdb4c659d0a9b40856@virtall.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <b850e038-a0a2-19bd-6fcd-c3511fafda2c@gmx.com>
Date: Thu, 15 Feb 2018 15:38:27 +0800
MIME-Version: 1.0
In-Reply-To: <57960c49a431cdfdb4c659d0a9b40856@virtall.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="APfluKkrQK8Lc7hBRBEDv2CWTWpbj5eKj"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--APfluKkrQK8Lc7hBRBEDv2CWTWpbj5eKj
Content-Type: multipart/mixed; boundary="AjmFvzCjN5nkWGirgLOm4nmpSm3AxfWut";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Tomasz Chmielewski <tch@virtall.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <b850e038-a0a2-19bd-6fcd-c3511fafda2c@gmx.com>
Subject: Re: fatal database corruption with btrfs "out of space" with ~50 GB
 left
References: <de1fdabb35ffe14eb92433ef444494e7@virtall.com>
 <72c2c665-97f1-3356-6d65-66ba162736de@gmx.com>
 <f77a1a28c2cbf08efd24577088a29de0@virtall.com>
 <58ea1e02-6f38-97f7-34aa-e993a1aa261b@gmx.com>
 <57960c49a431cdfdb4c659d0a9b40856@virtall.com>
In-Reply-To: <57960c49a431cdfdb4c659d0a9b40856@virtall.com>

--AjmFvzCjN5nkWGirgLOm4nmpSm3AxfWut
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8815=E6=97=A5 15:02, Tomasz Chmielewski wrote:
> On 2018-02-15 13:32, Qu Wenruo wrote:
>=20
>> Is there any kernel message like kernel warning or backtrace?
>=20
> I see there was this one:
>=20
> Feb 13 13:53:32 lxd01 kernel: [9351710.878404] ------------[ cut
> here ]------------ Feb 13 13:53:32 lxd01 kernel: [9351710.878430]
> WARNING: CPU: 9 PID: 7780 at
> /home/kernel/COD/linux/fs/btrfs/tree-log.c:3361

Something with tree log (used by fsync) is not running as expected, and
it seems to be a big problem.
As the code shows that, btrfs fails to search the key in log tree.

No wonder why MySQL is reporting error, as fsync is not executed correctl=
y.

I strongly recommend to run offline btrfs check to ensure metadata is
not corrupted before causing more problems.

> log_dir_items+0x54b/0x560 [btrfs] Feb 13 13:53:32 lxd01 kernel:
> [9351710.878431] Modules linked in: nfnetlink_queue bluetooth
> ecdh_generic xt_nat xt_REDIRECT nf_nat_redirect sunrpc cfg80211
> tcp_diag inet_diag xt_NFLOG nfnetlink_log nfnetlink xt_conntrack
> ipt_REJECT nf_reject_ipv4 binfmt_misc veth ebtable_filter ebtables
> ip6t_MASQUERADE nf_nat_masquerade_ipv6 ip6table_nat nf_conntrack_ipv6
> nf_defrag_ipv6 nf_nat_ipv6 xt_comment nf_log_ipv4 nf_log_common
> xt_LOG ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat
> nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat ip_vs
> nf_conntrack ip6table_filter ip6_tables iptable_filter xt_CHECKSUM
> xt_tcpudp iptable_mangle ip_tables x_tables intel_rapl
> x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm=20
> irqbypass btrfs bridge stp llc crct10dif_pclmul crc32_pclmul=20
> ghash_clmulni_intel pcbc zstd_compress aesni_intel aes_x86_64 Feb 13
> 13:53:32 lxd01 kernel: [9351710.878460]  crypto_simd glue_helper=20
> cryptd input_leds intel_cstate ipmi_ssif intel_rapl_perf serio_raw=20
> lpc_ich shpchp ipmi_devintf ipmi_msghandler tpm_infineon acpi_pad=20
> mac_hid autofs4 raid10 raid456 async_raid6_recov async_memcpy
> async_pq async_xor async_tx xor raid6_pq libcrc32c raid1 raid0
> multipath linear ttm drm_kms_helper syscopyarea sysfillrect sysimgblt
> fb_sys_fops igb drm dca ahci ptp pps_core libahci i2c_algo_bit wmi=20
> Feb 13 13:53:32 lxd01 kernel: [9351710.878484] CPU: 9 PID: 7780
> Comm: TaskSchedulerBa Tainted: G        W
> 4.14.0-041400rc6-generic #201710230731 Feb 13 13:53:32 lxd01 kernel:
> [9351710.878485] Hardware name: ASUSTeK COMPUTER INC. Z10PA-U8
> Series/Z10PA-U8 Series, BIOS 0601 06/26/2015 Feb 13 13:53:32 lxd01
> kernel: [9351710.878486] task: ffff9454227d1700 task.stack:
> ffffabc6a810c000 Feb 13 13:53:32 lxd01 kernel: [9351710.878502] RIP:=20
> 0010:log_dir_items+0x54b/0x560 [btrfs] Feb 13 13:53:32 lxd01 kernel:
> [9351710.878502] RSP: 0018:ffffabc6a810f980 EFLAGS: 00010202 Feb 13
> 13:53:32 lxd01 kernel: [9351710.878503] RAX: 0000000000000001 RBX:
> 000000000008b771 RCX: 0000000000000000 Feb 13 13:53:32 lxd01 kernel:
> [9351710.878504] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
> 0000000000000000 Feb 13 13:53:32 lxd01 kernel: [9351710.878505] RBP:
> ffffabc6a810fa28 R08: ffff9491a8f05540 R09: 0000000000000008 Feb 13
> 13:53:32 lxd01 kernel: [9351710.878506] R10: 0000000000000000 R11:
> ffffabc6a810f934 R12: ffffabc6a810fe50 Feb 13 13:53:32 lxd01 kernel:
> [9351710.878506] R13: ffff94666d426000 R14: ffff9491a8f05540 R15:
> 0000000000000054 Feb 13 13:53:32 lxd01 kernel: [9351710.878508] FS:=20
> 00007f9936e22700(0000) GS:ffff9491bf440000(0000)
> knlGS:0000000000000000 Feb 13 13:53:32 lxd01 kernel: [9351710.878508]
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 Feb 13 13:53:32
> lxd01 kernel: [9351710.878509] CR2: 00007f6abef4d7b0 CR3:
> 00000023ecaf7006 CR4: 00000000001606e0 Feb 13 13:53:32 lxd01 kernel:
> [9351710.878510] Call Trace: Feb 13 13:53:32 lxd01 kernel:
> [9351710.878524]  ? btrfs_search_slot+0x81b/0x9c0 [btrfs] Feb 13
> 13:53:32 lxd01 kernel: [9351710.878538]=20
> log_directory_changes+0x83/0xd0 [btrfs] Feb 13 13:53:32 lxd01 kernel:
> [9351710.878551] btrfs_log_inode+0xa24/0x11a0 [btrfs] Feb 13 13:53:32
> lxd01 kernel: [9351710.878563]  ?=20
> generic_bin_search.constprop.37+0xe7/0x1f0 [btrfs] Feb 13 13:53:32
> lxd01 kernel: [9351710.878565]  ? find_inode+0x59/0xb0 Feb 13
> 13:53:32 lxd01 kernel: [9351710.878567]  ? iget5_locked+0x9e/0x1e0=20
> Feb 13 13:53:32 lxd01 kernel: [9351710.878582]=20
> log_new_dir_dentries+0x203/0x4a7 [btrfs] Feb 13 13:53:32 lxd01
> kernel: [9351710.878595] btrfs_log_inode_parent+0x6c2/0xa10 [btrfs]=20
> Feb 13 13:53:32 lxd01 kernel: [9351710.878598]  ?=20
> pagevec_lookup_tag+0x21/0x30 Feb 13 13:53:32 lxd01 kernel:
> [9351710.878599]  ? __filemap_fdatawait_range+0x9a/0x170 Feb 13
> 13:53:32 lxd01 kernel: [9351710.878614]  ?=20
> wait_current_trans+0x33/0x110 [btrfs] Feb 13 13:53:32 lxd01 kernel:
> [9351710.878627]  ? join_transaction+0x27/0x420 [btrfs] Feb 13
> 13:53:32 lxd01 kernel: [9351710.878639]=20
> btrfs_log_dentry_safe+0x60/0x80 [btrfs] Feb 13 13:53:32 lxd01 kernel:
> [9351710.878658] btrfs_sync_file+0x2d1/0x410 [btrfs] Feb 13 13:53:32
> lxd01 kernel: [9351710.878661]  vfs_fsync_range+0x4b/0xb0 Feb 13
> 13:53:32 lxd01 kernel: [9351710.878663]  do_fsync+0x3d/0x70 Feb 13
> 13:53:32 lxd01 kernel: [9351710.878668]  SyS_fdatasync+0x13/0x20 Feb
> 13 13:53:32 lxd01 kernel: [9351710.878670]  do_syscall_64+0x61/0x120=20
> Feb 13 13:53:32 lxd01 kernel: [9351710.878673]=20
> entry_SYSCALL64_slow_path+0x25/0x25 Feb 13 13:53:32 lxd01 kernel:
> [9351710.878674] RIP: 0033:0x7f99461437dd Feb 13 13:53:32 lxd01
> kernel: [9351710.878675] RSP: 002b:00007f9936e20f10 EFLAGS: 00000293
> ORIG_RAX: 000000000000004b Feb 13 13:53:32 lxd01 kernel:
> [9351710.878676] RAX: ffffffffffffffda RBX: 0000307d6f5d1070 RCX:
> 00007f99461437dd Feb 13 13:53:32 lxd01 kernel: [9351710.878677] RDX:
> 000000000000005c RSI: 0000000000080000 RDI: 000000000000005c Feb 13
> 13:53:32 lxd01 kernel: [9351710.878678] RBP: 0000000000000000 R08:
> 0000000000000000 R09: 0000000000000000 Feb 13 13:53:32 lxd01 kernel:
> [9351710.878679] R10: 00000000ffffffff R11: 0000000000000293 R12:
> 0000000000001000 Feb 13 13:53:32 lxd01 kernel: [9351710.878679] R13:
> 0000307d6f550b00 R14: 0000000000000000 R15: 0000000000001000 Feb 13
> 13:53:32 lxd01 kernel: [9351710.878681] Code: 89 85 6c ff ff ff 4c 8b
> 95 70 ff ff ff 74 23 4c 89 f7 e8 a9 dc f8 ff 48 8b 7d 88 e8 a0 dc f8
> ff 8b 85 6c ff ff ff e9 d8 fb ff ff <0f> ff e9 35 fe ff ff 4c 89 55=20
> 18 e9 56 fc ff ff e8 60 65 61 eb Feb 13 13:53:32 lxd01 kernel:
> [9351710.878707] ---[ end trace 81aeb3fb0c68ce00 ]---
>=20
>=20
> BTW we've updated to the latest 4.15 kernel after that.
>=20
>=20
>> Not sure if the removal of 80G has anything to do with this, but
>> this seems that your metadata (along with data) is quite
>> scattered.
>>=20
>> It's really recommended to keep some unallocated device space, and
>> one of the method to do that is to use balance to free such
>> scattered space from data/metadata usage.
>>=20
>> And that's why balance routine is recommened for btrfs.
>=20
> The balance might work on that server - it's less than 0.5 TB SSD
> disks.
>=20
> However, on multi-terabyte servers with terabytes of data on HDD
> disks, running balance is not realistic> We have some servers where
> balance was taking 2 months or so, and was not even 50% done. And the
> IO load the balance was adding was slowing the things down a lot.

How did you do the balance?

Btrfs are completely OK to relocate certain chunks which meet certain
condition.

For example, only to relocate chunk whose used space is lower than 15%.

If you're relocating the whole fs, no wonder it will takes a long long ti=
me.

And further more, btrfs is super fast in creating snapshots, but at the
cost of dramatically slowing down balance and snapshot deletion.

So abusing snapshots is not a good idea for btrfs especially for balance.=


Thanks,
Qu

>=20
>=20
> Tomasz Chmielewski https://lxadm.com


--AjmFvzCjN5nkWGirgLOm4nmpSm3AxfWut--

--APfluKkrQK8Lc7hBRBEDv2CWTWpbj5eKj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqFOPQXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgnMAf/aiXY6uZKV7ZXOm8v3S/0jGqA
6LgIQeVbnp0vjo644EEEIncU1DOAQrpMYjlY0gGoUsXwmr04yU5yIV6l686U+vZR
Jp1aDZyVoxY4lKIbx0mqH74BW9A6iuueksb5QZGZh8+xmjvieuPX55NHSEQW8oNw
Ua1eOTe3PcLa0ZPW8Mxb9/pKYLZi/+xWgZOhiSBJaYhfSQiQlClMp2ezwz80kTHW
/hIcC3jlxxA2c8NSDh26EYhJjtEGCvCmAT0nW3IgD7hLaLEKkIODCs1YZm0qBV+O
1EYfI4SC2AHcKGKVTqgYRqDOq6XLJDA4ST9/oKOReXiO6RFNmw+BaKMeXofECg==
=GQ/2
-----END PGP SIGNATURE-----

--APfluKkrQK8Lc7hBRBEDv2CWTWpbj5eKj--
