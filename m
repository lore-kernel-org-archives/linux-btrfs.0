Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:39104 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbbI2MVm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 08:21:42 -0400
Date: Tue, 29 Sep 2015 12:21:39 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: dsterba@suse.cz,
        =?iso-8859-1?Q?Gabr=EDel_Arth=FAr_P=E9tursson?= <gabriel@system.is>,
        linux-btrfs@vger.kernel.org
Subject: Re: Add stripes filter
Message-ID: <20150929122139.GF25907@carfax.org.uk>
References: <1443463025.16163.6.camel@system.is>
 <20150929120029.GX11442@twin.jikos.cz>
 <560A7FAB.1040607@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SxgehGEc6vB0cZwN"
In-Reply-To: <560A7FAB.1040607@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--SxgehGEc6vB0cZwN
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 29, 2015 at 08:10:19AM -0400, Austin S Hemmelgarn wrote:
> On 2015-09-29 08:00, David Sterba wrote:
> >On Mon, Sep 28, 2015 at 05:57:05PM +0000, Gabr=EDel Arth=FAr P=E9tursson=
 wrote:
> >>The attached patches to linux and btrfs-progs add support for filtering
> >>based on the number of strips in a block when balancing.
> >
> >What usecase do you want to address? As I understand it, this would help
> >the raid56 rebalancing to process only blockgroups that are not spread
> >accross enough devices.

   Exactly. Last week, I was trying to help Gabr=EDel on IRC with a
close-to-full filesystem balance it to add some new devices in a
parity RAID configuration. He'd added the devices and balanced, but
the usage was unequal across the devices. The only way I could think
of dealing with it with the current tools was either to do a full
balance repeatedly until it worked itself out, or to delve into the
metadata with btrfs-debug-tree, and balance selected block groups
individually.

   I whinged that we needed a filter to pick just the block groups
that weren't "as full as possible", and Gabr=EDel picked up the idea and
ran with it.

> This could also be helpful when reshaping a raid10 or raid0 setup.

   Yes, although ultimately less important in most cases, I think,
because you don't lose space by reducing the number of devices in a
block group for those. There are some corner cases where you could end
up losing space by having one (for RAID-0) or up to three (for
RAID-10) devices with more space left than the rest.

   Hugo.

--=20
Hugo Mills             | Dullest spy film ever: The Eastbourne Ultimatum
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                       The Thick of=
 It

--SxgehGEc6vB0cZwN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWCoJTAAoJEFheFHXiqx3krEAP/2Uv0jFUZlh+nbotVLZ9jgrp
suuB01vUnHySqKSs0Yc6viYsGUBV3sadgGU4px+Y2rbZFM00rzYyI7qbHOEUSegN
g8ZXKya+xu+AYLQojBiSYj/eNXmyMYPFbi8koz4+/EYh2iFI6JuKgfzGGSzYSYYm
rzpbivviB3OBxQ3fCj5mYEJ/I/phz6HVcFmvVUikRWACO4Iuq9GxYTS5HgmwGK7h
6nUxdMPA5DtEPv3gEgzffRpk+STdSBtyv3ADxJMS9gOif8flimIihK8ITinZM+zP
B/yNGr2EFhB8CJGxSpQXvpZBOtSY9Vory9RtCosDLp6SPHeQQzSZmUR2R9K9uL5l
svSHBcUGk7TgStBHzJuauZk3xqAPRFWR6H/NZrfwwk/LUyfmRkt7qIfQZtDtMwBN
ibi328GOYaUk41AnUae63SDKbXzgorvEJ/YJxILpcG0FZEBvKQRcwag08O82Bav1
l2/LzNZLrww7Ws+dnXgY4axKZdPh1QWpfDnUcpCytnHNj+xOxHAGkwKwHY0zjlQs
0Gqb9gmKwSmx2FL4DWX4VI1ZBYWMuJGj9+0tOZY+qiD4icWyuUCKpeqeRdbTm+Xf
xPa9rnZ2xYZymQ4eNXXkmHVZs+sr5P5T+iSP2pgKxkJ/p7ojLR+na7rE3QXXGTfX
8nw30VVcqg8USg5Bf+lI
=5bio
-----END PGP SIGNATURE-----

--SxgehGEc6vB0cZwN--
