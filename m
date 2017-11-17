Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:53477 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756746AbdKQFi3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Nov 2017 00:38:29 -0500
Subject: Re: Btrfs restore error
To: Jay <j4y0t15@gmail.com>, linux-btrfs@vger.kernel.org
References: <2382a8cf-2137-9622-6074-a082bcbe2b94@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <ad8010db-9e11-e205-d77a-d15a11b4da56@gmx.com>
Date: Fri, 17 Nov 2017 13:38:08 +0800
MIME-Version: 1.0
In-Reply-To: <2382a8cf-2137-9622-6074-a082bcbe2b94@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FWG9T4VOC30Q5QufkA73DOP0uBWiGKnNw"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FWG9T4VOC30Q5QufkA73DOP0uBWiGKnNw
Content-Type: multipart/mixed; boundary="VAl4MlcVES879lpldlFxnVSNSbkWuFuJ0";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Jay <j4y0t15@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <ad8010db-9e11-e205-d77a-d15a11b4da56@gmx.com>
Subject: Re: Btrfs restore error
References: <2382a8cf-2137-9622-6074-a082bcbe2b94@gmail.com>
In-Reply-To: <2382a8cf-2137-9622-6074-a082bcbe2b94@gmail.com>

--VAl4MlcVES879lpldlFxnVSNSbkWuFuJ0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8817=E6=97=A5 11:56, Jay wrote:
> Hello,
>=20
> I thought I should report something since there was little information
> on this error. The situation is I have 2 external hard drives on
> Xubuntu. One is not working and I need to move the data over to the
> other.

"btrfs replace" should be your first option, not "btrfs restore", unless
it's totally damaged and you want to salvage as much as possible.


> I used 'sudo btrfs restore -v /dev/sde1 /mnt/Old4TB' and
> received 'Error mkdiring /mnt/Old4TB/Jayda TV:2'.

No extra info like something restored succefully? Just 'Error mkdiring
/mnt/Old4TB/Jayda TV:2'?

At least it's ENOENT, checking mkdir(3p) should gives your the reason:
---
       ENOENT A  component  of the path prefix specified by path does
not name
              an existing directory or path is an empty string.

---

Did the dir "/mnt/Old4TB" exists in first place?

Thanks,
Qu

> I found one forum
> post that said I needed to make the destination folder manually, then
> restore. That did not work. looking at your code 2(%d) is a kernel
> message? not sure what to make of it. I decided to enter a root
> environment with 'sudo su' and the restore worked(the folder still
> existed from previous troubleshoot step). The console is showing files
> being restored. I tried a dry run first which did not show an error.
> Just some feedback and reference.
>=20
> uname -a
>=20
> Linux emb 4.10.0-38-generic #42-16.04.1-Ubuntu SMP Tue Oct 10 16:21:20
> UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
>=20
> btrfs --version
>=20
> btrfs-progs v4.4
>=20
> Thank you,
>=20
> Jayotis
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--VAl4MlcVES879lpldlFxnVSNSbkWuFuJ0--

--FWG9T4VOC30Q5QufkA73DOP0uBWiGKnNw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloOdcAXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qg1zQf/abcCV3TGiVldX5egixoePIaT
qRoLkC3CtB+7MgCTSXUgn1G8ZW/Z9gA8f9z1yjBu0EJAWuRlyZfCIy3aDFD/mI/W
DCnFw+xG6vW/zFndc1YDPosbVc3YsxWhwdAZjf22oLgoXQecrYXa/Z59xdUjWiJL
RSDaMVsZWthFfhF0DXcdgtReqljZpUlcIXf4cmzj4QH6pcfRPTs30+Lh92H/sMmu
FCJboKxiQcvcdmgIZX0qp04niuvDcXSL8AyjEhbVazJyAMely9D05Ab1etuXy9AV
Z9L9Zue6XDZbd5vUwqZX7he9DxHuyGd5Ql7Ba8Yf7MJZr8TWwJZYrVoNu/5yCQ==
=GovS
-----END PGP SIGNATURE-----

--FWG9T4VOC30Q5QufkA73DOP0uBWiGKnNw--
