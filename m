From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: A little confused about what remains to make a stable release
Date: Thu, 18 Nov 2010 09:39:07 +0000
Message-ID: <20101118093907.GE2401@selene>
References: <AANLkTi=q4bKVGfD-QoF68NecL4e4d5dfcvMrgv5NHtb3@mail.gmail.com>
 <20101117225901.GA5367@vlad.carfax.org.uk>
 <230760eab83b95c53c2ec6e618360a01@arbitraryconstant.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JBi0ZxuS5uaEhkUZ"
Cc: Hugo Mills <hugo-lkml@carfax.org.uk>, linux-btrfs@vger.kernel.org
To: Anthony Roberts <btrfs-devel@arbitraryconstant.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <230760eab83b95c53c2ec6e618360a01@arbitraryconstant.com>
List-ID: <linux-btrfs.vger.kernel.org>


--JBi0ZxuS5uaEhkUZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 17, 2010 at 05:46:30PM -0700, Anthony Roberts wrote:
> >   It's stable *for you* when it functions with the workloads *you*
> >expect of it, with a failure rate that is acceptable *to you*.
> 
> I think there's a few ancillary things like a working fsck needed
> before it can even be recommended for widespread use, even to users
> willing to risk any residual bugs. IIRC at this point the utilities
> don't even aspire to provide basic recovery functionality (though
> Chris has posted that fsck is coming).
> 
> Beyond that, the management capabilities at this point don't look
> ready for long term use in a production environment. By this I
> mean adding/removing disks,

   That much is already there and working.

> reshaping arrays, etc. Without that I
> might use BTRFS on top of LVM/RAID just like any other filesystem,
> and there's features I'm looking forward to even if I that's all
> I can do, but without robust management features there's certain
> environments where it just doesn't make sense yet.

   What do you think is missing? Could you create and maintain a
wishlist page on the wiki[1], and populate it with all the things that
people need for production use? (This is an ongoing task -- track
what's actually finished and remove it; track what's currently being
worked on and mark it as such; keep an eye on discussions on the
mailing list for things that people need...)

> There's one or two other things I'm keeping an eye on. That
> limitation on the number of hardlinks you can have in a directory
> is kinda irksome. Also, dedup needs a way to verify/dedup safely
> before people can start doing stuff like deduping live VM images.

   Hugo.

[1] https://btrfs.wiki.kernel.org/index.php/Main_Page

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- Someone's been throwing dead sheep down my Fun Well ---       

--JBi0ZxuS5uaEhkUZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFM5PQ6IKyzvlFcI40RAhBXAJ9feve+5MTAItkd7Ksw9e3yQiJA3QCfSt3q
3w6VMq8AAW5zPZevZH6NUqI=
=zWRw
-----END PGP SIGNATURE-----

--JBi0ZxuS5uaEhkUZ--
