From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: Update to Project_ideas wiki page
Date: Wed, 17 Nov 2010 18:34:18 +0000
Message-ID: <20101117183418.GC2401@selene>
References: <m3hbfg3acu.fsf@pullcord.laptop.org>
 <20101117143103.GA2401@selene>
 <AANLkTi=YcVE44g9waRBHQPido4_xf1o5hE4zmTPqVBxN@mail.gmail.com>
 <20101117175657.GB2401@selene>
 <4CE41B97.4070606@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6zdv2QT/q3FMhpsV"
Cc: Hugo Mills <hugo-lkml@carfax.org.uk>,
	Bart Noordervliet <bart@noordervliet.net>,
	Chris Ball <cjb@laptop.org>, linux-btrfs@vger.kernel.org
To: Andreas Philipp <philipp.andreas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CE41B97.4070606@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--6zdv2QT/q3FMhpsV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 17, 2010 at 07:14:47PM +0100, Andreas Philipp wrote:
> On 17.11.2010 18:56, Hugo Mills wrote:
> > On Wed, Nov 17, 2010 at 04:12:29PM +0100, Bart Noordervliet wrote:
> >> Can I suggest we combine this new RAID level management with a
> >> modernisation of the terminology for storage redundancy, as has been
> >> discussed previously in the "Raid1 with 3 drives" thread of March this
> >> year? I.e. abandon the burdened raid* terminology in favour of
> >> something that makes more sense for a filesystem.
> >
> > Well, our current RAID modes are:
> >
> > * 1 Copy ("SINGLE")
> > * 2 Copies ("DUP")
> > * 2 Copies, different spindles ("RAID1")
> > * 1 Copy, 2 Stripes ("RAID0")
> > * 2 Copies, 2 Stripes [each] ("RAID10")
> >
> > The forthcoming RAID5/6 code will expand on that, with
> >
> > * 1 Copy, n Stripes + 1 Parity ("RAID5")
> > * 1 Copy, n Stripes + 2 Parity ("RAID6")
> >
> > (I'm not certain how "n" will be selected -- it could be a config
> > option, or simply selected on the basis of the number of
> > spindles/devices currently in the FS).
> Just one question on "small n": If one has N = 3*k >= 6 spindles, then
> RAID5 with n = N/2-1 results in something like RAID50? So having an
> option for "small n" might realize RAID50 given the right choice for n.

   I see what you're getting at, but actually, that would just be
RAID-5 with small n. It merely happens to spread chunks out over more
spindles than the minimum n+1 required to give you what you asked for.
(See the explanation below for why).

> > We could further postulate a RAID50/RAID60 mode, which would be
> >
> > * 2 Copies, n Stripes + 1 Parity
> > * 2 Copies, n Stripes + 2 Parity
> Isn't this RAID51/RAID61 (or 15/16 unsure on how to put) and would
> RAID50/RAID60 correspond to

   Errr... yes, you're right. My mistake. Although... again, see the
conclusion below. :)

> * 2 Stripes, n Stripes + 1 Parity
> * 2 Stripes, n Stripes + 2 Parity

   I'm not sure talking about RAID50-like things (as you state above)
makes much sense, given the internal data structures that btrfs uses:

   As far as I know(*), data is firstly allocated in chunks of about
1GiB per device. Chunks are grouped together to give you replication.
So, for a RAID-0 or RAID-1 arrangement, chunks are allocated in pairs,
picked from different devices. For RAID-10, they're allocated in
quartets, again on different devices. For RAID-5, they'd be allocated
in groups of n+1. For RAID-61, we'd use 2n+4 chunks in an allocation.

   For replication strategies where it matters (anything other than
DUP, SINGLE, RAID-1 so far), the chunks are then subdivided into
stripes of a fixed width. Data written to the disk is spread across
the stripes in an appropriate manner.

   From this point of view, RAID50 and RAID51 look much the same,
unless the stripe size for the "5" is different to the stripe size for
the "0" or "1". I'm not sure that's the case. If the stripe sizes are
the same, you'll basically get the same layout of data across the 2n+2
chunks -- it's just that (possibly) the internal labels of the chunks
which indicate which bit of data they're holding in the pattern will
be different.

   Hugo.

(*) I could be wrong, hopefully someone will correct me if so.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- A cross? Oy vey, have you picked the wrong vampire! ---       

--6zdv2QT/q3FMhpsV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFM5CAqIKyzvlFcI40RAllDAJ4x56MQnKx2WY+mm3pwBDgLw2BNPQCfW/ts
mEY3WxqsYVhLYlJCOyX64vs=
=I8rO
-----END PGP SIGNATURE-----

--6zdv2QT/q3FMhpsV--
