From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: df output wrong ?
Date: Mon, 5 Sep 2011 11:19:18 +0100
Message-ID: <20110905101918.GK9907@carfax.org.uk>
References: <4E649B73.6060802@consolejunkie.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lildS9pRFgpM/xzO"
Cc: linux-btrfs@vger.kernel.org
To: Leen Besselink <leen@consolejunkie.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E649B73.6060802@consolejunkie.net>
List-ID: <linux-btrfs.vger.kernel.org>


--lildS9pRFgpM/xzO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 05, 2011 at 11:50:43AM +0200, Leen Besselink wrote:
> Hi,
> 
> Just noticed something about df -h output I didn't expect.
> 
> I'm sorry if this has already been answered or is a know problem.
> 
> Just see the test-part below to see what I did.
> 
> ____ setup ____
> 
> - installed Fedora 16 Alpha on a KVM-VM with one 8GB HD-image.
> - did a yum update
> ( - got a kernel update, which broke grub setup, worked around it:
> kernel I use is: 3.0.0-1.fc16.x86_64)
> - installed btrfs-progs
> - created a directory /test
> - created 2 files with dd from /dev/zero with the size of 2GB in /test
> - created 2 loopback devices of the files
> - created a btrfs filesystem with RAID 1 data and RAID1 meta-data
> - created directory /test/mnt
> 
> ____ test _____
> 
> - mounted the btrfs filesystem on /test/mnt
> - created a file of 256MB with dd from /dev/zero in /test/mnt
> - created a snapshot of /test/mnt in /test/mnt/snap1
> - deleted 256MB file in /test/mnt
> - deleted snapshot /test/mnt/snap1
> - checked df -h, 256MB wasn't released. The filesystem does not look empty
> - unmounted /test/mnt
> - mounted /test/mnt
> - checked df -h, 256MB was released. The filesystem does look empty
> 
> Hope this is helpful.

   Snapshot/subvolume deletion is asynchronous -- it can take a while
to happen. Try waiting a minute or two after the snapshot deletion and
before looking at df -h.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- If it's December 1941 in Casablanca,  what time is it ---      
                              in New York?                               

--lildS9pRFgpM/xzO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOZKImIKyzvlFcI40RAgaYAJ0TafkL3Ux6EE4VfgWPza6613ENoACgmsfT
jK3nz0UWBtn0Qbp9gx+ocUc=
=GVc/
-----END PGP SIGNATURE-----

--lildS9pRFgpM/xzO--
