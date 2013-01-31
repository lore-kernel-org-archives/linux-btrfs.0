Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:55778 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756132Ab3AaWAm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 17:00:42 -0500
Date: Thu, 31 Jan 2013 22:00:40 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Christopher Thorjussen <joffer@onlinebackupcompany.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs subvolume list - with three subvolumes, the second is
 missing/not showing
Message-ID: <20130131220040.GP16285@carfax.org.uk>
References: <CAFKW2=ETvfXTyth9jHoc=6yZQDLj+5c8kRTZd4+79zVbs4LU-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uQ3BaAlxDi9XKvis"
In-Reply-To: <CAFKW2=ETvfXTyth9jHoc=6yZQDLj+5c8kRTZd4+79zVbs4LU-w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--uQ3BaAlxDi9XKvis
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 31, 2013 at 04:39:52PM +0100, Christopher Thorjussen wrote:
> I've created a large btrfs volume out of two large raid-60 devices. On
> there I've created three subvolumes. When I do a list of those the 2nd
> isn't displayed. If I however add a fouth subvol they all gets listed.

   This is (probably) a known bug in the userspace tools. It should be
fixed in David Sterba's integration branch:

  git://repo.or.cz/btrfs-progs-unstable/devel.git integration-20130130          
   Hugo.

> This is on a HP DL360 running RHEL6.3 with a P411 SAS Raid controller
> connected to a HP MD600 (70 x 2TB NL-SAS).
> I've installed kernel-ml v3.7.4 from elrepo and also installed
> btrfs-progs-0.19-12.el6.x86_64
> 
> root@data01:/opt/data# btrfs fi sh
> failed to read /dev/sr0
> Label: none  uuid: 786684d1-95fa-4809-8fca-e17e37a79999
>         Total devices 2 FS bytes used 816.00KB
>         devid    1 size 54.58TB used 2.03GB path /dev/sdb
>         devid    2 size 54.58TB used 2.01GB path /dev/sdc
> 
> Btrfs Btrfs v0.19
> 
> root@data01:/opt/data# ls -l
> total 0
> drwxr-xr-x 1 root root 0 Jan 31 15:55 buffer
> drwxr-xr-x 1 root root 0 Jan 31 15:55 consolidated
> drwxr-xr-x 1 root root 0 Jan 31 15:55 staging
> 
> root@data01:/opt/data# btrfs subvolume list .
> ID 265 top level 5 path consolidated
> ID 267 top level 5 path buffer
> 
> root@data01:/opt/data# btrfs subvolume create 4thsubvol
> Create subvolume './4thsubvol'
> 
> root@data01:/opt/data# btrfs subvolume list .
> ID 265 top level 5 path consolidated
> ID 266 top level 5 path staging
> ID 267 top level 5 path buffer
> ID 272 top level 5 path 4thsubvol
> 
> root@data01:/opt/data# rpm -qa | grep btrfs
> btrfs-progs-0.19-12.el6.x86_64
> 
> It surely is a bug, but has it been reported and/or fixed? I wasn't
> able to find out by googling just now.
> 
> 
> 
> Med vennlig hilsen / kind regards
> 
> Christopher Thorjussen
> System Administrator, VCP4/VCP5
> The Online Backup Company AS
> http://www.onlinebackupcompany.no
> 
> "Backup isn't the real concern. Restoring normal business is."

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- What do you give the man who has everything? -- Penicillin is ---  
                             a good start...                             

--uQ3BaAlxDi9XKvis
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUQrpiL9z9OVl50rAAQI+Mw/+PbuPIkTOFuOAA+XgHpUrrgMDhcr40rlR
6MHlbBmNmornT0x/kHcELbWOnl9OTX552jGCAh7jwF24hVcNG55AWSudJt8lrCzK
uqrcPPH2064mPtYakjEcSOZSmSfVuznCVc3BJS+SA8JgfrGaWoxGksIvN7fEwb57
Q8GtWvCwVU6xAoQg6EvBI0E5ivtVOHnAeFH0DO4Gf2aXPfr9qyu3ZSyrGJ99cPT3
ZuCF3KEYaQUhLrY0zI1DOLt7mUzKZAjoZq3YHCQpp7tu+L8pnV6EUiyq1FJHBNmm
nBWIG+chioqTDgVsHRLrcnrEv9VC8jhLpp0QNVeOP+k8JaboqeV80U19iz/ibAjC
YoLypZ5OoHu0H7Klg/f3bZC/fp+5JrqfJKqrG1D4Arjx8EGZy/fazoO58KLa0weS
XW6Eshe4MTPVUUGxxIfIOtW64NAz7lGrZ7IYkyFwr3jRdedJCYsFvBUcxl+nvPbQ
3LKiBcKh0R8CsC0TKndbGNP1QgLAzzRkjPpAxVfjCRITLnN0mE+6qnm6Pt8JvE7c
OvNOsUAsiMVEJA5YJEpFf37b895d6Smq3HNfi7Kxacc8el4zCZLsQjbyd+aWrjCN
STn4lzzoi+5o6w2E/xktdhBJ2GXHWSUlKOsXtRHxyglHYHHysFXSV3FVJgaBFUDf
K3A+WLoXBek=
=E6t3
-----END PGP SIGNATURE-----

--uQ3BaAlxDi9XKvis--
