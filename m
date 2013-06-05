Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:56641 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639Ab3FEQFB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Jun 2013 12:05:01 -0400
Date: Wed, 5 Jun 2013 17:04:58 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Martin <m_btrfs@ml1.co.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs raid1 on 16TB goes read-only after "btrfs: block rsv
 returned -28"
Message-ID: <20130605160458.GR20133@carfax.org.uk>
References: <konjl0$r06$1@ger.gmane.org>
 <20130605150549.GP20133@carfax.org.uk>
 <konler$h9p$1@ger.gmane.org>
 <20130605154329.GQ20133@carfax.org.uk>
 <konn9n$7hf$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7UIJfHqpdi+oBJdT"
In-Reply-To: <konn9n$7hf$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--7UIJfHqpdi+oBJdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 05, 2013 at 04:59:57PM +0100, Martin wrote:
> On 05/06/13 16:43, Hugo Mills wrote:
> > On Wed, Jun 05, 2013 at 04:28:33PM +0100, Martin wrote:
> >> btrfs fi df:
> >> 
> >> Data, RAID1: total=2.85TB, used=2.84TB Data: total=8.00MB,
> >> used=0.00 System, RAID1: total=8.00MB, used=412.00KB System:
> >> total=4.00MB, used=0.00 Metadata, RAID1: total=27.00GB,
> >> used=25.82GB Metadata: total=8.00MB, used=0.00
> >> 
> >> 
> >> btrfs fi show:
> >> 
> >> Label: 'bu-16TB_0'  uuid: 8fd9a0a8-9109-46db-8da0-396d9c6bc8e9 
> >> Total devices 4 FS bytes used 2.87TB devid    4 size 3.64TB used
> >> 1.44TB path /dev/sdf devid    3 size 3.64TB used 1.44TB path
> >> /dev/sde devid    1 size 3.64TB used 1.44TB path /dev/sdc devid
> >> 2 size 3.64TB used 1.44TB path /dev/sdd
> > 
> 
> Thanks for that. I can give kernel 3.9.4 a try. For a giggle, I'll try
> first with "nice 19" and syncs in a loop...
> 
> 
> One confusing bit is why the "Data, RAID1: total=2.85TB" from "btrfs
> fi df"?

   Because you've got enough raw space allocated for 2.85 TiB of data;
that's 5.7 TiB of actual bytes, because you're using RAID-1 for it.
That should add up to somewhere near the total of the "used" values in
btrfs fi show. The difference will be accounted for in metadata,
system, and the inevitable rounding errors. All the values are shown
in powers-of-two -- i.e. IEEE units, not SI units despite the use of
SI prefixes.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
           --- All hope abandon,  Ye who press Enter here. ---           

--7UIJfHqpdi+oBJdT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUa9hqlheFHXiqx3kAQIhJg/9EUlXxSoJUfb8kwu3NsaLDXErptMnh1de
EnnJCJWgwRpcD5PBOmo/vXxPWdZZYnclHrd3tyQD/31AaG8OyPB1uqyESJMz6ctG
+XUHZXIVnjlIYoM4FdZxRHMqQ8IiyBcmJbbOe2zY21rDjSGlsReLHL+CUo6f1DVl
QitL/TGsej8T6dl4n9pp88SD/VsrrjiIttaoGMjoW6D4nOx4i34waq1qHIbdlnnk
TZrIR2RI6cqJi/dTvpTA5QSU/9l8sQNvaTURc6pMJ8A4G0+UHA0XsRpOzmrMQ1ah
zuJJpVeAuMeXXC7z1dzgmjj77z8dZvdsqWJQVY05dGstrBINYK9IbvPXiByYd4p1
yBiRiUlcxLHhSkQTGiirlHwi0Fb3IySVjm3ShPwHVWxEC2ZdP0WKGuykcvQEr76c
2qlHUeigZ3bTyDwZQMqxyYVMjP0ieXkp+4TUOA9rIdmrQHzCbudWZbO10A2V9pRi
He4QARC3Qlu+EMMT8hubddKbrB0M7qCh7wLhvCtQbgKUL7SKlC62iXhVHRRJaxK+
XC2DeDunVLTYhju031tvbblPdCZw7rme9sP4+BOAuWLubePrw2lKrELbe2QlktSf
ey0iG7S4k4mb29u3Z1jl31I6HjD0DECsvUteBgTBT6XP3aFjwITSjUMeGNM4Je5h
zOgv4/lh760=
=bcXv
-----END PGP SIGNATURE-----

--7UIJfHqpdi+oBJdT--
