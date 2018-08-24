Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54758 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727490AbeHXLcf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Aug 2018 07:32:35 -0400
Subject: Re: [PATCH v2] btrfs: Always check nocow for quota enabled case to
 make sure we won't reserve unnecessary data space
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <20180821054016.28058-1-wqu@suse.com>
 <afee4b2f-ee0b-8afb-b4d6-1fd8f5958e3a@jp.fujitsu.com>
 <662fd511-708f-5784-18f8-1282830d5730@suse.de>
 <99167e75-351e-ac1d-1a13-97e7717b4a8a@jp.fujitsu.com>
From: Qu Wenruo <wqu@suse.de>
Message-ID: <2c3f3e97-06db-4bbb-59d9-c2880190a5a5@suse.de>
Date: Fri, 24 Aug 2018 15:58:59 +0800
MIME-Version: 1.0
In-Reply-To: <99167e75-351e-ac1d-1a13-97e7717b4a8a@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="AxAsflfNDJi3OXk50Olpp7Y1IwRBHgdCP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--AxAsflfNDJi3OXk50Olpp7Y1IwRBHgdCP
Content-Type: multipart/mixed; boundary="WpFZ3X5QpcJFG2iYrNexfJh6brlF860s7";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <2c3f3e97-06db-4bbb-59d9-c2880190a5a5@suse.de>
Subject: Re: [PATCH v2] btrfs: Always check nocow for quota enabled case to
 make sure we won't reserve unnecessary data space
References: <20180821054016.28058-1-wqu@suse.com>
 <afee4b2f-ee0b-8afb-b4d6-1fd8f5958e3a@jp.fujitsu.com>
 <662fd511-708f-5784-18f8-1282830d5730@suse.de>
 <99167e75-351e-ac1d-1a13-97e7717b4a8a@jp.fujitsu.com>
In-Reply-To: <99167e75-351e-ac1d-1a13-97e7717b4a8a@jp.fujitsu.com>

--WpFZ3X5QpcJFG2iYrNexfJh6brlF860s7
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/8/24 =E4=B8=8B=E5=8D=883:54, Misono Tomohiro wrote:
> On 2018/08/24 16:20, Qu Wenruo wrote:
>>
>>
>> On 2018/8/24 =E4=B8=8B=E5=8D=883:14, Misono Tomohiro wrote:
>>> Hi,
>>>
>>> On 2018/08/21 14:40, Qu Wenruo wrote:
>>>> Commit c6887cd11149 ("Btrfs: don't do nocow check unless we have to"=
)
>>>> makes nocow check less frequent to improve performance.
>>>>
>>>> However for quota enabled case, such optimization could lead to extr=
a
>>>> unnecessary data reservation, which results failure for test case li=
ke
>>>> btrfs/153 in fstests.
>>>>
>>>> Fix it by reverting to old behavior for quota enabled case.
>>>>
>>>> Fixes: c6887cd11149 ("Btrfs: don't do nocow check unless we have to"=
)
>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>> ---
>>>> changelog
>>>> v2:
>>>>   Fix regression for quota+cow case. (Previously it will skip data
>>>>   reservation if quota is enabled, causing regression for limit case=
=2E
>>>>   Pointed out by Misono)
>>>> ---
>>>>  fs/btrfs/file.c | 18 +++++++++++++++++-
>>>>  1 file changed, 17 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
>>>> index 2be00e873e92..183e5fb96f42 100644
>>>> --- a/fs/btrfs/file.c
>>>> +++ b/fs/btrfs/file.c
>>>> @@ -1584,6 +1584,7 @@ static noinline ssize_t btrfs_buffered_write(s=
truct kiocb *iocb,
>>>>  	int ret =3D 0;
>>>>  	bool only_release_metadata =3D false;
>>>>  	bool force_page_uptodate =3D false;
>>>> +	bool quota_enabled =3D test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->=
flags);
>>>> =20
>>>>  	nrptrs =3D min(DIV_ROUND_UP(iov_iter_count(i), PAGE_SIZE),
>>>>  			PAGE_SIZE / (sizeof(struct page *)));
>>>> @@ -1624,13 +1625,28 @@ static noinline ssize_t btrfs_buffered_write=
(struct kiocb *iocb,
>>>>  				fs_info->sectorsize);
>>>> =20
>>>>  		extent_changeset_release(data_reserved);
>>>> +
>>>> +		/*
>>>> +		 * If we have quota enabled, we must do the heavy lift nocow
>>>> +		 * check here to avoid reserving data space, or we can hit
>>>> +		 * limitation for NOCOW files.
>>>> +		 */
>>>> +		if (quota_enabled) {
>>>> +			if ((BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
>>>> +						      BTRFS_INODE_PREALLOC)) &&
>>>> +			    check_can_nocow(BTRFS_I(inode), pos,
>>>> +					    &write_bytes) > 0)
>>>> +				goto reserve_meta_only;
>>>> +		}
>>>>  		ret =3D btrfs_check_data_free_space(inode, &data_reserved, pos,
>>>>  						  write_bytes);
>>>>  		if (ret < 0) {
>>>>  			if ((BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
>>>>  						      BTRFS_INODE_PREALLOC)) &&
>>>>  			    check_can_nocow(BTRFS_I(inode), pos,
>>>> -					&write_bytes) > 0) {
>>>> +					&write_bytes) > 0 &&
>>>
>>>> +			    !quota_enabled) {
>>>
>>> (When we check this condition, quota_enabled must be false or otherwi=
se
>>> we have already goto reserve_meta_only. So it seems redundant.)
>>
>> It's possible that we have quota enabled, and then
>> btrfs_check_data_free_space() failed with -EDQUOT.
>>
>> In that case, we need above !quota_enabled check to avoid unnecessary
>> check and just go error branch.
>=20
> So should quota_enabled be checked before check_can_nocow()?

Oh, yes, it should be put before nocow check.

>=20
>>
>>>
>>>> +reserve_meta_only:
>>>>  				/*
>>>>  				 * For nodata cow case, no need to reserve
>>>>  				 * data space.
>>>>
>>>
>>> I applied this patch on today's misc-next and it seems mostly ok, but=

>>> btrfs/022 sometimes gives following warning:
>>
>> This looks like related to the regression caused by commit
>> c4c129db5da8f070147f175 ("btrfs: drop unused
>> parameter qgroup_reserved").
>>
>> Would you please try reverting that patch?
>=20
> I think above commit is fixed by commit eb27db470 ("btrfs: fix
> qgroup_free wrong num_bytes in btrfs_subvolume_reserve_metadata") which=

> is already in misc-next too.
>=20
> I reverted above two patch (and one more related patch 6b0cb14901
> ("btrfs: drop useless member qgroup_reserved of btrfs_pending_snapshot"=
)),
> but get the same result.

So something really goes wrong.
I assume it's some error handler which double freed, but a quick glance
nor my initial test run doesn't show something obvious.

BTW, what's the possibility of such problem in your test environment?

Thanks,
Qu

>=20
> Thanks,
> Misono
>=20
>>
>> Thanks,
>> Qu
>>
>>
>>>
>>> [80244.152130] WARNING: CPU: 5 PID: 14575 at fs/btrfs/extent-tree.c:9=
742 btrfs_free_block_groups+0x2d7/0x440 [btrfs]
>>> [80244.152132] Modules linked in: btrfs(O) xor zstd_decompress zstd_c=
ompress xxhash raid6_pq xt_CHECKSUM ipt_MASQUERADE tun bridge stp llc xt_=
conntrack ip_set nfnetlink iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 n=
f_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_raw iptable_securit=
y sunrpc intel_powerclamp kvm_intel kvm gpio_ich iTCO_wdt ipmi_ssif iTCO_=
vendor_support ipmi_si st irqbypass ipmi_devintf crct10dif_pclmul crc32_p=
clmul ipmi_msghandler ghash_clmulni_intel pcspkr acpi_power_meter i2c_i80=
1 pcc_cpufreq i7core_edac lpc_ich acpi_cpufreq xfs libcrc32c mgag200 drm_=
kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm igb sr_m=
od hwmon uas ptp crc32c_intel cdrom usb_storage pps_core ata_generic mega=
raid_sas dca pata_acpi i2c_algo_bit ipv6 [last unloaded: xor]
>>> [80244.152185] CPU: 5 PID: 14575 Comm: umount Tainted: G        W IO =
     4.18.0-rc8+ #98
>>> [80244.152187] Hardware name: FUJITSU-SV                       PRIMER=
GY RX300 S6             /D2619, BIOS 6.00 Rev. 1.09.2619.N1           12/=
13/2010
>>> [80244.152205] RIP: 0010:btrfs_free_block_groups+0x2d7/0x440 [btrfs]
>>> [80244.152206] Code: 85 20 cb 00 00 48 39 c6 0f 84 b9 00 00 00 49 bf =
00 01 00 00 00 00 ad de 48 8b 9d 20 cb 00 00 48 83 7b a0 00 0f 84 0d 01 0=
0 00 <0f> 0b 48 8d 73 88 31 c9 31 d2 48 89 ef e8 27 7a ff ff 48 89 df e8
>>> [80244.152235] RSP: 0018:ffff8ea10393fdb0 EFLAGS: 00010286
>>> [80244.152237] RAX: ffff8c1025819e78 RBX: ffff8c1025819e78 RCX: 00000=
00000000000
>>> [80244.152238] RDX: 0000000000000001 RSI: ffff8c115329cb20 RDI: ffff8=
c1025818e00
>>> [80244.152239] RBP: ffff8c1153290000 R08: 0000000000000000 R09: 00000=
00000000000
>>> [80244.152240] R10: ffff8c1025818e98 R11: 0000000000000002 R12: ffff8=
c11532900a0
>>> [80244.152241] R13: 0000000000000000 R14: dead000000000200 R15: dead0=
00000000100
>>> [80244.152243] FS:  00007ff0cc3d8fc0(0000) GS:ffff8c1137d40000(0000) =
knlGS:0000000000000000
>>> [80244.152244] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [80244.152245] CR2: 00007ffe75e53c88 CR3: 0000000235d16001 CR4: 00000=
000000206e0
>>> [80244.152246] Call Trace:
>>> [80244.152270]  close_ctree+0x146/0x320 [btrfs]
>>> [80244.152276]  ? kthread_stop+0x42/0xf0
>>> [80244.152280]  generic_shutdown_super+0x6c/0x110
>>> [80244.152283]  kill_anon_super+0xe/0x20
>>> [80244.152298]  btrfs_kill_super+0x13/0x100 [btrfs]
>>> [80244.152301]  deactivate_locked_super+0x3f/0x70
>>> [80244.152303]  cleanup_mnt+0x3b/0x70
>>> [80244.152305]  task_work_run+0x84/0xa0
>>> [80244.152308]  do_syscall_64+0x143/0x4cd
>>> [80244.152311]  ? do_page_fault+0x31/0x130
>>> [80244.152314]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>> [80244.152316] RIP: 0033:0x7ff0cb43c1a7
>>> [80244.152317] Code: ad 2b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f =
44 00 00 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0=
f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d c9 ac 2b 00 f7 d8 64 89 01 48
>>> [80244.152346] RSP: 002b:00007ffe75e554b8 EFLAGS: 00000246 ORIG_RAX: =
00000000000000a6
>>> [80244.152348] RAX: 0000000000000000 RBX: 0000563ccced82d0 RCX: 00007=
ff0cb43c1a7
>>> [80244.152349] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00005=
63ccced84b0
>>> [80244.152350] RBP: 0000563ccced84b0 R08: 0000000000000005 R09: 00005=
63ccced84d0
>>> [80244.152351] R10: 00007ff0cb4ba320 R11: 0000000000000246 R12: 00007=
ff0cc1d0184
>>> [80244.152352] R13: 0000000000000000 R14: 0000000000000000 R15: 00000=
00000000000
>>> [80244.152354] ---[ end trace b5975ec96174c60c ]---
>>> [80244.152358] BTRFS info (device sdh2): space_info 1 has 1022132224 =
free, is not full
>>> [80244.152360] BTRFS info (device sdh2): space_info total=3D108213043=
2, used=3D60039168, pinned=3D0, reserved=3D0, may_use=3D18446744073709510=
656, readonly=3D0
>>>
>>> Obviously, may_use value is underflowed.
>>>
>>> Thanks,
>>> Misono
>>>
>>>
>>
>=20


--WpFZ3X5QpcJFG2iYrNexfJh6brlF860s7--

--AxAsflfNDJi3OXk50Olpp7Y1IwRBHgdCP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlt/usMACgkQwj2R86El
/qjDUwf5AdHyths4PzyY1XC5yKbUMjhCU95Xt5K6u8LVSRVXVmi68bSHJgQaHPjh
8+pPerii0HGWPqTjSBTUARRNB8//nF/Tg6U0Bv9oEr3Gtgn7w4DV0Fvgriy+wuAe
T2Y9uBJTu7jtPK/l2y+GmhOqcuZ2joR0lmEzo3Gesdh/X/s57NLjwK0m0Wqi14IT
1R/7ZTccRGZV59tfvSgGTNkh99adlwNXZiKO6MO78+4hPLLVKHntL8mfmpa7Oals
auZJt/PKdbvZ8/MkYww1VgIi/rZ/7Gx5RmfGfTVEf27PR3kCVPrXfeO7g+QwxNLn
9BW2k4zkw+/p79T9FIkTjk9fgANGdA==
=LzQW
-----END PGP SIGNATURE-----

--AxAsflfNDJi3OXk50Olpp7Y1IwRBHgdCP--
