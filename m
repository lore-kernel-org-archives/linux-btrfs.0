Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36407 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094AbbF0OVd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Jun 2015 10:21:33 -0400
Date: Sat, 27 Jun 2015 14:21:32 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Vincent Olivier <vincent@up4.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Send/Receive Use Case
Message-ID: <20150627142132.GI16065@carfax.org.uk>
References: <F2771637-3D78-4332-AB96-993069114030@up4.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6lCXDTVICvIQMz0h"
In-Reply-To: <F2771637-3D78-4332-AB96-993069114030@up4.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--6lCXDTVICvIQMz0h
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 27, 2015 at 10:04:28AM -0400, Vincent Olivier wrote:
> Hi,
>=20
> There are 4 things I=E2=80=99m not sure about re:send/receive.
>=20
> 1) Is it possible to first copy things on a file system using rsync and t=
hen use send-receive ? And to subsequently mix rsync and send-receive ? Pro=
vided that snapshots are made accordingly.

   Probably. It depends on exctly how you want to use them.

> 2) Is possible to =E2=80=9Csend" a snapshot diff to disk and then =E2=80=
=9Creceive" it from the said disk into a remote filesystem ? I have two ver=
y large and physically distant btrfs filesystems. It would be more economic=
al to juste dump snapshot diffs to disk for transport instead of the networ=
k.

   Yes, that's perfectly possible.

> 3) How are =E2=80=9Cconflicts=E2=80=9D handled by send-receive if at all ?

   There are no conflicts possible, due to the requirement of all the
subvolumes involved in the send/receive process being read-only.
(Actually, that's not quite true -- you can make a subvolume
read/write, and then read-only again. In that case, the receive will
probably fail, leaving the received subvolume in a partially-created
state).

> 4) If a file is created, modified and then deleted in-between two
> snapshots is it ignored by send/receive or does send/receive
> "re-enacts=E2=80=9D the journal exactly ?

   It'll be ignored. The FS doesn't keep track of how it reached a
particular state -- only what that state is.

   Hugo.

--=20
Hugo Mills             | IMPROVE YOUR ORGANISMS!!
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                            Subject line of spam em=
ail

--6lCXDTVICvIQMz0h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVjrFrAAoJEFheFHXiqx3kmAUP/0rIRcQEDwI6hweU2Ngt66zN
3JvlMkWVzbbSYsBZfknyTcxOKz7S1c3yee0YSRan6gl4+i+ubtrwc6MSojpK/+R0
mRLs4AeO2aTFzROtfYOqEIeNqb1aYjQQCG4+uydJoY18vt/e05hgFi6acf6X+RYq
2N4+sxZJkyL/P0cK3JMqsntV2Q2QwKqjHSMm8Xo+absV9Nl4gNmiq1Uty4UQq3Z4
O2LR0GXwsaUWpyvlM72FYrM6vyqp1BrDord46j9lLLfre6kWmCoEZAriYoKKVQjy
fWjVgh4vjgNXuDc+8MmV6ckH+95RIBMHLVP4s5pYJMDFbVkjQ1lEAfmHIeajnAsq
PsqmfR3lntO+a4X7jPNibCo7VvS97xrFLQ7Wtl3p+Vkmh/2AvFYTPmwtWLidThkC
SSjg6XW+wdUIX2c6uMFw49Re4xz5Pw/B87GgTwIdKSxJ3XKGfFbqsLdvYqqcKVOa
KT5uVP1x48Cdk2q04EsUEdpgwNeUkmc/1jTZvYfRuAybK8bLL9FVrHbHTDyizPXH
vT/QRwLOe3AyF0ijsoKK4KLWwd9bDJ2t0mRUpdh2aGKARVIVIqhpbWgmaQNBj9Gl
QcWfMShR2fWRDzQ6FN/TxWlV7n2/ggabPm0CINyNkkqGPvUHOG4u8n26obP97f7Y
dhpXDM+ovAVFMby6++BF
=uQjz
-----END PGP SIGNATURE-----

--6lCXDTVICvIQMz0h--
