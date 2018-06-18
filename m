Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:47447 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933381AbeFRLky (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Jun 2018 07:40:54 -0400
Subject: Re: About more loose parameter sequence requirement
To: dsterba@suse.cz,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <dbd36f90-fb00-0da1-b38f-567575c5b02f@gmx.com>
 <20180618113432.GJ24375@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <f746bf72-148d-9fc3-6d0d-c7e07f00c099@gmx.com>
Date: Mon, 18 Jun 2018 19:40:44 +0800
MIME-Version: 1.0
In-Reply-To: <20180618113432.GJ24375@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="sgobbgeuMf6NgJjcTUdr8bev2IGKp6qZp"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--sgobbgeuMf6NgJjcTUdr8bev2IGKp6qZp
Content-Type: multipart/mixed; boundary="9b0ZD2L4wLWxqVOiNbsKwDXWiaMopO1Ck";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, "linux-btrfs@vger.kernel.org"
 <linux-btrfs@vger.kernel.org>
Message-ID: <f746bf72-148d-9fc3-6d0d-c7e07f00c099@gmx.com>
Subject: Re: About more loose parameter sequence requirement
References: <dbd36f90-fb00-0da1-b38f-567575c5b02f@gmx.com>
 <20180618113432.GJ24375@twin.jikos.cz>
In-Reply-To: <20180618113432.GJ24375@twin.jikos.cz>

--9b0ZD2L4wLWxqVOiNbsKwDXWiaMopO1Ck
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8818=E6=97=A5 19:34, David Sterba wrote:
> On Thu, Jun 14, 2018 at 03:17:45PM +0800, Qu Wenruo wrote:
>> I understand that btrfs-progs introduced restrict parameter/option ord=
er
>> to distinguish global and sub-command parameter/option.
>>
>> However it's really annoying if one just want to append some new optio=
ns
>> to previous command:
>>
>> E.g.
>> # btrfs check /dev/data/btrfs
>> # !! --check-data-csum
>>
>> The last command will fail as current btrfs-progs doesn't allow any
>> option after parameter.
>>
>>
>> Despite the requirement to distinguish global and subcommand
>> option/parameter, is there any other requirement for such restrict
>> option-first-parameter-last policy?
>=20
> I'd say that it's a common and recommended pattern. Getopt is able to
> reorder the parameters so mixed options and non-options are accepted,
> unless POSIXLY_CORRECT (see man getopt(3)) is not set. With the more
> strict requirement, 'btrfs' option parser works the same regardless of
> that.

But currently it doesn't work.
Just as the example, btrfs check /dev/data/btrfs --check-data-sum won't
work.
It's different from a lot of other common programs.

>=20
>> If I could implement a enhanced getopt to allow more loose order insid=
e
>> subcomand while still can distinguish global option, will it be accept=
ed
>> (if it's quality is acceptable) ?
>=20
> I think it's not worth updating the parser just to support an IMHO
> narrow usecase.

I'll try to use the getopt() and keeps the current structure if possible.=


Thanks,
Qu

>=20


--9b0ZD2L4wLWxqVOiNbsKwDXWiaMopO1Ck--

--sgobbgeuMf6NgJjcTUdr8bev2IGKp6qZp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsnmjwACgkQwj2R86El
/qh6oQgAj6yLHAtkZuxw4t2aKXgBtaYzJ7sIlT1NXBD5f621iE7k5Q4C61kL5S14
tp4Bjxrkw9uIk++rYldrny9Nqw9J+qq++nUM6xxXz5rmOgnzXK2PPsjOV56yGjPE
Ocw5ZjSYBHb6ck+w6P4uZ6zEl0fhEn3ImsWEPdEvsv0sVIQ1aQ1OsYk97spq7UBJ
c0sM44dRCa/zuMh6ZqiVcvo0zkNEvsanQHTNjraRUrIVPqNSUvEl8LNtUqyh+Yfs
DOlRzmZHp2Q8Eb1IoRmGTNBlNglZJ8W6CZ5pHD0sp2W9HKBJzVo2Gv/MTM7Qjk8c
Oc97jBrjrqbx2lBr1uXeW+Bd+JbQBg==
=glJl
-----END PGP SIGNATURE-----

--sgobbgeuMf6NgJjcTUdr8bev2IGKp6qZp--
