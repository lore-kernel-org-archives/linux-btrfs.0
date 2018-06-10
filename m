Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:48085 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753656AbeFJFMp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Jun 2018 01:12:45 -0400
Subject: Re: corrupt leaf; unaligned key offset for csum item
To: Chris Murphy <lists@colorremedies.com>
Cc: Simon Kaiser <simon.kaiser@kit.edu>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <87lgboxi83.fsf@int-nb-181.i-did-not-set--mail-host-address--so-tickle-me>
 <31a293a5-6cad-cd42-b70b-bb23c02233bf@gmx.com>
 <CAJCQCtQzd=pKySzt1aJoABHw3kEYxUnJMqCAZhBnmxSNV43=EQ@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <aa02c8c9-7ce7-eb8d-18e8-d810532083d8@gmx.com>
Date: Sun, 10 Jun 2018 13:12:30 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQzd=pKySzt1aJoABHw3kEYxUnJMqCAZhBnmxSNV43=EQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="PgZS9JVVVgW5wa95cHZUwCEp9KMGsrdiO"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PgZS9JVVVgW5wa95cHZUwCEp9KMGsrdiO
Content-Type: multipart/mixed; boundary="xdXWM91OU9EH4OfEHmN1DcG5vWHmwhrFS";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Simon Kaiser <simon.kaiser@kit.edu>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <aa02c8c9-7ce7-eb8d-18e8-d810532083d8@gmx.com>
Subject: Re: corrupt leaf; unaligned key offset for csum item
References: <87lgboxi83.fsf@int-nb-181.i-did-not-set--mail-host-address--so-tickle-me>
 <31a293a5-6cad-cd42-b70b-bb23c02233bf@gmx.com>
 <CAJCQCtQzd=pKySzt1aJoABHw3kEYxUnJMqCAZhBnmxSNV43=EQ@mail.gmail.com>
In-Reply-To: <CAJCQCtQzd=pKySzt1aJoABHw3kEYxUnJMqCAZhBnmxSNV43=EQ@mail.gmail.com>

--xdXWM91OU9EH4OfEHmN1DcG5vWHmwhrFS
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8810=E6=97=A5 11:53, Chris Murphy wrote:
> On Sat, Jun 9, 2018 at 7:56 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrot=
e:
>>
>> Indeed, the corrupted bytenr is 0x4bc98004.
>> Looks pretty like a bit flip in the 3rd lowest bit.
>>
>> It can be fixed by manually patching the corrupted leaf to get rid of
>> the bitflip.
>> I could provide a special branch of btrfs-progs to fix it easily.
>>
>> But before that, it's better to do a scrub to see if there is other
>> similar problems, so I could fix them all.
>>
>=20
> Do you think Simon should try -o ro and -o ro,norecovery and see if he
> can update backups the easy way first?

If the bit flip is the only problem, I could fix it manually and nothing
is lost, the fs can be used as usual.

> And then use the offline scrub
> to check for additional problems?

I mean online scrub.

I didn't notice extra error, and I don't believe even for a faulty
memory, bit flip is that easy to happen, so on-line scrub should do the
work.

>=20
> Simon, the offline scrub is done unmounted with 'btrfs check
> --check-data-csum <dev>' and it is a read-only check.
>=20
>=20


--xdXWM91OU9EH4OfEHmN1DcG5vWHmwhrFS--

--PgZS9JVVVgW5wa95cHZUwCEp9KMGsrdiO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlscsz4ACgkQwj2R86El
/qg7Gwf+OZ8WLe0rrkFLrmyVFmk7uAeiyb2Rqgl0Jexf3H9Cdo02QVsAQmtsD/tJ
xdMlVsSmHXCH/5s9tr9Gikqhr/EHL4ihUH8GFkS2UFhNea73PSdwAcrLC3hXTuyt
llHTAskWiRVYovI+3xYQDpferVXXaRM7rShJZTKC1us+nw1QHT/RwYwZZn2zLiUW
nh88fkKh1/UiLHgew2X5NTCrtqyl2BDgrio60gdJ5DwiBIfUZfloSl5f9ibU0u2D
sy6nDTNGvajbXgvZ6o+Nnddz1COmOk1KRNKed+vLkmRYukqW1g9llPtbY3JZe9R1
8mbAiF85pipo9LvT4U4uf/tySKLBWg==
=W8O0
-----END PGP SIGNATURE-----

--PgZS9JVVVgW5wa95cHZUwCEp9KMGsrdiO--
