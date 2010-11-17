From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: Update to Project_ideas wiki page
Date: Wed, 17 Nov 2010 17:56:57 +0000
Message-ID: <20101117175657.GB2401@selene>
References: <m3hbfg3acu.fsf@pullcord.laptop.org>
 <20101117143103.GA2401@selene>
 <AANLkTi=YcVE44g9waRBHQPido4_xf1o5hE4zmTPqVBxN@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CUfgB8w4ZwR/yMy5"
Cc: Hugo Mills <hugo-lkml@carfax.org.uk>, Chris Ball <cjb@laptop.org>,
	linux-btrfs@vger.kernel.org
To: Bart Noordervliet <bart@noordervliet.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=YcVE44g9waRBHQPido4_xf1o5hE4zmTPqVBxN@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--CUfgB8w4ZwR/yMy5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 17, 2010 at 04:12:29PM +0100, Bart Noordervliet wrote:
> Can I suggest we combine this new RAID level management with a
> modernisation of the terminology for storage redundancy, as has been
> discussed previously in the "Raid1 with 3 drives" thread of March this
> year? I.e. abandon the burdened raid* terminology in favour of
> something that makes more sense for a filesystem.

   Well, our current RAID modes are:

 * 1 Copy ("SINGLE")
 * 2 Copies ("DUP")
 * 2 Copies, different spindles ("RAID1")
 * 1 Copy, 2 Stripes ("RAID0")
 * 2 Copies, 2 Stripes [each] ("RAID10")

   The forthcoming RAID5/6 code will expand on that, with

 * 1 Copy, n Stripes + 1 Parity ("RAID5")
 * 1 Copy, n Stripes + 2 Parity ("RAID6")

   (I'm not certain how "n" will be selected -- it could be a config
option, or simply selected on the basis of the number of
spindles/devices currently in the FS).

   We could further postulate a RAID50/RAID60 mode, which would be

 * 2 Copies, n Stripes + 1 Parity
 * 2 Copies, n Stripes + 2 Parity

   For brevity, we could collapse these names down to: 1C, 2C, 2CR,
1C2S, 2C2S, 1CnS1P, 1CnS2P, 2CnS1P, 2CnS2P. However, that's probably a
bit too condensed for useful readability. I'd support some set of
terms based on this taxonomy, though, as it's fairly extensible, and
tells you the details of the duplication strategy in question.

> Mostly this would involve a discussion about what terms would make
> most sense, though some changes in the behaviour of btrfs redundancy
> modes may be warranted if they make things more intuitive.

   Consider the above a first suggestion. :)

> I could help you make these changes in your patches, or write my own
> patches against yours, though I'm also completely new to kernel
> development.

   Probably best to keep the kernel internals unchanged for this
particular issue, as they don't make much difference to the naming,
but patches to the userspace side of things (mkfs.btrfs and btrfs fi
df specifically) should be fairly straightforward.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- <gdb> The enemy have elected for Death by Powerpoint.  That's ---  
                          what they shall get.                           

--CUfgB8w4ZwR/yMy5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFM5BdpIKyzvlFcI40RApLLAJwKsOmXQ1u6rZ4wZuxJjGvVDRI++gCgsXc0
7mLygHeNuIXJOnv6FhPrGCc=
=voTH
-----END PGP SIGNATURE-----

--CUfgB8w4ZwR/yMy5--
