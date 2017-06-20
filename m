Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:50073 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752392AbdFTXMV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Jun 2017 19:12:21 -0400
Date: Tue, 20 Jun 2017 16:12:03 -0700
From: Marc MERLIN <marc@merlins.org>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: 4.11.3: BTRFS critical (device dm-1): unable to add free space :-17 => btrfs check --repair runs clean
Message-ID: <20170620231202.GB5303@merlins.org>
References: <20170620143916.GA22987@merlins.org> <20170620152354.GD7140@carfax.org.uk> <20170620152648.GB22987@merlins.org> <20170620153601.GE7140@carfax.org.uk> <20170620154429.GC22987@merlins.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
In-Reply-To: <20170620154429.GC22987@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 20, 2017 at 08:44:29AM -0700, Marc MERLIN wrote:
> On Tue, Jun 20, 2017 at 03:36:01PM +0000, Hugo Mills wrote:
> > > Thanks for having a look. Is it a bug, or is it a problem with my sto=
rage
> > > subsystem?
> >=20
> >    Well, I'd say it's probably a problem with some inconsistent data
> > on the disk. How that data got there is another matter -- it may be
> > due to a bug which wrote the inconsistent data some time ago, and has
> > only now been found out.
> =20
> Understood.
>=20
> > > "space cache will be invalidated " =3D> doesn't that mean that my cac=
he was
> > > already cleared by check --repair, or are you saying I need to clear =
it
> > > again?
> >=20
> >    I'm never quite sure about that one. :)
> >=20
> >    It can't hurt to clear it manually as well.
>=20
> Sounds good, done.
=20
Except it didn't help :(
It worked for a while, and failed again.

It looks like I'm hitting a persistent bug :(

[   86.383988] BTRFS: device label dshelf2 devid 1 transid 37975 /dev/mappe=
r/dshelf2
[   98.232529] BTRFS info (device dm-1): use lzo compression
[   98.251982] BTRFS info (device dm-1): disk space caching is enabled
[   98.274847] BTRFS info (device dm-1): has skinny extents
[  104.171597] BTRFS info (device dm-1): detected SSD devices, enabling SSD=
 mode
[  165.429894] BTRFS error (device dm-1): Duplicate entries in free space c=
ache, dumping
[  165.455673] BTRFS warning (device dm-1): failed to load free space cache=
 for block group 2039601954816, rebuilding it now
[  234.221435] BTRFS warning (device dm-1): block group 2837392130048 has w=
rong amount of free space
[  234.249264] BTRFS warning (device dm-1): failed to load free space cache=
 for block group 2837392130048, rebuilding it now
[  234.636396] BTRFS warning (device dm-1): block group 2885173641216 has w=
rong amount of free space
[  234.664015] BTRFS warning (device dm-1): failed to load free space cache=
 for block group 2885173641216, rebuilding it now
[  242.042940] BTRFS warning (device dm-1): block group 3116565004288 has w=
rong amount of free space
[  242.071207] BTRFS warning (device dm-1): failed to load free space cache=
 for block group 3116565004288, rebuilding it now
[  273.910918] BTRFS warning (device dm-1): block group 3209980542976 has w=
rong amount of free space
[  273.937625] BTRFS warning (device dm-1): failed to load free space cache=
 for block group 3209980542976, rebuilding it now
[  298.578615] BTRFS warning (device dm-1): block group 2305889927168 has w=
rong amount of free space
[  298.605250] BTRFS warning (device dm-1): failed to load free space cache=
 for block group 2305889927168, rebuilding it now
[  873.265687] BTRFS: Transaction aborted (error -17)
[  873.948245] BTRFS: error (device dm-1) in btrfs_run_delayed_refs:2961: e=
rrno=3D-17 Object already exists
[  873.978884] BTRFS info (device dm-1): forced readonly

Given that check --repair ran clean when I ran it yesterday after this firs=
t happened,
and I then ran  mount -o clear_cache , the cache got rebuilt, and I got the=
 problem again,=20
this is not looking good, seems like a persistent bug :-/

I'm now going to remount this with nospace_cache to see if your guess about
space_cache was correct.
Other suggestions also welcome :)

Marc
--=20
"A mouse is a device used to point at the xterm you want to type in" - A.S.=
R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet coo=
king
Home page: http://marc.merlins.org/ =20

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQCVAwUBWUmrwn4xUKZ2O+kBAQLkzAQAri0YyPzKOOnud4a7UPGc9BljYSjgu8qY
yW+N/hPUbsCy4+szbxHkO7VRsga+AFkQgsdn8xv0lTN6HuoSrH7g9FjIEIpE7+Sr
rA2kuqi9tysAIEPI2w7XaQV9qZjPboiHScKcHNMcyaJMGxMyW06QEFE7ASYeGwXI
llhrkrfkE8w=
=GQsW
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
