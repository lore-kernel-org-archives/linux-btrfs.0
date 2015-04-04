Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:55253 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbbDDNAw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Apr 2015 09:00:52 -0400
Date: Sat, 4 Apr 2015 13:00:47 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Russell Coker <russell@coker.com.au>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: Btrfs hangs 3.19-10
Message-ID: <20150404130047.GC13864@carfax.org.uk>
References: <CAGqmi74e_U5-UVUy+MHbxc2f-38pRyjK1Zo0Up-V9ndFpv-bXA@mail.gmail.com>
 <20150402191312.1ee31af3@natsu>
 <pan$a9ed6$bb1c7fdd$74534d5d$7b638441@cox.net>
 <201504041255.08052.russell@coker.com.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H8ygTp4AXg6deix2"
In-Reply-To: <201504041255.08052.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--H8ygTp4AXg6deix2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Apr 04, 2015 at 12:55:08PM +0000, Russell Coker wrote:
> On Fri, 3 Apr 2015 05:14:12 AM Duncan wrote:
> > Well, btrfs itself isn't really stable yet...  Stable series should be 
> > stable at least to the extent that whatever you're using in them is, but 
> > with btrfs itself not yet entirely stable... 
> 
> Also for stable operation you want both forward and backward compatability.  
> You could make an Ext3 filesystem and expect that any random ancient Linux box 
> you are likely to encounter can read it.  Even Ext4 has been supported for a 
> long time and most systems you are likely to encounter won't have any problems 
> with it.
> 
> I recently made a BTRFS filesystem on a Debian/Jessie system (kernel 3.16.7) 
> with default options and discovered that Debian/Wheezy (kernel 3.2.65) can't 
> read it.  I think that one criteria for "stable" in a filesystem is that 
> kernels from a couple of previous releases can mount it.  By that criteria 
> BTRFS won't be "stable" for use in Debian for about 4 years.
> 
> As an aside are there options to mkfs.btrfs that would make a filesystem 
> mountable by kernel 3.2.65?  If so I'll file a Debian/Jessie bug report 
> requesting that a specific mention be added to the man page.

   Yes, there are. It's probably -O^extref, but if you can show the
dmesg output from the 3.2 kernel on the failed mount (so that it shows
what the actual failure was), we should be able to give you a more
precise answer.

   Hugo.

-- 
Hugo Mills             | Welcome to Hollywood, a land just off the coast of
hugo@... carfax.org.uk | Planet Earth
http://carfax.org.uk/  |
PGP: 65E74AC0          |                                        The Cat's Meow

--H8ygTp4AXg6deix2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVH+B/AAoJEFheFHXiqx3kll8QAJMwcz/xpNIvv1jdxwJ4RL32
2caGCdU0NocYy4B48CaQH0vhzaTLtVc94eM8zSgKnCj0MalYDHxVCnK9NY7gdZ4p
2rvWrRJy86NI2cSrx5nwHSRlF+D7FoRkZCLcip8U88YbI6Sx/+2qSyPEG+o4gJnj
OaFDDVZlXt0mWyTk6KKyGykxsB8bOvd6Yf6R6fZRZgtxuFOEyg1AHUaC30zfgDcS
WggU8jHtKP7+8GMPw3Oo35I5y7e9Nsfn66+DBKJBD/KGCJYt3ihF2S03u/hHkFq3
zqKbaMMEdtE725HYk05A7AyrHmphexpPxMIwK0nZMuMY/0pgZEb8HxXwhk4mdodb
d3zklRsc9OQZY7o2OFx8L/yJBzHMpAfgfdkJ6UYfDhWUGDlEKTa9UIuDpkgtMBGb
Nru8KCo46Y5aiBkgSYf08CBqW6CoCn9SpBMwH+LXCNj4pzpCYd31i5+mJ6sBSCNO
QeJzthsTOp4ZWbutnXn1muagIYicwsRp045p3jIduFSL/UJVlz1NecF9lazdltal
ca2+Dd91ww78fQPPkMWQP5OZDepJfi43BoUgnkVD3pVd9XFmR7pjnnhiuFu3Walv
4jrgfw6IUPQ33GY1CsLusSZZA3zRS2rxTcNFpKOIQXL3gx+07pZ/Nba4m9ceDiUc
mArWVD7eiLsFAeumsdbq
=Iwso
-----END PGP SIGNATURE-----

--H8ygTp4AXg6deix2--
