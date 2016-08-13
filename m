Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:46615 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbcHNNmF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Aug 2016 09:42:05 -0400
Date: Sat, 13 Aug 2016 20:15:35 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Wolfgang Mader <Wolfgang_Mader@brain-frog.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Likelihood of read error, recover device failure raid10
Message-ID: <20160813201535.GA20440@carfax.org.uk>
References: <2336793.AMaAIAxWk4@discus>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
In-Reply-To: <2336793.AMaAIAxWk4@discus>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Aug 13, 2016 at 05:39:18PM +0200, Wolfgang Mader wrote:
> Hi,
> 
> I have two questions
> 
> 1) Layout of raid10 in btrfs
> btrfs pools all devices and than stripes and mirrors across this pool. Is it 
> therefore correct, that a raid10 layout consisting of 4 devices a,b,c,d is 
> _not_
> 
>               raid0
>        |---------------|
> ------------      -------------
> |a|  |b|      |c|  |d|
>    raid1            raid1
> 
> Rather, there is no clear distinction of device level between two devices 
> which form a raid1 set which are than paired by raid0, but simply, each bit is 
> mirrored across two different devices. Is this correct?

   Correct. There's no clear hierarchy of RAID-1-then-RAID-0 vs
RAID-0-then-RAID-1. Instead, if you look at a single device (in a
4-device arraay), that will be one of two copies, and will be either
the "odd" stripes or the "even" stripes. That's all you get, within a
block group.

> 2) Recover raid10 from a failed disk
> Raid10 inherits its redundancy from the raid1 scheme. If I build a raid10 from 
> n devices, each bit is mirrored across two devices. Therefore, in order to 
> restore a raid10 from a single failed device, I need to read the amount of 
> data worth this device from the remaining n-1 devices. In case, the amount of 
> data on the failed disk is in the order of the number of bits for which I can 
> expect an unrecoverable read error from a device, I will most likely not be 
> able to recover from the disk failure. Is this conclusion correct, or am I am 
> missing something here.

   That's right, but the unrecoverable bit rates quoted by the hard
drive manufacturers aren't necessarily reflected in the real-life
usage of the devices. I think that if you're doing those calculations,
you really need to find out what the values quoted by the manufacturer
actually mean, first. (i.e. if you read all the data once a month with
a scrub, and allow the drive to identify and correct any transient
errors which might indicate incipient failure, does the quoted BER
still apply?)

   Hugo.

-- 
Hugo Mills             | Let me past! There's been a major scientific
hugo@... carfax.org.uk | break-in!
http://carfax.org.uk/  | Through! Break-through!
PGP: E2AB1DE4          |                                          Ford Prefect

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXr3/nAAoJEFheFHXiqx3ki9MP/ibAQABRPFrayA83FnaNYCQK
IvBhdfybgs8cHv3X0jzjA7MGDDLkzRijXsqTTnWCb21EMXTFe4GbdrnTp2U8wI8H
3exoMb4nEwLNuP+bHZPoZZKjCVk5ml9eXmIdjk+hayw+cNYwClyEX48+V0YQ/gyD
FKi3ACJQafzoDYdgqz9EUX8GEQOtB1OFU0j2LBybBudt7Pc5O8jvOcva6DfK2vTT
VLK335RVgXm1mdPxmvp6T9UILJ/Yr5hf/IPwOPxnn+b3DVYzr3eTVdjXS8fDC/6k
vtzRMOJ0nxzNbhcFzOMYTGBx9f46hx3ESE0/guiTorUkSLBbx4rSAIESBmi538JV
0vQl5vjmZYyxz7/lwSj+I2izHhr8TGxi7N6l/oPU+SG/i/yc1Oag3HvSdap1Jspe
T9GJx9fC4eijcHBQIVSD/ZcA2OdLRBTvSYO+rz+hEOvI4mEBz+2X4YWw4hE48DN8
IjnF4PWgtdv9AiXCVz0Ed6OzFjQ4EewIRhI/a7RRiFCo5H0YN0CATPjh3/7xE3hI
bsuDnFnsLlGUzkmQc4T2b26ASTPTE4XCCRe9QBwWMpuk+cganKczY1Qqg6kZxC/J
7hszbDtLereTtUQ1UUJbRHJtxmGVgHVJ3J0UBcwZ261fX28Ixu7yDql+7eJ2WBHr
Jd1erpUq4m9ukXmHhCfu
=TRMf
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
