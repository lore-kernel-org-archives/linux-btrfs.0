Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:60077 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725918AbeIFPzZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Sep 2018 11:55:25 -0400
Subject: Re: [PATCH] btrfs: qgroup: Don't trace subtree if we're dropping tree
 reloc tree
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180905050339.5356-1-wqu@suse.com>
 <20180905131146.GX24025@twin.jikos.cz>
 <c0767f62-5356-af80-c5b4-2e97be62e730@gmx.com>
 <20180906111529.GY24025@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <a37f9cc5-7d5a-4a49-d858-9c58c8930afd@gmx.com>
Date: Thu, 6 Sep 2018 19:20:18 +0800
MIME-Version: 1.0
In-Reply-To: <20180906111529.GY24025@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="0Stj4dYS7l1D9Vjul3SWktaMCMCSjXUgY"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0Stj4dYS7l1D9Vjul3SWktaMCMCSjXUgY
Content-Type: multipart/mixed; boundary="0qKC8NXzLjZVi6JhnK8OLtVuoWpInNMIY";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <a37f9cc5-7d5a-4a49-d858-9c58c8930afd@gmx.com>
Subject: Re: [PATCH] btrfs: qgroup: Don't trace subtree if we're dropping tree
 reloc tree
References: <20180905050339.5356-1-wqu@suse.com>
 <20180905131146.GX24025@twin.jikos.cz>
 <c0767f62-5356-af80-c5b4-2e97be62e730@gmx.com>
 <20180906111529.GY24025@twin.jikos.cz>
In-Reply-To: <20180906111529.GY24025@twin.jikos.cz>

--0qKC8NXzLjZVi6JhnK8OLtVuoWpInNMIY
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/9/6 =E4=B8=8B=E5=8D=887:15, David Sterba wrote:
> On Thu, Sep 06, 2018 at 09:41:14AM +0800, Qu Wenruo wrote:
>>
>>
>> On 2018/9/5 =E4=B8=8B=E5=8D=889:11, David Sterba wrote:
>>> On Wed, Sep 05, 2018 at 01:03:39PM +0800, Qu Wenruo wrote:
>>>> Tree reloc tree doesn't contribute to qgroup numbers, as we have
>>>
>>> I think you can call it just 'reloc tree', I'm fixing that in all
>>> changelogs and comments anyway.
>>
>> But there is another tree called data reloc tree.
>> That why I'm sticking to tree reloc tree to distinguish from data relo=
c
>> tree.
>=20
> So call it 'reloc tree' and 'data reloc tree', the naming of
> BTRFS_TREE_RELOC_OBJECTID does not follow the other tree naming and I
> don't know if the inention was to name it after the 'tree log' scheme o=
r
> the 'extent tree'. Or if there was an intention behind the naming at
> all.
>=20
> If this is going to bother us too much, I won't mind renaming it to
> BTRFS_RELOC_TREE_OBJECTID everywhere. For consistency.
>=20

I'll go reloc tree for later reference.

Renaming makes sense, although I'd like to change its name to something
more distinguish (without the reloc part).

For now, I'm fine using reloc tree.

>>>> accounted them at balance time (check replace_path()).
>>>>
>>>> Skip such unneeded subtree trace should reduce some performance
>>>> overhead.
>>>
>>> Please provide some numbers or description of the improvement. There =
are
>>> several performance problems caused by qgroups so it would be good to=

>>> get a better idea how much this patch is going to help. Thanks.
>>
>> That's the problem.
>> For my internal test, with 3000+ tree blocks, metadata balance could
>> save about 1~2%.
>> But according to dump-tree, the tree layout is almost the worst case
>> scenario, just one metadata block group owns all the tree blocks.
>=20
> If you do such test, it's also a good example for the changelog. It
> describes the worst case and this information can be used to prepare
> testing environment on large data samples.

Already preparing the real world case (great thanks for Fujitsu guys
providing 1TB storage for the test).

I'll provide the data along after the test is done.

Thanks,
Qu


--0qKC8NXzLjZVi6JhnK8OLtVuoWpInNMIY--

--0Stj4dYS7l1D9Vjul3SWktaMCMCSjXUgY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluRDXIACgkQwj2R86El
/qiMpgf/WTWznkMVJXj3Pqs5DAiANSrlQdjcRt0HwoMXeldwpt9afFWSaOI7XyHz
yUHScSrUU/5TO+Lx8ZhmzH/GDmNLqQ+Rx56IwPhtmIHUDMv3tf+wEW0YJm42Z+G5
Sj3hhFgViBxdtnkCPWTdiAwjKkpmGUh/HJN6b/s9SF1/r9DT3UOU7XkaH1k/uo3j
PMV+vwpSgVnaBmC8Sc+10L5ys8UgUpsDlIa8FrVGoPc+beUiHpWw8vEFrp3MRIDg
Bs4zIoDFA1LWuiE62tcpW7x5m2hksMLsCUMRXZ2pBdNC8tIQZ/FLdAYmRk3FYfHt
ufrwVvu3+rXneJ7S8NaqX08K/zX7Fw==
=6vw7
-----END PGP SIGNATURE-----

--0Stj4dYS7l1D9Vjul3SWktaMCMCSjXUgY--
