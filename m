Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:36931 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727475AbeHLDGF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 11 Aug 2018 23:06:05 -0400
Subject: Re: Mount stalls indefinitely after enabling quota groups.
To: Dan Merillat <dan.merillat@gmail.com>
Cc: BTRFS <linux-btrfs@vger.kernel.org>
References: <CAPL5yKfaoujn4gOcejJKwvXHhnuRgFLACKHxxy=bXQz0tE0YMA@mail.gmail.com>
 <06f0c899-bb33-54d5-8a87-20f138642f70@gmx.com>
 <CAPL5yKdhTAZjG00xwd=2Z7PsNO7ixBY9gTYMS6c2-7DSBeMapA@mail.gmail.com>
 <6389f50e-3ce5-1f3d-0c2c-d169cf431b57@gmx.com>
 <CAPL5yKfPvmJKtgLTtpAAh_DJ91_M-_mUeX_upQ0-rgO4XwJZDA@mail.gmail.com>
 <e3b0929f-9415-5816-2a68-0e46f11454ba@gmx.com>
 <CAPL5yKds7f2NeGqBx_+LP62FU-EOge74DeW=VJGocDbiZHoztw@mail.gmail.com>
 <6c29c33b-68f4-91d1-493e-5751000dec24@gmx.com>
 <CAPL5yKe4if48zANCpSXi+G_q6cHevTEu+LJ2whqc1dQYapq1bA@mail.gmail.com>
 <CAPL5yKcWZ9qOt7ymw2tCM4gqZ3wiwgRLer+r1x=+kYgDJnqjcQ@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <0ad384b6-58ef-f2e9-76e3-f706cd38bd42@gmx.com>
Date: Sun, 12 Aug 2018 08:30:01 +0800
MIME-Version: 1.0
In-Reply-To: <CAPL5yKcWZ9qOt7ymw2tCM4gqZ3wiwgRLer+r1x=+kYgDJnqjcQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Hd4gnK5aZLCocey8mnMrBzWr6GqsB6MRG"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Hd4gnK5aZLCocey8mnMrBzWr6GqsB6MRG
Content-Type: multipart/mixed; boundary="tBh1cFVcywXTYK8cwUX7sQbQ9047Y697L";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Dan Merillat <dan.merillat@gmail.com>
Cc: BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <0ad384b6-58ef-f2e9-76e3-f706cd38bd42@gmx.com>
Subject: Re: Mount stalls indefinitely after enabling quota groups.
References: <CAPL5yKfaoujn4gOcejJKwvXHhnuRgFLACKHxxy=bXQz0tE0YMA@mail.gmail.com>
 <06f0c899-bb33-54d5-8a87-20f138642f70@gmx.com>
 <CAPL5yKdhTAZjG00xwd=2Z7PsNO7ixBY9gTYMS6c2-7DSBeMapA@mail.gmail.com>
 <6389f50e-3ce5-1f3d-0c2c-d169cf431b57@gmx.com>
 <CAPL5yKfPvmJKtgLTtpAAh_DJ91_M-_mUeX_upQ0-rgO4XwJZDA@mail.gmail.com>
 <e3b0929f-9415-5816-2a68-0e46f11454ba@gmx.com>
 <CAPL5yKds7f2NeGqBx_+LP62FU-EOge74DeW=VJGocDbiZHoztw@mail.gmail.com>
 <6c29c33b-68f4-91d1-493e-5751000dec24@gmx.com>
 <CAPL5yKe4if48zANCpSXi+G_q6cHevTEu+LJ2whqc1dQYapq1bA@mail.gmail.com>
 <CAPL5yKcWZ9qOt7ymw2tCM4gqZ3wiwgRLer+r1x=+kYgDJnqjcQ@mail.gmail.com>
In-Reply-To: <CAPL5yKcWZ9qOt7ymw2tCM4gqZ3wiwgRLer+r1x=+kYgDJnqjcQ@mail.gmail.com>

--tBh1cFVcywXTYK8cwUX7sQbQ9047Y697L
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/8/12 =E4=B8=8A=E5=8D=885:10, Dan Merillat wrote:
> 19 hours later, still going extremely slowly and taking longer and
> longer for progress made.  Main symptom is the mount process is
> spinning at 100% CPU, interspersed with btrfs-transaction spinning at
> 100% CPU.
> So far it's racked up 14h45m of CPU time on mount and an additional
> 3h40m on btrfs-transaction.
>=20
> The current drop key changes every 10-15 minutes when I check it via
> inspect-internal, so some progress is slowly being made.
>=20
> I built the kernel with ftrace to see what's going on internally, this
> is the pattern I'm seeing:
>=20
[snip]

It looks pretty like qgroup, but too many noise.
The pin point trace event would btrfs_find_all_roots().

>=20
> Repeats indefinitely.  btrace shows basically zero activity on the
> array while it spins, with the occasional burst when mount &
> btrfs-transaction swap off.
>=20
> To recap the chain of events leading up to this:
> 11TB Array got completely full and started fragmenting badly.
> Ran bedup and it found 600gb of duplicate files that it offline-shared.=

> Reboot for unrelated reasons

11T, with highly deduped usage is really the worst scenario case for qgro=
up.
Qgroup is not really good at handle hight reflinked files, nor balance.
When they combines, it goes worse.

> Enabled quota on all subvolumes to try to track where the new data is
> coming from
> Tried to balance metadata due to transaction CPU spikes
> Force-rebooted after the array was completely lagged out.
>=20
> Now attempting to mount it RW.  Readonly works, but RW has taken well
> over 24 hours at this point.

I'll add a new rescue subcommand, 'btrfs rescue disable-quota' for you
to disable quota offline.

Thanks,
Qu



--tBh1cFVcywXTYK8cwUX7sQbQ9047Y697L--

--Hd4gnK5aZLCocey8mnMrBzWr6GqsB6MRG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltvf4kACgkQwj2R86El
/qgnwAf+Oq6Cp4XBNEd6DP4iBZ5KstaztKQ3smGIFdFJIw7/j1lqn69/EYuEszzI
5y/lv2nhr5TNv44x7Rxx6sao3fJaP5YNZfoUGKasH+cgPJvYqw29jBqAjVyPpSQn
eNwX7uKpAmmuU/+XRP5INP1RnKccJOdgpENcQwpXxwofz5nbkJ6R3ooqDb8F3hkE
ntZ3fnfuVK1KlOqa5vB9BmeyStmx6mpCy+BvOro0V3vqE2qnIaZGoOUB2dIUj7B0
IM72zMbbBIVC17m0hXJaQNcJqpuU07iaMLzhkErsBxvFWvpcpzQ+jMfOspYttpT3
y0YDh94E2XDN7WwX4Ym36gZsx434Bg==
=mfpZ
-----END PGP SIGNATURE-----

--Hd4gnK5aZLCocey8mnMrBzWr6GqsB6MRG--
