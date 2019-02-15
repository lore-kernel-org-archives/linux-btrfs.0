Return-Path: <SRS0=Dxhg=QW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EDDFC43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 15:55:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 330522190C
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 15:55:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389803AbfBOPzw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Feb 2019 10:55:52 -0500
Received: from frost.carfax.org.uk ([85.119.82.111]:60199 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729485AbfBOPzv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Feb 2019 10:55:51 -0500
Received: from hrm by frost.carfax.org.uk with local (Exim 4.80)
        (envelope-from <hrm@carfax.org.uk>)
        id 1gufq9-0000pJ-Qj; Fri, 15 Feb 2019 15:55:49 +0000
Date:   Fri, 15 Feb 2019 15:55:49 +0000
From:   Hugo Mills <hugo@carfax.org.uk>
To:     Brian B <brian@sd85.net>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: Better distribution of RAID1 data?
Message-ID: <20190215155549.GA317@carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo@carfax.org.uk>, Brian B <brian@sd85.net>,
        linux-btrfs@vger.kernel.org
References: <db678e75-6f56-a247-adb9-c7cca4d63528@sd85.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
In-Reply-To: <db678e75-6f56-a247-adb9-c7cca4d63528@sd85.net>
X-GPG-Fingerprint: DD84 D558 9D81 DDEE 930D  2054 585E 1475 E2AB 1DE4
X-GPG-Key: E2AB1DE4
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 15, 2019 at 10:40:56AM -0500, Brian B wrote:
> It looks like the btrfs code currently uses the total space available on
> a disk to determine where it should place the two copies of a file in
> RAID1 mode.=A0 Wouldn't it make more sense to use the _percentage_ of free
> space instead of the number of free bytes?

   I don't think it'll make much difference. I spent a long time a
couple of years ago trying to prove (mathematically) that the current
strategy always produces an optimal usage of the available space -- I
wasn't able to complete the theorem, but a lot of playing around with
it convinced me that at least if there are cases where it's
non-optimal, they're bizarre corner cases.

> For example, I have two disks in my array that are 8 TB, plus an
> assortment of 3,4, and 1 TB disks.=A0 With the current allocation code,
> btrfs will use my two 8 TB drives exclusively until I've written 4 TB of
> files, then it will start using the 4 TB disks, then eventually the 3,
> and finally the 1 TB disks.=A0 If the code used a percentage figure
> instead, it would spread the allocations much more evenly across the
> drives, ideally spreading load and reducing drive wear.
>=20
> Is there a reason this is done this way, or is it just something that
> hasn't had time for development?

   I'd guess it's the easiest algorithm to use, plus it seems to
provide optimal space usage (almost?) all of the time.=20

   Hugo.

--=20
Hugo Mills             | Be pure.
hugo@... carfax.org.uk | Be vigilant.
http://carfax.org.uk/  | Behave.
PGP: E2AB1DE4          |                                   Torquemada, Neme=
sis

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJcZuEFAAoJEFheFHXiqx3k5fUQAKJBovvFCXr7FFU+qU8pdfpG
n0o5SXIuPZ96A13/8ZSJFEDe6/8AR8Cd/DkDxFt8zEZoNvia4h/vVxLrr2qLLAA2
PnEnyUyleTRKQpr+LlIwSHexTmhG1REVPs/tCXg/veBZ4bmJV4wQudfD2smw5iuZ
k3/cAaMOvX4d3FRArzJSXvfZEArElE44ROYqiMRcFiRn+nIWft3F7njY6ihB6D5v
+RQaK+lubuJMazC85lnT6IdzdYSFACrwKeIU+z7n6xqmZsn8ktN1o+wn2ZUZnOj9
sW/OYNGsyObJEsk6N+ZN19Kxb2kzEsHFIcWeIR/+w4MqxAEUfaE59cm5N5Ll9P95
Mx5eCjSaOzb0uO+jT+6zhtE3+o/49GNVtEaHhFMFKh5sXggg42/dtCxSnEKed7JQ
vrL/pOveb/ULp23VnDrAZJCkRKNIMVYLopq9N4Vrm7h/+w1BEVJrPmWe+/g44eL7
MrL/SrmFpHkuSRnIE68MpIdcPmbmD5AuwBTU9JvCPKtwtD0HpVxkZ+O1UtFlrYsU
7eS3hYr8K+IOFBoS7kodUKMZVMZp4SyrOmtR7m/dFYJeIFPiLhkA8Vh75VK/Sc4/
7lb5FN0Dprnb+3gl118KoDNrwfJqfbHFTx3NJGYB2eBO3iQtRbmAFQrQpqm/CWir
hjan+dSr/m+tUZeBhZoF
=C4CW
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
