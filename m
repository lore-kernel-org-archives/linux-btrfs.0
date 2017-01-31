Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from vsrv.kern.pm ([138.201.172.171]:44990 "EHLO vsrv.kern.pm"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751232AbdAaU3A (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Jan 2017 15:29:00 -0500
Received: from authenticated-user
        by vsrv.kern.pm with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <pkern@debian.org>)
        id 1cYf2v-0002xB-KD
        for linux-btrfs@vger.kernel.org; Tue, 31 Jan 2017 21:28:57 +0100
Subject: Re: Battling an issue with btrfs quota
To: linux-btrfs@vger.kernel.org
References: <168f5009-d525-d5ce-3a04-631339c49ec8@debian.org>
 <0518f878-5827-611f-d4ed-0e56cb938141@debian.org>
From: Philipp Kern <pkern@debian.org>
Message-ID: <31607ab7-4cca-deca-8114-e08c93ddbb92@debian.org>
Date: Tue, 31 Jan 2017 21:28:56 +0100
MIME-Version: 1.0
In-Reply-To: <0518f878-5827-611f-d4ed-0e56cb938141@debian.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6Pdu7gMSJ9U1qwQFaIaPkmnCA3bRAujT5"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6Pdu7gMSJ9U1qwQFaIaPkmnCA3bRAujT5
Content-Type: multipart/mixed; boundary="699dunNpTImt1xmEp0KbUJwNBxMXn2VGT";
 protected-headers="v1"
From: Philipp Kern <pkern@debian.org>
To: linux-btrfs@vger.kernel.org
Message-ID: <31607ab7-4cca-deca-8114-e08c93ddbb92@debian.org>
Subject: Re: Battling an issue with btrfs quota
References: <168f5009-d525-d5ce-3a04-631339c49ec8@debian.org>
 <0518f878-5827-611f-d4ed-0e56cb938141@debian.org>
In-Reply-To: <0518f878-5827-611f-d4ed-0e56cb938141@debian.org>

--699dunNpTImt1xmEp0KbUJwNBxMXn2VGT
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 01/31/2017 08:32 AM, Philipp Kern wrote:
> On 01/31/2017 01:15 AM, Philipp Kern wrote:
> [...]
>>>   149 0            0 RW   [btrfs-transacti]
>>
>> So there's always a running btrfs-transaction. The kernel messages sta=
rt
>> off like this:
> [...]
>=20
> At it turns out, it also OOMs the complete machine after 2h while
> consuming the available 4 GB RAM (w/o swap):

5.7 CPU hours and 13 GiB RAM later, btrfs-transaction completed on a
different machine and I was able to turn off quotas. ATA over Ethernet
to the rescue.

Kind regards
Philipp Kern


--699dunNpTImt1xmEp0KbUJwNBxMXn2VGT--

--6Pdu7gMSJ9U1qwQFaIaPkmnCA3bRAujT5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFFBAEBCAAvFiEEPzuChCNsw7gPxr3/RG4lRTXQVuwFAliQ84kRHHBrZXJuQGRl
Ymlhbi5vcmcACgkQRG4lRTXQVux87ggAxzOJ3RsOjyBAqPzDSAdoF0ZXf78SatnN
tr5V8IrV4u/6dMQjsoFhEGcjdVwV974QW8cUZ4HVDsrQUiyi61KjKe7FGHqAwpE5
fJ3Cw1Al3t6DUPTP/jadLzLA8XFHbUXUi3d2dPecp0A5KPUQid/SzNE/ekz+jqcK
9+OZr/7tM60qkKag8JMPggV5j5327ccq6Z25KcFIs1kYqL/l4lZzvpp8nRRXe63k
nWgRHkeLboK/h1cwN6STjpm7s6DaFDPt7BE8om953ZhID1VWcA/jDz58wxhUHVqp
oLWJjK55szMF+aVEFxYISWxlHo4+BecwAYv7bPsU3MP4dVkLl9MvrQ==
=bA60
-----END PGP SIGNATURE-----

--6Pdu7gMSJ9U1qwQFaIaPkmnCA3bRAujT5--
