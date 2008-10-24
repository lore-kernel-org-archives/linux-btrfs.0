From: Chris Samuel <chris@csamuel.org>
Subject: Re: Some very basic questions
Date: Fri, 24 Oct 2008 19:39:27 +1100
Message-ID: <200810241939.31807.chris@csamuel.org>
References: <20081021132322.271ad728.skraw@ithnet.com> <1224611383.27474.140.camel@think.oraclecorp.com> <20081022141906.f6529c6d.skraw@ithnet.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart153116153.gYv5nKsRol";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081022141906.f6529c6d.skraw@ithnet.com>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart153116153.gYv5nKsRol
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wed, 22 Oct 2008 11:19:06 pm Stephan von Krawczynski wrote:

> You have a NFS server with clients. Your NFS server dies, your backup
> server cannot take over the clients without them resetting their NFS-link
> (which means reboot to many applications) - no way.

We're getting way off btrfs here, but did you set the fsid's for all your=20
exports on the primary and backup NFS servers and make sure they were also =
set=20
to the same values ?

e.g.

/home   10.0.0.0/255.0.0.0(async,no_subtree_check,rw,fsid=3D0111)

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP


--nextPart153116153.gYv5nKsRol
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQEVAwUASQGJw41yjaOTJg85AQKngwf+NfB/mSFUgQmuN53rCIpLF1wxYM5mkHdT
wp7kPzYtJSUGsWjfVQa024OlO2xlK/bceikz+BsooZJRMkx6iVehOVCiFHpJpxf/
cNx/62hFi+9eSr7ufutMRasKdPKKoO/0LYXeoPRJRoRK0xHgIXxq2XaEamsHcIyr
I2iRlEcmNfN/0vNblHXrt78B4LsfhKICSUF5yfKfK68qsppzC7XXE4aqBjAAQT5Q
wXKEWou3uBABJAHhJcgw3iaQIS8P8rTtzJ3uRh4hnFQeeWimVEKKivdV5X4vRe0s
KR9OCgp27EAD6PKLVTMRF1S+9w1KqBKNL3H/0Cnjw2WnoseN55mrJg==
=XNyG
-----END PGP SIGNATURE-----

--nextPart153116153.gYv5nKsRol--
