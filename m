Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:42030 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbaEJBJN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 May 2014 21:09:13 -0400
Date: Sat, 10 May 2014 02:09:02 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Marc MERLIN <marc@merlins.org>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs cleaner failure - fs/btrfs/extent-tree.c:5748 (3.14.0)
Message-ID: <20140510010902.GQ16185@carfax.org.uk>
References: <20140507233959.GB11401@merlins.org>
 <536AD20E.70004@fb.com>
 <20140508004344.GE11401@merlins.org>
 <20140508013440.GH11401@merlins.org>
 <CAKgsxVR=6GTesbtqG_SAyKnpw9pxz1TZ0oOi_MB8Ej3j4-vMiw@mail.gmail.com>
 <20140508220242.GO11401@merlins.org>
 <CAKhhfD5DTPfKvWcRDERxWa_pjfhCkZxW3WBtznYC94EFy7A0mQ@mail.gmail.com>
 <423AB9BE-EDBF-478B-8CED-C1A9A0FAE736@colorremedies.com>
 <20140509223659.GW11401@merlins.org>
 <0AE72D68-224C-4B12-9C9B-3B7628174ACB@colorremedies.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oDto3OTLsk6uOlQH"
In-Reply-To: <0AE72D68-224C-4B12-9C9B-3B7628174ACB@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--oDto3OTLsk6uOlQH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 09, 2014 at 06:00:50PM -0600, Chris Murphy wrote:
> Well I'm sorta dense, so I only find a complete dmesg useful because
> with storage problems it seems much is due to some other problem
> happening earlier. 

   Life would be so much easier if filesystems didn't store any
persistent state... :)

   The number of people who don't quite get that that's the function
and natural behaviour of a filesystem is... surprising. 

   As in, "Your filesystem got corruption as a result of a bug in some
earlier version. Upgrading to the new version isn't magically going to
make that corruption go away". (Not saying that's what's happened
here, but it's common, and commonly misunderstood).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- The makers of Steinway pianos would like me to tell you that ---   
                          this is a Bechstein.                           

--oDto3OTLsk6uOlQH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU218LlheFHXiqx3kAQISGBAAo7sMiKarTTuTuLof8inI7BZQNLPNZC8Z
VwkmK4gvyFKvpP9saTl+zKQUPZx36Ieg6MCdLt+D8fNS6sMEFXDRDlzb3kifmKSL
xC+lo01ezvdkj2cruJhAOw3gSnH89/uL2huUAjrQpbQU7ZKFy7L+TIsDOij4cZXy
0FgoBZRlVKXJy1zU0bshIE1hMJMiLacbS9/M7rn3yy0K7c2Bge0lENZgDhQCe8LU
zs3W4RWf/MjKgDSGF0d7jOrnHVdFLCUaRDnSuS1fzknXqU4bXkENfK1UPQcaP9WZ
+qgbub3vI60451l+LLH/z9TzMIWcsqHm2ZBk9mwhzjZH6lUbs1JEpl5fN2Cfynz+
3UxdhBbI60LUJ4Zu3yJ+Z0xXtVZHRlKGLvIVPM3TMQKXOiuq142alH0O0tHhpQFt
3cMMghGX/z1o37bLYKJiDFRiFi9eUYt3OHVe34HPDneTHSwQ4j0qlOB+iclAYydP
gTs/uS7Ie1IBVHbs7TUOZ1uCrF+faSFg7HQR+ETa7zAfSO/J3BKEOxdXzCXl2TQe
o3pI7rrxE5wvtRXWy6IxyXxjAtrR+3WDRrgkQR+yKsPGNwdhkjZk8NO8WfCI6QLT
lRevwaOOLzNOcchHXNgR990z37g+hQhXF9VwDUt3g9AjB5RZmOtI3DSM+xy05YXN
1r/asR3H0Tc=
=zckd
-----END PGP SIGNATURE-----

--oDto3OTLsk6uOlQH--
