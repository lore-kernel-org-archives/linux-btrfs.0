Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49206 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726338AbeHXKxf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Aug 2018 06:53:35 -0400
Subject: Re: [PATCH v2] btrfs: Always check nocow for quota enabled case to
 make sure we won't reserve unnecessary data space
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <20180821054016.28058-1-wqu@suse.com>
 <afee4b2f-ee0b-8afb-b4d6-1fd8f5958e3a@jp.fujitsu.com>
From: Qu Wenruo <wqu@suse.de>
Message-ID: <662fd511-708f-5784-18f8-1282830d5730@suse.de>
Date: Fri, 24 Aug 2018 15:20:07 +0800
MIME-Version: 1.0
In-Reply-To: <afee4b2f-ee0b-8afb-b4d6-1fd8f5958e3a@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="12kzaQQD9hRg9qG2L744jwZ8EzUCsj1pf"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--12kzaQQD9hRg9qG2L744jwZ8EzUCsj1pf
Content-Type: multipart/mixed; boundary="iDZ6d9AtknCo5U6eaH6wMVjGm7D1FSmpX";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <662fd511-708f-5784-18f8-1282830d5730@suse.de>
Subject: Re: [PATCH v2] btrfs: Always check nocow for quota enabled case to
 make sure we won't reserve unnecessary data space
References: <20180821054016.28058-1-wqu@suse.com>
 <afee4b2f-ee0b-8afb-b4d6-1fd8f5958e3a@jp.fujitsu.com>
In-Reply-To: <afee4b2f-ee0b-8afb-b4d6-1fd8f5958e3a@jp.fujitsu.com>

--iDZ6d9AtknCo5U6eaH6wMVjGm7D1FSmpX
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/8/24 =E4=B8=8B=E5=8D=883:14, Misono Tomohiro wrote:
> Hi,
>=20
> On 2018/08/21 14:40, Qu Wenruo wrote:
>> Commit c6887cd11149 ("Btrfs: don't do nocow check unless we have to")
>> makes nocow check less frequent to improve performance.
>>
>> However for quota enabled case, such optimization could lead to extra
>> unnecessary data reservation, which results failure for test case like=

>> btrfs/153 in fstests.
>>
>> Fix it by reverting to old behavior for quota enabled case.
>>
>> Fixes: c6887cd11149 ("Btrfs: don't do nocow check unless we have to")
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>> changelog
>> v2:
>>   Fix regression for quota+cow case. (Previously it will skip data
>>   reservation if quota is enabled, causing regression for limit case.
>>   Pointed out by Misono)
>> ---
>>  fs/btrfs/file.c | 18 +++++++++++++++++-
>>  1 file changed, 17 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
>> index 2be00e873e92..183e5fb96f42 100644
>> --- a/fs/btrfs/file.c
>> +++ b/fs/btrfs/file.c
>> @@ -1584,6 +1584,7 @@ static noinline ssize_t btrfs_buffered_write(str=
uct kiocb *iocb,
>>  	int ret =3D 0;
>>  	bool only_release_metadata =3D false;
>>  	bool force_page_uptodate =3D false;
>> +	bool quota_enabled =3D test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->fl=
ags);
>> =20
>>  	nrptrs =3D min(DIV_ROUND_UP(iov_iter_count(i), PAGE_SIZE),
>>  			PAGE_SIZE / (sizeof(struct page *)));
>> @@ -1624,13 +1625,28 @@ static noinline ssize_t btrfs_buffered_write(s=
truct kiocb *iocb,
>>  				fs_info->sectorsize);
>> =20
>>  		extent_changeset_release(data_reserved);
>> +
>> +		/*
>> +		 * If we have quota enabled, we must do the heavy lift nocow
>> +		 * check here to avoid reserving data space, or we can hit
>> +		 * limitation for NOCOW files.
>> +		 */
>> +		if (quota_enabled) {
>> +			if ((BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
>> +						      BTRFS_INODE_PREALLOC)) &&
>> +			    check_can_nocow(BTRFS_I(inode), pos,
>> +					    &write_bytes) > 0)
>> +				goto reserve_meta_only;
>> +		}
>>  		ret =3D btrfs_check_data_free_space(inode, &data_reserved, pos,
>>  						  write_bytes);
>>  		if (ret < 0) {
>>  			if ((BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
>>  						      BTRFS_INODE_PREALLOC)) &&
>>  			    check_can_nocow(BTRFS_I(inode), pos,
>> -					&write_bytes) > 0) {
>> +					&write_bytes) > 0 &&
>=20
>> +			    !quota_enabled) {
>=20
> (When we check this condition, quota_enabled must be false or otherwise=

> we have already goto reserve_meta_only. So it seems redundant.)

It's possible that we have quota enabled, and then
btrfs_check_data_free_space() failed with -EDQUOT.

In that case, we need above !quota_enabled check to avoid unnecessary
check and just go error branch.

>=20
>> +reserve_meta_only:
>>  				/*
>>  				 * For nodata cow case, no need to reserve
>>  				 * data space.
>>
>=20
> I applied this patch on today's misc-next and it seems mostly ok, but
> btrfs/022 sometimes gives following warning:

This looks like related to the regression caused by commit
c4c129db5da8f070147f175 ("btrfs: drop unused
parameter qgroup_reserved").

Would you please try reverting that patch?

Thanks,
Qu


>=20
> [80244.152130] WARNING: CPU: 5 PID: 14575 at fs/btrfs/extent-tree.c:974=
2 btrfs_free_block_groups+0x2d7/0x440 [btrfs]
> [80244.152132] Modules linked in: btrfs(O) xor zstd_decompress zstd_com=
press xxhash raid6_pq xt_CHECKSUM ipt_MASQUERADE tun bridge stp llc xt_co=
nntrack ip_set nfnetlink iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_=
nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_raw iptable_security =
sunrpc intel_powerclamp kvm_intel kvm gpio_ich iTCO_wdt ipmi_ssif iTCO_ve=
ndor_support ipmi_si st irqbypass ipmi_devintf crct10dif_pclmul crc32_pcl=
mul ipmi_msghandler ghash_clmulni_intel pcspkr acpi_power_meter i2c_i801 =
pcc_cpufreq i7core_edac lpc_ich acpi_cpufreq xfs libcrc32c mgag200 drm_km=
s_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm igb sr_mod=
 hwmon uas ptp crc32c_intel cdrom usb_storage pps_core ata_generic megara=
id_sas dca pata_acpi i2c_algo_bit ipv6 [last unloaded: xor]
> [80244.152185] CPU: 5 PID: 14575 Comm: umount Tainted: G        W IO   =
   4.18.0-rc8+ #98
> [80244.152187] Hardware name: FUJITSU-SV                       PRIMERGY=
 RX300 S6             /D2619, BIOS 6.00 Rev. 1.09.2619.N1           12/13=
/2010
> [80244.152205] RIP: 0010:btrfs_free_block_groups+0x2d7/0x440 [btrfs]
> [80244.152206] Code: 85 20 cb 00 00 48 39 c6 0f 84 b9 00 00 00 49 bf 00=
 01 00 00 00 00 ad de 48 8b 9d 20 cb 00 00 48 83 7b a0 00 0f 84 0d 01 00 =
00 <0f> 0b 48 8d 73 88 31 c9 31 d2 48 89 ef e8 27 7a ff ff 48 89 df e8
> [80244.152235] RSP: 0018:ffff8ea10393fdb0 EFLAGS: 00010286
> [80244.152237] RAX: ffff8c1025819e78 RBX: ffff8c1025819e78 RCX: 0000000=
000000000
> [80244.152238] RDX: 0000000000000001 RSI: ffff8c115329cb20 RDI: ffff8c1=
025818e00
> [80244.152239] RBP: ffff8c1153290000 R08: 0000000000000000 R09: 0000000=
000000000
> [80244.152240] R10: ffff8c1025818e98 R11: 0000000000000002 R12: ffff8c1=
1532900a0
> [80244.152241] R13: 0000000000000000 R14: dead000000000200 R15: dead000=
000000100
> [80244.152243] FS:  00007ff0cc3d8fc0(0000) GS:ffff8c1137d40000(0000) kn=
lGS:0000000000000000
> [80244.152244] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [80244.152245] CR2: 00007ffe75e53c88 CR3: 0000000235d16001 CR4: 0000000=
0000206e0
> [80244.152246] Call Trace:
> [80244.152270]  close_ctree+0x146/0x320 [btrfs]
> [80244.152276]  ? kthread_stop+0x42/0xf0
> [80244.152280]  generic_shutdown_super+0x6c/0x110
> [80244.152283]  kill_anon_super+0xe/0x20
> [80244.152298]  btrfs_kill_super+0x13/0x100 [btrfs]
> [80244.152301]  deactivate_locked_super+0x3f/0x70
> [80244.152303]  cleanup_mnt+0x3b/0x70
> [80244.152305]  task_work_run+0x84/0xa0
> [80244.152308]  do_syscall_64+0x143/0x4cd
> [80244.152311]  ? do_page_fault+0x31/0x130
> [80244.152314]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [80244.152316] RIP: 0033:0x7ff0cb43c1a7
> [80244.152317] Code: ad 2b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44=
 00 00 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f =
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d c9 ac 2b 00 f7 d8 64 89 01 48
> [80244.152346] RSP: 002b:00007ffe75e554b8 EFLAGS: 00000246 ORIG_RAX: 00=
000000000000a6
> [80244.152348] RAX: 0000000000000000 RBX: 0000563ccced82d0 RCX: 00007ff=
0cb43c1a7
> [80244.152349] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000563=
ccced84b0
> [80244.152350] RBP: 0000563ccced84b0 R08: 0000000000000005 R09: 0000563=
ccced84d0
> [80244.152351] R10: 00007ff0cb4ba320 R11: 0000000000000246 R12: 00007ff=
0cc1d0184
> [80244.152352] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000=
000000000
> [80244.152354] ---[ end trace b5975ec96174c60c ]---
> [80244.152358] BTRFS info (device sdh2): space_info 1 has 1022132224 fr=
ee, is not full
> [80244.152360] BTRFS info (device sdh2): space_info total=3D1082130432,=
 used=3D60039168, pinned=3D0, reserved=3D0, may_use=3D1844674407370951065=
6, readonly=3D0
>=20
> Obviously, may_use value is underflowed.
>=20
> Thanks,
> Misono
>=20
>=20


--iDZ6d9AtknCo5U6eaH6wMVjGm7D1FSmpX--

--12kzaQQD9hRg9qG2L744jwZ8EzUCsj1pf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlt/sacACgkQwj2R86El
/qiFlwf/U9kS5KfxITuTJykBa/Lw6igPHqqu/mumGp4ovalKIPPjr3ku19zYt0jv
sKnGXuqg58DTXW1BygyLG8JFSPnZmulH5xrUOvqoqR90O8mJpJ7WPmXHcY0ja6FW
SXIUYBc2oM78mRYAsgBMNfqLS/4DDEC13ojsShXhGTeH5VSV6UlTs4y2qPg6fJ3P
zoTCxwnataS9rv3bnXHR/XriCbpwq55G4/RjUHaz4iqKv/7Fv0UgpzxeGqn6JoGY
RYyzZSTseU4BjTGcIPTYAllNiWokngtkN8PsFsC8Tv10ife755RSZTCA7B4RJcjO
WgSYlPnnYDu/k/f3PjruxB+qlTQJ4w==
=jHKv
-----END PGP SIGNATURE-----

--12kzaQQD9hRg9qG2L744jwZ8EzUCsj1pf--
