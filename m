Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:56979 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751378AbdKXBSY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Nov 2017 20:18:24 -0500
Subject: Re: misc/021-image-multi-devices fails on latest
 btrfs-devel/misc-next
To: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>,
        btrfs <linux-btrfs@vger.kernel.org>
References: <CAKuJGC9bi3V5acV6CJEH8GYrdOZ4dA52D-4a7WEGPiVQHTsuxw@mail.gmail.com>
 <CAKuJGC9PnKn0FdZZG9F_LTOc2tcS=a-mGTo8qmg5ubtHfBq8pg@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <54224bfa-153a-ad2d-0e84-41c43e752be2@gmx.com>
Date: Fri, 24 Nov 2017 09:18:19 +0800
MIME-Version: 1.0
In-Reply-To: <CAKuJGC9PnKn0FdZZG9F_LTOc2tcS=a-mGTo8qmg5ubtHfBq8pg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vKoVG6DcR7bfgxW8MVP77lbIHk1HPjEi8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vKoVG6DcR7bfgxW8MVP77lbIHk1HPjEi8
Content-Type: multipart/mixed; boundary="JJGbAX2qOGh6h4EMOMCVk9laEEohdpfgp";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>,
 btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <54224bfa-153a-ad2d-0e84-41c43e752be2@gmx.com>
Subject: Re: misc/021-image-multi-devices fails on latest
 btrfs-devel/misc-next
References: <CAKuJGC9bi3V5acV6CJEH8GYrdOZ4dA52D-4a7WEGPiVQHTsuxw@mail.gmail.com>
 <CAKuJGC9PnKn0FdZZG9F_LTOc2tcS=a-mGTo8qmg5ubtHfBq8pg@mail.gmail.com>
In-Reply-To: <CAKuJGC9PnKn0FdZZG9F_LTOc2tcS=a-mGTo8qmg5ubtHfBq8pg@mail.gmail.com>

--JJGbAX2qOGh6h4EMOMCVk9laEEohdpfgp
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8823=E6=97=A5 11:16, Lakshmipathi.G wrote:
> Quick update: It continues to fail:
> https://asciinema.org/a/8HAL3uZ4MG7eb5gXnlgq3jm7q

Still fails to reproduce it.

All success across my host and VMs.

And according to your misc-test-result, it seems that your testing
system doesn't cleanup loop devices for 021 well.

I think that's the reason why you always get stuck at misc/021.

Thanks,
Qu

> ----
> Cheers,
> Lakshmipathi.G
> http://www.giis.co.in http://www.webminal.org
>=20
>=20
> On Sat, Nov 18, 2017 at 12:59 PM, Lakshmipathi.G
> <lakshmipathi.g@gmail.com> wrote:
>> Hi.
>>
>> Few days back(Nov14th) this(misc/021-image-multi-devices) test script
>> used to pass and seems like its failing
>> now. may be due to recent commits? Logs,screen-casts available here:
>> https://lakshmipathi.github.io/btrfsqa/
>>
>> ----
>> Cheers,
>> Lakshmipathi.G
>> http://www.giis.co.in http://www.webminal.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--JJGbAX2qOGh6h4EMOMCVk9laEEohdpfgp--

--vKoVG6DcR7bfgxW8MVP77lbIHk1HPjEi8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloXc1sXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qisDwgAo3uTXp45YDanJn8d1J1zL+sX
EfII2jpLaUcIanGr8qGtc1vIM8l/HmHAYNJy3KMQE+lACiBFc/QncULfGuYLe61s
D9Pljj1WJuMn/mPyq+FWS0AfLbb0f7/vhUufqWmyVhKsa9u+XSwcLABwAYxOnrTN
8RX1bhCKEydA5KRh+wOPbEGWxCVWmcSNA4MUuBYBRDLGUfmxR0fBA8yGTsnmRBcG
jztR08ytemmqqGakjks/5KJZGB4R8/WgY+9sYcbFtQS+GrG8+Zh/8sfubyvTopVN
b83Iz25qeOIk6ckHgGXcKTbxhYcDC6GSVYKrUhiU4+Gir/tDjTNYD620D7V8fQ==
=pBtk
-----END PGP SIGNATURE-----

--vKoVG6DcR7bfgxW8MVP77lbIHk1HPjEi8--
