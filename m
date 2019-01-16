Return-Path: <SRS0=HC3m=PY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B051AC43444
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 14:42:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E75520657
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 14:42:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404639AbfAPOmL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 16 Jan 2019 09:42:11 -0500
Received: from frost.carfax.org.uk ([85.119.82.111]:39083 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393688AbfAPOmK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Jan 2019 09:42:10 -0500
Received: from hrm by frost.carfax.org.uk with local (Exim 4.80)
        (envelope-from <hrm@carfax.org.uk>)
        id 1gjmOO-0000lD-7a; Wed, 16 Jan 2019 14:42:08 +0000
Date:   Wed, 16 Jan 2019 14:42:08 +0000
From:   Hugo Mills <hugo@carfax.org.uk>
To:     Stefan K <shadow_7@gmx.net>
Cc:     Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: question about creating a raid10
Message-ID: <20190116144208.GI5134@carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo@carfax.org.uk>,
        Stefan K <shadow_7@gmx.net>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
References: <3318002.5e9V1lv8s4@t460-skr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="YrQNB5Deg1WGKZi3"
Content-Disposition: inline
In-Reply-To: <3318002.5e9V1lv8s4@t460-skr>
X-GPG-Fingerprint: DD84 D558 9D81 DDEE 930D  2054 585E 1475 E2AB 1DE4
X-GPG-Key: E2AB1DE4
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--YrQNB5Deg1WGKZi3
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 16, 2019 at 03:36:25PM +0100, Stefan K wrote:
> Hello,
>=20
> if I create a raid10 it looks like that:
> mkfs.btrfs -m raid10 -d raid10 /dev/sdb /dev/sdc /dev/sdd /dev/sde
>=20
> but if I've different jbods and I want that every mirror of a raid10 is o=
n a different jbod how can I archive that? in zfs it looks like that:
[snip]
> how can I be sure that is btrfs the same?

   I'm afraid you can't. It would take modifications of the chunk
allocator to achieve this (and you'd also need to store the metadata
somewhere as to which devices were in which failure domain).

   Hugo.

--=20
Hugo Mills             | "It was half way to Rivendell when the drugs began
hugo@... carfax.org.uk | to take hold"
http://carfax.org.uk/  |                                      Hunter S Tolk=
ien
PGP: E2AB1DE4          |                        Fear and Loathing in Barad =
D=FBr

--YrQNB5Deg1WGKZi3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJcP0K/AAoJEFheFHXiqx3kNcgP/ibIeXlnSQyuZx1B6KiIQfUh
JOQsKVWRvBowP5zA1L/pqqBqztWVKApXJk9T57TupN0TEH6sHOk0TtVE+SQDdl48
zGaRZtfORUf4S1c9D2ccrlOD6lJjvrRBZoXFDcEZ1x5ljcaMU4WOE/F0xwz86KXU
+QripjFaeyqLIxBH7bcAKf2+/5bMwOKTi0wxrQQJztr9f/nIQ3CSn3/M9nlohuXT
F1YAz9tC3KxSVYhft3hYHNgIJm4vrKe9CvqfoPoUlFI1kPhLqAZ2sauqXRjE5Tbp
fhpAj+groYQPtH/9zwAM4nElaXoMiVVYDa4gMtzlMOEau063CZCznNfydvdeSnS0
dL3toBsOA8Q95QM8aNogGdCnhRbitOVmf3ML+1xAxVBUKxzK+6yURy8m2il7QpOA
UrQO0YXwdXy7+qlLcT2JE2j5uNZvY4ThVGok7njIx+xZzCVBhJ6rmnZRYrGfJOlK
5T0GASabfXkY0cGrdNdyWKrxTJAl2N9+rfXibimkk7L/T0dmZBFLMKmJJ6X0DqkH
EfPLEFvw1rVmtENGj8eVsOBWlWcvjVMbXPdAH/WSzW2+xSvM6o+HNQm4cmKKGEyg
80CiZPqr6qn9UeMYyrLcAJjiVCl3elpH6pAAmwdP/o+zQ/Oa1MMc8EMzElvNBSaX
RwBGA8JZVWmbqqG38F8w
=2yB5
-----END PGP SIGNATURE-----

--YrQNB5Deg1WGKZi3--
