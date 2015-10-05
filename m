Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:34113 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbbJENO1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Oct 2015 09:14:27 -0400
Date: Mon, 5 Oct 2015 13:14:26 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Issues with unmountable BTRFS raid1 filesystem
Message-ID: <20151005131426.GP25907@carfax.org.uk>
References: <56126D59.7070505@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CKf/2jVYos1l2hij"
In-Reply-To: <56126D59.7070505@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--CKf/2jVYos1l2hij
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 05, 2015 at 08:30:17AM -0400, Austin S Hemmelgarn wrote:
> I've been having issues recently with a relatively simple setup
> using a two device BTRFS raid1 on top of two two device md RAID0's,
> and every time I've rebooted since starting trying to use this
> particular filesystem, I've found it unable to mount and had to
> recreate it from scratch.  This is more of an inconvenience than
> anything else (while I don't have backups of it, all the data is
> trivial to recreate (in fact, so trivial that doing backups would be
> more effort than just recreating the data by hand)), but it's still
> something that I would like to try and fix.
> 
> First off, general info:
> Kernel version: 4.2.1-local+ (4.2.1 with minor modifications,
> sources can be found here: https://github.com/ferroin/linux)
> Btrfs-progs version: 4.2
>
> I would post output from btrfs fi show, but that's spouting
> obviously wrong data (it's saying I'm using only 127MB with 2GB of
> allocations on each 'disk',  I had been storing approximately 4-6GB
> of actual data on the filesystem).
> 
> This particular filesystem is composed of BTRFS raid1 across two LVM
> managed DM/MD RAID0 devices, each of which spans 2 physical hard
> drives.  I have a couple of other filesystems with the exact same
> configuration that have not ever displayed this issue.
> 
> When I run 'btrfs check' on the filesystem when it refuses to mount,
> I get a number of lines like the following:
> bad metadata [<bytenr>, <bytenr>) crossing stripe boundary
> 
> followed eventually by:
> Errors found in extent allocation tree or chunk allocation

   I _think_ this is a bug in mkfs from 4.2.0, fixed in later
releases of the btrfs-progs.

   Hugo.

> As is typical of a failed mount, dmesg shows a 'failed to read the
> system array on <device>' 'open_ctree failed'.
> 
> I doubt that this is a hardware issue because:
> 1. Memory is brand new, and I ran a 48 hour burn-in test that showed
> no errors.
> 2. A failing storage controller, PSU, or CPU would be manifesting
> with many more issues than just this.
> 3. A disk failure would mean that two different disks, from
> different manufacturing lots, are encountering errors on exactly the
> same LBA's at exactly the same time, which while possible is
> astronomically unlikely for disks bigger than a few hundred
> gigabytes (the disks in question are 1TB each).
> 



-- 
Hugo Mills             | Jazz is the sort of music where no-one plays
hugo@... carfax.org.uk | anything the same way once.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--CKf/2jVYos1l2hij
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWEnexAAoJEFheFHXiqx3kcAsP+wXo0PdBXfpYUjDILVSuFP4G
Os/a8/soYwQ+I4jAAFRf04AhCS/czyf0vY3qAM5HaY6QiIYgyg5+0DYqOLVOWI7U
sKnSJAuCQaCAFYOhmyDZu8fwkfneOnGMICeV2cj6vYGmeYh/6R+BZUV4NaJWXtvk
0eFG09L7GpLBs5q8GgOMU67EoYbe1ngBfCjtOr+KcAgIi352eu6OXBAjz3WAD263
dcAOf2RgolISR7MKHJKVAdGxL70+XDMfCbXnuZdOQjdFlti4iytRewzUYlz64XA0
w+StoAgXGXNgLzIfD5rWUmhczPRS24JxrtosgOjaJHdE879wVRELBkAEu/WAeLoh
SR1fJnnI3Rt1g9+GBFBWduEuXej97gY0NbYIIAgfahYZbtNQAJFRpCmhyhnuythW
fi1JQGKSKPzhmbE8752JpHdu9uoWBX1OD+9qmRXnApseoIY8XnWT3KXjVXWw1RuY
xCQ/4lu+Mq1AeTIVAiFSClhSHS3kGqlgW3DG7mRzpRGffNQRg5COufVhN2hy4CBB
6z6tLLyR8SOkDdRT5+dwTp/BR2CZDmYBSTOM7/FF7IAOh9+5+VQjD2AhrdRcjCvW
vLspMeeVeazZuUenXtPU/Oxw7R4C22fzIwBSlIMt9M8twRn3SOOp+f5qdcEmALA2
BKGuZPOJOvyJ+UfofZeB
=s/qb
-----END PGP SIGNATURE-----

--CKf/2jVYos1l2hij--
