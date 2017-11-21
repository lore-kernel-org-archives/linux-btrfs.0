Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:63251 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751684AbdKUM2f (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Nov 2017 07:28:35 -0500
Subject: Re: quotas: failure on removing a file via SFTP/SSH
To: ST <smntov@gmail.com>, linux-btrfs@vger.kernel.org
References: <1511266131.1680.27.camel@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <093ee7e4-91f1-7d23-1ef1-81230d07b405@gmx.com>
Date: Tue, 21 Nov 2017 20:28:28 +0800
MIME-Version: 1.0
In-Reply-To: <1511266131.1680.27.camel@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="RIiQd4LshqhMswB4n5K6UDl5Qem0vNUhU"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RIiQd4LshqhMswB4n5K6UDl5Qem0vNUhU
Content-Type: multipart/mixed; boundary="4DsHu15CHM6E4pLvF3aND0I6TwB1okJRe";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: ST <smntov@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <093ee7e4-91f1-7d23-1ef1-81230d07b405@gmx.com>
Subject: Re: quotas: failure on removing a file via SFTP/SSH
References: <1511266131.1680.27.camel@gmail.com>
In-Reply-To: <1511266131.1680.27.camel@gmail.com>

--4DsHu15CHM6E4pLvF3aND0I6TwB1okJRe
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8821=E6=97=A5 20:08, ST wrote:
> Hello,
>=20
> I'm trying to use quotas for a simple chrooted sftp setup, limiting
> space for each user's subvolume (now for testing to 1M).
>=20
> I tried to hit the limit by uploading files and once it comes to the
> limit I face following problem: if I try to free space by removing a
> file via Linux sftp client (or Filezilla) - I get error:
> "Couldn't delete file: Failure"
>=20
> Sometimes, but not always, if I repeat it for 3-5 times it does removes=

> the file at the end.
> If I login as root and try to remove the file via SSH I get the error:
> "rm: cannot remove 'example.txt': Disk quota exceeded"
>=20
> What is the problem? And how can I solve it?

Kernel version first.

If it's possible, please use latest kernel, at least newer than v4.10,
since we have a lot of qgroup reservation related fixes in newer kernel.

Then, for small quota, due to the nature of btrfs metadata CoW and
relative large default node size (16K), it's quite easy to hit disk
quota for metadata.

So it's not really useful for such small quota usage.
If you really want to use quota for small limit, at least use small
nodesize.

And if you hit -EDQUOTA, normally you could try to sync the fs to free
some reserved space, then try again.

Thanks,
Qu
>=20
> Thank you in advance!
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--4DsHu15CHM6E4pLvF3aND0I6TwB1okJRe--

--RIiQd4LshqhMswB4n5K6UDl5Qem0vNUhU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloUG+wXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgklAf/VZqA5QvQZjf+KQAHfr4FA4VL
gtRMZwkOvFQrtMPG3MMWmvh4BB2yZQ/2oqe1h2eNrrEyF5Zp7lsseOBtvvLbcOfk
ykQVIQUtWgf3jHVNVPuSjZaHF4aBMkzUB1ixa8KinWmXK0w4ERBqNABF+9Qg4s+b
Dt1ATJzOSeXl18iQrJuCy0l7d2qVEQBgebM+62Ctc9nDaUZF5sq7Im/lAlj8y3QW
y5AnYosyLlzbPvnbWSunJJKyToye60ma1atml6ZYETOhwrJCDZq7fQ4LxYYTweHk
iopTG3LlOoHxi5owpxc94ZA24Rcacha/36rR8lyYAAGvfno/7gIVejSZUW2rxw==
=VGqF
-----END PGP SIGNATURE-----

--RIiQd4LshqhMswB4n5K6UDl5Qem0vNUhU--
