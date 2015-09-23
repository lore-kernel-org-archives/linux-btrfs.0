Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47794 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbbIWOFv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Sep 2015 10:05:51 -0400
Date: Wed, 23 Sep 2015 14:05:48 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: dsterba@suse.cz, Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix no space bug caused by removing bg
Message-ID: <20150923140548.GO5918@carfax.org.uk>
References: <15fc8f8d002e4ffcdb46e769736f240ae7ace20b.1442839332.git.zhaolei@cn.fujitsu.com>
 <560150CD.6070301@suse.com>
 <5601596B.1020607@googlemail.com>
 <20150922134131.GH5918@carfax.org.uk>
 <20150922142333.GH12815@twin.jikos.cz>
 <20150922143602.GI5918@carfax.org.uk>
 <56016BB5.6060101@gmail.com>
 <20150922153930.GK5918@carfax.org.uk>
 <20150923132829.GB12815@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lCFQJunhLz1tFGpX"
In-Reply-To: <20150923132829.GB12815@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--lCFQJunhLz1tFGpX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 23, 2015 at 03:28:29PM +0200, David Sterba wrote:
> On Tue, Sep 22, 2015 at 03:39:30PM +0000, Hugo Mills wrote:
> > > The way I would expect things to work is that a new subvolume
> > > inherits it's properties from it's parent (if it's a snapshot),
> > 
> >    Definitely this.
> > 
> > > or
> > > from the next higher subvolume it's nested in.
> > 
> >    I don't think I like this. I'm not quite sure why, though, at the
> > moment.
> 
> I don't like inheritance from other than the parent subvolume because
> this makes things less obvious.
> 
> >    It definitely makes the process at the start of allocating a new
> > block group much more complex: you have to walk back up through an
> > arbitrary depth of nested subvols to find the one that's actually got
> > a replication policy record in it. (Because after this feature is
> > brought in, there will be lots of filesystems without per-subvol
> > replication policies in them, and we have to have some way of dealing
> > with those as well).
> > 
> >    With an FS default policy, you only need check the current subvol,
> > and then fall back to the FS default if that's not found.
> 
> That looks reasonable to me.
> 
> >    These things are, I think, likely to be lightly used: I would be
> > reasonably surprised to find more than two or possibly three storage
> > policies in use on any given system with a sane sysadmin.
> 
> Agreed. At the moment I'm thinking about all the configuration
> possibilites we want to give to the users. Eg. the inheritance can be
> configurable on the property level.
> 
> The usecase: the toplevel has compression enabled but I don't want any
> new subvolume share this property automatically.
> 
> (The blockgroup type is probably a bad example for configurable
> inheritance as it would not work for shared extents if the type is
> different.)

   There's some major questions about the semantics and the UI for
per-subvol RAID, too:

(Assume that A is RAID-1)
# btrfs sub snap A A'
# btrfs prop set A' raid raid-5

   What happens? Do we convert A' to RAID-5 immediately, doubling (or
more) the disk usage? Do we do lazy conversion, so that only new data
in A' is written to RAID-5? Do we need a "btrfs sub restripe A'"
command? Is directly setting properties actually the right interface
to use here? (Reading properties... yes, but we still have the
possible issues of getting information on partially-converted
subvols).

# btrfs sub snap A A'         # A' is also RAID-1 here: inherit from A
# btrfs prop set A' raid raid-5
# btrfs sub restripe A'
(you wait, time passes)
# btrfs sub snap A A''
# btrfs prop set A'' raid raid-5
# btrfs sub restripe A''

   How do I make A' and A'' pick up their sharing again? Dedup? Will
this cause problems with incremental send?

# btrfs balance start -dconvert=single A

   What does this do? Convert the whole FS's data to single? Just
subvol A? If the whole FS, will all the subvols' raid xattrs be
dropped? Or will only the FS-default ones be changed? If only the
FS-default xattrs are changed, then a write to any non-default subvol
will revert to its configured RAID level, and we almost immediately
lose the "everything single" configuration requested by the convert...

# btrfs balance start -mconvert=single A

   What does this do? (Probably convert the whole FS's metadata to
single -- which may well answer the previous question as well, unless
we want to surprise users).

   I'll probably think of some more questions later, but that's enough
for going on with. :)

   Hugo.

-- 
Hugo Mills             | 2 + 2 = 5, for sufficiently large values of 2.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--lCFQJunhLz1tFGpX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWArG8AAoJEFheFHXiqx3kPv8P+gMld/728zAx5cEZIh4Zltsn
EWhb5bmb9KTJB76pIsz/ZoUB4ciZKGT4bvcdTHUfoVfdtFLxFMAZzjtzMjuOb9Qe
p8qvzgCj4H6waB5J48j85KiAE0IJPh2pYg7oqofEKWAeWc3M4NbdPi9rUijm8rXO
FOplgENxVhKLDqDxoaFOJc6oje4cGnEZp4OPr7xqUZantoH1PRO4VcNBMK6eSxZF
guwJ7IXRPUj6l0Yi3MHGVBSamoDwrniaLTFGbjHdzON4cSc4Ur51HX9s6zKTz9Be
un34K5aBoc5zQh7+1W6gtDEpCizlveevfkt6iIEytEGp8MOgxIzWGZAbEtbmx37N
BbwJpSS+6ZjkztAGF0PQGLnE5CbdksU8sGiTpHoELk5KbKuJUTM4capGP005Oq+D
KtMQMUOK2N4ucSm/5mlW/6QJRQBnpV8uLEWjC64UepA3TAIJaXRoQf3St+LXp9ED
fCx6KPhooQiLScewojNr8/Hr7Z5OhrpSJrabjHLb1e8aT475RdFQrJ63bRBbyuDP
WJDkumJ7ZMeVrUkWWlyT4IQ1vN8dvPi/uxHhtAud7hnhGUuhP6UD4c95hAEwAENZ
HDZVNfXQ6RV7aUPbuoxQ+OveTxy7sOWNP3R4I0TzdFgCJ6w7Z2C70woFeURzMvb5
Y5dbnsps+8aaRJBTJw98
=+CUY
-----END PGP SIGNATURE-----

--lCFQJunhLz1tFGpX--
