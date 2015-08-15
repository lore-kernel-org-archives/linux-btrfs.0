Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:64778 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbbHOJTW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Aug 2015 05:19:22 -0400
Received: from thetick ([93.181.44.4]) by mail.gmx.com (mrgmx003) with ESMTPSA
 (Nemesis) id 0Lx8OH-1YkjmA2Kuf-016iox for <linux-btrfs@vger.kernel.org>; Sat,
 15 Aug 2015 11:19:19 +0200
Date: Sat, 15 Aug 2015 11:19:07 +0200
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Deleted files cause btrfs-send to fail
Message-ID: <20150815111907.700aa44b@thetick>
In-Reply-To: <pan$8c3e$358182b2$bcc0178b$ca1ab807@cox.net>
References: <20150813003419.09f13c1a@thetick>
	<20150813090541.77f5c821@thetick>
	<pan$1dd35$9501221a$dce0e6ab$9d04fcea@cox.net>
	<20150813105458.676c884a@thetick>
	<20150814233737.5403f9fe@thetick>
	<pan$8c3e$358182b2$bcc0178b$ca1ab807@cox.net>
Reply-To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/ZJM+CP3dU4YRvwEKeH=__GA"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/ZJM+CP3dU4YRvwEKeH=__GA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Am Sat, 15 Aug 2015 05:10:57 +0000 (UTC)
schrieb Duncan <1i5t5.duncan@cox.net>:

> Marc Joliet posted on Fri, 14 Aug 2015 23:37:37 +0200 as excerpted:
>=20
> > (One other thing I found interesting was that "btrfs scrub" didn't care
> > about the link count errors.)
>=20
> A lot of people are confused about exactly what btrfs scrub does, and=20
> expect it to detect and possibly fix stuff it has nothing to do with. =20
> It's *not* an fsck.
>=20
> Scrub does one very useful, but limited, thing.  It systematically=20
> verifies that the computed checksums for all data and metadata covered by=
=20
> checksums match the corresponding recorded checksums.  For dup/raid1/
> raid10 modes, if there's a match failure, it will look up the other copy=
=20
> and see if it matches, replacing the invalid block with a new copy of the=
=20
> other one, assuming it's valid.  For raid56 modes, it attempts to compute=
=20
> the valid copy from parity and, again assuming a match after doing so,=20
> does the replace.  If a valid copy cannot be found or computed, either=20
> because it's damaged too or because there's no second copy or parity to=20
> fall back on (single and raid0 modes), then scrub will detect but cannot=
=20
> correct the error.
>=20
> In routine usage, btrfs automatically does the same thing if it happens=20
> to come across checksum errors in its normal IO stream, but it has to=20
> come across them first.  Scrub's benefit is that it systematically=20
> verifies (and corrects errors where it can) checksums on the entire=20
> filesystem, not just the parts that happen to appear in the normal IO=20
> stream.

I know all that, I just thought it was interesting and wanted to remark as
such. After thinking about it a bit, of course, it makes perfect sense and =
is
not very interesting at all:  scrub will just verify that the checksums mat=
ch,
no matter whether the underlying (meta)data is valid or not.

> Such checksum errors can be for a few reasons...
>=20
> I have one ssd that's gradually failing and returns checksum errors=20
> fairly regularly.  Were I using a normal filesystem I'd have had to=20
> replace it some time ago.  But with btrfs in raid1 mode and regular=20
> scrubs (and backups, should they be needed; sometimes I let them get a=20
> bit stale, but I do have them and am prepared to live with the stale=20
> restored data if I have to), I've been able to keep using the failing=20
> device.  When the scrubs hit errors and btrfs does the rewrite from the=20
> good copy, a block relocation on the failing device is triggered as well,=
=20
> with the bad block taken out of service and a new one from the set of=20
> spares all modern devices have takes its place.  Currently, smartctl -A=20
> reports 904 reallocated sectors raw value, with a standardized value of=20
> 92.  Before the first reallocated sector, the standardized value was 253,=
=20
> perfect.  With the first reallocated sector, it immediately dropped to=20
> 100, apparently the rounded percentage of spare sectors left.  It has=20
> gradually dropped since then to its current 92, with a threshold value of=
=20
> 36.  So while it's gradually failing, there's still plenty of spare=20
> sectors left.  Normally I would have replaced the device even so, but=20
> I've never actually had the opportunity to actually watch a slow failure=
=20
> continue to get worse over time, and now that I do I'm a bit curious how=
=20
> things will go, so I'm just letting it happen, tho I do have a=20
> replacement device already purchased and ready, when the time comes.=20

I'm curious how that will pan out.  My experience with HDDs is that at some
point the sector reallocations start picking up at a somewhat constant (may=
be
even accelerating) rate.  I wonder how SSDs behave in this regard.

> So real media failure, bitrot, is one reason for bad checksums.  The data=
=20
> read back from the device simply isn't the same data that was stored to=20
> it, and the checksum fails as a result.
>=20
> Of course bad connector cables or storage chipset firmware or hardware is=
=20
> another "hardware" cause.
>=20
> Sudden reboot or power loss, with data being actively written and one=20
> copy either already updated or not yet touched, while the other is=20
> actually being written at the time of the crash so the write isn't=20
> completed, is yet another reason for checksum failure.  This one is=20
> actually why a scrub can appear to do so much more than it does, because=
=20
> where there's a second copy (or parity) of the data available, scrub can=
=20
> use it to recover the partially written copy (which being partially=20
> written fails its checksum verification) to either the completed write=20
> state, if the other copy was already written, or the pre-write state, if=
=20
> the other copy hadn't been written at all, yet.  In this way the result=20
> is often the same one an fsck would normally produce, detecting and=20
> fixing the error, but the mechanism is entirely different -- it only=20
> detected and fixed the error because the checksum was bad and it had a=20
> good copy it could replace it with, not because it had any smarts about=20
> how the filesystem actually worked, and could actually tell what the=20
> error was and correct it by actually correcting it.
>=20
>=20
> Meanwhile, in your case the problem was an actual btrfs logic bug -- it=20
> didn't track the inode ref-counts correctly, and didn't remove the inode=
=20
> when the last reference to it was deleted, because it still thought there=
=20
> were more references.  So the metadata actually written to storage was=20
> incorrect due to the logic flaw, but the checksum covering it was indeed=
=20
> the correct checksum for that metadata, as wrong as the metadata actually=
=20
> happened to be.  So scrub couldn't detect the error, because it was an=20
> error not in checksum, which was computed correctly over the metadata,=20
> but in the logic of the metadata itself as it was written.  Scrub=20
> therefore had nothing to do with that error and was in fact totally=20
> oblivious to the fact that the valid checksum covered flawed data in the=
=20
> first place.  Only a tool that could follow the actual logic, send in=20
> this case, since it has to follow the logic in ordered to properly send=20
> it, could detect the error, and only btrfs check knew enough about the=20
> logic to both detect the problem and correct it -- tho even then, it=20
> couldn't totally fix it, as part of the metadata was irretrievably=20
> missing, so it simply dropped what it could retrieve in lost-and-found.
>=20
>=20
> That should make the answer to the question of why scrub couldn't detect=
=20
> and fix the problem clearer -- scrub only detects and possibly fixes a=20
> very specific problem. checksum verification failure, and that's not the=
=20
> problem you had.  As far as scrub was concerned, the checksums were fine,=
=20
> and that's all it knows about, so to it, the data and metadata were fine.

Yeah, that's a more verbose way to put it :) .  Thanks anyway.

Greetings
--=20
Marc Joliet
--
"People who think they know everything really annoy those of us who know we
don't" - Bjarne Stroustrup

--Sig_/ZJM+CP3dU4YRvwEKeH=__GA
Content-Type: application/pgp-signature
Content-Description: Digitale Signatur von OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJVzwQWAAoJEL/Q5oYsiHj0imsP/ijJyMdY2AJDo+8DEyeMpYRi
koyYWUSCZaZ23+YtAokYXGHuH2kHtNfb0G737hRIDVtM6JvGJ1HNdf/AsCywDqUm
PF5AMzxi78UW6dVbd5kvCVhUW+73RWQbpQgsxh9oYc+3GpuldzsrmXBro0aTcuaH
CEu5APyzMvLihLfZqks0tyr836BPCGUsLYwXQltrg606o5JLphl5HO/AUmAZQCnp
GLzYBpH8AijWmjxUNLEiRrNFR9iVF9lVTpxEi4tyci+6EgHuyMRU/I/qIqsD43hT
TcnxhsuvodHKhbOeZ795enjHAsv0GiaVWgwRIthiUb/eFnXx6Sk1S4PGyi8C6mzZ
QG9MeWXf3kOlRByz0wR+VKC+b/QdhyeY6jBJfzHDj4Ey+UNbbnwaSDnXIJtGMIqK
rt50A+DEXvsZbRNjNqF2kamVgbuCaBzskwwc3fvAd+wP9GkTbMtW3C1ClGTZWmXW
+/0fbOqgnskR3A6SuGDXeFxZvnZHn38SgkjHUl+5bbGnHeOMosvgoXcLtoa7Ujar
ixyRko7I3mS8+ZwDzTg7xFlryINXh4d9slFWjBIgPmrPs/ScTbRJQftMxqpjiRSU
7DuTCvda6xpZu+6p8ms+NxQ0gGzIum7MxuVJ9PrFdddTsUhOfq/bHkC1HfOiKIuz
ebX235LuASx1el4F7UZI
=H0b/
-----END PGP SIGNATURE-----

--Sig_/ZJM+CP3dU4YRvwEKeH=__GA--
