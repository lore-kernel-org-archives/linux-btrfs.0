Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:55769 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751025AbdFTPgD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Jun 2017 11:36:03 -0400
Date: Tue, 20 Jun 2017 15:36:01 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: 4.11.3: BTRFS critical (device dm-1): unable to add free space
 :-17 => btrfs check --repair runs clean
Message-ID: <20170620153601.GE7140@carfax.org.uk>
References: <20170620143916.GA22987@merlins.org>
 <20170620152354.GD7140@carfax.org.uk>
 <20170620152648.GB22987@merlins.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="s9fJI615cBHmzTOP"
In-Reply-To: <20170620152648.GB22987@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--s9fJI615cBHmzTOP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 20, 2017 at 08:26:48AM -0700, Marc MERLIN wrote:
> On Tue, Jun 20, 2017 at 03:23:54PM +0000, Hugo Mills wrote:
> > On Tue, Jun 20, 2017 at 07:39:16AM -0700, Marc MERLIN wrote:
> > > My filesystem got remounted read only, and yet after a lengthy
> > > btrfs check --repair, it ran clean.
> > > 
> > > Any idea what went wrong?
> > > [846332.992285] WARNING: CPU: 4 PID: 4095 at fs/btrfs/free-space-cache.c:1476 tree_insert_offset+0x78/0xb1
> > > [846333.744721] BTRFS critical (device dm-1): unable to add free space :-17
> > > [847312.529660] BTRFS: Transaction aborted (error -17)
> > > [847313.218391] BTRFS: error (device dm-1) in btrfs_run_delayed_refs:2961: errno=-17 Object already exists
> > 
> >    Error 17 is EEXIST, so I'd guess (and it is a guess) that it's
> > trying to add a free space cache record for some space that already
> > has such a record. This might also match with:
>  
> Thanks for having a look. Is it a bug, or is it a problem with my storage
> subsystem?

   Well, I'd say it's probably a problem with some inconsistent data
on the disk. How that data got there is another matter -- it may be
due to a bug which wrote the inconsistent data some time ago, and has
only now been found out.

> > [...]
> > > gargamel:~# btrfs check --repair /dev/mapper/dshelf2
> > [...]
> > > cache and super generation don't match, space cache will be invalidated
> > [...]
> > 
> >    I'd try clearing the cache (mount with -o clear_cache, once), and
> > then letting it rebuild.
> 
> "space cache will be invalidated " => doesn't that mean that my cache was
> already cleared by check --repair, or are you saying I need to clear it
> again?

   I'm never quite sure about that one. :)

   It can't hurt to clear it manually as well.

   Hugo.

-- 
Hugo Mills             | I believe that it's closely correlated with the
hugo@... carfax.org.uk | aeroswine coefficient
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                       Adrian Bridgett

--s9fJI615cBHmzTOP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZSUDhAAoJEFheFHXiqx3kNCoP/18w3vv/sUKTGodKpBsYpvtM
Fr1QnGEF23SDjIf5pYk7bA+m83g844TMPOF8bYY5DzAP9m4mk7lepTUVHsaOvKAF
BRiEc0dPpUWRXrleDQt3EhIr7GjDVeIutOOH6hHduIlVz6UPuFx1MjCJx0MmDe6/
UhOuq90fRIjUOUJUi/2qhDdoJgoibu4TuOVoBUY9htkxFlwCoEfiXQmqinU43yDK
3zn4NP1AEVR9bR/uhz/BpoSbOoMzsCYSzw3o8z+7g1Uh9Os8o15+JTd4RVeuPVsl
4/zWy+zfQ+s4Hx5m4wKRMxKYUYw/CA4dalzWajmos7xn+Zn0lYbP32kLJlB4J3bk
0HCRZBKpSRC5aIuAnkJZoGQYKkFIdBsBARpEB4078l0326AdO6A6aFe+RxdrKZjs
p8pd6GaksAt2s66SWNAhpE5wqH2hBknjcjcE46JjTx097+edJfbbvVPXBRVh/C7U
2M0uiCfG8lm9Ck6RCZLdc3XLyDLJRcIVZabEE71SJGisj2262sIA+++ik+H+Y5J4
ZZl5HVmljGfFGQArtZoq/bDiX6wOmAxVWhcW/pysVTEfTflCRwo0Dqs20Yt9Nyup
m/uepVp9NYeRCtDmN01XuyirbTXavkJvL061abOyldKTWJshVTNwZ84nVJiyQ6Hg
BkBjnqI7DaN9CmES7iil
=ZNoL
-----END PGP SIGNATURE-----

--s9fJI615cBHmzTOP--
