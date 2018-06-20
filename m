Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:47187 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754055AbeFTAQe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Jun 2018 20:16:34 -0400
Subject: Re: About more loose parameter sequence requirement
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <dbd36f90-fb00-0da1-b38f-567575c5b02f@gmx.com>
 <20180618113432.GJ24375@twin.jikos.cz>
 <f746bf72-148d-9fc3-6d0d-c7e07f00c099@gmx.com>
 <20180618120200.GK24375@twin.jikos.cz>
 <48a89b08-3859-e635-1da2-ce7c9e842d8a@gmx.com>
 <20180619144758.GR24375@twin.jikos.cz>
 <81f3b209-e11a-17b0-8e4f-a7e8df02f448@gmx.com>
Message-ID: <3a59dbbd-a399-8faa-76ad-d0d86338202f@gmx.com>
Date: Wed, 20 Jun 2018 08:16:22 +0800
MIME-Version: 1.0
In-Reply-To: <81f3b209-e11a-17b0-8e4f-a7e8df02f448@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Mbq12rQvBNonVW1pqhs1n4f8tGED4MOcj"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Mbq12rQvBNonVW1pqhs1n4f8tGED4MOcj
Content-Type: multipart/mixed; boundary="ASp9NSueJWHTRmdOKv7owD99ZjihyoNyY";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, "linux-btrfs@vger.kernel.org"
 <linux-btrfs@vger.kernel.org>
Message-ID: <3a59dbbd-a399-8faa-76ad-d0d86338202f@gmx.com>
Subject: Re: About more loose parameter sequence requirement
References: <dbd36f90-fb00-0da1-b38f-567575c5b02f@gmx.com>
 <20180618113432.GJ24375@twin.jikos.cz>
 <f746bf72-148d-9fc3-6d0d-c7e07f00c099@gmx.com>
 <20180618120200.GK24375@twin.jikos.cz>
 <48a89b08-3859-e635-1da2-ce7c9e842d8a@gmx.com>
 <20180619144758.GR24375@twin.jikos.cz>
 <81f3b209-e11a-17b0-8e4f-a7e8df02f448@gmx.com>
In-Reply-To: <81f3b209-e11a-17b0-8e4f-a7e8df02f448@gmx.com>

--ASp9NSueJWHTRmdOKv7owD99ZjihyoNyY
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8820=E6=97=A5 07:18, Qu Wenruo wrote:
>=20
>=20
> On 2018=E5=B9=B406=E6=9C=8819=E6=97=A5 22:47, David Sterba wrote:
>> On Mon, Jun 18, 2018 at 09:05:59PM +0800, Qu Wenruo wrote:
>>>> New code needs to be tested, documented and maintained, that's the c=
ost
>>>> I find too high for something that's convenience for people who are =
used
>>>> to some shell builtins.
>>>
>>> The biggest problem is, the behavior isn't even consistent across
>>> btrfs-progs.
>>> mkfs.btrfs accept such out-of-order parameters while btrfs not.
>>>
>>> And most common tools, like commands provided by coretutil, they don'=
t
>>> care about the order.
>>> The only daily exception is 'scp', which I found it pretty unhandy.
>>>
>>> And just as Paul and Hugo, I think there are quite some users preferr=
ing
>>> out-of-order parameter/options.
>>
>> Because of the feedback and interest of the relaxed mixed
>> option/argument syntax, I don't object anymore.
>=20
> And in fact, the behavior of btrfs is caused by @optind wrongly initial=
ized.
> The fix is just one line (along some comments).
>=20
> https://patchwork.kernel.org/patch/10473173/
>=20
> So no or little pressure on maintenance.

I'm totally wrong.
Since there are cases we call check_argc_*() directly using @optind,
reinitialize it to 0 would cause them to fail.

I'll update the patch to manually reset optind to 0 only for cases we
call getopt().
And indeed, it adds extra maintenance effort.

Thanks,
Qu

>=20
> Thanks,
> Qu
>=20


--ASp9NSueJWHTRmdOKv7owD99ZjihyoNyY--

--Mbq12rQvBNonVW1pqhs1n4f8tGED4MOcj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlspnNYACgkQwj2R86El
/qg7Vwf/cuHHe7DqOc11lMMfvQmERDieEWU5BMdmyrymM++YRqZr+kGah72Ku9Ge
Zo6OVkZ87LN3igOfzVahlhdtkPM3P9EtR6ygpxu9v2ZK5MyNewyLY+E3LcxGDCTk
kohpHwzNkmodZfHu5l/wTsoi+EyznQmXQgkvu4c6omzpDitzU75VuuxZus62UwGr
edMYBEamBxg4PQsEgqe2LSq3wg0zDvFTS1Btu4NR9L853ORuVPZuDQdINThBfsDt
PRE/sv/7Y4eZLkdWcZVxxTZfxIwIjXil8/WYsN3D2crT+hKdwbEuv1fYryQc7/MC
auDa+37fPb2KYlQ5TlGhctNAObUhXw==
=Fg5h
-----END PGP SIGNATURE-----

--Mbq12rQvBNonVW1pqhs1n4f8tGED4MOcj--
