Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:34686 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752236AbdG1ShU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Jul 2017 14:37:20 -0400
Date: Fri, 28 Jul 2017 18:37:16 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: William Muriithi <william@perasotech.com>
Cc: Roman Mamedov <rm@romanrm.net>,
        "Konstantin V. Gavrilenko" <k.gavrilenko@arhont.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs + compression = slow performance and high cpu usage
Message-ID: <20170728183716.GW7140@carfax.org.uk>
References: <33040946.535.1501254718807.JavaMail.gkos@dynomob>
 <8446582.541.1501260065690.JavaMail.gkos@dynomob>
 <20170728224835.41c98aea@natsu>
 <DM2PR08MB701E0AB9CC2DFEC6CB88C8DCEBF0@DM2PR08MB701.namprd08.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="JvcFcSNq1wOCYqbI"
In-Reply-To: <DM2PR08MB701E0AB9CC2DFEC6CB88C8DCEBF0@DM2PR08MB701.namprd08.prod.outlook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--JvcFcSNq1wOCYqbI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 28, 2017 at 06:20:14PM +0000, William Muriithi wrote:
> Hi Roman,
> 
> > autodefrag
> 
> This sure sounded like a good thing to enable? on paper? right?...
> 
> The moment you see anything remotely weird about btrfs, this is the first thing you have to disable and retest without. Oh wait, the first would be qgroups, this one is second.
> 
> What's the problem with autodefrag?  I am also using it, so you caught my attention when you implied that it shouldn't be used.  According to docs, it seem like one of the very mature feature of the filesystem.  See below for the doc I am referring to 
> 
> https://btrfs.wiki.kernel.org/index.php/Status
> 
> I am using it as I assumed it could prevent the filesystem being too fragmented long term, but never thought there was price to pay for using it

   It introduces additional I/O on writes, as it modifies a small area
surrounding any write or cluster of writes.

   I'm not aware of it causing massive slowdowns, in the way the
qgroups does in some situations.

   If your system is already marginal in terms of being able to
support the I/O required, then turning on autodefrag will make things
worse (but you may be heading for _much_ worse performance in the
future as the FS becomes more fragmented -- depending on your write
patterns and use case).

   Hugo.

-- 
Hugo Mills             | Great oxymorons of the world, no. 6:
hugo@... carfax.org.uk | Mature Student
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--JvcFcSNq1wOCYqbI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZe4RbAAoJEFheFHXiqx3kUeEP/2qBh8RZQmk7QsQdHQZeujPK
SgbMJuvxUE1i6aWTEQMqJ9ToV9DqfOpgoLlLLrynBE5+7MyPpT+y1rdBuQyRdNDz
qLeqaLVM5TA2pIZTtzrqMkXG7OxXA4LJs0d/lW97PR56KBll3q9pLqqfDRrs/To9
fmAZazbs68itGBK0Vgz0SLdUk+Opm+ShtwBqlMNlp3x1o5B0QgrIC2kjMyt0+cRe
mOE7YdoOYvp98wTvI/d1r7ac/ZWTI5GoPQWeQnzR/XC56LG2yYyMgawteQ2Yj+6a
vw5JIRA3bKiEfzRSJTxxmq1w3NKfK87kvpV5vt2xSRZBATWkskCr/f0ttdqTPS8N
8Sepea7+jhPDRuRoZgw665i51Bd3CCsAOPm2Hw1SnlJ3xmAjjjZ7OLvQFGyX9QI1
8R5PSfAYo5xBpj3kEQiJoyPzyEzXbnEYNiBi1trfoppxX3tWEO5GFI0KtsaxZ2UA
yo4n4wNlKRoeW4vrkXDE5qO1GtpeaxwXMsF2taDucGOCw3ARPHcVAUEfIbVhse7h
V5np8kW7UJcHtw/GSld23WIQfVwyz66AjA7iBlkSXKclV0GvHyB58dERndyh9xsr
ZNlJKqgEjmlfhcDWd4EJMUv2V3pr777RscMrqVMD+m7Rc5Ec0UIAkTAGJ/E+jvU6
t2MDLaKaOK8tLsY/bi7e
=Tec0
-----END PGP SIGNATURE-----

--JvcFcSNq1wOCYqbI--
