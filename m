Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:33030 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754396AbcHSRRu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Aug 2016 13:17:50 -0400
Date: Fri, 19 Aug 2016 17:17:34 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Davide Depau <me@davideddu.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Balancing subvolume on a specific device
Message-ID: <20160819171734.GJ20440@carfax.org.uk>
References: <df03a71c-8558-520c-af1b-ffb152f65a7d@davideddu.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="CNfT9TXqV7nd4cfk"
In-Reply-To: <df03a71c-8558-520c-af1b-ffb152f65a7d@davideddu.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--CNfT9TXqV7nd4cfk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 19, 2016 at 07:09:48PM +0200, Davide Depau wrote:
> Hello,
> 
> I have a btrfs filesystem spanning over two drives: an SSD and HDD.
> 
> Label: 'Android Dev'  uuid: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx
>     Total devices 3 FS bytes used 32.08GiB
>     devid    1 size 21.95GiB used 12.00GiB path /dev/sda2
>     devid    2 size 33.22GiB used 12.01GiB path /dev/sda3
>     devid    3 size 53.10GiB used 13.01GiB path /dev/sdb2
> 
> (sda is the SSD, sdb is the HDD)
> 
> I've got these subvolumes in the filesystem:
> 
> ID 258 gen 708 top level 5 path cm13.0
> ID 259 gen 708 top level 5 path ccache
> ID 269 gen 708 top level 5 path omni
> 
> I would like the ccache subvol to always be stored on the SSD, unless no
> disk space is available. Is that possible?

   No, it isn't, sorry.

   Hugo.

-- 
Hugo Mills             | Well, sir, the floor is yours. But remember, the
hugo@... carfax.org.uk | roof is ours!
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                             The Goons

--CNfT9TXqV7nd4cfk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXtz8uAAoJEFheFHXiqx3kJmYP/3f1Sr9rDThedxWlo/dmL6K3
xw80Vz5FOiloXBHXW7X5A+8OV86WYiY7xTtLX8vwZgmeipYXkAj7HjD0FSwLgQf0
5PBjmI12RrwY09kWnMD/O98NIwhczOwIutz7ahpqVbjQWphwHHTgqbVRGZIhoJhy
FtvnNZpVqUxypeEIcPgnZP9DAatciNjUOC3bslk/7FI2BIS5AxL+U0N1G/PBcIaF
1kamjrST0MuUorAEpVH/1/Kiojbn0oo2iuaSqIqolcmk8WK7jqLwwgUtryykPRAi
5eKUCSvq4cKS6qK/TU1HCN2KLYWX6/Fb+scmImng98UmZx06yBVrlHPpbWL7D+zc
J6QOiAncrnVrgdX7ZP9Xl1+JYmRTE5zTxukTUjLgmWlDcfkHTMp7jectYZ/92iZq
OB1whs6lW+hqZsbUkBP+zADgN8MfurrtTmMtXs/CqVxiKPkpdYpXJz3zarQei1Ng
BonsqxMvQzjJO7rlSR7CkL50JEejjpY2I5rUzAyivmQkJcm2/yCF9W6mhxlCyqhr
dycWh7swHjERyFdmEGYjNQpvvGXruxdtj1RTEkvH34DyXsMySwMcx7s0u4HLcWVv
DuE6gooM6m0aeQStkhFHxbl+mbQFdEI9Q1c5uROYb7SVedt5b2MC2H1SQjfsJLv+
poCWTHr2togRFpRF3A1P
=P0oX
-----END PGP SIGNATURE-----

--CNfT9TXqV7nd4cfk--
