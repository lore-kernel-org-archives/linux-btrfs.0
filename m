From: Eric Blake <eblake@redhat.com>
Subject: Re: [PATCH 1/2] fs: add SEEK_HOLE and SEEK_DATA flags
Date: Fri, 22 Apr 2011 11:03:45 -0600
Message-ID: <4DB1B4F1.8070109@redhat.com>
References: <1303414954-3315-1-git-send-email-josef@redhat.com> <loom.20110422T001650-760@post.gmane.org> <BANLkTiknb+hzFAjpwESwMcqMVtkFc0HFQQ@mail.gmail.com> <20110422045054.GB17795@infradead.org> <20110422112852.GB1627@x4.trippels.de> <4DB16B72.1050702@redhat.com> <4DB1AC9D.3010706@oracle.com> <4DB1AF6F.4040706@redhat.com> <4DB1B37C.9070406@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------enig5516505D65DBF6AD6EC7D5A9"
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
	Christoph Hellwig <hch@infradead.org>,
	Josef Bacik <josef@toxicpanda.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Sunil Mushran <sunil.mushran@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4DB1B37C.9070406@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5516505D65DBF6AD6EC7D5A9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/22/2011 10:57 AM, Sunil Mushran wrote:
> On 04/22/2011 09:40 AM, Eric Blake wrote:
>> On 04/22/2011 10:28 AM, Sunil Mushran wrote:
>>> while(1) {
>>>      read(block);
>>>      if (block_all_zeroes)
>>>          lseek(SEEK_DATA);
>>> }
>>>
>>> What's wrong with the above? If this is the case, even SEEK_HOLE
>>> is not needed but should be added as it is already in Solaris.
>=20
> Holes are an implementation detail.

Nobody's arguing that.  And on Solaris, a file system with no holes
support tells you that up front - lseek(fd, 0, SEEK_HOLE) returns the
end of the file (unless the file is 0 bytes, then it fails with ENXIO).

>=20
> cp can read whatever blocksize it chooses. If that block contains
> zero, it would signal cp that maybe it should SEEK_DATA and skip
> reading all those blocks. That's all. We are not trying to achieve
> perfection. We are just trying to reduce cpu waste.
>=20
> If the fs supports SEEK_*, then great. If it does not, then it is no
> worse than before.

But providing just SEEK_DATA _is_ worse than before if you don't provide
the correct SEEK_HOLE everywhere.  Because then your algorithm of trying
lseek(SEEK_DATA) after every run of zeros in the hopes of an
optimization is a wasted syscall, since it will just return your current
offset every time, so you end up with more syscalls than if you had used
the single lseek(SEEK_DATA) that returns the end of the file up front,
and known that the remainder of the file has no holes to even try
seeking past.

--=20
Eric Blake   eblake@redhat.com    +1-801-349-2682
Libvirt virtualization library http://libvirt.org


--------------enig5516505D65DBF6AD6EC7D5A9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Public key at http://people.redhat.com/eblake/eblake.gpg
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iQEcBAEBCAAGBQJNsbTxAAoJEKeha0olJ0NqKvwH/j4XwNtUtwofwo8urGuo6pUs
XLnEJ4hKf5Kc0sug+00JNoAFXA0BtoU/tiljbl0zJ/UIyqrkIAeQrL870VYZ1Mn0
9Svo0sz0a3ZQuzqfi4MApraNgLdtbs0HBoxwE9C6Ab7ObT/W3g/3aGH0V7FkZ4pe
wHKEKiThJSj6AUBxMrtA0Wt3uDQRnJgge6qK1GfX1YUiC9tLWfdu+Burk3qjIT8q
m6L3+q62K7L8Ip/oOsQIC9G96Wri1h01DoD7v7AYDJ5VQ454xPwjj+8NNeEBV11R
llm+SiXxXzAB59PtrHhMAmmGUwzr6WBsqkscXZAcBPnD7oefWabzsesnAbeorRo=
=c8VW
-----END PGP SIGNATURE-----

--------------enig5516505D65DBF6AD6EC7D5A9--
