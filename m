From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: btrfs w/ckd
Date: Thu, 2 Jun 2011 20:59:56 +0100
Message-ID: <20110602195956.GC8002@carfax.org.uk>
References: <47C68B986D117D40A7E109AE2FC85C291128DB4A12@MX01A.corp.emc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/e2eDi0V/xtL+Mc8"
Cc: linux-btrfs@vger.kernel.org
To: kathleen.hodge@emc.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <47C68B986D117D40A7E109AE2FC85C291128DB4A12@MX01A.corp.emc.com>
List-ID: <linux-btrfs.vger.kernel.org>


--/e2eDi0V/xtL+Mc8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 02, 2011 at 03:45:07PM -0400, kathleen.hodge@emc.com wrote:
> Hello,
> I'm trying to use mod3 ckds which are already RAID10 protection. (most of the doc I'm looking at uses fba instead of ckd, so I didn't know if this was a limitation)
> I'm addressing the head device and able to use these devices with no problem as ext3.  I've been reading that cache may remember that it used to be ext3, so I detached and reattached, but get the same result when trying to mount after formatting.
> 
> I use the following to make the file system after I've attached, varied online, formated and partitioned (also tried without the journaling switch).
> mke2fs -j -t btrfs /dev/dasdbj1

   Quoting the man page for that command:

"mke2fs  is used to create an ext2, ext3, or ext4 filesystem, [...]"

The -t option specifies which of ext2, ext3, and ext4 to create.  I'm
surprised it did anything at all given a type of "btrfs"...

   You probably wanted mkfs.btrfs instead:

# mkfs.btrfs -d single -m single /dev/dasdbj1

> Then the mount command:
> mount -t btrfs /dev/dasdbj1 /home/sdasd/d01
> mount: /dev/dasdbj1: can't read superblock

   If it created an ext2/3/4 filesystem, I'm not entirely surprised
that it can't find a btrfs superblock there. :)

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- We teach people management skills by examining characters in ---   
            Shakespeare.  You could look at Claudius's crisis            
                   management techniques, for example.                   

--/e2eDi0V/xtL+Mc8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFN5+u8IKyzvlFcI40RApK6AJ42pPJ4Yre0CA3Vh8S+m29AWgJkwwCgnhJj
G8cdW/Kye6iwx9EZ4ioHBi4=
=lDdr
-----END PGP SIGNATURE-----

--/e2eDi0V/xtL+Mc8--
