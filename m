Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from wolfsden.cz ([37.205.8.62]:50556 "EHLO wolfsden.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729601AbeGPVcc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jul 2018 17:32:32 -0400
Received: from localhost (unknown [128.0.188.242])
        by wolfsden.cz (Postfix) with ESMTPSA id 213D76D266
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 20:58:10 +0000 (UTC)
Date: Mon, 16 Jul 2018 22:58:09 +0200
From: Wolf <wolf@wolfsden.cz>
To: linux-btrfs@vger.kernel.org
Subject: Healthy amount of free space?
Message-ID: <20180716205809.42jywfvuxwuuqixd@wolfsden.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="52aacrwa7otadmh6"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--52aacrwa7otadmh6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Greetings,
I would like to ask what what is healthy amount of free space to keep on
each device for btrfs to be happy?

This is how my disk array currently looks like

    [root@dennas ~]# btrfs fi usage /raid
    Overall:
        Device size:                  29.11TiB
        Device allocated:             21.26TiB
        Device unallocated:            7.85TiB
        Device missing:                  0.00B
        Used:                         21.18TiB
        Free (estimated):              3.96TiB      (min: 3.96TiB)
        Data ratio:                       2.00
        Metadata ratio:                   2.00
        Global reserve:              512.00MiB      (used: 0.00B)

    Data,RAID1: Size:10.61TiB, Used:10.58TiB
       /dev/mapper/data1       1.75TiB
       /dev/mapper/data2       1.75TiB
       /dev/mapper/data3     856.00GiB
       /dev/mapper/data4     856.00GiB
       /dev/mapper/data5       1.75TiB
       /dev/mapper/data6       1.75TiB
       /dev/mapper/data7       6.29TiB
       /dev/mapper/data8       6.29TiB

    Metadata,RAID1: Size:15.00GiB, Used:13.00GiB
       /dev/mapper/data1       2.00GiB
       /dev/mapper/data2       3.00GiB
       /dev/mapper/data3       1.00GiB
       /dev/mapper/data4       1.00GiB
       /dev/mapper/data5       3.00GiB
       /dev/mapper/data6       1.00GiB
       /dev/mapper/data7       9.00GiB
       /dev/mapper/data8      10.00GiB

    System,RAID1: Size:64.00MiB, Used:1.50MiB
       /dev/mapper/data2      32.00MiB
       /dev/mapper/data6      32.00MiB
       /dev/mapper/data7      32.00MiB
       /dev/mapper/data8      32.00MiB

    Unallocated:
       /dev/mapper/data1    1004.52GiB
       /dev/mapper/data2    1004.49GiB
       /dev/mapper/data3    1006.01GiB
       /dev/mapper/data4    1006.01GiB
       /dev/mapper/data5    1004.52GiB
       /dev/mapper/data6    1004.49GiB
       /dev/mapper/data7    1005.00GiB
       /dev/mapper/data8    1005.00GiB

Btrfs does quite good job of evenly using space on all devices. No, how
low can I let that go? In other words, with how much space
free/unallocated remaining space should I consider adding new disk?

Thanks for advice :)

W.

--=20
There are only two hard things in Computer Science:
cache invalidation, naming things and off-by-one errors.

--52aacrwa7otadmh6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEKUV4RjubkPramXVZs4umGUJTxRIFAltNBuEACgkQs4umGUJT
xRIFJQ/+N5yeAlV1WU7XfrceTCG54f78LEa78h9tagoqC9NP4CSyREL5nbjtHvaw
dOsXcflBDM151yiSVQJhjsMSZLhT9+Qt7gDcnuHwlSnQSeEE9JUrn+rOqACoIj1e
3Un24xgn4BlCQ7jODwaXQWG4s/9sa3V79m6GWSQsgVaBQzDeeIIwkGDsCm9fOKS9
6QrxinS/b/mjbbAydSB/Qf0uJ/ljmlCU/230EmhZaS4JR2SaXNGSu1CcIf0NJEiX
QqDesZ8uy1UsLJNOMlG3hJTtZ3kJZVQjJiy6ViAeOJLohJpcEyfBmCb6f+85jw27
WuA9if7As+0V1rMpB70C443boiiJ1nnwT6VUz0mHV928fseyTBd5J03ozjlsBIVB
jJwcJniu0rFjxE6ETF7itR8USsG/5UYur4dy1ROFP5bYAU0aYkOIOiOLS213W4ra
RtmM12K1t9SD3t0HaCTx/2QkFyCVvByhHj2FFa+Y4rnexGQvJR65wCoKBOrwF+67
szwiLHHT/zGFhzkxzu0m5+HT/x/X/eOjOAojOE85CE3g5yI+RNUV83OgYrVaw1QQ
Pb2kce8nNkhciW/vkRYKlamPZfGL6X/HjX72y1swPLpVhPZP9pzrrilptfiiWOQh
kh6rUHJOz7cFGSHn1n+LdqzRAlCv2TEJ59cUfqKUvb+VQAugv/M=
=UP4d
-----END PGP SIGNATURE-----

--52aacrwa7otadmh6--
