Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:53586 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751268AbdLJXc5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Dec 2017 18:32:57 -0500
Subject: Re: Chunk-Recovery fails with alignment error
To: Benjamin Beichler <hadrian2002@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
References: <CABi++uJj6x=ZT1QbB7vu5Zh3_Mf6nsLNMAO9QXNLEBQN_ngoYA@mail.gmail.com>
 <211ded6e-5b02-0c33-b75e-b0ad6ff30ca4@gmx.com>
 <CABi++uKoMgi3WMw4z+kgJ1G2H_y_2e2Czg0OLwf18g9GmoU2Cg@mail.gmail.com>
 <2f4346d5-ccb9-8de2-11d1-b270058723c1@gmx.com>
 <CABi++uLD_2sXjuF6b0GKhWAX6fRRA0jqqUaujWP6_q+hiuvSXw@mail.gmail.com>
 <b484d30c-f32d-78cf-7f07-b9cadb43a2d1@gmx.com>
 <CABi++u+Asgyrxq7+txcdJ4EkknrpTTOo7B1G36-Mymk+Wfhv6A@mail.gmail.com>
 <d6722177-45c5-5010-ae48-ab8ec2a89141@gmx.com>
 <80e80ca8-5fbe-d0c9-c389-28df820f01dd@gmx.com>
 <CABi++uJD=XRVq-tUNZMep+GKFUKf8=okxrhhRGRo00aS=B9OOw@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <28d152f8-f299-f769-ab22-b2db4ed8d8c6@gmx.com>
Date: Mon, 11 Dec 2017 07:32:35 +0800
MIME-Version: 1.0
In-Reply-To: <CABi++uJD=XRVq-tUNZMep+GKFUKf8=okxrhhRGRo00aS=B9OOw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="PcqjnUbdHSN1fXg1TtR79NDdxvtw4OsiC"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PcqjnUbdHSN1fXg1TtR79NDdxvtw4OsiC
Content-Type: multipart/mixed; boundary="pclX2j8h5aD5BJPg8lGgXGobJuf3Ubva0";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Benjamin Beichler <hadrian2002@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <28d152f8-f299-f769-ab22-b2db4ed8d8c6@gmx.com>
Subject: Re: Chunk-Recovery fails with alignment error
References: <CABi++uJj6x=ZT1QbB7vu5Zh3_Mf6nsLNMAO9QXNLEBQN_ngoYA@mail.gmail.com>
 <211ded6e-5b02-0c33-b75e-b0ad6ff30ca4@gmx.com>
 <CABi++uKoMgi3WMw4z+kgJ1G2H_y_2e2Czg0OLwf18g9GmoU2Cg@mail.gmail.com>
 <2f4346d5-ccb9-8de2-11d1-b270058723c1@gmx.com>
 <CABi++uLD_2sXjuF6b0GKhWAX6fRRA0jqqUaujWP6_q+hiuvSXw@mail.gmail.com>
 <b484d30c-f32d-78cf-7f07-b9cadb43a2d1@gmx.com>
 <CABi++u+Asgyrxq7+txcdJ4EkknrpTTOo7B1G36-Mymk+Wfhv6A@mail.gmail.com>
 <d6722177-45c5-5010-ae48-ab8ec2a89141@gmx.com>
 <80e80ca8-5fbe-d0c9-c389-28df820f01dd@gmx.com>
 <CABi++uJD=XRVq-tUNZMep+GKFUKf8=okxrhhRGRo00aS=B9OOw@mail.gmail.com>
In-Reply-To: <CABi++uJD=XRVq-tUNZMep+GKFUKf8=okxrhhRGRo00aS=B9OOw@mail.gmail.com>

--pclX2j8h5aD5BJPg8lGgXGobJuf3Ubva0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8811=E6=97=A5 05:16, Benjamin Beichler wrote:
> The patch let the chunk-recover be successful. But I'm no lucky man,
> the recovered chunk tree does not work or other metadata is also
> broken.
>=20
> Mounting the system is not successful (dmesg):
> BTRFS critical (device dm-0): corrupt node, invalid item slot:
> block=3D16384, root=3D1, slot=3D0

What does btrfs dump-tree -b 16384 say?

IIRC the same 0 bytenr problem in kernel.

> BTRFS error (device dm-0): failed to read chunk root
> BTRFS error (device dm-0): open_ctree failed
>=20
> Therefore I tried a btrfs check --repair, this time without error:
> https://gist.github.com/anonymous/5cf7ad9e187032d2c94db4f91bb62c24
>=20
> Then I tried btrfs check --init-extent-tree and this produces much
> output. I put the beginning into here:
> https://gist.github.com/anonymous/70e2482646a8235ee2327105d920dadd

That's common for --init-extent-tree, but I don't think extent tree is
related in this case.

Thanks,
Qu
> From a fast view, the messages keep to be similar to the last of the
> gist, but the messages in the beginning are not repeating. If it helps
> I have complete compressed log.
>=20
> Then I tried a btrfs recover to get files, but for many files (also
> improtant data, but I filtered the output) I get outputs like in:
> https://gist.github.com/anonymous/1cc7f7ab5af33e76d0bf80960bb300eb>
> Any new suggestions?
>=20


--pclX2j8h5aD5BJPg8lGgXGobJuf3Ubva0--

--PcqjnUbdHSN1fXg1TtR79NDdxvtw4OsiC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlotxBMXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhQuQf/dDL2K1Y5WHuttCw8OkaGItwb
Pu9UQRrIGmPNrfCCMyxynXIrCIvgD+36tZCW/RwckSsbh4dOOyc6qjOl5HU53/Iu
4yN77o6ygMESAbmEcKEhj5Ij3G2bC2jpMtmY6X1bLwRe9E9oEMmc2kjhxyLvz+Kf
SgXO0t8qKN0Jb7amTUHIpHBEOBwMLCBYRx0D8sKU1MEyMV0Gv6mLJ11n9s8sdMYT
cIBdVWPRWf1KGp24hAHZRA8+AOWP4cqJ5qFZ0wWg7o4XLH9mjBAf/9TaKdna+CZ1
gTk/WwPD4AJ5Pyvb+YN5832w6tn7FLjhuq7Ixcqip18NYi79s+lWsKVYTbbe5A==
=aL98
-----END PGP SIGNATURE-----

--PcqjnUbdHSN1fXg1TtR79NDdxvtw4OsiC--
