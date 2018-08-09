Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51560 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726882AbeHIVOQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 9 Aug 2018 17:14:16 -0400
Subject: Re: [COMMAND HANGS] The command 'btrfs subvolume sync -s 2 xyz' can
 hangs.
To: bepi@adria.it, linux-btrfs@vger.kernel.org
References: <2543962.HIiRWmuHEy@exnet.gdb.it>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <3834bc23-03bf-f6e4-dd56-2cf028469a82@suse.com>
Date: Thu, 9 Aug 2018 14:48:03 -0400
MIME-Version: 1.0
In-Reply-To: <2543962.HIiRWmuHEy@exnet.gdb.it>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="XBBZjFaVmfExtmjQvL5giHqUbH0p1MxQb"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XBBZjFaVmfExtmjQvL5giHqUbH0p1MxQb
Content-Type: multipart/mixed; boundary="I7vGYs9Wy20EBNJdvVqF1JVGawwacm0cF";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: bepi@adria.it, linux-btrfs@vger.kernel.org
Message-ID: <3834bc23-03bf-f6e4-dd56-2cf028469a82@suse.com>
Subject: Re: [COMMAND HANGS] The command 'btrfs subvolume sync -s 2 xyz' can
 hangs.
References: <2543962.HIiRWmuHEy@exnet.gdb.it>
In-Reply-To: <2543962.HIiRWmuHEy@exnet.gdb.it>

--I7vGYs9Wy20EBNJdvVqF1JVGawwacm0cF
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/9/18 11:15 AM, Giuseppe Della Bianca wrote:
> Hi.
>=20
> My system:=20
> - Fedora 28 x86_64
> - kernel-4.17.7-200
> - btrfs-progs-4.15.1-1
>=20
> The command 'btrfs subvolume sync -s 2 xyz' hangs in this case:
>=20
> - Run command 'btrfs subvolume sync -s 2 xyz' .
> - After some time the kernel reports an error on the filesystem.
>   (error that existed before the command was launched.)
> - The filesystem goes in read-only mode.
> - The command hangs.

Can you provide the output of 'dmesg' and the contents of
/proc/<pid>/stack where <pid> is the pid of the btrfs command process?

-Jeff
--=20
Jeff Mahoney
SUSE Labs



--I7vGYs9Wy20EBNJdvVqF1JVGawwacm0cF--

--XBBZjFaVmfExtmjQvL5giHqUbH0p1MxQb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAltsjGQACgkQHntLYyF5
5bL3HQ//bDhvkjMt6FPrP00cJ7gLFtGjb40fbAtxkTAf6dDSHE/BVKJdDFGYDJfC
h7mbYTZ9diaoUSSp57UEx16Isgn7Ao8KHdV2XKdbuttfLqCQNGBRIstrv78IvcRw
W1FWU2pR7m1RMqgBHSd2QOLx754s48poQga8DKLmTY+lWoAXR6S4UOZ66hHT02gs
SGmk9RBMwI0TBmiIIC5sDSCg16zjTRH4gd/VrWEn+vd9vf3mOgm/bToJQ1Ggn+DJ
2mwk5HXKtxVWcR2DzYzjRXybxaTwbKeGBZhqNhIY0W8HBPADvwU9gHw4f4Jq99Ay
us819xRRf3/JUg3BylJjwxX5D5RMxnn6HkBKYoNayZSjWGGHvAwEf67O2a1nZ6yj
0/4BpdbQq1RQtLfXedME6WhHTBDHrm+ncd7Rl1TLsMQh1MHwGsInuG8G/u1C9ign
BOqhIzxOGbFFUMJSzGxYyCDYFt8EvrS3ovIYMPjb1OOjmgOWvjRF4mgQU9Yo3uy9
0/qFxrJjPcIIvy0Fhxg0cvYJWgR6gcst9h0nuvWNs3ScqK3mqCHv4MLtjWma2y59
B8/1/tVtZhHBiSEdkDgjR8GAfEuBRLaKH7gWI6XMfTLNeTm9/VZWwOtRx3rkJURm
7enIElNtxfweknhD/QCMNUbnU1MxTlgmMlE7kKBss5M2QIDFUao=
=tzxp
-----END PGP SIGNATURE-----

--XBBZjFaVmfExtmjQvL5giHqUbH0p1MxQb--
