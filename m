Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:60311 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761926AbdJQNEJ (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 17 Oct 2017 09:04:09 -0400
Subject: Re: reproducable oops in btrfs/130 with latests mainline
To: Qu Wenruo <wqu@suse.com>, Po-Hsu Lin <po-hsu.lin@canonical.com>,
        linux-btrfs@vger.kernel.org
References: <20161125080723.GA12776@infradead.org>
 <190cc125&#45;d1c1&#45;6005&#45;c23b&#45;cc54c825f242@fb.com>
 <20171017111151.4316-1-po-hsu.lin@canonical.com>
 <4bd6e028-a4bf-6749-2894-e5f9a0e0f629@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <86b47125-32e7-d8b5-fe42-0225b8c1d42a@suse.com>
Date: Tue, 17 Oct 2017 09:03:56 -0400
MIME-Version: 1.0
In-Reply-To: <4bd6e028-a4bf-6749-2894-e5f9a0e0f629@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="COILsUPSlKRRhbf1SoWD05mvleTgniREt"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--COILsUPSlKRRhbf1SoWD05mvleTgniREt
Content-Type: multipart/mixed; boundary="dDimVnoQ89KfWHMCp7xW45CwlRPvrF0Rd";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Qu Wenruo <wqu@suse.com>, Po-Hsu Lin <po-hsu.lin@canonical.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <86b47125-32e7-d8b5-fe42-0225b8c1d42a@suse.com>
Subject: Re: reproducable oops in btrfs/130 with latests mainline
References: <20161125080723.GA12776@infradead.org>
 <190cc125&#45;d1c1&#45;6005&#45;c23b&#45;cc54c825f242@fb.com>
 <20171017111151.4316-1-po-hsu.lin@canonical.com>
 <4bd6e028-a4bf-6749-2894-e5f9a0e0f629@suse.com>
In-Reply-To: <4bd6e028-a4bf-6749-2894-e5f9a0e0f629@suse.com>

--dDimVnoQ89KfWHMCp7xW45CwlRPvrF0Rd
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 10/17/17 8:46 AM, Qu Wenruo wrote:
>=20
>=20
> On 2017=E5=B9=B410=E6=9C=8817=E6=97=A5 19:11, Po-Hsu Lin wrote:
>> Hello Chris,
>>
>> I can reproduce this on my side too, with Ubuntu 16.04 + 4.4.0-97 kern=
el.
>=20
> Btrfs/130 is a known bug.
>=20
> I submitted it to raise the concern about such situation and purposed
> one possible solution (just disable deduped file detection).
>=20
> But the solution doesn't get accepted.

It also works very well as a performance test for qgroup runtime
improvements. :)

-Jeff

> Thanks,
> Qu
>>
>> PREEMPT config:
>> $ cat config-4.4.0-97-generic | grep PREEMPT
>> CONFIG_PREEMPT_NOTIFIERS=3Dy
>> # CONFIG_PREEMPT_NONE is not set
>> CONFIG_PREEMPT_VOLUNTARY=3Dy
>> # CONFIG_PREEMPT is not set
>>
>> Bug reports on launchpad:
>> https://bugs.launchpad.net/bugs/1718925
>> https://bugs.launchpad.net/bugs/1717443
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>=20


--=20
Jeff Mahoney
SUSE Labs


--dDimVnoQ89KfWHMCp7xW45CwlRPvrF0Rd--

--COILsUPSlKRRhbf1SoWD05mvleTgniREt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWeX/wB57S2MheeWyAQgqWhAAtOS83zAOixrZoJDG3Z9Eb7WUIQ9NoE3J
lnZeDTZgHGsK7AnqqZsDoU6zKayWU1Zn1bRabbx+X3xZcMo15dB9JIdH3LCWrUZ5
+EJ/RSJ8EcdDEmNgYyZJ1B1h1Rg7+xT17mCsu5AqySgC8waPW+5tiQf5UWgWRA4S
0EOTZ7gl4qWWOfDOrfNpnC55AXk+qFQF8w8egq18ubXuklG1AeFf//7qiD+pozHL
Ki/13AdwLJsvd5QfZ1LtUTS4CVmAjdYc+8z6qtAN3PTTIhiHKhcCVxAuHuSKDOQL
qsdVJhJmL5/t85w4JxSGiN+HUVaIkJDyMHIaK3m394RKLLpVW9JnkcxFRvkT68gG
/N/klF8TUf5SfQWUTq5bnm4B6myusVujuuI84GFauEM138VjDic0nImMq8H+n3ln
XXM/a3eSQp691vvpp2vMT/8XohsX478xPSyGdLUENKdrvCzT+gN4NSY2yptUCMPk
RRMbg78oYbUyseB9LSuYXTbCoqSbRgdoVxhYnlBgigPqFU9nrvY+cmotaHD9XSq4
6i6SbG49NgX23Z601VKYXqPb8cBUrKYTo0WpiC/RVHPpc7X5qm/lI1m5KKchfwJi
FSxJuINkwYFUoomqPfcNrYHeEBIyvaKOVOngVx42LfeJJjWHrIkEnW9QN5vqXdNB
7LOx0xA6NV0=
=aZKd
-----END PGP SIGNATURE-----

--COILsUPSlKRRhbf1SoWD05mvleTgniREt--
