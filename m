Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:55040 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750705AbdCBJww (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Mar 2017 04:52:52 -0500
Received: from thetick.localnet ([93.181.44.247]) by mail.gmx.com (mrgmx103
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0LjZn2-1cCEKe19xY-00bf0o for
 <linux-btrfs@vger.kernel.org>; Thu, 02 Mar 2017 10:44:48 +0100
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: [4.7.2] btrfs_run_delayed_refs:2963: errno=-17 Object already exists
Date: Thu, 02 Mar 2017 10:44:46 +0100
Message-ID: <1689223.KKWey1OxT2@thetick>
In-Reply-To: <14737660.8idzxVKBRv@thetick>
References: <20160828152908.6e1325b5@jupiter.sol.kaishome.de> <63cf74bb-009a-b422-4390-7562395db31d@cn.fujitsu.com> <14737660.8idzxVKBRv@thetick>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart5770818.1bFgcWeJxn"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart5770818.1bFgcWeJxn
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Wednesday 01 March 2017 19:14:07 Marc Joliet wrote:
> In any=20
> case, I started btrfs-check on the device itself.

OK, it's still running, but the output so far is:

# btrfs check --mode=3Dlowmem --progress /dev/sdb2
Checking filesystem on /dev/sdb2
UUID: f97b3cda-15e8-418b-bb9b-235391ef2a38
ERROR: shared extent[3826242740224 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3826442825728 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3826744471552 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3827106349056 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3827141001216 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3827150958592 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3827251724288 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3827433795584 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3827536166912 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3827536183296 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3827621646336 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3828179406848 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3828267970560 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3828284530688 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3828714246144 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3828794187776 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3829161340928 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3829373693952 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3830252130304 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3830421159936 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3830439141376 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3830441398272 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3830785138688 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3831099297792 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3831128768512 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3831371513856 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3831535570944 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3831591952384 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3831799398400 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3831829250048 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3831829512192 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3832011440128 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3832011767808 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3832023920640 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3832024678400 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3832027316224 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3832028762112 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3832030236672 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3832030330880 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3832161079296 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3832164904960 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3832164945920 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3832613765120 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3833727565824 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3833914073088 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3833929310208 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: shared extent[3833930141696 4096] lost its parent (parent:=20
3827251183616, level: 0)
ERROR: extent[3837768077312, 24576] referencer count mismatch (root: 33=
174,=20
owner: 1277577, offset: 4767744) wanted: 1, have: 0
[snip many more referencer count mismatches]
ERROR: extent[3878247383040, 8192] referencer count mismatch (root: 334=
95,=20
owner: 2688918, offset: 3874816) wanted: 2, have: 3
ERROR: block group[3879328546816 1073741824] used 1072840704 but extent=
 items=20
used 1129164800
ERROR: extent[3879516581888, 40960] referencer count mismatch (root: 33=
530,=20
owner: 1277577, offset: 23461888) wanted: 1, have: 0
[snip many more referencer count mismatches]
ERROR: extent[3951758860288, 16384] referencer count mismatch (root: 33=
189,=20
owner: 1277577, offset: 519880704) wanted: 1, have: 0

This is 56=09lines of output, the unabridged output contains enough "re=
ferencer=20
count mismatches" to fill 1329 lines of output.  Could that be because =
there=20
are deleted snapshots that btrfs-cleaner hasn't been able to clean up?

Greetings
=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who kno=
w we
don't" - Bjarne Stroustrup

--nextPart5770818.1bFgcWeJxn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJYt+mOAAoJEL/Q5oYsiHj0xmgP/0gYib/Es3B83QPqtxKyvBxO
OqUHXMZz1t0C3j1KmPFx9kb7TUrDmCbEJnVIevYx10vnZkkdkmqSGG+C8jjMtOSZ
nkHaAQhvl+bXbq8PuTak3TYyVAQuL+F0jZ/0VF+thFUvAdZZqsbCVFSAzyXGTHVd
HLqr0G8cN4mQShfylyLFXIt4zYPBZMj8LdUAi7z3+06fEVC8GT/mfZP/lJVWyOe9
O6mg4Kj/f7w5C+hAtMh9wAvQfyxfZRjjIP8CvIRCmXP3HKqcpJBwn5pxGXqSlr3+
FaPusyyB3ScWRgNTfAZ4uPeMietwN9IDm1r7DJgQA9FMwY31cH0lkoyOOmvrciJL
/122gIRJCZ8q4uzggFAtsaxrIUw9+3cWWba2SzJDpb95GDs0IUcptac+QBDty0BV
wY2QxmfdsheQe9L+7wJmUpW2YuuVXCKvPx+2W9/E5IBCO6C0vM2uyW56fQmraQYE
2vMx7gnqAUoYuCosZQC9iaf9suJ4d+GIGuw/Nqt8LNi3P1oifqeaUPhHn94NS3WP
d18nEKw1DLxqwFH1cEhaTzVPtTZKfnTZCoS2hV46JwPpBHqPBbxZr+hscaX32ZWW
kTCX0HBK0rlcznPMDkmapgnB6DTx9eBwp02zc1dTeRjuIvr50B4+8j7QLgWppbAy
Y5/xJdqkwJsAx1vytqbh
=HPd5
-----END PGP SIGNATURE-----

--nextPart5770818.1bFgcWeJxn--

