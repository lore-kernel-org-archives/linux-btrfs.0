Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:34483 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965130Ab2JDOtg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Oct 2012 10:49:36 -0400
Date: Thu, 4 Oct 2012 15:49:32 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: "Ken D'Ambrosio" <ken@jots.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Will RAID have issues with disks that spin down?
Message-ID: <20121004144932.GH25498@carfax.org.uk>
References: <d33ad0cb427c4885092e4440b5a140cb@jots.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RwGu8mu1E+uYXPWP"
In-Reply-To: <d33ad0cb427c4885092e4440b5a140cb@jots.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--RwGu8mu1E+uYXPWP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 04, 2012 at 10:36:43AM -0400, Ken D'Ambrosio wrote:
> Hi.  I know that several hardware RAID solutions have issues with
> disks that spin down when idle; the time to spin back up -- usually
> on the order of five seconds -- causes unhappy timeouts, etc.  I was
> wondering if that would be an issue with RAID a-la btrfs?

   I have (some of(*)) the disks in my 8-drive RAID-1 btrfs array set
to spin down after 10 minutes of no use. I've not had a problem with
it so far. So I'd say it's not an issue from my limited testing.

   Hugo.

(*) Damn you, Samsung!

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Great oxymorons of the world, no.  3: Military Intelligence ---   

--RwGu8mu1E+uYXPWP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUG2h/L9z9OVl50rAAQLL2hAAm8XXDMKTDzs6UdhRXDZNj5OESG7d07J/
AbuWmR3PLkiYWPZBc9ml9TaWUjI4ox9dUoZaNYYm941kXN6cIl0RLLGtRE96VH76
DipPyvP6NIv7cLyQHcozOpUVGrjO5+wKPNwmc4jApiXibt55avto+ULB1KmqhP5s
UzpT1HA58De1ueALqPnDCUi0F0xtTNbRrbahwoaJOoeU3nDZ082z4WmPVh1mpqcA
+mf5DDxPXBBXwphO0byET8qSid7hr9j9rvJPmYLb1ejEGEqkd37M8Kjyfh4xYMhJ
0Fy4+DqUFHq34+s+M+LsWBzGhk8x607lia9/CSOxECehDtHN5I3q3iejsDTBR2Lr
KpyRmnSS3OQIR9VwTMUK9wrXiImWit6IaNsnUUFcwK8CYRNWDO3Uf4nP5PL3Wbg6
o7tfqAxACHIwiQL13bptzIdO8nRBgXktdWFbSashIh/QVsrrz0Imb+4q25wL/s1R
ldo3ICI0FbpC3mycGIGxrb21i/fqhuYlRW2AXAPdQjANscGuOezC6Rs/v6/G27Bw
1VkI8yQeWziqDwkX7Az+wpPd4VXmDF+WMvaRjZfq2Gh1JZA3RVQh9oGFRO8wUJrE
cZrffcXIQdi2N2cvfRRs9VffdyKauPvxaikN6Lcuf4uH5g5/ExEjdPpdU44aSLWU
V/4nm/t4b5A=
=0Ox/
-----END PGP SIGNATURE-----

--RwGu8mu1E+uYXPWP--
