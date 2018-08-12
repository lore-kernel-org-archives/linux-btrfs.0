Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:43973 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725760AbeHLENA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 12 Aug 2018 00:13:00 -0400
Subject: Re: Mount stalls indefinitely after enabling quota groups.
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
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
 <0ad384b6-58ef-f2e9-76e3-f706cd38bd42@gmx.com>
Message-ID: <250c5cd0-03fe-f5c6-93d6-75c60431f673@gmx.com>
Date: Sun, 12 Aug 2018 09:36:45 +0800
MIME-Version: 1.0
In-Reply-To: <0ad384b6-58ef-f2e9-76e3-f706cd38bd42@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="zP6piQ4qBjFyu7vPrrIQLFmKLRmDg2QdR"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--zP6piQ4qBjFyu7vPrrIQLFmKLRmDg2QdR
Content-Type: multipart/mixed; boundary="eMchoakxwzYgDMnRdMLQwJ0u9QtngxZPG";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Dan Merillat <dan.merillat@gmail.com>
Cc: BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <250c5cd0-03fe-f5c6-93d6-75c60431f673@gmx.com>
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
 <0ad384b6-58ef-f2e9-76e3-f706cd38bd42@gmx.com>
In-Reply-To: <0ad384b6-58ef-f2e9-76e3-f706cd38bd42@gmx.com>

--eMchoakxwzYgDMnRdMLQwJ0u9QtngxZPG
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/8/12 =E4=B8=8A=E5=8D=888:30, Qu Wenruo wrote:
>=20
>=20
> On 2018/8/12 =E4=B8=8A=E5=8D=885:10, Dan Merillat wrote:
>> 19 hours later, still going extremely slowly and taking longer and
>> longer for progress made.  Main symptom is the mount process is
>> spinning at 100% CPU, interspersed with btrfs-transaction spinning at
>> 100% CPU.
>> So far it's racked up 14h45m of CPU time on mount and an additional
>> 3h40m on btrfs-transaction.
>>
>> The current drop key changes every 10-15 minutes when I check it via
>> inspect-internal, so some progress is slowly being made.
>>
>> I built the kernel with ftrace to see what's going on internally, this=

>> is the pattern I'm seeing:
>>
> [snip]
>=20
> It looks pretty like qgroup, but too many noise.
> The pin point trace event would btrfs_find_all_roots().
>=20
>>
>> Repeats indefinitely.  btrace shows basically zero activity on the
>> array while it spins, with the occasional burst when mount &
>> btrfs-transaction swap off.
>>
>> To recap the chain of events leading up to this:
>> 11TB Array got completely full and started fragmenting badly.
>> Ran bedup and it found 600gb of duplicate files that it offline-shared=
=2E
>> Reboot for unrelated reasons
>=20
> 11T, with highly deduped usage is really the worst scenario case for qg=
roup.
> Qgroup is not really good at handle hight reflinked files, nor balance.=

> When they combines, it goes worse.
>=20
>> Enabled quota on all subvolumes to try to track where the new data is
>> coming from
>> Tried to balance metadata due to transaction CPU spikes
>> Force-rebooted after the array was completely lagged out.
>>
>> Now attempting to mount it RW.  Readonly works, but RW has taken well
>> over 24 hours at this point.
>=20
> I'll add a new rescue subcommand, 'btrfs rescue disable-quota' for you
> to disable quota offline.

Patch set (from my work mailbox), titled "[PATCH] btrfs-progs: rescue:
Add ability to disable quota offline".
Can also be fetched from github:
https://github.com/adam900710/btrfs-progs/tree/quota_disable

Usage is:
# btrfs rescue disable-quota <device>

Tested locally, it would just toggle the ON/OFF flag for quota, so the
modification should be minimal.

Thanks,
Qu

>=20
> Thanks,
> Qu
>=20
>=20


--eMchoakxwzYgDMnRdMLQwJ0u9QtngxZPG--

--zP6piQ4qBjFyu7vPrrIQLFmKLRmDg2QdR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltvjy0ACgkQwj2R86El
/qjQyAgAg1CzMAjrShxUeminrR37An2jrYnP1hpQC9hj26JtpfBx7R8TU+Tm/Z5f
phvkQ5TFI7Q4LJsZf1zo0Rm7ae8mUpGZISXVYO32oDOrVB38myHpBONdpViE3FEW
BHQrrP6U7Bnn91hlTXhR/b84AZB4TNckXUVzhZegEwEqkSLij/U3VzBOHK9rfIcl
ZWeJTmBg1STJo1GmROOnQIxC+Z3DGKpW6eNmzVOIX2oZLZ/aFbW10A4HgNiMHKxx
j2ZuSPeCCXkDxMR7gauKezr2NFZjslO3zrupRomgQB81fAX4uvAVs0B/6hldYtV7
7klS0fo+u6e64u5FeTLMyU/s0yJc1w==
=L15k
-----END PGP SIGNATURE-----

--zP6piQ4qBjFyu7vPrrIQLFmKLRmDg2QdR--
