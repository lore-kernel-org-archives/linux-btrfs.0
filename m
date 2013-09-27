Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:46107 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab3I0VN1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Sep 2013 17:13:27 -0400
Date: Fri, 27 Sep 2013 22:13:21 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: extlinux and btrfs RAID-1
Message-ID: <20130927211321.GE28147@carfax.org.uk>
References: <20130927193655.GC28147@carfax.org.uk>
 <1487829E-FBAE-4405-93DB-94AD30EEE144@colorremedies.com>
 <20130927204419.GD28147@carfax.org.uk>
 <EDAE452B-D4F1-4027-9FC3-C3EF251F8430@colorremedies.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0H629O+sVkh21xTi"
In-Reply-To: <EDAE452B-D4F1-4027-9FC3-C3EF251F8430@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--0H629O+sVkh21xTi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 27, 2013 at 03:04:22PM -0600, Chris Murphy wrote:
> 
> On Sep 27, 2013, at 2:44 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> 
> > On Fri, Sep 27, 2013 at 02:12:36PM -0600, Chris Murphy wrote:
> >> 
> >> On Sep 27, 2013, at 1:36 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> >>> 
> >>>  When I boot the machine from its disks, I'm being told that
> >>> extlinux only supports single-disk btrfs. Is this still the case?
> >> 
> >> I'm pretty sure the answer is yes. The last time I looked not that long ago the multiple device scenario wasn't supported.
> > 
> >   Dammit.
> > 
> >   Thanks for the info. At least this means I don't have to struggle
> > with the syslinux error I've been getting... Back to grub, then.
> 
> I'm seeing in changelogs that 4.0 brought btrfs support, 4.06
> brought subvolume support. Nothing in changelogs for versions 5 and
> 6 so far inclusive. And interestingly enough, Fedora's koji only has
> 4.05 current for F20 and rawhide.

   Yeah, Debian have 4.05 in everything except experimental (which is
6.02~pre16).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- I'll take your bet, but make it ten thousand francs. I'm only ---  
                       a _poor_ corrupt official.                        

--0H629O+sVkh21xTi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUkX08FheFHXiqx3kAQLXwQ/8CZy7hECR6Mzc+nPjJsQy2hDSe4zfdXcl
ABUjswhrP+2W6VUJ1PnkySWde1xGHXeb170fQ8TbS34G8rq3yBXWdJZxD5w/KhUf
71iUrjSGwJ/334tWr9C08wXUje0QK1dnnYSZ9wtI4qPOGkCbEJ/Tk/kBrnOKbsE7
16x+Ge5YgDzhJBnvaO1VWXTOO+4tS2JbSe8BEZCMXkZ1sg6eBF+QAt63lD0TpO3a
GqX06LUOdm1tJVjTWuNcgvAg0auLY1EW8sOJk0k47Fam0+pW9r55+VCG6HmxRrnx
zCc+P8fq7DJ40bP9PEIhhWuF+Aw+ms6ATur3BgNeyAxfGKcN4l1u/F70hnoL3TOn
xW8yDjVuLA7MQlRwQgXhBDZrh0BNFXwJ03v2blxxAqBbsgel2H33dpsz8O1jW2Ah
z5S8HCQhwkFATUD3P8WCxMrtIuT778QicJiElgBF0ToWlsLTnWGZBc6pBNpvIsMn
BjbwQO+wkL0WFiHPulLCB8ZYWZefA+QoDGlYtfdm5NZd4458FU8SDjL3iXwBjqr2
pJZ90bPztod0nhse2Ka+f2UH7q7Grt+PH2QAc0gr08dvxjsUyCBJUaJo9oITUQIN
KcBWKiUntXatrqqGvdTPXGXe4sPkrOOv5D+rMVy/nUuNjGXgRfGxJKaEiuF3YqDM
516WX/u41XU=
=pXfE
-----END PGP SIGNATURE-----

--0H629O+sVkh21xTi--
