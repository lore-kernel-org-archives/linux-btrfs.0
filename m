Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:35342 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752764AbdC0NH4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Mar 2017 09:07:56 -0400
Date: Mon, 27 Mar 2017 13:07:30 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Christian Theune <ct@flyingcircus.io>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Shrinking a device - performance?
Message-ID: <20170327130730.GN11714@carfax.org.uk>
References: <1CCB3887-A88C-41C1-A8EA-514146828A42@flyingcircus.io>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="BtmVPk+Smchi6n7w"
In-Reply-To: <1CCB3887-A88C-41C1-A8EA-514146828A42@flyingcircus.io>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--BtmVPk+Smchi6n7w
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 27, 2017 at 01:17:26PM +0200, Christian Theune wrote:
> Hi,
>=20
> I=E2=80=99m currently shrinking a device and it seems that the performanc=
e of shrink is abysmal. I intended to shrink a ~22TiB filesystem down to 20=
TiB. This is still using LVM underneath so that I can=E2=80=99t just remove=
 a device from the filesystem but have to use the resize command.
>=20
> Label: 'backy'  uuid: 3d0b7511-4901-4554-96d4-e6f9627ea9a4
>         Total devices 1 FS bytes used 18.21TiB
>         devid    1 size 20.00TiB used 20.71TiB path /dev/mapper/vgsys-bac=
ky
>=20
> This has been running since last Thursday, so roughly 3.5days now. The =
=E2=80=9Cused=E2=80=9D number in devid1 has moved about 1TiB in this time. =
The filesystem is seeing regular usage (read and write) and when I=E2=80=99=
m suspending any application traffic I see about 1GiB of movement every now=
 and then. Maybe once every 30 seconds or so.
>=20
> Does this sound fishy or normal to you?

   On my hardware (consumer HDDs and SATA, RAID-1 over 6 devices), it
takes about a minute to move 1 GiB of data. At that rate, it would
take 1000 minutes (or about 16 hours) to move 1 TiB of data.

   However, there are cases where some items of data can take *much*
longer to move. The biggest of these is when you have lots of
snapshots. When that happens, some (but not all) of the metadata can
take a very long time. In my case, with a couple of hundred snapshots,
some metadata chunks take 4+ hours to move.

   Hugo.

--=20
Hugo Mills             | Great films about cricket: Silly Point Break
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--BtmVPk+Smchi6n7w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJY2Q6RAAoJEFheFHXiqx3kEQkP/0hnuGyNT/+5h1AiZV5UIHMa
Iwjceo04CW09zzUX24hlWgUqlRYMEaVLLqIHvhmBJIzFNnHto8FmqAXBSpV/wqn0
fLWl0m/Th6rSqH092ItbNMwfGNEGE4vqr29I8NAYrMn+ifYAmkRCJBzakTQa6pbN
h+PzeRsniBZIbM98u7m0Gln9AqZkR9cZLiiuFJjfn+FUEc8UZamXtF5pfawVrG/D
ll+Cw9v7nyFFs5dcRG5Ns6nMhQsxekn3CdHij3r+i5bpYOdOClOu7CwJUbNtFDVG
Ts3icTA9ovrCDjFGATuf6eG2GT9O+R6QEuEt3ZiqwoD/lfhZu2yRQ55mubY2En/u
hkORMZiYCKQyXqtBOwLeDQUNti+1yFlVUnDbmFvPr185lIxuAAaUL/huVyjteHWK
MgqxBmujWofggUYJFpOru2nRGUx4zX23aDjCItwbT10iiatzM9vR9THxpRMiKRg6
c9MyvgJY5dovrQTZwW3p88Z1coKYreA0z+zb/TLRkWrmW7Zbh4jcmhbrwrv2bGF7
tjOW4EQ3G1XuMBrFEEVIsTqO1tTev/EMoVifN30QpWkMoJCz1fPyTUxjBWahxUJG
ArDFivSJ53KYTfBFEM6aRNjLzeZSRZXqxW+ngGY0n9s4KJtoEgMvWxPd+XnNuRzT
pMMv49xh2CdRLQIlyUNQ
=S4O/
-----END PGP SIGNATURE-----

--BtmVPk+Smchi6n7w--
