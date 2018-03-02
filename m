Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:49639 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932845AbeCBFZi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Mar 2018 00:25:38 -0500
Subject: Re: [PATCH 0/4] Fix long standing -EOPNOTSUPP problem caused by
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        peteryuchuang@gmail.com
References: <20180301024747.26192-1-wqu@suse.com>
 <20180301145328.GB4817@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <f9e527ea-79a6-1636-09ce-a575835b9366@gmx.com>
Date: Fri, 2 Mar 2018 13:25:21 +0800
MIME-Version: 1.0
In-Reply-To: <20180301145328.GB4817@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="njkvsKxW0HO72qfuFAzkuZ5ZRVCN4Mlvr"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--njkvsKxW0HO72qfuFAzkuZ5ZRVCN4Mlvr
Content-Type: multipart/mixed; boundary="kxMVzKzUfscfdErTmxwMUjr7bUKCVpAFe";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
 peteryuchuang@gmail.com
Message-ID: <f9e527ea-79a6-1636-09ce-a575835b9366@gmx.com>
Subject: Re: [PATCH 0/4] Fix long standing -EOPNOTSUPP problem caused by
References: <20180301024747.26192-1-wqu@suse.com>
 <20180301145328.GB4817@twin.jikos.cz>
In-Reply-To: <20180301145328.GB4817@twin.jikos.cz>

--kxMVzKzUfscfdErTmxwMUjr7bUKCVpAFe
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8801=E6=97=A5 22:53, David Sterba wrote:
> On Thu, Mar 01, 2018 at 10:47:43AM +0800, Qu Wenruo wrote:
>> Kernel doesn't support dropping range inside inline extent, and preven=
ts
>> such thing happening by limiting max inline extent size to
>> min(max_inline, sectorsize - 1) in cow_file_range_inline().
>>
>> However btrfs-progs only inherit the BTRFS_MAX_INLINE_DATA_SIZE() macr=
o,
>> which doesn't have sectorsize check.
>> And since btrfs-progs defaults to 16K nodesize, above macro allows lar=
ge
>> inline extent over 15K size.
>>
>> This leads to unexpected kernel behavior.
>>
>> The bug exists from the very beginning of btrfs-convert, dating back t=
o
>> 2008 when btrfs-convert is first introduced.
>>
>> Qu Wenruo (4):
>>   btrfs-progs: Limit inline extent below page size
>>   btrfs-progs: check/original mode: Check inline extent size
>>   btrfs-progs: check/lowmem mode: Check inline extent size
>>   btrfs-progs: test/convert: Add test case for invalid large inline da=
ta
>>     extent
>=20
> Thanks, added to devel. Fixes will be added to 4.15.2.

Just to mention, since we're checking inline extent size, and kernel can
still create such inline extent by symbol linking, I'm afraid we may get
some false alerts.
(Although it's should be less possible, as symbol link with over 4K size
is a little crazy)

Thanks,
Qu


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--kxMVzKzUfscfdErTmxwMUjr7bUKCVpAFe--

--njkvsKxW0HO72qfuFAzkuZ5ZRVCN4Mlvr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqY4EEXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qh7UAf/VCYPEefTuQqjMhnHxhSYS6Dn
Kdte9Tbn2CLtcq8rHHeS6l2nMAXLFD1hdf2pQtUiuXqkbDXUwfPZCjQCWIlRbpG0
pufwyCXdR94EKziUNnhHfeP/lDQSzgZga4HRuF3wGyT7m9O8e56dkDa4b3KXs8Ya
FsGpovPgcupv2ty2yezj38HrJPwpj41P8WnD3rjpCbZmbgtppniChWgM/MwdS51a
vb+uOZTPdtlXQb6IVfP2hd77CpVxy1Rh7a1Lsj/7JRNMmV++qYQovWHhLFCv0/w+
4va8scZLCXAjq9Z0r9G/KzSdaSVG420UJunlgD5gESD0ADhtzq3iQBA7RnPjzw==
=zib9
-----END PGP SIGNATURE-----

--njkvsKxW0HO72qfuFAzkuZ5ZRVCN4Mlvr--
