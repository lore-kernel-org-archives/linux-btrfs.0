Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47524 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbaDYTPB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Apr 2014 15:15:01 -0400
Date: Fri, 25 Apr 2014 20:14:48 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, Steve Leung <sjleung@shaw.ca>,
        linux-btrfs@vger.kernel.org
Subject: Re: safe/necessary to balance system chunks?
Message-ID: <20140425191448.GJ2391@carfax.org.uk>
References: <alpine.DEB.2.10.1404250842350.2320@cubia.leung>
 <75D8579E-1284-4F12-A573-15D50EFC4614@colorremedies.com>
 <535AA581.1080301@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="enLffk0M6cffIOOh"
In-Reply-To: <535AA581.1080301@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--enLffk0M6cffIOOh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 25, 2014 at 02:12:17PM -0400, Austin S Hemmelgarn wrote:
> On 2014-04-25 13:24, Chris Murphy wrote:
> > 
> > On Apr 25, 2014, at 8:57 AM, Steve Leung <sjleung@shaw.ca> wrote:
> > 
> >>
> >> Hi list,
> >>
> >> I've got a 3-device RAID1 btrfs filesystem that started out life as single-device.
> >>
> >> btrfs fi df:
> >>
> >> Data, RAID1: total=1.31TiB, used=1.07TiB
> >> System, RAID1: total=32.00MiB, used=224.00KiB
> >> System, DUP: total=32.00MiB, used=32.00KiB
> >> System, single: total=4.00MiB, used=0.00
> >> Metadata, RAID1: total=66.00GiB, used=2.97GiB
> >>
> >> This still lists some system chunks as DUP, and not as RAID1.  Does this mean that if one device were to fail, some system chunks would be unrecoverable?  How bad would that be?
> > 
> > Since it's "system" type, it might mean the whole volume is toast if the drive containing those 32KB dies. I'm not sure what kind of information is in system chunk type, but I'd expect it's important enough that if unavailable that mounting the file system may be difficult or impossible. Perhaps btrfs restore would still work?
> > 
> > Anyway, it's probably a high penalty for losing only 32KB of data.  I think this could use some testing to try and reproduce conversions where some amount of "system" or "metadata" type chunks are stuck in DUP. This has come up before on the list but I'm not sure how it's happening, as I've never encountered it.
> >
> As far as I understand it, the system chunks are THE root chunk tree for
> the entire system, that is to say, it's the tree of tree roots that is
> pointed to by the superblock. (I would love to know if this
> understanding is wrong).  Thus losing that data almost always means
> losing the whole filesystem.

   From a conversation I had with cmason a while ago, the System
chunks contain the chunk tree. They're special because *everything* in
the filesystem -- including the locations of all the trees, including
the chunk tree and the roots tree -- is positioned in terms of the
internal virtual address space. Therefore, when starting up the FS,
you can read the superblock (which is at a known position on each
device), which tells you the virtual address of the other trees... and
you still need to find out where that really is.

   The superblock has (I think) a list of physical block addresses at
the end of it (sys_chunk_array), which allows you to find the blocks
for the chunk tree and work out this mapping, which allows you to find
everything else. I'm not 100% certain of the actual format of that
array -- it's declared as u8 [2048], so I'm guessing there's a load of
casting to something useful going on in the code somewhere.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- Is it still called an affair if I'm sleeping with my wife ---    
                        behind her lover's back?

--enLffk0M6cffIOOh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU1q0KFheFHXiqx3kAQIc3A/9FZUHaWJb/shd7ozGkqCqpaQb1GcjmYAs
X/oDutCrzdmOFdw0lbahx3h0NdCIc/Yyg9uAQ4KyIDHt/oktpNk0LdmxoQUDbMBN
oSoTFqcZKygwEPwW43EbCkeByIzxGZGZcHLpRPdbq94Hz+o33UnqxcTvKusCCtqw
N57zcdtGlTWWVI6bmvGbdTEgf0xfwQy/vn/jZBKi0vV4uHulM06oLuI0q4NMCD7Q
cobSVIHiR2atDUKrATG26gZ+LLu+wLZCatm+PjznzA1D9/Ifpg4wLAYLoe/myyvx
YP+mgnT15rIerB0UbsKAQN1ClHme6L8JkCdprE51j046S0XOUOpnYFTGqmBSZdm9
BSQjG1AyOXSF7a3FqGIIg+8zii8+yFIESClDOYrSRkwm99o4W7Hb50cZEBJ3it5q
11UzEZTa01MyepjEnaBK1bd7LtQQzSvvZm/SJWe9JXG1NQ8OYfhjDXGDu7M2v1Wf
qWUX5OnMHrD5XuiYcNeyQVAKsi1o90m1WvIlJuRJRAcBwL+i7D/Eu+xRl9fd5l7x
ilp75GTOTYffKlU1IG9NtId/S24Jv3wmDvBHAurymoPFiyYSNVWKjwb6Zl0aBXDj
MW/YhcotF2n8jCfHLMJEN+byot48GukAcZZA6sP80aUBt14dBkJJb5FgjmxhL+Oe
AIcy+4ul7G4=
=qwPd
-----END PGP SIGNATURE-----

--enLffk0M6cffIOOh--
