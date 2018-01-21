Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:62999 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751009AbeAUKEj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 Jan 2018 05:04:39 -0500
Subject: Re: Periodic frame losses when recording to btrfs volume with OBS
To: Sebastian Ochmann <ochmann@cs.uni-bonn.de>, linux-btrfs@vger.kernel.org
References: <f52e20c8-db0d-ffbb-91e3-268c548a544a@cs.uni-bonn.de>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <35acc308-d68d-3a4b-a626-38b9a7820fd4@gmx.com>
Date: Sun, 21 Jan 2018 18:04:30 +0800
MIME-Version: 1.0
In-Reply-To: <f52e20c8-db0d-ffbb-91e3-268c548a544a@cs.uni-bonn.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="N3ZByYPmRnPVWQUzaXk0AYUz9DNXih2Cb"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--N3ZByYPmRnPVWQUzaXk0AYUz9DNXih2Cb
Content-Type: multipart/mixed; boundary="veOdQM9AZ8lGC1I4fqoetDkw9at8z1R5m";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Sebastian Ochmann <ochmann@cs.uni-bonn.de>, linux-btrfs@vger.kernel.org
Message-ID: <35acc308-d68d-3a4b-a626-38b9a7820fd4@gmx.com>
Subject: Re: Periodic frame losses when recording to btrfs volume with OBS
References: <f52e20c8-db0d-ffbb-91e3-268c548a544a@cs.uni-bonn.de>
In-Reply-To: <f52e20c8-db0d-ffbb-91e3-268c548a544a@cs.uni-bonn.de>

--veOdQM9AZ8lGC1I4fqoetDkw9at8z1R5m
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8820=E6=97=A5 18:47, Sebastian Ochmann wrote:
> Hello,
>=20
> I would like to describe a real-world use case where btrfs does not
> perform well for me. I'm recording 60 fps, larger-than-1080p video usin=
g
> OBS Studio [1] where it is important that the video stream is encoded
> and written out to disk in real-time for a prolonged period of time (2-=
5
> hours). The result is a H264 video encoded on the GPU with a data rate
> ranging from approximately 10-50 MB/s.

>=20
> The hardware used is powerful enough to handle this task. When I use a
> XFS volume for recording, no matter whether it's a SSD or HDD, the
> recording is smooth and no frame drops are reported (OBS has a nice
> Stats window where it shows the number of frames dropped due to encodin=
g
> lag which seemingly also includes writing the data out to disk).
>=20
> However, when using a btrfs volume I quickly observe severe, periodic
> frame drops. It's not single frames but larger chunks of frames that a
> dropped at a time. I tried mounting the volume with nobarrier but to no=

> avail.

What's the drop internal? Something near 30s?
If so, try mount option commit=3D300 to see if it helps.

>=20
> Of course, the simple fix is to use a FS that works for me(TM). However=

> I thought since this is a common real-world use case I'd describe the
> symptoms here in case anyone is interested in analyzing this behavior.
> It's not immediately obvious that the FS makes such a difference. Also,=

> if anyone has an idea what I could try to mitigate this issue (mount or=

> mkfs options?) I can try that.

Mkfs.options can help, but only marginally AFAIK.

You could try mkfs with -n 4K (minimal supported nodesize), to reduce
the tree lock critical region by a little, at the cost of more metadata
fragmentation.

And is there any special features enabled like quota?
Or scheduled balance running at background?
Which is known to dramatically impact performance of transaction
commitment, so it's recommended to disable quota/scheduled balance first.=



Another recommendation is to use nodatacow mount option to reduce the
CoW metadata overhead, but I doubt about the effectiveness.

Thanks,
Qu

>=20
> I saw this behavior on two different machines with kernels 4.14.13 and
> 4.14.5, both Arch Linux. btrfs-progs 4.14, OBS 20.1.3-241-gf5c3af1b
> built from git.
>=20
> Best regards
> Sebastian
>=20
> [1] https://github.com/jp9000/obs-studio
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--veOdQM9AZ8lGC1I4fqoetDkw9at8z1R5m--

--N3ZByYPmRnPVWQUzaXk0AYUz9DNXih2Cb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpkZa4XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qg7XQf/X2dH7dYw/rHkx3Ug71Z8AYEc
///21q+14qRwQ+fwg9cf8/DjdpFZ7OAXlnHLGouvaWHt8UufNW5xQaaH8BlGOYZ8
hZk3RDqgkDUpI8oB3qSHAwU015ajSg1SJ/fEUzLqha4uZoJVtVuflP9q6hI2Adnn
GePb+eNI8NDTLUAJP/lh9vpxzInRFzwyHIjmHe70FJ1yNdcfUJDK3N+aHlTFlSB3
HIZr2JRl1OCvdg1mNl6WWO782ASS3Uqk/tZgmpvD3cgDyyEkf7Ilv1Hmc+Bmogee
tXUfysEu/YsCeOZwpSMVsZaalEO1FH4KfTbxhKxA8dnaqkOGOrvUUIJokxjJ8Q==
=a+nE
-----END PGP SIGNATURE-----

--N3ZByYPmRnPVWQUzaXk0AYUz9DNXih2Cb--
