Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:57738 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaAGKxa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Jan 2014 05:53:30 -0500
Date: Tue, 7 Jan 2014 10:53:29 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Is anyone using btrfs send/receive howto?
Message-ID: <20140107105329.GE15634@carfax.org.uk>
References: <20131228171943.GE19863@merlins.org>
 <20131228173730.GA7234@carfax.org.uk>
 <20131228180758.GF19863@merlins.org>
 <20140107104951.GL10936@merlins.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uCPdOCrL+PnN2Vxy"
In-Reply-To: <20140107104951.GL10936@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--uCPdOCrL+PnN2Vxy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 07, 2014 at 02:49:51AM -0800, Marc MERLIN wrote:
> I read different howtos on the wiki and oracle docs, but I can't get it
> to work:
> 
> legolas:/mnt/btrfs_pool1# btrfs subvolume snapshot -r tmp tmp_read_only_new
> Create a readonly snapshot of 'tmp' in './tmp_read_only_new'
> legolas:/mnt/btrfs_pool1# sync
> legolas:/mnt/btrfs_pool1# btrfs send tmp_read_only_new | btrfs receive /mnt/btrfs_pool2/
> At subvol tmp_read_only_new
> At subvol tmp_read_only_new
> 
> # Make a new snapshot later and try to sync it:
> legolas:/mnt/btrfs_pool1# mv tmp_read_only_new tmp_read_only
> legolas:/mnt/btrfs_pool1# btrfs subvolume snapshot -r tmp tmp_read_only_new
> Create a readonly snapshot of 'tmp' in './tmp_read_only_new'
> legolas:/mnt/btrfs_pool1# btrfs send -p tmp_read_only  tmp_read_only_new | btrfs receive /mnt/btrfs_pool2/
> At subvol tmp_read_only_new
> At snapshot tmp_read_only_new
> ERROR: creating snapshot tmp_read_only_new -> tmp_read_only_new failed. File exists
> 
> This is where I get stuck:
> Obviously /mnt/btrfs_pool2/tmp_read_only_new already exists since it's the reference backup volume.
> 
> What am I doing wrong?

   You need to move /mnt/btrfs_pool2/tmp_read_only_new to a different
name as well. The send stream contains the name of the subvolume it
wants to create, so it's trying to create a subvolume called
"tmp_read_only_new" in /mnt/btrfs_pool2, and there's one there already.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- It's against my programming to impersonate a deity! ---       

--uCPdOCrL+PnN2Vxy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUBUsvcqVheFHXiqx3kAQJVBBAAjYaQ9IsK9YztXd3nnTpIAaUp0vPjgQ4d
Wh7I41ycS2hKDhj6KKqspkQBXIP1MmAG/Slz4XxeEZx87qW3BzPM2oywT1QbqvCs
F+AbagDrYx8wpH5GwDuJeKQ4I/1qn/wbMVXaKk483cOWcNM08Xwl7ZSY7TK2ttUm
W+PNZ4HgAK5sO/DYGOMoNxqrUCyEmE1ra7F4dG0Yx3DYtOmdFAF1oFZSi3m0mMrd
vsLyVQCHKt1xGGrDFHW93xsi7kw2JYE64aOsnlHMmLjAe8fS8BWW8CwXqpbrDst8
u7T0BIiSERjgynrM3/oT/keYEffjwCmKo1VOtYtLfKB6Y5gYitBkHYY3jJWtBQkC
GwIOYMARNi3QnUnJaGhXsuIYnV8pmPcpI8/aPDDXWe+j8nUaHCGCmOqcJA/JSKlw
ClRW+F7pj7HpcEHdcCSFa9n0TeyJNCog/ccbcJn1qofydRcYki3PFq/9hlScZoti
FozZ0Il9lkN7GLZpGSojgGyK8QVp5rcJM/s45EUuDzGHTFcbfL6OxpqNKEJfIVzi
Jwqmsv1+wkubzrpLkayMbfh3V522UtEF9WsoM+07UsXtKWis4yXYJb60w7WJva16
uOO1VYr4ErZ9fGvwCACzCw7molycJ2XlSgBEWfcTW64n+krzZRhhXkkysAIN6UOZ
mIDE3BrHWbQ=
=9SzW
-----END PGP SIGNATURE-----

--uCPdOCrL+PnN2Vxy--
