Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:37726 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756493Ab3BYUp0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 15:45:26 -0500
Date: Mon, 25 Feb 2013 20:45:23 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4] Btrfs: ability to add label to snapshot and subvol
Message-ID: <20130225204523.GK14283@carfax.org.uk>
References: <1361770305-1206-1-git-send-email-anand.jain@oracle.com>
 <1361770305-1206-2-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcXnUX77nabWBLF4"
In-Reply-To: <1361770305-1206-2-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--HcXnUX77nabWBLF4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 25, 2013 at 01:31:45PM +0800, Anand Jain wrote:
> Generally snapshots are machine generated, so at any point in time
> if a sysadmin looks at a list of snapshots there should be some
> info about the snapshots to indicate purpose of it being created.

   I still can't see what benefits you get from having this extra
metadata that you couldn't put in a filename -- particularly in the
case of a scripted snapshot. However, assuming that you can bend the
argument to needing this feature...

> With this patch and along with the corresponding btrfs-progs patch
> a 32byte info can be added to the snapshots/subvol.

   How is this any different to using extended attributes to store the
same information? With the exception that xattrs:

 - can store more than 32 bytes
 - can store an arbitrary number of items 
 - have already been implemented
 - don't introduce more FS-specific ioctls
 - don't take up valuable extra space in metadata structures

> Further, ioctl is preferred over the attribute to write the label
> since btrfs-progs is not only the application which might be
> interacting with the subvol to write the label, for example
> btrfs-gui might as well write the label, so that needs an
> additional efforts to maintain a consistent keyword across the
> applications is difficult in the long run.

   As long as there's a well-known xattr name that's written by
btrfs-progs, that'll become the de-facto standard. If any other system
fails to use that attribute name, it becomes non-interoperable with
the default tools. This is probably enough to ensure that it'll get
fixed fairly quickly in this case (because the users that care about
the feature will complain it's not working right).

   My conclusion: go with user xattrs.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- Welcome to Hollywood, a land just off the coast ---         
                            of Planet Earth.                             

--HcXnUX77nabWBLF4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUSvNY79z9OVl50rAAQKnww//RZoWRWhBm2AjCKqERMaYQIKnnT99vAE2
00ueDH1wtwo6Z/ccSiAspgpfa1FR/c2XxdCVta1edN+HOvGnmsDi5KGOXnCOlLTT
QOQdrj2XNL8Wb127TqGHQuAhqxIfEZBzNzgs1ff4CV4Z9DOUZyfXIMawEjsutzvy
6TXd6mpfYst4HPGBJEigCNGRGF1V8PPn1895GdsWGhTo0MTea5sue17kUxm98VXF
O+hIQU3BIkFAqZ9FwG1cimMu5OVVlmqd6GIoJ82lZ8xidWnyt3awu0ZYUjmyqXi1
CLSbu5AKRpZp4Xz9gKE7mcTXKD5om+Alw3SwEsVweSVj9NTZyaDoPlTWBMF9CiTN
m+nArN/h8AK5Xtz+/FiTk9pkL3YDxvnSPpWbQYofZuv8njlyfR75bx+s9tQgUZ9a
oZkkbz5s5rkn1xtPKDCtpM5wblVGsQDaVBreJFBPZODNZBVoFGVmbqqfSrlC8nur
HztbVpTrbBjsNwD4iup+R3OzlQKyTRUoIfBpnLEU4gMTJNjhYPJ/gCfssXOJoImP
zN9hudCC6DxD0tHCPQpkgHuvG9RA8oaKmh2ohQL5cWcaf/oZCduBZ+j8fcTJWAqF
2rFKazb/eEjE2IA3Oz+qwJlbm9ZHmaEHm299SHPUiT8VQJer9wGyjNBaU4EBiFN5
4CU447w0ub4=
=f+ac
-----END PGP SIGNATURE-----

--HcXnUX77nabWBLF4--
