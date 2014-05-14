Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341AbaENOro (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 10:47:44 -0400
Message-ID: <1400078849.15603.177.camel@rh>
Subject: Re: [PATCH] mkfs.btrfs: allow UUID specification at mkfs time
From: James Shubin <purpleidea@redhat.com>
To: kreijack@inwind.it
Cc: Eric Sandeen <sandeen@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, jshubin@redhat.com
Date: Wed, 14 May 2014 10:47:29 -0400
In-Reply-To: <5373803E.9000406@libero.it>
References: <5372C457.3000706@redhat.com> <5373803E.9000406@libero.it>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-rJxoS45+lSu/YoTIbrsy"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-rJxoS45+lSu/YoTIbrsy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2014-05-14 at 16:39 +0200, Goffredo Baroncelli wrote:
> Hi Eric,
>=20
> On 05/14/2014 03:18 AM, Eric Sandeen wrote:
> > Allow the specification of the filesystem UUID at mkfs time.
>=20
> I suggest to add some warning when this options is used, because the beha=
vior could be very different than the one expected.
>=20
> I suspect that BTRFS tracks the filesystem by UUID and not by devices. Wh=
en two filesystems have the same UUID at the same time, it may mount the wr=
ong one.
>=20
> $ #
> $ # Make two *different* filesystems with the *same* UUID
> $ #
> $ UUID=3De285c9bd-ea97-40b3-ad7d-8713dcfd5eea
> $ sudo ./mkfs.btrfs -f -U $UUID /dev/vdg
> $ sudo ./mkfs.btrfs -f -U $UUID /dev/vdh
>=20
> $ #
> $ # from the beginning "btrfs fi show" reports wrong information
> $ #
> $ sudo btrfs fi show
> Label: none  uuid: e285c9bd-ea97-40b3-ad7d-8713dcfd5eea
> 	Total devices 1 FS bytes used 96.00KB
> 	devid    1 size 50.00GB used 4.00MB path /dev/vdh
> 	devid    1 size 50.00GB used 2.04GB path /dev/vdg
>=20
> $ #
> $ # mount the first one, create a new file then un-mount it
> $ #
> $ sudo mount /dev/vdg /mnt/btrfs1
> $ sudo touch /mnt/btrfs1/dev-vdg
> $ sudo umount /dev/vdg
>=20
> $ #
> $ # mount the second one, it should be empty
> $ # instead btrfs mount the first one
> $ #
> $ sudo mount /dev/vdh /mnt/btrfs2
> $ ls -l /mnt/btrfs2
> total 0
> -rw-r--r-- 1 root root 0 May 14 16:12 dev-vdg
>=20
>=20
> I am not against this option; I am suggesting to add a explicit warning t=
o the user about the risk of doing that, both on the man pages and into the=
 program.=20
> The warning should say that this option is only for testing. Better ask f=
or a confirmation (even with an undocumented switch like '--I-know-that-I-a=
m-doing-something-really-dangerous').

I don't think is necessary since xfs and ext4 both have these options
too... There probably *should* be a conflict, because typically this
will cause an entry to show up in
/dev/disks/by-uuid/$UUID

I'm sure this same bug exists if two "randomly generated UUID's" get
created too. I think a warning in the man page would be enough.

>=20
> For the record, BTRFS seems unable to mount at the same time two differen=
t filesystems with the same UUID:
>=20
> $ #
> $ # try to mount two fs with the same UUID, but BTRFS doesn't allow it
> $ #
> $ sudo mount /dev/vdh /mnt/btrfs2
> $ sudo mount /dev/vdg /mnt/btrfs1
> ERROR: mount failed : 16 - Device or resource busy
>=20
>=20
> BR
> G.Baroncelli
>=20



--=-rJxoS45+lSu/YoTIbrsy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABAgAGBQJTc4IBAAoJEF9gnLdaSQBgmG8P/1zV3ppzemLB8fxM23VxeeNd
DBnOv4UeMJoHpI/+2xElHDEUmLat80RwpkAtzjVdyWlhKTsa4Jjen6khoyLkOIK9
YZa903tsEw6+Hyf0cEnWvzTHwlMRgc0Bm8ZDXqKWj2NcX/EEZKJwGYbG36Szp0eA
SV2O7cPGtq77oRVTo7KG1WQ9fE3ZgeuOA6eW6Ux1NJwrKhZ0HdBZoV3yp3kdeT3D
oR9Er45FDgEzuu7FUDkNj7JgItwGsa4n7P/kW5rZetRUXaZ9+DSVpN/izfidnqVi
0R69pnwLy/1SUEcK50+iRxsHtmmyzAs0VgnZLqMAvgzk/detaPGgHrH4Mtc4cg9V
dgJfsng2aRTrqQHoXvX8UMiN8+dA4TxQcKzyeT+I7lZ+YlizWRQdJY2ITi7DdkGn
m2QIxbUdHfJMhUw38sXN6wDdPwupqEwBFCISbeVr8zUuqWO249aoUGfirrEExXEr
3BZM+Vk75TZHy9q/95YdN/lcyg/EMincOqwzAz3sXfi/Ao48IqxpAh9nMY4HIlFk
4r712rtFdxl5CDD4T/pmAZxWkHrPho3uyhz3J4BhIW+P2uzC3A/SLSvKqL5cLl01
wmhyUEGcrncWkV8EeNudDB4jCTGWL831w+dTndp/QAezMlkehaX4HsaSSWdoJkik
BzZK218Sp7xcn7DwcZ6S
=Oxsi
-----END PGP SIGNATURE-----

--=-rJxoS45+lSu/YoTIbrsy--

