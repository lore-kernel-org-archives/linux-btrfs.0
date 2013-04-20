Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:58688 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026Ab3DTUsQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Apr 2013 16:48:16 -0400
Date: Sat, 20 Apr 2013 21:48:14 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Roger Binns <rogerb@rogerbinns.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: data DUP
Message-ID: <20130420204814.GN7639@carfax.org.uk>
References: <kkut3u$lp1$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SCOJXUq1iwCn05li"
In-Reply-To: <kkut3u$lp1$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--SCOJXUq1iwCn05li
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Apr 20, 2013 at 01:17:06PM -0700, Roger Binns wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Is there any particular reason why I can't use DUP for data?

   Technically, no. Performance is likely to suck if you use
rotational disks, and you may find some SSDs deduplicate blocks,
making it fairly pointless for those devices.

> When I try to set it with balance there is a kernel message:
> 
>   btrfs: dup for data is not allowed

   What kernel and userspace versions are you using? I thought the
restriction had been removed at some point (but possibly I'm just
misremembering it).

> The glossary at https://btrfs.wiki.kernel.org/index.php/Glossary says:
> 
>   Regular data cannot be assigned DUP level.
> 
> It is somewhat baffling that code and documentation exists to prevent this!

   I think it did get fixed at some point. The documentation doesn't
always get updated everywhere -- it can be quite hard to find every
single implication of a feature when that feature gets changd/updated.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
        --- UNIX: Spanish manufacturer of fire extinguishers. ---        

--SCOJXUq1iwCn05li
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUXL/DVheFHXiqx3kAQI2bxAAhDhTSGtpV00rEI3TizpbEYi0YpX3MVfk
FzKN/N7T/bgnbfL5dH8IHBFlExZat5oHWZze4/wYJn/InWtqF03O9dIGgZ8Rxm57
mlqkE4A9qB/nWiVBgXo/cMAH0lQVFrU8+Gr2lBl5p4MHxXPbbIvy0XIKd9Tm343x
C7SUBYtbZbizAkPvq5g4jR3h3iJS08Gl8NzNipreVchHL/zVNvICaHhODMjM5vYv
zMKKahHTFv9nAo6t972Xycq2fMRuadAtsEWe65tHv6XCRTUqDoz89nTocGIVgJVY
L3D9I4Wel3ys8m+bw7nThRpXmD6izkUp2HFhv8YaRI7pbULXyrxeDexHMyWvEYmU
iROoXty4uSuVKde63yeQ23wCU0oimSK4JuapSLCJFfRzqS4Q496Dt6pzpGwM/i7g
P6Zig/WEw1x/2evmTl6Mcub76UgoqFph4I4q25IlfKLzxoMnKOipTHlpjpFpDKMR
rVxoVglVaNVmFg8l2lprl3hzcyYfJ8r26jeFmnQlVgDgPQZNyyuwX2U1vxWKck/p
rHR3z6OU1pwgDNds73P8FuCk58jwYgs4sl82Bef7jwICwXG4MWWednlDf5dWw1ix
thRa4Ri0hYNUJ7XoUqIli00LBncf3cx1B+Hxknx7wlYNF83U4jbpdXqFTr/zoWsM
1uZ7QzBeKTQ=
=qcsU
-----END PGP SIGNATURE-----

--SCOJXUq1iwCn05li--
