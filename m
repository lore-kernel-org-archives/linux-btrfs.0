Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:36773 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754605AbeFNHRy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Jun 2018 03:17:54 -0400
To: David Sterba <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: About more loose parameter sequence requirement
Message-ID: <dbd36f90-fb00-0da1-b38f-567575c5b02f@gmx.com>
Date: Thu, 14 Jun 2018 15:17:45 +0800
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="sqyueXnq22ENdR1OTQILoHnlGDsoF8l35"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--sqyueXnq22ENdR1OTQILoHnlGDsoF8l35
Content-Type: multipart/mixed; boundary="ZXKw1k063lRUe54fR87KrZmmEBwkBvWiG";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: David Sterba <dsterba@suse.cz>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <dbd36f90-fb00-0da1-b38f-567575c5b02f@gmx.com>
Subject: About more loose parameter sequence requirement

--ZXKw1k063lRUe54fR87KrZmmEBwkBvWiG
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi David,

I understand that btrfs-progs introduced restrict parameter/option order
to distinguish global and sub-command parameter/option.

However it's really annoying if one just want to append some new options
to previous command:

E.g.
# btrfs check /dev/data/btrfs
# !! --check-data-csum

The last command will fail as current btrfs-progs doesn't allow any
option after parameter.


Despite the requirement to distinguish global and subcommand
option/parameter, is there any other requirement for such restrict
option-first-parameter-last policy?

If I could implement a enhanced getopt to allow more loose order inside
subcomand while still can distinguish global option, will it be accepted
(if it's quality is acceptable) ?

Thanks,
Qu


--ZXKw1k063lRUe54fR87KrZmmEBwkBvWiG--

--sqyueXnq22ENdR1OTQILoHnlGDsoF8l35
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsiFpkACgkQwj2R86El
/qhOnAf+KZR1hmoRnBXbCUQ84pfsiSkFKdOer9sYi05ajn6R+IgOx5jfMhfvMWds
z6+B9zRKN+QHeu2VBl40svhCIbiB70qnO4bWn4HfaOzzAqPOGS4QwxVrOe3QErtf
2WuSWTYkBTkVPYuvoPQ99AMFT6/BbGnd9F8Az13rCZ9Ki61SiZLZcuAIbngf2T0l
kRC1fWSudS1Ww/OSxGz/gqVkk0KmgF4qAQ5f2BcE6w9hlsEkUNp9jcVBQIhezq8i
qSXomidu3CcachXzLHIMpEQo1IG33ZJFIM8Jcd3TNY0htzlAqDEooLDPVHTkQNjq
zf2VJQWOoGtjFiZFWzvTetd705IXEg==
=o6e+
-----END PGP SIGNATURE-----

--sqyueXnq22ENdR1OTQILoHnlGDsoF8l35--
