From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: revert to static snapshot on reboot
Date: Mon, 9 Jan 2012 09:51:36 +0000
Message-ID: <20120109095136.GE12629@carfax.org.uk>
References: <20120109064304.18411.qmail@otpproductions.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5xSkJheCpeK0RUEJ"
Cc: linux-btrfs@vger.kernel.org
To: btrfs@spiritvideo.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120109064304.18411.qmail@otpproductions.com>
List-ID: <linux-btrfs.vger.kernel.org>


--5xSkJheCpeK0RUEJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 08, 2012 at 10:43:04PM -0800, btrfs@spiritvideo.com wrote:
> Hi all --
> 
> I just installed my first btrfs-based linux tonight, and I must say it
> gives me a very warm feeling!  Congratulations on all your hard work
> and your fine product.
> 
> I administer laptops for a small school, and we want to implement what
> Deep Freeze (http://www.faronics.com/enterprise/deep-freeze) does for
> Windows -- no matter what a student does after they log in, when they
> reboot it is all forgotten and the computer has returned to a standard
> state.
> 
> I would think this would be a FAQ, but I have searched the web and
> mailing list for the past couple of hours.
> 
> Of course it's easy to mount a snapshot, but then if students make
> changes the snapshot changes.
> 
> The plan that occurs to me is to make a snapshot of the system in the
> state that I want to always boot.  Then, I would rewrite the init
> script in the initrd to (a) delete any old tmp copy of the snapshot;
> (b) copy the static snapshot to a tmp copy; (c) mount the tmp copy.
> 
> That's a little harder than I was hoping to work -- is there an easier
> way to get this functionality?

   I think you've got the right approach there. I can't immediately
see anything simpler.

   The other way of doing it I can think of, without using btrfs
snapshots, might be to mount / read-only, and then mount a disposable
writable layer on top of it with some union filesystem.

> I have a small ext4 boot partition containing grub, vmlinuz and
> initramfs.  Everything else is in a big btrfs root partition.  I am
> running Fedora 14, with Fedora-patched linux 2.6.35.  I could upgrade
> if necessary.

   Yes, do upgrade. Really, really do upgrade. 2.6.35 is nearly 18
months old, and there are many serious bugs that have been fixed in
btrfs since then. For btrfs, you should be running the latest release
kernel (3.2 currently) at the *minimum*. Preferably, you should be
running the (later-series) -rc kernels; I'd avoid -rc1 or -rc2, but by
-rc3 or so it's usually stabilised to the point that it's usable.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- He's playing Schubert.  I think Schubert is losing. ---       

--5xSkJheCpeK0RUEJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPCrioIKyzvlFcI40RAsnoAJ9j2PZ+b6P8+8kxDwS+NW3qYlxbKACfV7PY
SU2ZNP1zZ7CdOVJNrirjyzU=
=m9oj
-----END PGP SIGNATURE-----

--5xSkJheCpeK0RUEJ--
