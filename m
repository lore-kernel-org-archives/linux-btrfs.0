From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: btrfs-tools in Debian squeeze-backports?
Date: Mon, 2 Jan 2012 15:14:22 +0000
Message-ID: <20120102151422.GA27122@carfax.org.uk>
References: <4F01BF5D.2070801@pocock.com.au>
 <CAE5mzviX5kJ70nG3bLPwE7E3ZjmdQvsKNUbs6XXqVhs+MEeSXw@mail.gmail.com>
 <4F01C6DC.3040609@pocock.com.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Cc: cwillu <cwillu@cwillu.com>, linux-btrfs@vger.kernel.org
To: Daniel Pocock <daniel@pocock.com.au>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F01C6DC.3040609@pocock.com.au>
List-ID: <linux-btrfs.vger.kernel.org>


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 02, 2012 at 04:01:48PM +0100, Daniel Pocock wrote:
> One thing I've already noticed in 2.6.39 (and both versions of the
> tools) is that df results are misleading.  E.g. if I run regular df (not
> btrfs fi df), I am seeing the same amount of available space for all
> filesystems.  Is there currently a way to see space used by each
> subvolume and snapshot and which kernel and tools versions might be needed?

   It's actually not possible in general. Since it's possible to have
different bits of the FS (data vs metadata) with different replication
levels, one byte written to the FS could take up either 1 or 2 bytes
of raw disk storage, and there's no way of predicting what the overall
usage will be, so it's not possible to give an accurate estimate of
free space.

   Similarly, if you have a 10G subvolume, and a snapshot of it, then
how much space does each one take up?

   If you said 10G, then you're wrong, because the total storage space
for the two together is only 10G.

   If, on the basis of that, you said 5G each, you're wrong, because
if you delete one of them, you get no free space back.

   If, on the basis of that, you said 0G each, you're wrong, because
if you delete both of them you get 10G of free space back.

   The best you can ask is "if I delete this subvolume, how much space
will I get back?", but even that's non-trivial: Arne Jansen is working
on that feature as a side-effect of his quota work, and it will be
coming at some point, but we can't do it right now.

   See the FAQ on filesystem usage[1] for how to interpret the btrfs
tools for examining space usage, and the mis-named "sysadmin's
guide"[2] for more horrible details of what's going on underneath.

   Hugo.

[1] http://btrfs.ipv5.de/index.php?title=FAQ#Why_does_df_show_incorrect_free_space_for_my_RAID_volume.3F
[2] http://btrfs.ipv5.de/index.php?title=SysadminGuide

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- I'm on a 30-day diet. So far I've lost 18 days. ---         

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPAcnOIKyzvlFcI40RAgLqAKCEP0WNsMLpopR5BuyFj5Xpu+8jzwCgrkBT
RmD9Z4KuFekOtZHcxxk9Aq8=
=aQ5M
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
