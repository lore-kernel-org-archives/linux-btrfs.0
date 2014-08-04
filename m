Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:34283 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbaHDLcd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Aug 2014 07:32:33 -0400
Date: Mon, 4 Aug 2014 12:32:31 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Clemens Eisserer <linuxhippy@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC with mkdir and rename
Message-ID: <20140804113231.GD31950@carfax.org.uk>
References: <CAFChkqtpb+xMhFk+7RBux-o-FOO0oaxx28Wz-LZZZVpvq2nRFQ@mail.gmail.com>
 <53DEE40C.6020403@cn.fujitsu.com>
 <CAFChkqttiPWQ+FquT2FfKE54US7vkeEyQsUT8fuD1BWNhS3k=w@mail.gmail.com>
 <17833067.mzxAL4oqZq@quad>
 <CAFChkqs3LOM4HmDzpXgs6YTeoXvyNPbsNWCPf74=_MnPneJ+HQ@mail.gmail.com>
 <20140804102206.GA31950@carfax.org.uk>
 <CAFvQSYRDz1EW4CiKbRNEp0HKhciHPM+b_63CrOOko+D6aYPnvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EcSFpNr6Vcxykj4g"
In-Reply-To: <CAFvQSYRDz1EW4CiKbRNEp0HKhciHPM+b_63CrOOko+D6aYPnvw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--EcSFpNr6Vcxykj4g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 04, 2014 at 01:04:25PM +0200, Clemens Eisserer wrote:
> Hi Hugo,
> 
> >    On the 3.15+ kernels, the block reserve is split out of metadata
> > and reported separately. This helps with the following process:
> 
> Thanks a lot for pointing this out, I hadn't noticed this change until now.
> 
> One thing I didn't find any information about is the overhead
> introduced by mixied-mode.
> It would be great if you could explain it in a few sentences.

   I don't know, I'm afraid. I don't think we've got any benchmarks on
the scale of the slowdown.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- Reading Mein Kampf won't make you a Nazi. Reading Das Kapital ---  
         won't make you a communist. But most trolls started out         
                    with a copy of Lord of the Rings.                    

--EcSFpNr6Vcxykj4g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU99vT1heFHXiqx3kAQLfExAAqzb7d1hL5OMUvbYlkuxM+UTvp6wQ1+SZ
tXSFegrb2iypaYZ6QTA93P5/xg8e6q/T1cmJFKrmpk4nbZYu2iTT3qZxp05cljua
z47fs50iX1bLhpJzF9x9UKRa1Mvoh7nkn3+44pXUnMMPJEPYf5muBVckIB6+59HG
wAOX7xZOOJZ7014UWGTqk/3bjB+bjJcXI9nWvt+gcNaIJ00hCb+tgQIkHXHr6AXf
PnWpYE6eSpUwqNHddmfF3af7IHHVGEIbIjLXKwE2TxWssV7n6FOUNDomdiCK6soE
xevqYUtPitQUbPS686XjBYShhM4FNXbuKACC1sJVtGnp76fW7LlULm4HiGXgjDVM
aUbvu5Pv8wI73GL3ZvPtHCn/qGoanUPRKKeKcXdAL7TBX2S86TxCxN4TG1U/77Al
36R1UHhPSKQmXwZmY8JKshpOFXtnlT3MD17dtuNxFij44SPXAUeDl2lILf13IU08
7AuFYLIBa9en4SnGk285wSbM3Gkqv2e1FyA7VmB5KN15b6Ca5dsr0kE4+tdy0G33
s85CbHSV4ksV06PMb4vQ+g4EQcksXbdcih9UwDD9rF6Af5W6NtkGGN7zW7mDwQ5e
xm4oVqbr6/OBanDs1lPHPoAPTEFPC2LmwIhWzkrRhqOzduCY3bcrBkLPItz0Ix/3
stTjpnxr3J0=
=B+Iz
-----END PGP SIGNATURE-----

--EcSFpNr6Vcxykj4g--
