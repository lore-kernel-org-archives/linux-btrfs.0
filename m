Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:43736 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108Ab3BFWV0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Feb 2013 17:21:26 -0500
Date: Wed, 6 Feb 2013 22:21:22 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Michael Schneider <mike2.schneider@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs balance -> hang/crash
Message-ID: <20130206222122.GB28997@carfax.org.uk>
References: <CAGRMg0kYWUf5rh0WXNc+++9gG+XZ0-n9_SWpVh8jRHN-_2DfXQ@mail.gmail.com>
 <CAGRMg0nmjsMNp1psLzMnf77HWP2Zynj3fWAA1c0DGkFTgvWx+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bn2rw/3z4jIqBvZU"
In-Reply-To: <CAGRMg0nmjsMNp1psLzMnf77HWP2Zynj3fWAA1c0DGkFTgvWx+g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Bn2rw/3z4jIqBvZU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 06, 2013 at 11:12:14PM +0100, Michael Schneider wrote:
> Hi,
> 
> my btrfs "hangs" when doing a balance operation.
> 
> I'm using a 3.7.1 kernel from opensuse:  linux-opzz 3.7.1-2.10-m4 #11 SMP
> PREEMPT Fri Jan 11 18:04:04 CET 2013 x86_64 x86_64 x86_64 GNU/Linux
> and Btrfs v0.19+
> 
> I did a scrub which completed without errors. Then I tried "btrfs filesystem
> balance /" which work fine for the first 23 of 46 chunks, then ist stopped
> processing further chunks, but contiued to consume large amounts of the CPU.
> The system logged filled quickly with messages like:
> 
> [  347.237658] btrfs: block rsv returned -28
[snip]
> Any idea what's going on?

   You're running out of space. Can you post the output of:

# btrfs fi df /mountpoint
# btrfs fi show

this will give us a bit more info about likely scenarios. Also, josef
published a patch(*) in the last few hours, on this list, which may
help deal with the issue.

   Hugo.

(*) Btrfs: rework the overcommit logic to be based on the total size

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- What do you give the man who has everything? -- Penicillin is ---  
                             a good start...                             

--Bn2rw/3z4jIqBvZU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBURLXYr9z9OVl50rAAQI/+A//ZpJ3WfTD9HdGZhy1K8wNzc7gC3t8IcSD
/xiyzdFZnP3i1wpOvZHy8adnzvVxP93LppgvI2Obcq0nF/jQVZ30PPMI/GgtZAeI
VBQcZgqL5+EUmGBa2QmSCbdv7hjD8YcUbf70qxEq+GWhWS2F2O6wiKTc9z89FGpR
k8nkQAYJoIssYdwGEs4Fi8ZGqYDFKqfVzeGRFapdt/CIBKTlvCkRKiop/qNWQbAJ
bg3j2DCY2g6F3nympxJujhRErXaqTuyh6hTF+tLbwrOKodanvl4eteoy0YpXloOR
PmYMaFWBcvid/STQcowIGvwnij1vsW6MD2grJ7VCwLOCNEQh6iDYyvdLGk8cF73V
9yAnC9nZOVTeOwYBKW9fSflHQhqP6TgeKRpRABq4/7P1jUgtjHxFPiD6Gomu00uD
DF0sRgSN+iRWw0zy4BnWA0LY8vPDEueIGoA0SfVi12nPa/3sAgABNgMmjuHdynzf
BmIqRH8pXZchtBS7qFy1GHYBQ12aIg6lEedIRB6FPQaNMqfbl67lQq0xjTvxqUD1
1oPYBCQ0IAP3rfofkKJDRGECnbcSNGDMx9Yvmjk8zX91/LdSnHQq1+RsvxeXJxa7
fFqqh1YmBwmNPvm1ENrcH4ZHdadp7iB8B7F0XJf0ijFYpwyGEjJG9GqOjvL9waJ7
zcJiUTetOhc=
=bFzG
-----END PGP SIGNATURE-----

--Bn2rw/3z4jIqBvZU--
