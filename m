Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:53239 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932913AbeCJEqc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Mar 2018 23:46:32 -0500
Subject: Re: [PATCH 0/3] btrfs-progs: Split original mode check to its own
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180206070223.28791-1-wqu@suse.com>
 <20180309165602.GA23693@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <24e9f223-5e1a-c729-db8b-d89eeb770bc7@gmx.com>
Date: Sat, 10 Mar 2018 12:46:15 +0800
MIME-Version: 1.0
In-Reply-To: <20180309165602.GA23693@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="9xQCY8e7j64DzIVv74EQFSzHwrwfw6IwF"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9xQCY8e7j64DzIVv74EQFSzHwrwfw6IwF
Content-Type: multipart/mixed; boundary="5EBTODDB7Wlt5HKIycGOHNdMwlZBYmeCY";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <24e9f223-5e1a-c729-db8b-d89eeb770bc7@gmx.com>
Subject: Re: [PATCH 0/3] btrfs-progs: Split original mode check to its own
References: <20180206070223.28791-1-wqu@suse.com>
 <20180309165602.GA23693@twin.jikos.cz>
In-Reply-To: <20180309165602.GA23693@twin.jikos.cz>

--5EBTODDB7Wlt5HKIycGOHNdMwlZBYmeCY
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8810=E6=97=A5 00:56, David Sterba wrote:
> On Tue, Feb 06, 2018 at 03:02:20PM +0800, Qu Wenruo wrote:
>> This time, there are 2 patches too large to reach mail list, so please=

>> fetch the whole patchset from github as usual:
>> https://github.com/adam900710/btrfs-progs/tree/split_check_part2
>=20
> I missed this patch series, sorry. The changes look good, there
> are unfortunatelly merge conflicts due to the asan/ubsan fixes that
> should be trivial to resolve. Can you please rebase the branch and let
> mek now? Thanks.

No problem, would send the new patchset and pull request to info you.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--5EBTODDB7Wlt5HKIycGOHNdMwlZBYmeCY--

--9xQCY8e7j64DzIVv74EQFSzHwrwfw6IwF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqjYxcXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhPIggAjBpDmEa3kbPSxLSJF6YVEE6j
Lgjx/7LMJDSWyQbre2oK9Oi9fnqUlbGZvo3onb3xbdUojPBOwxb54RaN84CNTlV1
crA06VgfgNsQ1zMVukJ2quX4eQaN/S2wO65+71uWoPTMGVyfVQ114ivdniPHBb+C
66rFupIc7gQW3sClZqefUiQ3uyiuDbrn/Ufri6fkLa3CM4YhmVRk7eHTImdkYjXm
uD4eUaELPkT2ihDRj5zjbPvuUaYOek2dqHlxj4p2oMBioUoaMskC8N8cjTEWW4xW
wlo7WOdLPQkJPLJ6AZ4JG5Ghr4kUXOjt1SXK00vISgB+bpiSuGRgM83mMIkHCw==
=Zs0B
-----END PGP SIGNATURE-----

--9xQCY8e7j64DzIVv74EQFSzHwrwfw6IwF--
