Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:48292 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639AbbJARqR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Oct 2015 13:46:17 -0400
Date: Thu, 1 Oct 2015 17:46:15 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Sjoerd <sjoerd@sjomar.eu>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: RAID5 doesn't mount on boot, but you can afterwards?
Message-ID: <20151001174615.GK25907@carfax.org.uk>
References: <1627746.fEEz2JqgZk@hoefnix>
 <pan$b6f45$856590$f682594c$bd5aae60@cox.net>
 <1787237.MVYq6GNlXh@hoefnix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ogUXNSQj4OI1q3LQ"
In-Reply-To: <1787237.MVYq6GNlXh@hoefnix>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--ogUXNSQj4OI1q3LQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 01, 2015 at 07:04:43PM +0200, Sjoerd wrote:
> On Thursday 01 October 2015 02:21:23 Duncan wrote:
> 
> > That's very likely because unlike traditional single-device filesystems
> > (including single-device btrfs), multi-device btrfs has multiple devices
> > it must know about before it can mount the device, while mount only feeds
> > it one device.
> > 
> > There are two ways to tell btrfs (the kernel side) about the other
> > devices.
> > 
> > 1) Do a btrfs device scan before trying to mount.
> > 
> > 2) Name the component devices in the mount options, using the device=
> > option (multiple times as necessary to list all devices).
> > 
> Option 2 was to simplest to check and that works. Thanks for the tip!
> Still weird that my single devide SSD BTRFS bootdisk just worked fine 
> (althought it's using the uuid offcourse)...But it would imply to me that 
> there's a btrfs device scan run before mounting it.

   Not really. A single deice FS doesn't need the scan.

> Before I created the RAID5 I just had the four disks configures as JBOD in 
> btrfs (I used partitions that time though) and mounted it just fine with the 
> LABEL only, so it might be something with RAID5.
> 
> Anyway it's working now with just a much longer fstab line ;)
> 
> Cheers,
> Sjoerd
> 

-- 
Hugo Mills             | Vote early, vote often
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--ogUXNSQj4OI1q3LQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWDXFnAAoJEFheFHXiqx3kvr4P/21pDWp8lIoSL06ZDVMsPJxW
1v1gIepvVRaygEtVZvq/IVS1MVlhSgnC90VvVoO/cSyS3KoYFZDkMEmXyhs4oCNm
Why7Y5bPRsHiexl03TZI++SFlVvWC/1xAy7Y6I+g7DdNU1WlwTnlSzAZJjKoJKHU
en6y8viEDYhoCb9cqgsyzdy8JGeah63vK6A0jS+tp4BUW4DgxiqR+WwR6K6zLNzR
4tEB35BnAx0q91UsapCVy+gpfGYTLNHtInBIIohpkNJNPQA8deq68sB3VcXraWfI
QA/s0s/LnerCyiKGLE9cLteMfQZhMHTabeUEJYIPyyb/j8oB/Y/eHbKX6Yli0TWG
PK5GBZdgzEXROU1dUUCiZKYshjYlw7wxzORPojbHWiV5RrAwglzxPYSMS7Oi0Ciu
srPaQ/pf886715XyucLAils1kDyzTAJiklxJPfljNu/FO9/lGXJSFowoNscX28w4
SltlY6UUuIB2eTrZJriUxTDuCzRRFP2t7ja+Cf1i04Wx3QMtVc3RYu1/iuif0ZpP
c2YbkiSzrjC8JwZkwQcZ2/LX3v/b98WV/QgIHemv9r7+d2aONWAhJ4w9Zx+PW5VC
wIr/Szgb7q6+CP6HOhVJi7OpboHret7/Ovj0uwDzohZSO0eZsEdv38ykztmf2lVK
fEVNnNb6m1zejcyWs/Z2
=ycz7
-----END PGP SIGNATURE-----

--ogUXNSQj4OI1q3LQ--
