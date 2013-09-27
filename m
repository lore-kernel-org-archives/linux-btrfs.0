Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:45903 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab3I0UoW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Sep 2013 16:44:22 -0400
Date: Fri, 27 Sep 2013 21:44:19 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: extlinux and btrfs RAID-1
Message-ID: <20130927204419.GD28147@carfax.org.uk>
References: <20130927193655.GC28147@carfax.org.uk>
 <1487829E-FBAE-4405-93DB-94AD30EEE144@colorremedies.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lc9FT7cWel8HagAv"
In-Reply-To: <1487829E-FBAE-4405-93DB-94AD30EEE144@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--lc9FT7cWel8HagAv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 27, 2013 at 02:12:36PM -0600, Chris Murphy wrote:
> 
> On Sep 27, 2013, at 1:36 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> > 
> >   When I boot the machine from its disks, I'm being told that
> > extlinux only supports single-disk btrfs. Is this still the case?
> 
> I'm pretty sure the answer is yes. The last time I looked not that long ago the multiple device scenario wasn't supported.

   Dammit.

   Thanks for the info. At least this means I don't have to struggle
with the syslinux error I've been getting... Back to grub, then.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- It used to take a lot of talent and a certain type of ---      
        upbringing to be perfectly polite and have filthy manners        
            at the same time. Now all it needs is a computer.            

--lc9FT7cWel8HagAv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUkXuI1heFHXiqx3kAQLYGRAAqOxvRRFZDNEwyCn8soDY+DPFVflKozxT
C15lZmZhMzFbaVbOnMYGn4cneKkVWBXJujEKfcuirDzbs4MvvqrPEZgO9jJVt+XS
LUGKwHrK+v74QbpEi2Kt5Ewu1jRvpPNPvim917UXgjCix7RPAlUkKyg3waJrgr1P
TpVJmN44TGuLQBfYtA2L6b9BY0TlfKmtQb9DEPbdwIepiHomRGbldgd80dVDfVTg
H/hFrd2kjNRt4UfW86ep4+hkWzw71YQhdQHAFxddELYhfk4V3SkQmUo92C3kr4ju
juxmLvvMlGs9bOirVBd7wfAMFmnZmwg/CCkutCNaKJKNimfIku9Ft+iQbP4EJdgI
boe5of2FTFdu6jF6/VfUxGzINW5v3WpXdw62lVbcVDF0gAPP28yizdvyhFWMjuJI
p8HRd0y6C7VVyVb22PGGQBj8NAbu7cm7S/3ujcNe6t85PNiwTX/5yMbBS/QsD5yY
L79zIMIc7bfUbCq9wunTybGcl1Vtlztjv6ffWq9GsfPA3JwdonhLghbL0eR5Wspt
taCXXgv6kTfkk3UyDW7C96XdsniNREKG6Kls2U8k5hyemgIYlVZkjQX7pwgxEZgQ
J29QnbV4+J9Q9dFn1rgIpUl5OAqfZMgpnTj15YXRiKP8v8HQRZ/82Jbs3haAm/ts
IF5arOe6boU=
=DrJC
-----END PGP SIGNATURE-----

--lc9FT7cWel8HagAv--
