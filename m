Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60473 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124Ab3KURPs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Nov 2013 12:15:48 -0500
Message-ID: <528E3F65.4020806@suse.com>
Date: Thu, 21 Nov 2013 12:14:13 -0500
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: deadhorseconsulting <deadhorseconsulting@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: Actual effect of mkfs.btrfs -m raid10 </dev/sdX> ... -d raid10
 </dev/sdX> ...
References: <CAEWPe=pwpxdYUDk7BzfjR8h-Jq9wtQE+gxxQChjOZzsXJO4vHQ@mail.gmail.com>
In-Reply-To: <CAEWPe=pwpxdYUDk7BzfjR8h-Jq9wtQE+gxxQChjOZzsXJO4vHQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="wS1BXnc50KfIjQmcwn8xvTKhGI1E0nSKO"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wS1BXnc50KfIjQmcwn8xvTKhGI1E0nSKO
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/19/13, 12:12 AM, deadhorseconsulting wrote:
> In theory (going by the man page and available documentation, not 100%
> clear) does the following command indeed actually work as advertised
> and specify how metadata should be placed and kept only on the
> "devices" specified after the "-m" flag?
>=20
> Thus given the following example:
> mkfs.btrfs -L foo -m raid10 <ssd> <ssd> <ssd> <ssd> -d raid10 <rust>
> <rust> <rust> <rust>
>=20
> Would btrfs stripe/mirror and only keep metadata on the 4 specified SSD=
 devices?
> Likewise then stripe/mirror and only keep data on the specified 4 spinn=
ing rust?
>=20
> In trying and creating this type of setup it appears that data is also
> being stored on the devices specified as "metadata devices". This is
> observed through via a "btrfs filesystem show". after committing a
> large amount of data to the filesystem The data devices have balanced
> data as expected with plenty of free space but the SSD device are
> reported as either nearly used or completely used.

Others have noted that's not how it works, but I wanted to add a comment.=


I had a feature request from a customer recently that was pretty much
exactly this. I think it'd be pretty easy to implement by allocating all
(except for overhead) of the devices to chunks immediately at mkfs time,
bypassing the kernel's dynamic chunk allocation. Since you don't *want*
to mix allocation profiles, the usual reason for doing it dynamically
doesn't apply. Extending an existing file system created in a such a
manner so that the added devices are set up with the right kinds of
chunks would require other extensions, though.

I have a few things on my plate right now, but I'll probably dig into
this in the next month or so.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--wS1BXnc50KfIjQmcwn8xvTKhGI1E0nSKO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJSjj9pAAoJEB57S2MheeWypEEP/0b9tZYt1p5RZilxt4hl6OJR
8MI+eSM+U/xZALcRCH4tB/ybshD9u2iyv2LTz2qA4MUgu9gJ5PyLFV18GbMZWt9p
qnv0b0VTCh26Z3lPbJfq/mflQKHmu63RnucE4GKrujVxumoWw+BhMziue/ysc/PY
kL0ChzmpaBCebw685F83neIHZ47aFpaaDVF+be/aWGIQIwz423hZTiW4yEqer9z8
b+HuEQq5VoQCA7Ew8vYVjuc6hUj1tAoXDIZhDX8YNoStBqxQBeK9HoM3wVLRX9rR
3VUjPuWN7SIVGHkxYRV+Y+kVJAkTUVLw/pljM1ScQCniZdmJ52MSE8kvgRpPhU/9
RY2dk2sYCIRyB5sDRyYYvL4ve/LyG71adk3prKyYlzHgnTr4elN/XC+CS2o1AmX1
8TO8i5XjWf7PRUTjFiM0nibtchbA5cRdS0hmkBffLiqI2L4zOEXlxo/Wm2R6b8/T
M+vnY8oelBYLDQxfivRIpzT6bdMGwJ8SMNnGYfCBG32xPF+e7lb0n94PeGUfRXM6
p8rGaqhI6EtrMpf70WnUd4pbhB+VyGcUEsm1HMUepa3qwq79KC13ShsQiyl3PmyK
IKQghkB8ttyTbCBJ8qur9q98WerRrWhE7bU2XjJ9KWtnDiFH2wQbOxyh3NyCSJWw
iPRTrUV1SO83GyziDm/Y
=0BNn
-----END PGP SIGNATURE-----

--wS1BXnc50KfIjQmcwn8xvTKhGI1E0nSKO--
