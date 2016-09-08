Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33088 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759336AbcIHSuG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Sep 2016 14:50:06 -0400
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
To: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Chris Murphy <lists@colorremedies.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
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
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <86f87e36-db70-2ad1-cc20-3537dc7e529e@suse.com>
Date: Thu, 8 Sep 2016 14:49:56 -0400
MIME-Version: 1.0
In-Reply-To: <1473359094.7190.1.camel@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="2UcEMx80iHMm2GxLFRud7ueeTXE7L94HX"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2UcEMx80iHMm2GxLFRud7ueeTXE7L94HX
Content-Type: multipart/mixed; boundary="uiJqN8dV3eILaDfqQbXshEKkuoTDiO8sa";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>,
 Qu Wenruo <quwenruo@cn.fujitsu.com>, Chris Murphy <lists@colorremedies.com>,
 "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <86f87e36-db70-2ad1-cc20-3537dc7e529e@suse.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
References: <1471023419.16857.9.camel@gmail.com>
 <CAJCQCtTWJMigkeLUP0+aTFPwdpuJtMa3C4isercAfE_Wh3b=PQ@mail.gmail.com>
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
In-Reply-To: <1473359094.7190.1.camel@gmail.com>

--uiJqN8dV3eILaDfqQbXshEKkuoTDiO8sa
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 9/8/16 2:24 PM, Ronan Arraes Jardim Chagas wrote:
> Hi all!
>=20
> Em Seg, 2016-09-05 =C3=A0s 16:49 +0800, Qu Wenruo escreveu:
>> Just like what Wang has mentioned, would you please paste all the
>> output=20
>> of the contents of /sys/fs/btrfs/<your fs uuid>/allocation?
>>
>> It's recommended to use "grep . -IR <path>" to get all the data as
>> it=20
>> will show the file name.
>=20
> So, one more time, I see the problem. This time I was just using
> Firefox and I cannot recover using `btrfs balance`. I think that, one
> more time, I will need to reboot this machine. This problem is really
> causing me a lot of troubles :(

I have a hunch the list is about to be flooded with similar reports if
we don't find this one before 4.8.

commit d555b6c380c644af63dbdaa7cc14bba041a4e4dd
Author: Josef Bacik <jbacik@fb.com>
Date:   Fri Mar 25 13:25:51 2016 -0400

    Btrfs: warn_on for unaccounted spaces

This commit isn't the source of the bug, but it's making it a lot more
noisy.  I spent a few hours last night trying to track down why xfstests
was throwing these warnings and I was able to reproduce them at least as
far back as 4.4-vanilla with -oenospc_debug enabled.

Speaking of which, can you turn on mounting with -oenospc_debug if you
haven't already?

In my case, space_info->bytes_may_use was getting accounted incorrectly.

I am able to reproduce that even with the following commit:
commit 18513091af9483ba84328d42092bd4d42a3c958f
Author: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Date:   Mon Jul 25 15:51:40 2016 +0800

    btrfs: update btrfs_space_info's bytes_may_use timely


> grep . -IR /sys/fs/btrfs/e9efaa0c-d477-4249-830f-
> ee5956768b29/allocation
> allocation/data/flags:1
> allocation/data/bytes_pinned:0
> allocation/data/bytes_may_use:0
> allocation/data/total_bytes_pinned:202973265920

That adds up to ~ 189 GB.  total_bytes is only about 42 GB.

> allocation/data/bytes_reserved:0
> allocation/data/bytes_used:45623730176
> allocation/data/single/used_bytes:45623730176
> allocation/data/single/total_bytes:46179287040
> allocation/data/total_bytes:46179287040
> allocation/data/disk_total:46179287040
> allocation/data/disk_used:45623730176
> allocation/metadata/dup/used_bytes:1120698368
> allocation/metadata/dup/total_bytes:6979321856
> allocation/metadata/flags:4
> allocation/metadata/bytes_pinned:0
> allocation/metadata/bytes_may_use:88521768960
> allocation/metadata/total_bytes_pinned:-44285952

=2E.. well that's certainly interesting.  It looks like we'll need to see=

how that happened.  It seems like we've messed up at least that portion
of accounting.

-Jeff

> allocation/metadata/bytes_reserved:0
> allocation/metadata/bytes_used:1120698368
> allocation/metadata/total_bytes:6979321856
> allocation/metadata/disk_total:13958643712
> allocation/metadata/disk_used:2241396736
> allocation/global_rsv_size:385875968
> allocation/global_rsv_reserved:385875968
> allocation/system/dup/used_bytes:16384
> allocation/system/dup/total_bytes:33554432
> allocation/system/flags:2
> allocation/system/bytes_pinned:0
> allocation/system/bytes_may_use:0
> allocation/system/total_bytes_pinned:0
> allocation/system/bytes_reserved:0
> allocation/system/bytes_used:16384
> allocation/system/total_bytes:33554432
> allocation/system/disk_total:67108864
> allocation/system/disk_used:32768
>=20
> Additional information:
>=20
> btrfs fi usage /
> Overall:
>     Device size:		   1.26TiB
>     Device allocated:		  56.07GiB
>     Device unallocated:		   1.20TiB
>     Device missing:		     0.00B
>     Used:			  44.58GiB
>     Free (estimated):		   1.20TiB	(min: 616.41GiB)
>     Data ratio:			      1.00
>     Metadata ratio:		      2.00
>     Global reserve:		 368.00MiB	(used: 0.00B)
>=20
> Data,single: Size:43.01GiB, Used:42.49GiB
>    /dev/sda6	  43.01GiB
>=20
> Metadata,DUP: Size:6.50GiB, Used:1.04GiB
>    /dev/sda6	  13.00GiB
>=20
> System,DUP: Size:32.00MiB, Used:16.00KiB
>    /dev/sda6	  64.00MiB
>=20
> Unallocated:
>    /dev/sda6	   1.20TiB
>=20
> Can anyone help me?
>=20
> Best regards,
> Ronan Arraes
>=20


--=20
Jeff Mahoney
SUSE Labs


--uiJqN8dV3eILaDfqQbXshEKkuoTDiO8sa--

--2UcEMx80iHMm2GxLFRud7ueeTXE7L94HX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJX0bLXAAoJEB57S2MheeWyR4MQAJ72gSusrgtYZBIxrQ6de8y2
95RxdenGnqAYoEekuwmuhHwQ3mZTF0WmE0YJj67mOFcs2q6eRLQuQrV78l7XSuC4
2V5/0VI9ahPBbT0MN9WdiR6AATDmADkaWltGLrGnt4coh+qStpjtF1O7elFX0kNq
zSw8z0Ko+1B4p8/V6fUe4695Vd2sSWR3tjuTXI8FW5nGrjT+csTVle3hdPKLXO+u
LhQ04lzblEf14Db9uaALbLTeKGCC2Yua28abgv5ycsi8B2KzOqePleD9dh2ZDJj9
ORwZRvpo6RhRA8Ive8rtbqIPZdmIJYgOXsSusA1t4VSDJdwUpprwXF3F8bihcCL4
6Dcu0T7yZwBlSmKVHqxnwvfao340vIDqdYTjLqRwE/aHqxyEkOxlHCy9RnGPQiZq
Tv5BSlacPdoh5Ki8IZhepvvQlF1z57Ekkt/kr0s1NdM5PRdJsBY+WQgLp5Wwkhh4
t/o52Qly3JuFi2baYE1qfwt039CL0Qj+itrgZv8kLlq+JTCqaIz4QlYAUUl15O6m
zy1BgJBWk68IoP6XEHxXcLgDLkk06dXz8EdhGSd8ZINBbTic4ra0EE+Ee3s1cjm4
+cf44w1k2+5OZC4Ji9lfiDLEkWOceuM+8aqiaP2rHCWMKvD5MXGyHjSwUJbdygpc
7PsnjhisdvjlnlNjg33/
=CR08
-----END PGP SIGNATURE-----

--2UcEMx80iHMm2GxLFRud7ueeTXE7L94HX--
