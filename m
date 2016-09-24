Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:34064 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752656AbcIXMhv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 24 Sep 2016 08:37:51 -0400
Date: Sat, 24 Sep 2016 12:37:49 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Alexander Tomokhov <alexoundos@ya.ru>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Does data checksumming remain for files with No_COW file
 attribute?
Message-ID: <20160924123749.GR7138@carfax.org.uk>
References: <767591474719974@web21o.yandex.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="aMDdG8xNveJz2ruI"
In-Reply-To: <767591474719974@web21o.yandex.ru>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--aMDdG8xNveJz2ruI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Sep 24, 2016 at 03:26:14PM +0300, Alexander Tomokhov wrote:
> There is an unanswered question at stackexchange:
> http://unix.stackexchange.com/q/303130/41572
> 
> Assume that we don't invoke mount options like nodatacow and nodatasum - operate only at file attributes level, which are controlled with lsattr/chattr. So does setting No_COW on a file (chattr +C) imply disabling data checksumming on it? The same way as mount options behave (nodatacow implies nodatasum)? Moreover may it disable checksumming only for newly written extents and keep for reading existing ones?

   Yes, it does imply disabling checksums.

   If you have extents in the file when +C is set, then the flag is
ignored (even for new extents, as far as I know): you can only
usefully set +C on a file with no extents.

   So, to use +C, you either need to touch the file first, then set +C
on it, then open the file and write to it, or you need to have +C set
on the parent directory.

   Hugo.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Hugo Mills             | Comic Sans goes into a bar, and the barman says, "We
hugo@... carfax.org.uk | don't serve your type here."
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--aMDdG8xNveJz2ruI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJX5nOcAAoJEFheFHXiqx3kDqsP/1G/+fS5UTpjMpXHMvcwejGZ
24MTeru2YNJSwZcnTVzznHV1mM3w97+R8lQ8CK4ENk5bSrYHQVjrxsnUiNKdJiJg
BSlmCeJ7TDnZSsj7QkbUuFQA6o4b88bXZ6zhMDBymH9lZBmOCM6mhcEjPprWrsNH
wIeEBANLomCTM9nI+W3DN8fXC4a1gOgz9l+FKXSRzxwzl9MJrEzAsDCEMu4omzjo
P+Z91Ot9WvqIW1Ie84bnsUYRbcMJGofuOPzgWklddsvYOISEckFFdCBWWFWY/qPT
PmBzQKXE56rivxV4wt6tVv8EV1fcvIutu5j6pGc2i7n9hloLZ17KvbfoVGAyEWOI
2+vu5UKDQZeMT8EZV5dQSaAIHkWM1SAwfDycwLhXSPnMqmN/qLiTQW0M7GQDxfjW
HHLlzIcvjJbuvsRA0qnLe3Hj1XfbpUQP5+b2wqpwkhiuZYQF2plc2xledJsebnON
pinQarfvTUhpefTiU05vKqh4d27dgx/Z63nHaaggfj6scOIbX1fIgn1GZ9CjEB3k
/bYKUIjOFAYSgEcOCNai38sWu7AJ17cL3InPvTHyTiWE9rSLWR6Wgoh3w/alJiT5
e9zojnMhhyYQE0yjATAIbIhURDwzUA5oG+1/2QmatthZK3jO2xc93fgrNo0pbLxP
Sk1K/1TORxCPkt9m84py
=LdJ6
-----END PGP SIGNATURE-----

--aMDdG8xNveJz2ruI--
