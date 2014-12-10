Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:33810 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750744AbaLJV5b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 16:57:31 -0500
Date: Wed, 10 Dec 2014 16:57:29 -0500
From: Zygo Blaxell <zblaxell@furryterror.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Robert White <rwhite@pobox.com>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Subject: Re: Crazy idea of cleanup the inode_record btrfsck things with SQL?
Message-ID: <20141210215729.GC22023@hungrycats.org>
References: <547BCB43.5020505@cn.fujitsu.com>
 <547BE8A5.7050900@pobox.com>
 <547C0834.7090706@cn.fujitsu.com>
 <547CAF2E.7070109@pobox.com>
 <547D1339.10404@cn.fujitsu.com>
 <547F61F6.7020707@pobox.com>
 <548005B7.40503@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RASg3xLB4tUQ4RcS"
In-Reply-To: <548005B7.40503@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--RASg3xLB4tUQ4RcS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 04, 2014 at 02:56:55PM +0800, Qu Wenruo wrote:
> The main memory usage in btrfsck is extent record, which
> we can't free them until we read them all in and checked, so even we
> mmap/unmap, it can only help with
> the extent_buffer(which is already freed if not used according to refs).

I'm thinking aloud here, but is it *really* necessary to read everything
into memory?  Maybe a multiple-pass algorithm might be possible, e.g. one
to find free space by eliminating any areas that are occupied by extents,
then other passes to rebuild the metadata in the free space.  Or, one
pass to verify the connectivity of references and collect dangling refs,
then a second pass which fixes only the dangling refs.

Usually sequential reads are significantly faster than swapping--even
if swapping on solid-state media.  It could be that reading 260GB of
metadata sequentially two or three times is still faster than thrashing
through random lookups in 20GB of swap on a 4GB machine.


--RASg3xLB4tUQ4RcS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlSIwckACgkQgfmLGlazG5xhEgCdHy3GERyCZdveyt6uTa/rbxYy
J1kAoMAIovj3mP9VAlpep/FzJNCNwp5O
=FY+m
-----END PGP SIGNATURE-----

--RASg3xLB4tUQ4RcS--
