Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:42951 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751561AbeGAHj3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 1 Jul 2018 03:39:29 -0400
Subject: Re: A list of bugs in btrfs found by fuzzing
To: "Xu, Wen" <wen.xu@gatech.edu>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Cc: "jbacik@fb.com" <jbacik@fb.com>, "dsterba@suse.com" <dsterba@suse.com>,
        "clm@fb.com" <clm@fb.com>
References: <CANrHXgx5rPHOc9rYBEskwj6dt3r-KXUxhnph8b8gAwDTeCEixw@mail.gmail.com>
 <F54B32A6-F142-4BEF-9279-A85C593C9BE6@gatech.edu>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <d4c312b1-683f-36b7-526d-82df8e586b5b@gmx.com>
Date: Sun, 1 Jul 2018 15:39:07 +0800
MIME-Version: 1.0
In-Reply-To: <F54B32A6-F142-4BEF-9279-A85C593C9BE6@gatech.edu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="QC2GpWNSzop99SnwNTw07OJ5dtEuR4EIs"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QC2GpWNSzop99SnwNTw07OJ5dtEuR4EIs
Content-Type: multipart/mixed; boundary="FduPtDF2rycVcFPiSr6ILXe5sjDaNWFg0";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Xu, Wen" <wen.xu@gatech.edu>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Cc: "jbacik@fb.com" <jbacik@fb.com>, "dsterba@suse.com" <dsterba@suse.com>,
 "clm@fb.com" <clm@fb.com>
Message-ID: <d4c312b1-683f-36b7-526d-82df8e586b5b@gmx.com>
Subject: Re: A list of bugs in btrfs found by fuzzing
References: <CANrHXgx5rPHOc9rYBEskwj6dt3r-KXUxhnph8b8gAwDTeCEixw@mail.gmail.com>
 <F54B32A6-F142-4BEF-9279-A85C593C9BE6@gatech.edu>
In-Reply-To: <F54B32A6-F142-4BEF-9279-A85C593C9BE6@gatech.edu>

--FduPtDF2rycVcFPiSr6ILXe5sjDaNWFg0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8801=E6=97=A5 08:06, Xu, Wen wrote:
> Dear BTRFS developers,
>=20
> I would like to know if these issues are fixed or handled? Thanks.

Some bugs looks interesting and may be resolved by more checks in
tree-checker.

I'll take a look at them.

Thanks for the detailed and comprehensive report,
Qu

>=20
> -Wen
>=20
>> On Jun 3, 2018, at 6:22 PM, Wen Xu <xuwen.sjtu@gmail.com> wrote:
>>
>> Hi btrfs maintainers and developers,
>>
>> Here are a list of bugs found in upstream kernel recently. Please chec=
k:
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=3D199833
>> https://bugzilla.kernel.org/show_bug.cgi?id=3D199835
>> https://bugzilla.kernel.org/show_bug.cgi?id=3D199837
>> https://bugzilla.kernel.org/show_bug.cgi?id=3D199839
>> https://bugzilla.kernel.org/show_bug.cgi?id=3D199847
>> https://bugzilla.kernel.org/show_bug.cgi?id=3D199849
>>
>> Thanks,
>> Wen
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--FduPtDF2rycVcFPiSr6ILXe5sjDaNWFg0--

--QC2GpWNSzop99SnwNTw07OJ5dtEuR4EIs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAls4hRsACgkQwj2R86El
/qjJKwgAnUTvI11xNCMy1IboGPOohrAQ0WCiddmmWMLjNfCHHB0C5+GEi0HC3tGa
vSW0ulGlp8nWWSwmakOakvv49uHcLcHuUEFlAprc0p5y/ZLoj0bmoiWlHD8q7EBj
b1EsYnA6bipi6UP6gznnw4hW8ewDlLADMiLnkyDPbYyKCenfijdKSEcY7EurY5+v
h9asrAeaP5T/cED6T0EbUtGe87NusO+wN6w1DcRlGOyxGFqib9fXPkdT6gUKr7fS
7oVsXdKWqlWEBzPTT/dsA+TjV5RSGeCpboyhEu1pU7fk6oXNv1NJ2v+pMERlzuZR
IFfi8K9N1i+6cZzxHRlV1k1emosbYw==
=KSoz
-----END PGP SIGNATURE-----

--QC2GpWNSzop99SnwNTw07OJ5dtEuR4EIs--
