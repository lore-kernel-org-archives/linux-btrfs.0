Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from wolfsden.cz ([37.205.8.62]:57342 "EHLO wolfsden.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750835AbdJWUSt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Oct 2017 16:18:49 -0400
Date: Mon, 23 Oct 2017 22:18:46 +0200
From: Wolf <wolf@wolfsden.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Scrub doesn't correct coruption
Message-ID: <20171023201846.ap6bpy4zgxcj4dkb@wolfsden.cz>
References: <20171023083933.wlm2ar5u44yjgmuq@wolfsden.cz>
 <ee364c15-5902-07de-ab66-e57e6aa02c54@gmx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="eqfoyobextshyyp4"
In-Reply-To: <ee364c15-5902-07de-ab66-e57e6aa02c54@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--eqfoyobextshyyp4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On , Qu Wenruo wrote:
> [27240.680874] perf: interrupt took too long (3952 > 3942), lowering kern=
el.perf_event_max_sample_rate to 50400
> > [30658.875802] BTRFS warning (device dm-12): checksum error at logical =
37889245122560 on dev /dev/mapper/data7, sector 2743145096, root 23674, ino=
de 206751, offset 762638336, length 4096, links 1 (path: =E3=82=A2=E3=83=8B=
=E3=83=A1/!waiting_for_better_quality/Gate: Jieitai Kanochi nite, Kaku Tata=
kaeri/GATE Jieitai Kanochi nite, Kaku Tatakaeri 05v2.mp4)
>=20
> Well, it's several seasons ago, and I think there are better BDrip raws n=
ow.
> (Yeah, I'm also an Otaku)
>=20
> Despite that, it's better to hide such personal info though.

Since downloading stuff from internet is legal in my country I don't
usually bother to hide stuff like this, but will do so if it's an issue
in this mailing list.

> And, did you tried to scrub the corrupted device other than the whole fs?
> Btrfs default scrub will start threads to scrub all devices at the same
> time, maybe some concurrency caused the false alert.

Tbh I had no idea I can scrub just the device and not whole filesystem,
running it now (but the scrub on this drive takes like 12 hours so I see
tomorrow if it helped).

> Also, it could be possible to check/repair it by using btrfs-progs.
> Although it's still out-of-tree.
>=20
> Could you please try the following branch and use "btrfs scrub start
> --offline /dev/mapper/data7" to check if it reports the corruption is
> fixable?
> https://github.com/gujx2017/btrfs-progs/tree/offline_scrub
>=20
> Offline scrub gives us a quite good reference on whether it's fixable,
> without the possible hassle in kernel.
> So it's worth trying.

If scrubbing just the device doesn't help in any way, will give it a
try.

> (But hey, there is better better BDrip raws already, so I don't think
> you're really interested in fixing the corruption)

True. Plus since it's RAID1 no data were actually lost and the is
working without problem. I'm mainly interested in knowing if it's

1) Issue with HW
2) Some hidden issue with the whole fs and it's going to fall apart soon



Thanks for tips so far :)

W.
--=20
There are only two hard things in Computer Science:
cache invalidation, naming things and off-by-one errors.

--eqfoyobextshyyp4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEKUV4RjubkPramXVZs4umGUJTxRIFAlnuTqYACgkQs4umGUJT
xRLaHBAApgRBzeX4xGN1Zhj1mj0wf65spCQ4Fz/qwwqQL3lkksi6gPtyrdUky/Ag
ihPddO8IntNc0wgGLlXee83zaE2ih5pdnXwkHk40gkZ3SktzX4qghiJX9uExMA28
kHN8Y/2hJf6dep5vGSDUGUlEzgoIOyuNtbpMCFHk0ba8N5TBEcQxQXzbjtumKS4o
Mr+13GBvuUJasyuyrTGzFswYFbzkOmCW93ox62cFkJdGTWCEb1TdUdNFcij9AA6L
rg+lfCcyBvmUeTsfatIHw8GCZgiCCT9LDG74tuRWnUJbWDBXX+93cDRh2UgmaXCn
M5y+yZBRKO5vSEIhv1/A2Px2zio5gf9WJJ8mWg+DmVoLyn5WXXzsfDjBfA3LEJHr
xWcpp121luLEVm01nia4ZuWKRE5qfYXtrR76RDVo4jtkb4eVopA5yZlgpAxrgyEt
pY0F9Tx9BAI93s1IJpJLA/8r72Cpb0JWlNJqeruH4T9N5RXTfrYcJLdMbsGdQDkU
4JYHmd3mkx/pWF3VLp0jQ1hgZN7KR0n2RtDF+UxB0JCX2ffY7OeZm8yElJT0DtBx
XAU3NKqjLaJuoFcw5hVzFJH0VNecVHfSNPmP/JOXgwdeTg5KnisvRNbhKqVBcbvx
aIgJnNrBneXOrTuYLEoVKu4UpbzJO4ikuuy1EOpF9XcejFuIJKY=
=+Uq1
-----END PGP SIGNATURE-----

--eqfoyobextshyyp4--
