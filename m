Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:52648 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755AbbG0WoV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jul 2015 18:44:21 -0400
Date: Mon, 27 Jul 2015 22:44:10 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Brendan Hide <brendan@swiftspirit.co.za>
Cc: Omar Sandoval <osandov@fb.com>, dsterba@suse.com, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Wang Yanfeng <wangyf-fnst@cn.fujitsu.com>
Subject: Re: [PATCH 2/3] btrfs: add replace missing and replace RAID 5/6 to
 profile configs
Message-ID: <20150727224410.GD464@carfax.org.uk>
References: <cover.1437683940.git.osandov@fb.com>
 <6d332e954da29e8418689cb49294a68da2fa5376.1437683940.git.osandov@fb.com>
 <20150724120946.GT6306@twin.jikos.cz>
 <20150724175043.GA14974@huxley.DHCP.TheFacebook.com>
 <55B6AF40.5040107@swiftspirit.co.za>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LKTjZJSUETSlgu2t"
In-Reply-To: <55B6AF40.5040107@swiftspirit.co.za>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--LKTjZJSUETSlgu2t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 28, 2015 at 12:22:56AM +0200, Brendan Hide wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 2015/07/24 07:50 PM, Omar Sandoval wrote:
> > On Fri, Jul 24, 2015 at 02:09:46PM +0200, David Sterba wrote:
> >> On Thu, Jul 23, 2015 at 01:51:50PM -0700, Omar Sandoval wrote:
> >>> +			# We can't do replace with these profiles because they +
> >>> # imply only one device ($SCRATCH_DEV), and we need to +			#
> >>> keep $SCRATCH_DEV around for _scratch_mount +			# and
> >>> _check_scratch_fs. +			local unsupported=( +				"single" +
> >>> "dup"
> >> 
> >> DUP does imply single device, but why does 'single' ?
> > 
> > It does not, I apparently forgot that you could use single to 
> > concatenate multiple devices. I'll fix that in v2.
> > 
> > Thanks for reviewing!
> > 
> Late to the party. DUP *implies* single device but there are cases
> where dup is used on a multi-device fs. Even if the use-cases aren't
> good or intended to be long-term, they are still valid, right?

   Yes, but bear in mind that any new (presumably metadata) chunks
allocated on the multi-device FS will end up as RAID-1, because of the
automatic upgrade from DUP to RAID-1. Any balance will also do the
upgrade.

   Hugo.

PS. Can we get rid of that upgrade? It's a pain the arse in so many
ways.

> - -- 
> __________
> Brendan Hide
> http://swiftspirit.co.za/
> http://www.webafrica.co.za/?AFF1E97
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.22 (MingW32)
> 
> iQEcBAEBAgAGBQJVtq9AAAoJEE+uni74c4qN5eYIAJAGznsi3RD1tchbSLwhMXJk
> bJJ4ORB9taLXHykSfYTsHIaUoVpcVR6tT/I1jz5070DY3mKkQ16a8nwtSxPba4Lv
> QiS8YRegFiHMYzZbH1T7Tnm6R9g/RZsaU7GS3JhP9HUYG7hIWGRRuoiOjYn/hoLw
> uMXuIFOkPKGYDgyAhDIp3KDYlBjMHT6Oun7CcpvTjXiOnzJFFp3MSt3b6mmmdMVV
> YKWpWyKVh7qlENEoqKb4exqr1WGYKU+kBLXRs4wdm3xb66EcWYs0Er1u6v+K1trx
> nryFrfUxYtMJsSuR9ZJm88DOsXKAuX1LEdRKVOlq7krsIK8HlTizccMXAl10gKk=
> =ndkL
> -----END PGP SIGNATURE-----

-- 
Hugo Mills             | I'm on a 30-day diet. So far I've lost 18 days.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--LKTjZJSUETSlgu2t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVtrQ5AAoJEFheFHXiqx3kYXUP/0MzU4Hqx0RkmXsuUqm+UYud
/YqrwokYL69M2Pahc9/2SHL6wnWZBFJ5TtRlapgzvcI07LQM6DkvBhBTTCa34VFg
1tjxlBGm4U0sPWCcvF5TFl0RaG1PfVBf0HtrVrZz2aw/fGFZibvCDHpg3LmcaEtD
p5yqrTmnzIu9BZ1x5DlkUKvNDhd4JMu10kpKl7esNk1dZXKzeO4oh7w2whS1SF1w
4xG1fgRw1l7YBdIFjFflUMqiwEuqpAP+t/kkA5GLk94aS1kzbxHBXxEvV+Kx02iP
1zInuBkCpqTQo7cJkJroTQnDafp22Lm1oDbS4GfblP8BXu6PZhrCcyaqWwlpTabi
HgromEUTHozIzEHzmaDqvU6kLdrRrBEFeSol6utINyQWdHnCiJDLBkoeEoR2i5C+
UHT3BFDUqJaTX4kJxjvzHhjRhKVexdJXSUtavLa/a/cu8looaFPLwSixuy/7H4Xr
IBFTMq15ZrUddocAR32C3UonqsBIBev8eFfG2HEqSb4h8C2WgZ4tegy1AXmW4PHw
j+Dklw8jPE0nAoFa2+Ss09kI+yqyeQbqJS8fyS4FqdKAKpNT0Js26hrQ8DGZJwpN
NGRCgbDAa91AxKrYmz4iv740OTgI69Npysa+SmlWY8RzbAceT35szdMSfG+aNLVl
nJSIrGyPkWTdlCR5jZy3
=gNXC
-----END PGP SIGNATURE-----

--LKTjZJSUETSlgu2t--
