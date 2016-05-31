Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57517 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756224AbcEaUmA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 May 2016 16:42:00 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 2995DAAEF
	for <linux-btrfs@vger.kernel.org>; Tue, 31 May 2016 20:41:59 +0000 (UTC)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: David Sterba <DSterba@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Subject: [RFC] strace patches for new ioctls
Message-ID: <4a3270c7-8023-6d2c-3ab0-ffc699feb94f@suse.com>
Date: Tue, 31 May 2016 16:41:55 -0400
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="51siGPJ4B3x5P37I0nvxKSbHtDWt1eWoa"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--51siGPJ4B3x5P37I0nvxKSbHtDWt1eWoa
Content-Type: multipart/mixed; boundary="M0M20axqrDtDFR9Fv6TA0G7A0JKJFhS5f"
From: Jeff Mahoney <jeffm@suse.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: David Sterba <DSterba@suse.com>
Message-ID: <4a3270c7-8023-6d2c-3ab0-ffc699feb94f@suse.com>
Subject: [RFC] strace patches for new ioctls

--M0M20axqrDtDFR9Fv6TA0G7A0JKJFhS5f
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi all -

Strace 4.12 was tagged for release today and it supports decoding of
btrfs ioctls.  I'd like to propose a requirement that future ioctl
additions come with a patch to strace as well so we don't get out of sync=
=2E

I wrote the decoding to help with some issues some of our developers
were seeing while writing various tools.  Rather than describing their
workload or showing us the code, an strace in verbose mode shows us
pretty much exactly what they're doing.

Opinions?

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--M0M20axqrDtDFR9Fv6TA0G7A0JKJFhS5f--

--51siGPJ4B3x5P37I0nvxKSbHtDWt1eWoa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJXTfcUAAoJEB57S2MheeWyHGsQALfzCfKldzcrNm5irYD7OPh3
k/JyCPR/kiVfTI9xDAgmOpZ7YKVlxP1JJNfhm5Juk5DDLsjNYGBpm671Qm1Li9Ft
Dn1N605RMGhWmCQT4qST8rYlK1L4rSChOIFH7+Omtq3BI9wZOILmoW6dypGLIzEm
tDgNR8Pcmo1z6KPAA3BBZnnSTGgyBLA0cr0Jbk6IKUEzRSVblh4KtOwg1UivjVJD
C/49ud04ibw4MLKClXOpH082PKlOGsljV3sOyagjyjvuyWJviusqZ5KSOgq0DDjs
hpetkN4yeLI3lZqLdCoHzrbJMILrTM5Mts/GgycR2+fgURf/EaoxSqmv5iaR3l8q
sqSuBQWFQouer0Wi0BDnGuQ3brWE1HGB3WXXdQT5QhEAC6Up79XXJdpmHvY1td1r
JyYPYUVbYMETikvCfPw+PigrtDVxu6Fa04naDGCONYxwzaWscyJIFQfNxmqZfxvU
FR83Z1WEc24/P2d1PuDVqGWi+YKbRc+sAxUALFxxWnOiumxJcO0w2OH48L0kifW7
R9ctIaQ1t6QM1cBKrh/unb6MK0wxoYkCKyR8KCiKfkv4BrzqttBT7YqI/n/XAVI+
Gnyhe4aX8TiinCIXdVy3ZFxzOQSQSxgzEofT3LcEseOD6LDZBqFUrDMXZOa8aOLy
xZTTDiR3DCguNoLen4pz
=lzey
-----END PGP SIGNATURE-----

--51siGPJ4B3x5P37I0nvxKSbHtDWt1eWoa--
