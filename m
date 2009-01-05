From: Chris Samuel <chris@csamuel.org>
Subject: Re: Btrfs for mainline
Date: Mon, 5 Jan 2009 21:07:42 +1100
Message-ID: <200901052107.43341.chris@csamuel.org>
References: <1230722935.4680.5.camel@think.oraclecorp.com> <1230924749.7538.35.camel@think.oraclecorp.com> <20090102210104.GC496@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1260423.C1VZNbUi7i";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Cc: Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	"linux-fsdevel" <linux-fsdevel@vger.kernel.org>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090102210104.GC496@one.firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1260423.C1VZNbUi7i
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sat, 3 Jan 2009 8:01:04 am Andi Kleen wrote:

> When it's in mainline I suspect people will start using it for that.

Some people don't even wait for that. ;-)

Seriously though, if that is a concern can I suggest taking the btrfsdev ro=
ute=20
and, if you want a real belt and braces approach, perhaps require it to hav=
e a=20
mandatory mount option specified to successfully mount, maybe "eat_my_data"=
 ?

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP


--nextPart1260423.C1VZNbUi7i
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQEVAwUASWHb741yjaOTJg85AQLAgAf/Q9wPoQUchI+pjfjeD7f8/lXUwRQluHtS
owDr54kNMh1lqxlGtmsMyDa0Y1PCenruq9eeGdjXRNuG0hqYxFaIhXwDQYYGsBj2
BjtghpaihuUppF92AenyW+alad11NeESylABUXyVttEHo7UiHraOdFW33xqjZ/WW
gdEBGkOyNGRdYttlecJkr+wTAzo8HMMAS3Z5WzPSuPxX3pME9I1g0xBKVQihwCnu
PaVlhYGejR+M8X2vkoCfN3Xd9NfY6cFlZVbxycbPzM0YxKXG0pCGjDNuoSoWIKqf
cipylgYpAn/6iTrGL8unISPWZ5HFw5GjRDc7SIqa1Ggk0CJQyAcjdw==
=5JFs
-----END PGP SIGNATURE-----

--nextPart1260423.C1VZNbUi7i--
