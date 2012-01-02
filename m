From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: (renamed thread) btrfs metrics
Date: Mon, 2 Jan 2012 16:39:44 +0000
Message-ID: <20120102163944.GB27122@carfax.org.uk>
References: <4F01BF5D.2070801@pocock.com.au>
 <CAE5mzviX5kJ70nG3bLPwE7E3ZjmdQvsKNUbs6XXqVhs+MEeSXw@mail.gmail.com>
 <4F01C6DC.3040609@pocock.com.au>
 <20120102151422.GA27122@carfax.org.uk>
 <4F01DA85.4050107@pocock.com.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JYK4vJDZwFMowpUq"
Cc: cwillu <cwillu@cwillu.com>, linux-btrfs@vger.kernel.org
To: Daniel Pocock <daniel@pocock.com.au>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F01DA85.4050107@pocock.com.au>
List-ID: <linux-btrfs.vger.kernel.org>


--JYK4vJDZwFMowpUq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 02, 2012 at 05:25:41PM +0100, Daniel Pocock wrote:
> 
> >    It's actually not possible in general. Since it's possible to have
> > different bits of the FS (data vs metadata) with different replication
> > levels, one byte written to the FS could take up either 1 or 2 bytes
> > of raw disk storage, and there's no way of predicting what the overall
> > usage will be, so it's not possible to give an accurate estimate of
> > free space.
> > 
> >    Similarly, if you have a 10G subvolume, and a snapshot of it, then
> > how much space does each one take up?
> 
> Yes, I agree it is not simple
> 
> However, the lvs command from LVM does provide a useful way to show how
> full a snapshot volume is.  In the btrfs situation, the snapshot is
> within the FS, so it is not quite the same metric

   The way that LVM works is very different to the way that btrfs
works. If you try drawing parallels, you will probably go very wrong.
LVM snapshots are (IIRC) given a fixed-size pool of blocks on
creation, from which blocks are taken when modifications are made to
the original, so it's possible to know how much of the pool has been
taken. With btrfs, as you've spotted, the pool is the entirety of the
unused space in the filesystem, so there's no limit on snapshot size
or the divergence of a snapshot from its original subvolume.

> I am looking at what metrics are needed to monitor btrfs in production.
>  I actually look after the ganglia-modules-linux package, which includes
> some FS space metrics, but I figured that btrfs throws all that out the
> window.
> 
> Can you suggest metrics that would be meaningful, do I look in /proc or
> with syscalls, is there any code I should look at for an example of how
> to extract them with C?  Ideally, Ganglia runs without root privileges
> too, so please let me know if btrfs will allow me to access them

   It depends on what you want to know, really. If you want "how close
am I to a full filesystem?", then the output of df will give you a
measure, even if it could be up to a factor of 2 out -- you can use it
for predictive planning, though, as it'll be near zero when the FS
runs out of space.

   If you really want to, you can get your hands into the filesystem
structures on a read-only (and non-locked) basis using the
BTRFS_IOC_TREE_SEARCH ioctl, and the FS structures are documented at
[1]. However, that's generally going to be pretty ugly, and most
likely pretty slow for many operations at the subvolume level.

   If you want anything on a per-subvolume basis, then you'll have to
wait for Arne to finish the work on quotas.

   Hugo.

[1] http://btrfs.ipv5.de/index.php?title=Data_Structures

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- The Tao that is seen / Is not the true Tao, until / You ---     
                           bring fresh toner.                            

--JYK4vJDZwFMowpUq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPAd3QIKyzvlFcI40RAhXwAJ4xqjzjr8+ArZ0AMJeRTEyQvaRWewCgtyqp
zHS7StslsRu/ingavNhoOgE=
=uOBz
-----END PGP SIGNATURE-----

--JYK4vJDZwFMowpUq--
