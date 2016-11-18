Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:41211 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751449AbcKRAw4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Nov 2016 19:52:56 -0500
Date: Fri, 18 Nov 2016 00:52:53 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Marcus Sundman <sundman@iki.fi>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: root backup-reformat-restore
Message-ID: <20161118005253.GY16645@carfax.org.uk>
References: <7ef59dd2-fbfb-055a-3f5b-b11cc03f4cce@iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ulNsWUvGrZAj8PMr"
In-Reply-To: <7ef59dd2-fbfb-055a-3f5b-b11cc03f4cce@iki.fi>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--ulNsWUvGrZAj8PMr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 18, 2016 at 02:38:25AM +0200, Marcus Sundman wrote:
> The FAQ says that "the best solution for small devices (under about
> 16 GB) is to reformat the FS with the --mixed option to mkfs.btrfs".
> 
> OK. Does anyone have any good suggestions for doing that with an
> existing / partition (which has special files and whatnot)?
> 
> I assume a backup-restore cycle is needed, but with which program(s)?

 - If you don't have (or don't care about) any snapshots, then
    - if you can mount both the old and the new FS at the same time
       - mv
    - else, if you want to replace the old FS with the new
       - tar to a file elsewhere, and untar later
 - else, if you care about the snapshots
    - if you don't care about continuing btrfs send/receive backups to
      somewhere else
      - btrfs send/receive with -c (*)
    - if you want to continue using btrfs send -p incremental backups after
      the migration
       - cry, because you can't

(*) For subvols S1, S2, S3, ...: btrfs send S1; btrfs send -c S1 S2;
    btrfs send -c S1 -c S2 S3; btrfs send -c S1 -c S2 -c S3 S4; etc...

   Hugo.

-- 
Hugo Mills             | Great films about cricket: The Umpire Strikes Back
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--ulNsWUvGrZAj8PMr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJYLlDkAAoJEFheFHXiqx3kVRMP/j4vcDdi3YMdpr5mZbXKMhOw
VuMqpclSS9suRzl2fEYR3egxih2I5GjcQC/35fhvDV5TW9m6ACDd8AFz6dpClw0o
9VVpPlqUTJOk4t/Y9RdNtYawwC9sc/UcnCkwd5m7jpCanshQdnYehar+lt4LS7oX
bOFXijo5w7oY1N1tcx0g749Qe+upGdIfwAyh6Q/m7e6bJAtifR1NPWX/XjGI2tt+
7bEVo9ksdBt9S5FWH0+kmYptXFsKIU8fGKSx0ntcIpzyXaEzgwlTKCkFhLdtocCI
zOJQATGg43DwGvr1Qul7z1Y2z9Yebqy04GesChx5IBhyF55AD7rn3q6Dc+KT9BNn
oZOXOjx1vaXbDK/VO7Kawz3Ciq2KmCVSn5ph3//NBDgv9KUYyWbOkl1Oxe+UDq2n
8IAqhDyw9tqulltCwRRkbpZErMw1VzxFG6kgX3X3RpZdVrjqaafyrnReaaSbmAh+
xYT6cEeklDTNc9pwxiic3M1tn5fHJIDDrxZkRVNrjvcRxVfCnQRd5aaYw1w5uv+P
VMSBCddeP3WvLNNtPRgfcgA4AKB4UirGkIaqRkJ1NTrD0dujlscgcNeeENvydVPC
2Ax/MNHcXvD/hty9fu0KU6EG2rJXWi+W1MBQ9CahIJDbLbdoWBEJf2JnqsfaKnMU
QbVHNuBEv/uHxw+bnOSd
=9yjV
-----END PGP SIGNATURE-----

--ulNsWUvGrZAj8PMr--
