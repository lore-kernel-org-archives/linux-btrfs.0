Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:58428 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751252AbeAOBkW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 Jan 2018 20:40:22 -0500
Subject: Re: Partionless Btrfs drives now return PTTYPE="PMBR"
To: evan d <forumscollective@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAG__1a5by0WZ+-LiJTAY9Y3qrpJY-drDt9BuGgCZgqaUuG+mAQ@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <4cdc7d98-681d-15b8-c65b-21ac736e6034@gmx.com>
Date: Mon, 15 Jan 2018 09:40:17 +0800
MIME-Version: 1.0
In-Reply-To: <CAG__1a5by0WZ+-LiJTAY9Y3qrpJY-drDt9BuGgCZgqaUuG+mAQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WqGI6LBlyllxoeE48Y1c0mYrgj0w60ZWf"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WqGI6LBlyllxoeE48Y1c0mYrgj0w60ZWf
Content-Type: multipart/mixed; boundary="rvety0OYHjpfaOplhX7UMzNMFFhhPl87G";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: evan d <forumscollective@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <4cdc7d98-681d-15b8-c65b-21ac736e6034@gmx.com>
Subject: Re: Partionless Btrfs drives now return PTTYPE="PMBR"
References: <CAG__1a5by0WZ+-LiJTAY9Y3qrpJY-drDt9BuGgCZgqaUuG+mAQ@mail.gmail.com>
In-Reply-To: <CAG__1a5by0WZ+-LiJTAY9Y3qrpJY-drDt9BuGgCZgqaUuG+mAQ@mail.gmail.com>

--rvety0OYHjpfaOplhX7UMzNMFFhhPl87G
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8815=E6=97=A5 00:36, evan d wrote:
> I removed two partitionless Btrfs formatted drives from an Arch Linux
> based PC and installed them in another Linux based PC also running
> Arch.  The drives are independent of one another, each containing its
> own Btrfs filesystem.  Both machines are running recent kernels and
> the original host would be running whatever kernel was current in Arch
> on 1 Jan 2018.
>=20
> lsblk shows the two drives as partitionless as I'd expect, but
> attempting to mount them returns an error saying they're not
> recognised and btrfs filesystem show /dev/sdX also returns that the
> devices do not contain a Brtfs partition.  1 Jan 2018 was the last
> time I accessed these drives, which were mounted via the first
> machine's fstab.
>=20
> blkid returns PTTYPE=3D"PMBR" for both.
>=20
> For the current machine:
> uname -a returns:
> Linux ryzen 4.14.13-1-ARCH #1 SMP PREEMPT Wed Jan 10 11:14:50 UTC 2018
> x86_64 GNU/Linux

Nice to see another Ryzen system. :)

>=20
> btrfs --version returns:
> btrfs-progs v4.14
>=20
>=20
> Any ideas what could have gone wrong here?  I'm  hoping that
> reinserting them in the original machine may allow me to access the
> underlying data again, but that machine is in another country at
> present.

btrfs inspect dump-super -Ffa will help us to determine if it's still a
btrfs filesystem.

And it's also recommended to use grep to find the btrfs magic in the
beginning several MB range to ensure there is no offset screwing up fs
detection:

dd if=3D<device> of=3D/tmp/output bs=3D1M count=3D128
grep -obUaP "\x5F\x42\x48\x52\x66\x53\x5F\x4D" /tmp/output

Thanks,
Qu

>=20
> Any help much appreciated.
>=20
> Thanks
> Evan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--rvety0OYHjpfaOplhX7UMzNMFFhhPl87G--

--WqGI6LBlyllxoeE48Y1c0mYrgj0w60ZWf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpcBoEXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjgvwf/VOXk+YJXqI2R8NNAIPi8cb1l
8EnZA/xNoDHRNXQqN6zRqL4Fdcxmd3afrnYzn72xXMZ54/zYqT7tdfiof29Ndxmk
UbDns7ANq1aCfFN9At9SLMess2xhaFz+F5x02iqn8zQUngW0HzbX0eaWPWffLPZu
cNP5G6DSyEafnVc1co4Qj+PA0D1vDVUj51wjMKeiKEpXmabqRpMJ5B76HOTyo+FX
JBjrsFYbAVuESM1F0zgMUW9YG6bbdYoqNzrlk4AURZ/+bJ65hY1QVWW2GofIU0nl
YLI6ZqiYjyPMJaS6ROuTVJRYDpwNzd8oGrrmPB7QV6aP8UHXRWMJQdH19qT3dA==
=esIx
-----END PGP SIGNATURE-----

--WqGI6LBlyllxoeE48Y1c0mYrgj0w60ZWf--
