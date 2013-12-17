Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:54344 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab3LQImM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 03:42:12 -0500
Date: Tue, 17 Dec 2013 08:42:06 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Nicolas Michel <be.nicolas.michel@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, linux-btrfs@vger.kernel.org
Subject: Re: Understanding subvolume hierarchy
Message-ID: <20131217084206.GC11281@carfax.org.uk>
References: <CAO5znau9bYtjLmcwSE9uD7tRo0uY_CLHhLNCoYW7cpRLJtve-g@mail.gmail.com>
 <ABF7C191-D33A-4DE2-9E31-D44B7CE16475@colorremedies.com>
 <CAO5znatm9bKq2a3WBSAZTEPjHQgS3DZpRwGY7pDsyN9J1WsWNQ@mail.gmail.com>
 <D3F43FCF-1262-4324-B342-7DB2359B12FD@colorremedies.com>
 <CAO5znavUobuaWtUXhm2eYyuj+KfFVrh5k5Lz_PaHrxYrzhxG7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/Uq4LBwYP4y1W6pO"
In-Reply-To: <CAO5znavUobuaWtUXhm2eYyuj+KfFVrh5k5Lz_PaHrxYrzhxG7w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--/Uq4LBwYP4y1W6pO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 17, 2013 at 09:30:11AM +0100, Nicolas Michel wrote:
> Mhmm. Thanks. I'm begining to understand ;)
> Still : how can I see/know that id 5 is mapped to id 0 ? And why doing
> this? For what purpose? (is it a default btrfs behavior or is it set
> by the Ubuntu installer?)

   It's always mapped.

   Internally, every tree is identified by a number. FS trees (e.g.
subvolumes) start with numbers allocated dynamically from 256 upwards.
Other trees (chunk tree, extent tree, and all the others) have fixed
"well-known" numbers between 1 and 255, and the top-level FS tree is
given the number 5.

   To make things marginally simpler for the user to remember, there's
special-case code which looks at subvolume IDs passed from userspace,
and converts 0 to 5. This is all btrfs behaviour -- nothing to do with
Ubuntu.

   Hugo.

> 2013/12/17 Chris Murphy <lists@colorremedies.com>:
> >
> > On Dec 16, 2013, at 4:54 PM, Nicolas Michel <be.nicolas.michel@gmail.com> wrote:
> >
> >> OK. thanks for your pretty fast answer :)
> >>
> >> Now my last question is: in this case it was "easy" as I know that I
> >> created all these subvolumes as parts of volume 0. But in the btrfs
> >> subv list / I don't see any information that tells me they belongs to
> >> id 0. If I have to debug a server/desktop and I don't know the
> >> hierarchy that has been made, how can I know that my tmp subvolume is
> >> indeed a child of id 0 ?
> >
> > When you do a subvol list it shows you what its top level is. Example:
> >
> >
> >
> > # btrfs subvol list /
> > ID 256 gen 1047 top level 5 path root
> > ID 258 gen 983 top level 5 path home
> > ID 259 gen 983 top level 5 path data
> > ID 276 gen 1012 top level 5 path root_ro
> >
> >
> > root is mounted at /
> > home is mounted at /hoome
> > data is mounted at /data
> > root_ro is not mounted at all
> >
> >
> > #cd /data
> > # btrfs subvol create data2
> > Create subvolume './data2'
> > # btrfs subvol list /
> > ID 256 gen 1047 top level 5 path root
> > ID 258 gen 983 top level 5 path home
> > ID 259 gen 1048 top level 5 path data
> > ID 276 gen 1012 top level 5 path root_ro
> > ID 277 gen 1048 top level 5 path data/data2
> >
> > # btrfs subvol list /data
> > ID 256 gen 1047 top level 5 path root
> > ID 258 gen 983 top level 5 path home
> > ID 259 gen 1048 top level 5 path data
> > ID 276 gen 1012 top level 5 path root_ro
> > ID 277 gen 1048 top level 259 path data2
> >
> >
> > So notice that "top level 5 data/data2" means the same as "top level 259 data2" because top level 259 implies data.
> >
> > You can also use btrfs subvol show <subvol> and it will give you more information including whether it's a snapshot, what the parent is; and if it's a parent that has snapshots it'll list the snapshots.
> >
> > # btrfs subvol show /data
> > /data
> >         Name:                   data
> >         uuid:                   bc45f4be-51c9-2848-bb68-d6e922b8e2bd
> >         Parent uuid:            -
> >         Creation time:          2013-12-12 16:18:13
> >         Object ID:              259
> >         Generation (Gen):       1048
> >         Gen at creation:        11
> >         Parent:                 5
> >         Top Level:              5
> >         Flags:                  -
> >         Snapshot(s):
> > # btrfs subvol show /data/data2
> > /data/data2
> >         Name:                   data2
> >         uuid:                   a66eddf9-107f-0448-a021-da417a982827
> >         Parent uuid:            -
> >         Creation time:          2013-12-16 17:11:36
> >         Object ID:              277
> >         Generation (Gen):       1048
> >         Gen at creation:        1048
> >         Parent:                 259
> >         Top Level:              259
> >         Flags:                  -
> >         Snapshot(s):
> >
> >
> >
> > Chris Murphy
> >
> 
> 
> 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- You can't expect a boy to be depraved until he's gone to ---     
                             a good school.                              

--/Uq4LBwYP4y1W6pO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUrAOXlheFHXiqx3kAQIg0hAAnMf4JhEBiKJ9xa/i9lrFsicXnsHa6SJt
hhhjZUd9dqbVtTm+Hze1dzZag+h2Rdb2nCJwpy2o9h6R+PZOGTRyOEUEu/h+bpCk
CQcOm+gHzWJPa1PWtDrmcLw79X9ZY5QEdN59hsRhTgGzJd07cW84pustQpPM3U63
ieYYgxzfawpxuoCBVOCUayyWKtWAgib1KM0WJ6iYnkw7LWw/+ywH94fTNp9t0bxV
XeFm60A7Wzx8YBWwmaaIUYszSiMpoMJc/VGHa8nYqro5I+/hfQe92xb2m9qOPPaQ
2cPyjKFFFn7ZjbltpOHSoSliOu2J6lJZFtQJ6f5VJMc81uYcMvFjtITMII1alZsf
0+pduHY/uR6muiVZc9Atfu+OFBp020QJcg+JD0R4YCvaqTYJ1X0uSAg7oWgKWLhU
yq1O9Q8tZz9WFUCYHoY5sqmWn4w8LT18QcHBsxtGGU4Vf0Y2XuFWlGsbMseGnAcK
WRkibLILd1jIYrEEPRouUFQ8mZpMu8YYqiw7R3UfFWBk2stdI5OvCGs0RbVDPrvk
ScLRjvApBHB8mqpTNJ2ZYtVXscj9vRatsqzcRIgvE66XEdrq1bVrkblWK5hS4jih
aL50hPuQMs2gkiUiwrAnsqvW20xt0SznQLyegep+K0l4mzAGDtgwSNZzDNtbvw0T
GM51s7VETLE=
=Itxt
-----END PGP SIGNATURE-----

--/Uq4LBwYP4y1W6pO--
