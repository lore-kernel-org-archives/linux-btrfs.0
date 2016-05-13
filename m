Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:54171 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbcEMIWR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 May 2016 04:22:17 -0400
Received: from thetick.localnet ([93.181.44.247]) by mail.gmx.com (mrgmx101)
 with ESMTPSA (Nemesis) id 0LxcbX-1bhB9R0gcV-017Cqc for
 <linux-btrfs@vger.kernel.org>; Fri, 13 May 2016 10:22:14 +0200
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Input/output error on newly created file
Date: Fri, 13 May 2016 10:22:04 +0200
Message-ID: <2373043.nUhu0pE6A3@thetick>
In-Reply-To: <pan$b1cd$3f36224$2014cb30$68062598@cox.net>
References: <8760uoqjlt.fsf@vostro.rath.org> <ade418fb-d741-54d0-c9c2-1018889edc72@dblaci.hu> <pan$b1cd$3f36224$2014cb30$68062598@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1870303.TW9nUnFSKs"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1870303.TW9nUnFSKs
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Friday 13 May 2016
schrieb Duncan <1i5t5.duncan@cox.net>

>Szalma L=C3=A1szl=C3=B3 posted on Thu, 12 May 2016 20:28:24 +0200 as e=
xcerpted:
>> The files that rarely become unreadable (I/O error but no error in d=
mesg
>> or anywhere) are mysql MyIsam database files, and they are always sm=
all.
>> Like 16kbyte for example, or smaller. Sometimes dropping the fs cach=
e
>> fixes the problem, sometimes not. Umount / mount always fixes the
>> problem. Scrub says the filesystem is OK (when the file is unreadabl=
e).
>
>Is it possible the files are always under 4 KiB?

For the record, I was seeing a similar error with dovecot *.index.log f=
iles=20
(see the ML thread started by Szalma L=C3=A1szl=C3=B3) .  In my case th=
ey are *not* all=20
under 4 KiB.  Looking at some of the affected files, one of them is 25K=
, and=20
another is 6.6K.  However, perhaps they compress to under 4K?  But comp=
ressing=20
the 25K one with lzop only goes down to 5.6K with -9 :-/ .

>While there's a few variables as to max size, with 4 KiB being the
>practical max, btrfs will inline really small files into their metadat=
a
>node instead of writing them out as 4 KiB data block extents.  Since
>that's obviously a different code-path, if it's only 4 KiB and smaller=

>files, it's possible there's a race in that code-path that when lost,
>results in the file "disappearing" without a dmesg trace, only to
>reappear after reboot.
>
>Actually, now that I think about it, if the files are all OVER say 2 K=
iB
>but still quite small, say under 16 KiB, and if they had just recently=

>grown, it's possible that the race is in the transition from the inlin=
e
>metadata state to the multiples of 4 KiB block data extent state.
>
>And if all the files had just shrunk, say from compaction (if done in-=

>place, not with a copy and rename), perhaps it's the reverse, the
>transition from written data blocks to inline metadata state.

I'm glad somebody is (publicly) thinking about this :-) !

Greetings
=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who kno=
w we
don't" - Bjarne Stroustrup

--nextPart1870303.TW9nUnFSKs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXNY60AAoJEL/Q5oYsiHj0KfkP+gOYFL43ODTV5UKym01A0iYg
eq3F4jwwGZiW90LbD8m+/EGHFdru3d/UpATCDV3qrTn874oG1iOh3lNXHdECknaX
LzRiNSHECAb5bPLCrf+S81/jo1uIGosJU7UbGa266BWieDsl81dnpAOQpQ7iJG/N
G+xj/5xzNLeUeYzTIkkuWecZvUm0uLkXy1/2HITlbf1OysXeN7mHJNPrsYpv0CN7
GCG56UvK4LERLorY72b8+0kVlEzsvfzALJOt59R09dSQum8n6fh9FXDEqWjiL51P
YMOcMwx4O4zIgmwNrYC00EMVzJhZ7UY8Fj4IQ7faN/Y4UAF9gjteO8VQ5jOdNzNC
K0i1as1y88wP4P213pb3Gq4qfhPuwLiEVEJ23IgM9auWrNyGUmrH1/DcGNBlKIXh
d3IguawSRVZ+cH5D1Ae9RylYxq3JDd66muKRcnwMmhO980WhDCBxxRRH1N+FNqLR
TrBRLFNdhL1SLToRx0GB8fEL40A37akok5v3vshvxLMm5YM2qLuDz1RfWsSqY3QH
G/WUHcLk3++YsuFpekIbczHXfW6x56DrJjQmWwc5yzsgH3BfvbvJIGEMOjOK08hK
91oOfkiGBs2qhXFqRmfha6df/V8Wmdl0FmZYMhGrNq+7UeLkXeREk8M029xrBc70
CrJBkSoLv5fvwy5E0Brz
=GO0Y
-----END PGP SIGNATURE-----

--nextPart1870303.TW9nUnFSKs--

