Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:37949 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755433AbeCSNIB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Mar 2018 09:08:01 -0400
Date: Mon, 19 Mar 2018 13:07:59 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: dsterba@suse.cz, "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: mkfs: add uuid and otime to ROOT_ITEM of
 FS_TREE
Message-ID: <20180319130759.GD17966@carfax.org.uk>
References: <7ca269db-a724-5938-f4d8-b85e893fd558@jp.fujitsu.com>
 <20180319082010.GC17966@carfax.org.uk>
 <20180319130222.GE6955@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="jCrbxBqMcLqd4mOl"
In-Reply-To: <20180319130222.GE6955@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--jCrbxBqMcLqd4mOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 19, 2018 at 02:02:23PM +0100, David Sterba wrote:
> On Mon, Mar 19, 2018 at 08:20:10AM +0000, Hugo Mills wrote:
> > On Mon, Mar 19, 2018 at 05:16:42PM +0900, Misono, Tomohiro wrote:
> > > Currently, the top-level subvolume lacks the UUID. As a result, both
> > > non-snapshot subvolume and snapshot of top-level subvolume do not have
> > > Parent UUID and cannot be distinguisued. Therefore "fi show" of
> > > top-level lists all the subvolumes which lacks the UUID in
> > > "Snapshot(s)" filed.  Also, it lacks the otime information.
> > > 
> > > Fix this by adding the UUID and otime at the mkfs time.  As a
> > > consequence, snapshots of top-level subvolume now have a Parent UUID and
> > > UUID tree will create an entry for top-level subvolume at mount time.
> > > This should not cause the problem for current kernel, but user program
> > > which relies on the empty Parent UUID may be affected by this change.
> > 
> >    Is there any way of adding a UUID to the top level subvol on an
> > existing filesystem? It would be helpful not to have to rebuild every
> > filesystem in the world to fix this.
> 
> We can do that by a special purpose tool. The easiest way is to set the
> uuid on an unmouted filesystem, but as this is a one-time action I hope
> this is acceptable. Added to todo, thanks for the suggestion.

   Sounds good to me.

   Hugo.

-- 
Hugo Mills             | Talking about music is like dancing about
hugo@... carfax.org.uk | architecture
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                           Frank Zappa

--jCrbxBqMcLqd4mOl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJar7YvAAoJEFheFHXiqx3kjQUP/06ibL3Kw5XYV3VelyaYqoWL
cDGqGZ/Eue3t9donG8B6cE8mvy0DGBhpbrBP513KmWwyXsciXZDqgY4JFsY2TKll
s/sv2iLE9dp7TJlsyCddUP5wUBcKZikpE8mDeipk37pOrQ8Eo/xQuvXF0xCikjVk
VQGhr8pqupSaRIHCdg8hQwrwZNGG8Bi8yd3VQ4GZaxb0pkHlB/Asem96LBkxUAi9
CdI0/V/oVx9AWiWMzdCt9XDaZ+0d5sdSIxjo/gimAoTiLbbMUp+Apg+xhpwr1B1e
b4rAoyWEfQgZg73NLW3/gpA8ylifwXY/ZPojZq/1EdHfreegmDkOPteYimf1SaQv
aFu5ad9IkFft7fofdTj1fSeyT7z9oj7up+PKYdB3pe/oVUk2o5dOb6JHUjMTX50/
EUvWarfD+CaQZf8qpI+zaxFAXoBTJ8ngEzNGM15nNzpI5iu3Y/uOtVPspJGnnaYv
aneeCgd0SG0qwdOVlSmA1+fAqtJ/jSfu0n6sDLzKWG9rPFoHv2iJWlpDi2d7vtRz
F+Eebvb0HDryWJ+moOvfASNIDbFmL0CcLHvjc2NPxnXGPSFC9yJhRir1rl34A0l8
AX/qHdJ02iReRXCRiXvkIimovu1+VVJBRAG+vDRzmzsdf1V/XrkX9oZHloGW1nkC
7/LMK6/SLEM5b1lDNy1B
=RKiY
-----END PGP SIGNATURE-----

--jCrbxBqMcLqd4mOl--
