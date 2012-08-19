Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59296 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab2HSUKH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Aug 2012 16:10:07 -0400
Date: Sun, 19 Aug 2012 21:10:00 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: dg1727 <dg1727@hushmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: How to get Btrfs on 2nd partition of USB HDD to automount as
 read/write
Message-ID: <20120819201000.GG30735@carfax.org.uk>
References: <20120819195147.6EA7EA6E3F@smtp.hushmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lHGcFxmlz1yfXmOs"
In-Reply-To: <20120819195147.6EA7EA6E3F@smtp.hushmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--lHGcFxmlz1yfXmOs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 19, 2012 at 03:51:47PM -0400, dg1727 wrote:
> Hello, 
> 
> The question below is based on 
> https://lists.ubuntu.com/archives/xubuntu-users/2012-
> August/004509.html
> 
> Thanks in advance for any help with the following question, 
> including pointing me to some other info resource if needed.  
> 
> I have a user with an Xubuntu 12.04.1 laptop, 32-bit.  He needs to 
> use a USB hard disk drive which has 2 partitions:  the 1st 
> partition is NTFS and the 2nd partition is Btrfs.  
> 
> When he plugs in the hard drive, both partitions auto-mount OK, 
> except that the Btrfs partition automounts read-only.  That is, the 
> permissions of the directories in /dev are drwx------ for the NTFS 
> and dr-xr-xr-x for the Btrfs.  
> 
> How can the OS be set up so that the Btrfs will automount 
> read/write?  

   As Anthony points out, this is a property of the filesystem, not
the OS or the mount options. Just use chmod.

   (It's only filesystems like FAT, which have no concept of
permissions, which have mount options to set permissions)

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Two things came out of Berkeley in the 1960s: LSD and Unix. ---   
                       This is not a coincidence.                        

--lHGcFxmlz1yfXmOs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFQMUgYIKyzvlFcI40RAgKIAJ9feEIJydyyvPFG+09Ugme9Yy90nACfWyMo
8RRyWRvebdMMTefjtPNveHE=
=CNS+
-----END PGP SIGNATURE-----

--lHGcFxmlz1yfXmOs--
