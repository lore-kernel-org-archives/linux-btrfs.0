Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:41993 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab2FMN1w (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jun 2012 09:27:52 -0400
Date: Wed, 13 Jun 2012 14:27:47 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Jan-Hendrik Palic <billgotchy@ki.tng.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Computing size of snapshots approximatly
Message-ID: <20120613132747.GB28932@carfax.org.uk>
References: <4FD88465.3020303@ki.tng.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KFztAG8eRSV9hGtP"
In-Reply-To: <4FD88465.3020303@ki.tng.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--KFztAG8eRSV9hGtP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 13, 2012 at 02:15:33PM +0200, Jan-Hendrik Palic wrote:
> Hi,
> 
> we using on a server several lvm volumes with btrfs. We want to use
> nightly build snapshots for some days as an alternative to backups.
> 
> Now I want to get the size of the snapshots in detail.

   There are basically two figures you can get for each snapshot.
These values may differ wildly. Which one do you want?

(A) The first, larger, value is the total computed size of the
   files in the subvolume. This is what du returns.

(B) The second, smaller, value is the amount of space that would be
   freed by deleting the subvolume. (Alternatively, this is the amount
   of data in the subvolume which is not shared with some other
   subvolume). It is currently a difficult process to work out this
   value in general, but the qgroups patch set will track this
   information automatically, and expose an API that will allow you to
   retrieve it.

   The qgroups patches aren't complete yet.

> Therefore I
> played with
> 
>   btrfs subvolume find-new $snapshot $gen-id.

> And I know, that this is quite complicated and not implemented.
> Therefore I try to go my own way:
> 
> Now assume there are two snapshots of one subvolume, snap1 and
> snap2. Further get the find-new informations of these snapshots with
> $gen-id=1 and save them into different files. A diff of these files
> shows the changes between snap1 and snap2, right?
> 
> Ok.
> 
> There are three operations on a filesystem, I think,
> 
> 1. copy a file on the filesystem
> 2. change a file on the filesystem
> 3. delete a file on the filesystem
> 
> Am I right to assume, that operation 1 and 2 are not change much the
> size of a snapshot and the delete operation let increase the size of
> a snapshot in the size of the deleted files?

   It depends on which measure of the two above you're trying to use,
and whether the subvolume (and file) you're modifying still has
extents shared with some other subvolume.

1. Copying a file (without --reflink) will increase both the (A) and
   the (B) size of the snapshot. Copying a file with --reflink will
   increase (A) and leave (B) much the same.

2. Changing a file will, obviously, cause (A) to change by the
   difference between the old file and the new. If that file shares no
   extents with anything else, then (B) will also change by that
   amount. Otherwise, if it shares extents with anything else (another
   subvolume, or a reflink copy), then (B) will increase by the amount
   of data modified.

3. Deleting a file will reduce (A) by the size of the file. (B) will
   reduce by the size of non-shared extents owned by that file.

   Note that btrfs sub find-new will not allow you to track file
deletions.

> If it is so, it would be enough for me to get the deletions of files
> between two snapshots and their size. But is there another way to
> get these informations beside btrfs subvolume find-new? Perhaps it
> makes sense to use ioctl for it? What about the send/receive
> feature, which is upcoming?
> 
> Are there any hints?

   Wait for qgroups to land, because that actually does it the right
way, and will avoid you having to track all kinds of awkward (and
hard-to-find) corner cases.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
        --- Summoning his Cosmic Powers, and glowing slightly ---        
                            from his toes...                             

--KFztAG8eRSV9hGtP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFP2JVTIKyzvlFcI40RAh6cAJ9P9mXpIXmvblh/1DlnY6laDa0qJACgnbIC
d/16GbGME4faW26oB4WlSAg=
=NH3R
-----END PGP SIGNATURE-----

--KFztAG8eRSV9hGtP--
