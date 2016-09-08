Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46498 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751000AbcIHXC3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Sep 2016 19:02:29 -0400
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
To: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Chris Murphy <lists@colorremedies.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
References: <1471023419.16857.9.camel@gmail.com>
 <CAJCQCtSPLw5Kwunm6WdhDCiE8Kc7BcfZy6W9veuns7kBmgyivw@mail.gmail.com>
 <a61878b9-7b88-7aee-40cf-05368cd01d78@suse.com>
 <CAJCQCtTBfhXOLg3URfreG29NVfujPjEc0O_cnDFCzDQm0iRtaA@mail.gmail.com>
 <1472734635.3137.4.camel@gmail.com>
 <0778dff0-cb43-d279-adb2-0e314b61110d@gmail.com>
 <1472747695.3137.7.camel@gmail.com>
 <b0ec9154-16a5-5293-952a-0d5a988488e8@gmail.com>
 <ab83503e-58c5-e1b4-b1ba-1e1ea8313607@suse.com>
 <b9bd0a3d-0ae0-a30c-c14d-c85434134890@gmail.com>
 <CAJCQCtT1RptgW-_esKmm2_5eRTxd10wHNxwgNWHSD86LZJ7edQ@mail.gmail.com>
 <d1319d2e-3016-7eef-5f3f-87677600e13c@suse.com>
 <1472827395.3713.6.camel@gmail.com>
 <9dee919a-0e81-5ba7-ddc6-7dcdb3a6b873@suse.com>
 <1472829630.3713.8.camel@gmail.com>
 <506f2875-8cea-2d99-3664-52ee546adcfd@suse.com>
 <1472844353.3083.1.camel@gmail.com>
 <356a9e31-047e-d4c9-00ba-d01b6e92b266@cn.fujitsu.com>
 <1473359094.7190.1.camel@gmail.com>
 <86f87e36-db70-2ad1-cc20-3537dc7e529e@suse.com>
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <14f71ffe-4cc7-bad1-fde1-42d5e5f90d1d@suse.com>
Date: Thu, 8 Sep 2016 19:02:23 -0400
MIME-Version: 1.0
In-Reply-To: <86f87e36-db70-2ad1-cc20-3537dc7e529e@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="pRiRrjUTVLKpsKlWVXLqDAf84WMGpKMtH"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pRiRrjUTVLKpsKlWVXLqDAf84WMGpKMtH
Content-Type: multipart/mixed; boundary="6LDFsnrMuFCNPQdAIUOhugCF54jQ93MQn";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>,
 Qu Wenruo <quwenruo@cn.fujitsu.com>, Chris Murphy <lists@colorremedies.com>,
 "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <14f71ffe-4cc7-bad1-fde1-42d5e5f90d1d@suse.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
References: <1471023419.16857.9.camel@gmail.com>
 <52290114-3b37-2de5-9c9f-ceda6dff955b@suse.com>
 <CAJCQCtSPLw5Kwunm6WdhDCiE8Kc7BcfZy6W9veuns7kBmgyivw@mail.gmail.com>
 <a61878b9-7b88-7aee-40cf-05368cd01d78@suse.com>
 <CAJCQCtTBfhXOLg3URfreG29NVfujPjEc0O_cnDFCzDQm0iRtaA@mail.gmail.com>
 <1472734635.3137.4.camel@gmail.com>
 <0778dff0-cb43-d279-adb2-0e314b61110d@gmail.com>
 <1472747695.3137.7.camel@gmail.com>
 <b0ec9154-16a5-5293-952a-0d5a988488e8@gmail.com>
 <ab83503e-58c5-e1b4-b1ba-1e1ea8313607@suse.com>
 <b9bd0a3d-0ae0-a30c-c14d-c85434134890@gmail.com>
 <CAJCQCtT1RptgW-_esKmm2_5eRTxd10wHNxwgNWHSD86LZJ7edQ@mail.gmail.com>
 <d1319d2e-3016-7eef-5f3f-87677600e13c@suse.com>
 <1472827395.3713.6.camel@gmail.com>
 <9dee919a-0e81-5ba7-ddc6-7dcdb3a6b873@suse.com>
 <1472829630.3713.8.camel@gmail.com>
 <506f2875-8cea-2d99-3664-52ee546adcfd@suse.com>
 <1472844353.3083.1.camel@gmail.com>
 <356a9e31-047e-d4c9-00ba-d01b6e92b266@cn.fujitsu.com>
 <1473359094.7190.1.camel@gmail.com>
 <86f87e36-db70-2ad1-cc20-3537dc7e529e@suse.com>
In-Reply-To: <86f87e36-db70-2ad1-cc20-3537dc7e529e@suse.com>

--6LDFsnrMuFCNPQdAIUOhugCF54jQ93MQn
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 9/8/16 2:49 PM, Jeff Mahoney wrote:
> On 9/8/16 2:24 PM, Ronan Arraes Jardim Chagas wrote:
>> Hi all!
>>
>> Em Seg, 2016-09-05 =C3=A0s 16:49 +0800, Qu Wenruo escreveu:
>>> Just like what Wang has mentioned, would you please paste all the
>>> output=20
>>> of the contents of /sys/fs/btrfs/<your fs uuid>/allocation?
>>>
>>> It's recommended to use "grep . -IR <path>" to get all the data as
>>> it=20
>>> will show the file name.
>>
>> So, one more time, I see the problem. This time I was just using
>> Firefox and I cannot recover using `btrfs balance`. I think that, one
>> more time, I will need to reboot this machine. This problem is really
>> causing me a lot of troubles :(
>=20
> I have a hunch the list is about to be flooded with similar reports if
> we don't find this one before 4.8.
>=20
> commit d555b6c380c644af63dbdaa7cc14bba041a4e4dd
> Author: Josef Bacik <jbacik@fb.com>
> Date:   Fri Mar 25 13:25:51 2016 -0400
>=20
>     Btrfs: warn_on for unaccounted spaces
>=20
> This commit isn't the source of the bug, but it's making it a lot more
> noisy.  I spent a few hours last night trying to track down why xfstest=
s
> was throwing these warnings and I was able to reproduce them at least a=
s
> far back as 4.4-vanilla with -oenospc_debug enabled.
>=20
> Speaking of which, can you turn on mounting with -oenospc_debug if you
> haven't already?
>=20
> In my case, space_info->bytes_may_use was getting accounted incorrectly=
=2E
>=20
> I am able to reproduce that even with the following commit:
> commit 18513091af9483ba84328d42092bd4d42a3c958f
> Author: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> Date:   Mon Jul 25 15:51:40 2016 +0800
>=20
>     btrfs: update btrfs_space_info's bytes_may_use timely

And the btrfs_free_reserved_data_space_noquota WARN_ON I was seeing is
fixed by:

commit ed7a6948394305b810d0c6203268648715e5006f
Author: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Date:   Fri Aug 26 11:33:14 2016 +0800

    btrfs: do not decrease bytes_may_use when replaying extents

=2E.. which shouldn't change anything for your issue, unfortunately.

I still see these:
WARNING: CPU: 2 PID: 8166 at ../fs/btrfs/extent-tree.c:9582
btrfs_free_block_groups+0x2a8/0x400 [btrfs]()
Modules linked in: loop dm_flakey af_packet iscsi_ibft iscsi_boot_sysfs
msr ext4 crc16 mbcache jbd2 ipmi_ssif dm_mod igb ptp pps_core
acpi_cpufreq tpm_infineon kvm_amd ipmi_si kvm dca pcspkr ipmi_msghandler
8250_fintek sp5100_tco fjes irqbypass i2c_piix4 shpchp processor button
amd64_edac_mod edac_mce_amd edac_core k10temp btrfs xor raid6_pq sd_mod
ata_generic mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect
ohci_pci sysimgblt ehci_pci serio_raw ohci_hcd fb_sys_fops pata_atiixp
ehci_hcd ttm ahci libahci drm usbcore libata usb_common sg scsi_mod autof=
s4
CPU: 2 PID: 8166 Comm: umount Tainted: G        W
4.4.19-11.g81405db-vanilla #1
Hardware name: HP ProLiant DL165 G7, BIOS O37 10/17/2012
 0000000000000000 ffff880230317d10 ffffffff813170ec 0000000000000000
 ffffffffa0472528 ffff880230317d48 ffffffff8107d816 0000000000000000
 ffff88009ab03600 ffff8800ba106288 ffff8800ab75a000 ffff8800ba106200
Call Trace:
 [<ffffffff813170ec>] dump_stack+0x63/0x87
 [<ffffffff8107d816>] warn_slowpath_common+0x86/0xc0
 [<ffffffff8107d90a>] warn_slowpath_null+0x1a/0x20
 [<ffffffffa03de3a8>] btrfs_free_block_groups+0x2a8/0x400 [btrfs]
 [<ffffffffa03ef24b>] close_ctree+0x15b/0x330 [btrfs]
 [<ffffffffa03bfeb9>] btrfs_put_super+0x19/0x20 [btrfs]
 [<ffffffff811fe5bf>] generic_shutdown_super+0x6f/0x100
 [<ffffffff811fe662>] kill_anon_super+0x12/0x20
 [<ffffffffa03c4fa8>] btrfs_kill_super+0x18/0x120 [btrfs]
 [<ffffffff811fe003>] deactivate_locked_super+0x43/0x70
 [<ffffffff811fe076>] deactivate_super+0x46/0x60
 [<ffffffff81219dcf>] cleanup_mnt+0x3f/0x80
 [<ffffffff81219e62>] __cleanup_mnt+0x12/0x20
 [<ffffffff81099fb6>] task_work_run+0x86/0xb0
 [<ffffffff81078806>] exit_to_usermode_loop+0x73/0xa2
 [<ffffffff81003b2d>] syscall_return_slowpath+0x8d/0xa0
 [<ffffffff815f928c>] int_ret_from_sys_call+0x25/0x8f
---[ end trace 09a0cc2892b6305c ]---
BTRFS: space_info 1 has 7946240 free, is not full
BTRFS: space_info total=3D8388608, used=3D442368, pinned=3D0, reserved=3D=
0,
may_use=3D4096, readonly=3D0

=2E.. where the value of may_use varies.

-Jeff

>=20
>> grep . -IR /sys/fs/btrfs/e9efaa0c-d477-4249-830f-
>> ee5956768b29/allocation
>> allocation/data/flags:1
>> allocation/data/bytes_pinned:0
>> allocation/data/bytes_may_use:0
>> allocation/data/total_bytes_pinned:202973265920
>=20
> That adds up to ~ 189 GB.  total_bytes is only about 42 GB.
>=20
>> allocation/data/bytes_reserved:0
>> allocation/data/bytes_used:45623730176
>> allocation/data/single/used_bytes:45623730176
>> allocation/data/single/total_bytes:46179287040
>> allocation/data/total_bytes:46179287040
>> allocation/data/disk_total:46179287040
>> allocation/data/disk_used:45623730176
>> allocation/metadata/dup/used_bytes:1120698368
>> allocation/metadata/dup/total_bytes:6979321856
>> allocation/metadata/flags:4
>> allocation/metadata/bytes_pinned:0
>> allocation/metadata/bytes_may_use:88521768960
>> allocation/metadata/total_bytes_pinned:-44285952
>=20
> ... well that's certainly interesting.  It looks like we'll need to see=

> how that happened.  It seems like we've messed up at least that portion=

> of accounting.
>=20
> -Jeff
>=20
>> allocation/metadata/bytes_reserved:0
>> allocation/metadata/bytes_used:1120698368
>> allocation/metadata/total_bytes:6979321856
>> allocation/metadata/disk_total:13958643712
>> allocation/metadata/disk_used:2241396736
>> allocation/global_rsv_size:385875968
>> allocation/global_rsv_reserved:385875968
>> allocation/system/dup/used_bytes:16384
>> allocation/system/dup/total_bytes:33554432
>> allocation/system/flags:2
>> allocation/system/bytes_pinned:0
>> allocation/system/bytes_may_use:0
>> allocation/system/total_bytes_pinned:0
>> allocation/system/bytes_reserved:0
>> allocation/system/bytes_used:16384
>> allocation/system/total_bytes:33554432
>> allocation/system/disk_total:67108864
>> allocation/system/disk_used:32768
>>
>> Additional information:
>>
>> btrfs fi usage /
>> Overall:
>>     Device size:		   1.26TiB
>>     Device allocated:		  56.07GiB
>>     Device unallocated:		   1.20TiB
>>     Device missing:		     0.00B
>>     Used:			  44.58GiB
>>     Free (estimated):		   1.20TiB	(min: 616.41GiB)
>>     Data ratio:			      1.00
>>     Metadata ratio:		      2.00
>>     Global reserve:		 368.00MiB	(used: 0.00B)
>>
>> Data,single: Size:43.01GiB, Used:42.49GiB
>>    /dev/sda6	  43.01GiB
>>
>> Metadata,DUP: Size:6.50GiB, Used:1.04GiB
>>    /dev/sda6	  13.00GiB
>>
>> System,DUP: Size:32.00MiB, Used:16.00KiB
>>    /dev/sda6	  64.00MiB
>>
>> Unallocated:
>>    /dev/sda6	   1.20TiB
>>
>> Can anyone help me?
>>
>> Best regards,
>> Ronan Arraes
>>
>=20
>=20


--=20
Jeff Mahoney
SUSE Labs


--6LDFsnrMuFCNPQdAIUOhugCF54jQ93MQn--

--pRiRrjUTVLKpsKlWVXLqDAf84WMGpKMtH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJX0e3/AAoJEB57S2MheeWyvgMP/1bmEYvW/cCgTc3/lH7hN0KZ
XUfpqAtet1wYGezpLxsHAiN1CBVMpQugnHdy3fHNL2cDRalCTfZOqszulB1UUFLh
uHeaITejYFxTsQlqAI4csCgehxxqZZjHcRfXkVl9MMMr8VS5irIfkp4Mvg81ejXy
I79i1sOeqP3fcdODUxIb8c465mp+1zWT2RXbkBYk07x7+Mc2/kXOYKLxK95rnwNE
hGngWhIycfLyduDjXrjDOUKk9QkN+WfJNcSSLIH03G3W8mIubpvL6YKf1LV+eR4d
vbuuPZJwk1xMb78/6cgCpqme7xSNDsLBsuqeilWbfnKeb2raxL+DSUC9FAhZuKla
ydjIV57LY8aH4iExnhgDtgQyZWKkVi9PSfGzmv7eccXgAjx7W1Ae1998LfMOmmQh
vzN3PQ19R74FXpM5j/SIJxdMj9Z/btiCSm9NvKB286txu4k9AcYgF5dChPVyTEey
WABAhWEFAnHACdhCb9tw6plzypeGmHc/mkO0WRYbLWRq6ekHARuG8Y8jMOqwQBVX
iVrvRqAu1J/765pldgc4ocHdj3TzHycAHdK1vXH6n6FscZdl8zF0519FQzft1XM8
tQJCCb7W5wTpbYvYvZ8AuF3sUvbN4ME6pT76QVjWJEqrp+jP3t3KQdq3uNv0H9ce
+PLVhW2I9gyY6iC6CErB
=9/1V
-----END PGP SIGNATURE-----

--pRiRrjUTVLKpsKlWVXLqDAf84WMGpKMtH--
