Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:51003 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485AbbDIQdV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Apr 2015 12:33:21 -0400
Date: Thu, 9 Apr 2015 16:33:19 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: incremental full file backups to smaller mediums possible?
Message-ID: <20150409163319.GV13864@carfax.org.uk>
References: <1428596073.4994.24.camel@scientia.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gYb7txo4D4wAJl1C"
In-Reply-To: <1428596073.4994.24.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--gYb7txo4D4wAJl1C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 09, 2015 at 06:14:33PM +0200, Christoph Anton Mitterer wrote:
> Hey.
> 
> I wondered whether this is possible in btrfs (or could be
> implemented),... it's in a way similar to send/receive, but AFAIU not
> fully solvable with that.
> 
> What I want to do is making incremental backups of a (btrfs) filesystem
> to smaller mediums (that is for example: from a big RAID filesystem to
> many BluRays or similar things).
> 
> 
> Right now I make this as follows:
> Every time backups should be made, I create a ext4 image which would
> just fit inside the UDF fs of a BluRay (the ext4 image in turn is
> dm-crypt encrypted) and copy as many *complete*[0] files from the source
> filesystem to that image as possible. That image file is then burned to
> BluRay. I also write an SHA512 sum of the whole image file to the BluRay
> so that one can check whether it can be still read correctly.
> Then the process continues with the remaining files.
> 
> 
> The main idea behind writing only complete files to the separate parts
> of the backup is, that I don't want to have a backup set, where I may
> get into troubles if just one of the disks fails.
> 
> 
> Obviously, when I would do regularly backups that way, then I'd write
> each time a big amount of data which hasn't changed at all, which is not
> just a costly issue, but also quite time consuming.
> So ideally, I'd want to do just an incremental backup of all the files
> that have been added/modified + the information of what has been
> deleted/moved/changed it's properties.
> 
> All that already smells quite a lot after making a snapshot at the last
> backup, and then doing send/receive for the next one.
> 
> 
> Now the problem, though, is, that I don't want to loose the property of
> working in terms of complete files (and I guess send/recieve does not),
> i.e. when a big file has just one block changed, I still would like to
> have the complete file on the next incremental dump (and not just
> information about the "diff").
> The only exception is when file metadata changes (i.e. pathname, date,
> permissions, xattrs, etc.). If *just* one of these changes I wouldn't
> want to backup the full raw data of the file again.

> Any ideas whether and how this could be done / assisted by btrfs?

   btrfs sub find-new might be more helpful to you here. That will
give you the list of changed files; then just feed that list to your
existing bin-packing algorithm for working out what goes on which
disks, and you're done.

   Hugo.

-- 
Hugo Mills             | Dullest spy film ever: The Eastbourne Ultimatum
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                       The Thick of It

--gYb7txo4D4wAJl1C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVJqnOAAoJEFheFHXiqx3kmDoQALVQnPFUynh8wBG6vVCblgwV
XE6ugMpBd748DAA/5JDqGycq7fP8Srx5asPQ8SIUVO4NcW+a0zxgE9Ts9ZuJ038w
SgMoQh6GaTemtMzMdRCQN+fPAR3xwVqM6o3hP6O6/DfMnwCQyNc2zMXW9iO/5iwt
ASn8ue9S7I5P7qkHyb0IoKq5wi2YaqIF3Qr+aETOIiiNEFBIICjQjvNNnAH7aej7
RrtPClisA3Ttrzt7hT07IpyzIUukr1MCPRWRWcK4u+8b/jFtrSFe53CJThVBKoBx
8hrLKDZVdPuM4Leu/3MRcgnp0IkjHjnPUJTOwgtKe69RYdb/L6ZsBJtGwO7iA0AU
9qeSfCqJkA7tZnGq6Rv09TO54MkZlO0uJ9qrFCbpWEM+4n/EIxNtaPiPU4M6X+zC
1HRTwH9d0dl+fhGtTyqV48rcK6t8STqmewUIutB3Lmty+va2O81GXg4Z3cc7IekH
5tF8dFUWrPMUbRfQshXQBc5pc5Fc3a+5teOa03MjDLL0Tk3w6/CHCCMZRRa3UZI7
PHje8vLg4jJrBVGPh4bSX1BM0FnkM94Uv91oZ5w704abnvHzIksJxF2kgnneRpNt
ZYayjr4XjTY/0TDOdUtvT0X59w1SEu1RxAXQHZtCA78odGs/Go4zh1BbbLxM4L2t
/D3e9TsmL9QEu/gqxzF3
=asDd
-----END PGP SIGNATURE-----

--gYb7txo4D4wAJl1C--
