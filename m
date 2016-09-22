Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32934 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756829AbcIVNlD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Sep 2016 09:41:03 -0400
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>, Josef Bacik <jbacik@fb.com>,
        Ronan Arraes Jardim Chagas <ronisbr@gmail.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Chris Murphy <lists@colorremedies.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
References: <1471023419.16857.9.camel@gmail.com>
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
 <14f71ffe-4cc7-bad1-fde1-42d5e5f90d1d@suse.com>
 <08737c8d-9f1b-5f18-61a0-d3bb501eb950@fb.com>
 <9221d4d9-d114-4ffb-d2f8-6dc2d1cdb79c@suse.com>
 <57DF4F93.2090708@cn.fujitsu.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <f296a35a-3d1a-7db5-9c17-076b241727fb@suse.com>
Date: Thu, 22 Sep 2016 09:40:53 -0400
MIME-Version: 1.0
In-Reply-To: <57DF4F93.2090708@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="9NhjO2iwbwFH7R77qXbU4SCUfgeFhab0Q"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9NhjO2iwbwFH7R77qXbU4SCUfgeFhab0Q
Content-Type: multipart/mixed; boundary="eN2UlOUeAkG8O9L69FQSXe5MgX90BT8sA";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>, Josef Bacik <jbacik@fb.com>,
 Ronan Arraes Jardim Chagas <ronisbr@gmail.com>,
 Qu Wenruo <quwenruo@cn.fujitsu.com>, Chris Murphy <lists@colorremedies.com>,
 "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <f296a35a-3d1a-7db5-9c17-076b241727fb@suse.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
References: <1471023419.16857.9.camel@gmail.com>
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
 <14f71ffe-4cc7-bad1-fde1-42d5e5f90d1d@suse.com>
 <08737c8d-9f1b-5f18-61a0-d3bb501eb950@fb.com>
 <9221d4d9-d114-4ffb-d2f8-6dc2d1cdb79c@suse.com>
 <57DF4F93.2090708@cn.fujitsu.com>
In-Reply-To: <57DF4F93.2090708@cn.fujitsu.com>

--eN2UlOUeAkG8O9L69FQSXe5MgX90BT8sA
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 9/18/16 10:38 PM, Wang Xiaoguang wrote:
> hi,
>=20
> On 09/14/2016 10:25 PM, Jeff Mahoney wrote:
>> On 9/13/16 10:24 PM, Josef Bacik wrote:
>>> On 09/08/2016 07:02 PM, Jeff Mahoney wrote:
>>>> On 9/8/16 2:49 PM, Jeff Mahoney wrote:
>>>>> On 9/8/16 2:24 PM, Ronan Arraes Jardim Chagas wrote:
>>>>>> Hi all!
>>>>>>
>>>>>> Em Seg, 2016-09-05 =C3=A0s 16:49 +0800, Qu Wenruo escreveu:
>>>>>>> Just like what Wang has mentioned, would you please paste all the=

>>>>>>> output
>>>>>>> of the contents of /sys/fs/btrfs/<your fs uuid>/allocation?
>>>>>>>
>>>>>>> It's recommended to use "grep . -IR <path>" to get all the data a=
s
>>>>>>> it
>>>>>>> will show the file name.
>>>>>> So, one more time, I see the problem. This time I was just using
>>>>>> Firefox and I cannot recover using `btrfs balance`. I think that, =
one
>>>>>> more time, I will need to reboot this machine. This problem is rea=
lly
>>>>>> causing me a lot of troubles :(
>>>>> I have a hunch the list is about to be flooded with similar reports=
 if
>>>>> we don't find this one before 4.8.
>>>>>
>>>>> commit d555b6c380c644af63dbdaa7cc14bba041a4e4dd
>>>>> Author: Josef Bacik <jbacik@fb.com>
>>>>> Date:   Fri Mar 25 13:25:51 2016 -0400
>>>>>
>>>>>      Btrfs: warn_on for unaccounted spaces
>>>>>
>>>>> This commit isn't the source of the bug, but it's making it a lot m=
ore
>>>>> noisy.  I spent a few hours last night trying to track down why
>>>>> xfstests
>>>>> was throwing these warnings and I was able to reproduce them at
>>>>> least as
>>>>> far back as 4.4-vanilla with -oenospc_debug enabled.
>>>>>
>>>>> Speaking of which, can you turn on mounting with -oenospc_debug if =
you
>>>>> haven't already?
>>>>>
>>>>> In my case, space_info->bytes_may_use was getting accounted
>>>>> incorrectly.
>>>>>
>>>>> I am able to reproduce that even with the following commit:
>>>>> commit 18513091af9483ba84328d42092bd4d42a3c958f
>>>>> Author: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>>>>> Date:   Mon Jul 25 15:51:40 2016 +0800
>>>>>
>>>>>      btrfs: update btrfs_space_info's bytes_may_use timely
>>>> And the btrfs_free_reserved_data_space_noquota WARN_ON I was seeing =
is
>>>> fixed by:
>>>>
>>>> commit ed7a6948394305b810d0c6203268648715e5006f
>>>> Author: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>>>> Date:   Fri Aug 26 11:33:14 2016 +0800
>>>>
>>>>      btrfs: do not decrease bytes_may_use when replaying extents
>>>>
>>>> ... which shouldn't change anything for your issue, unfortunately.
>>>>
>>>> I still see these:
>>>> WARNING: CPU: 2 PID: 8166 at ../fs/btrfs/extent-tree.c:9582
>>>> btrfs_free_block_groups+0x2a8/0x400 [btrfs]()
>>>> Modules linked in: loop dm_flakey af_packet iscsi_ibft iscsi_boot_sy=
sfs
>>>> msr ext4 crc16 mbcache jbd2 ipmi_ssif dm_mod igb ptp pps_core
>>>> acpi_cpufreq tpm_infineon kvm_amd ipmi_si kvm dca pcspkr
>>>> ipmi_msghandler
>>>> 8250_fintek sp5100_tco fjes irqbypass i2c_piix4 shpchp processor but=
ton
>>>> amd64_edac_mod edac_mce_amd edac_core k10temp btrfs xor raid6_pq sd_=
mod
>>>> ata_generic mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillr=
ect
>>>> ohci_pci sysimgblt ehci_pci serio_raw ohci_hcd fb_sys_fops pata_atii=
xp
>>>> ehci_hcd ttm ahci libahci drm usbcore libata usb_common sg scsi_mod
>>>> autofs4
>>>> CPU: 2 PID: 8166 Comm: umount Tainted: G        W
>>>> 4.4.19-11.g81405db-vanilla #1
>>>> Hardware name: HP ProLiant DL165 G7, BIOS O37 10/17/2012
>>>>   0000000000000000 ffff880230317d10 ffffffff813170ec 000000000000000=
0
>>>>   ffffffffa0472528 ffff880230317d48 ffffffff8107d816 000000000000000=
0
>>>>   ffff88009ab03600 ffff8800ba106288 ffff8800ab75a000 ffff8800ba10620=
0
>>>> Call Trace:
>>>>   [<ffffffff813170ec>] dump_stack+0x63/0x87
>>>>   [<ffffffff8107d816>] warn_slowpath_common+0x86/0xc0
>>>>   [<ffffffff8107d90a>] warn_slowpath_null+0x1a/0x20
>>>>   [<ffffffffa03de3a8>] btrfs_free_block_groups+0x2a8/0x400 [btrfs]
>>>>   [<ffffffffa03ef24b>] close_ctree+0x15b/0x330 [btrfs]
>>>>   [<ffffffffa03bfeb9>] btrfs_put_super+0x19/0x20 [btrfs]
>>>>   [<ffffffff811fe5bf>] generic_shutdown_super+0x6f/0x100
>>>>   [<ffffffff811fe662>] kill_anon_super+0x12/0x20
>>>>   [<ffffffffa03c4fa8>] btrfs_kill_super+0x18/0x120 [btrfs]
>>>>   [<ffffffff811fe003>] deactivate_locked_super+0x43/0x70
>>>>   [<ffffffff811fe076>] deactivate_super+0x46/0x60
>>>>   [<ffffffff81219dcf>] cleanup_mnt+0x3f/0x80
>>>>   [<ffffffff81219e62>] __cleanup_mnt+0x12/0x20
>>>>   [<ffffffff81099fb6>] task_work_run+0x86/0xb0
>>>>   [<ffffffff81078806>] exit_to_usermode_loop+0x73/0xa2
>>>>   [<ffffffff81003b2d>] syscall_return_slowpath+0x8d/0xa0
>>>>   [<ffffffff815f928c>] int_ret_from_sys_call+0x25/0x8f
>>>> ---[ end trace 09a0cc2892b6305c ]---
>>>> BTRFS: space_info 1 has 7946240 free, is not full
>>>> BTRFS: space_info total=3D8388608, used=3D442368, pinned=3D0, reserv=
ed=3D0,
>>>> may_use=3D4096, readonly=3D0
>>>>
>>>> ... where the value of may_use varies.
>>>>
>>> What test are you seeing this with?  Thanks,
>> btrfs/022 hits it every time for me.
> btrfs/022 is not related to this enospc error.
> Qu wenruo's patch =E2=80=9C btrfs: Fix leaking bytes_may_use after hitt=
ing
> EDQUOTA=E2=80=9D has
> fixed this warning, please check his patch for detailed commit message.=


Yep, that's understood.  This was just something I happened to encounter
while looking at this.

-Jeff


--=20
Jeff Mahoney
SUSE Labs


--eN2UlOUeAkG8O9L69FQSXe5MgX90BT8sA--

--9NhjO2iwbwFH7R77qXbU4SCUfgeFhab0Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJX499oAAoJEB57S2MheeWyVe0P/jr1AILgi1hrMLSo7wtkeEsC
hXnhE0DdRRb13j+IAqI4PgvsFmeM6hAd9MslI72hKIlNt+4xyPQxO3tcHXlnb2PD
bp8/ZwynBk0P7/9vLXnsOy4Ro32MspNQ1e7DN6B/hvb8AeBZ5YXltO2FM204r/sO
g7XQCrgDYR/JwncWJiD8KVAcWQXGZSFJ80aA3twrqTkKmQo4WLxVCMxktba4gtV7
w+jZ30s863xhnCEk+uU4hX9/IaL4M5VNZ/sSBm7LmHUQRTOArv6NBnlYcdHIh3fd
oKax+7OuEG7V3rCwSlogNb4VgIE3pBt5o3kWbL66A1ruM6I9YeE8s7+3GvKSEJZ3
gEpVzrLW7Tp+z2lopYlScng/VJfODrZUV8imaEI+UT6kggytFR6PCLjCNm2M8Dw1
hLo15iUk9BwvuEEgcnAaTCDu8azgR+69fljKVPs+mk3Puhr01hdo5X/+l7dkM0l/
pZzzHokR0g3N5O8AEoI5svuMol42F9zTU2InNRccL1NsMT/15be/2HGEY2VawE2F
e3nbtASoblaC5mt0STsscPUDriKOsgknRl7nqAJTiboZgBYPn8gm9c4m/L2BTDRn
ze/V1gf8kBgoOTJXB//sQbGfZGUlVWOCJNYGwcu6aCeawH+aYOlSJ1DAINQjKzyh
rEWk5L4y6EGIBbq6AYVN
=TXIR
-----END PGP SIGNATURE-----

--9NhjO2iwbwFH7R77qXbU4SCUfgeFhab0Q--
