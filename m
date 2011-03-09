From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: btrfs fi df returns nothing
Date: Wed, 9 Mar 2011 11:47:46 +0000
Message-ID: <20110309114746.GA2998@carfax.org.uk>
References: <il7npu$5lh$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Cc: linux-btrfs@vger.kernel.org
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <il7npu$5lh$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 09, 2011 at 06:20:28AM -0500, Brian J. Murrell wrote:
> I am using btrfs on Ubuntu's LTS kernel (2.6.32-22-generic) and have

   Ouch. That's a *very* early kernel, in btrfs terms. There are a
significant number of serious bugs that have been fixed since then.

> updated the btrfs-tools to 0.19+20101101-1~lucid1.  I have also built
> the latest from
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git.
> 
> The problem is that I don't get anything from btrfs fi df $mountpoint.
> i.e., for the btrfs filesystem mounted at /mnt/btrfs-test/
> 
> # ./btrfs fi df /mnt/btrfs-test/
> #
> 
> See, no output.  Is my kernel module too old for that feature?  Maybe it is:
> 
> stat64("/mnt/btrfs-test/", {st_mode=S_IFDIR|0755, st_size=72, ...}) = 0
> open("/mnt/btrfs-test/",
> O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 3
> fcntl64(3, F_GETFD)                     = 0x1 (flags FD_CLOEXEC)
> ioctl(3, 0xc0109414, 0x999c320)         = -1 ENOTTY (Inappropriate ioctl
> for device)
> exit_group(-1)                          = ?
> 
> If my kernel module is too old, anyone know of a successful backport of
> a newer btrfs for Ubuntu Lucid?  In a PPA or otherwise?

   There's Ubuntu kernel PPAs listed on the btrfs wiki:
https://btrfs.wiki.kernel.org/index.php/Getting_started#Ubuntu_Linux

   The wiki is your friend. :)

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- "You are demons,  and I am in Hell!" "Well, technically, it's ---  
               London,  but it's an easy mistake to make."               

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNd2jiIKyzvlFcI40RAiTHAKCJjvS7Pk7wR8owRPSvU8f91dw+tgCfcmSO
l7Khgha/PE1V9BxJD1AJvC0=
=N4ZM
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
