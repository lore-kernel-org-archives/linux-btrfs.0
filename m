From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: [PATCH v2] btrfs-progs: btrfs: implement 'start-sync' and
 'wait-sync' commands
Date: Wed, 3 Nov 2010 11:49:09 +0000
Message-ID: <20101103114909.GA8137@vlad.carfax.org.uk>
References: <1288629262-5405-1-git-send-email-sage@newdream.net>
 <1288629262-5405-2-git-send-email-sage@newdream.net>
 <201011021958.27578.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Cc: linux-btrfs@vger.kernel.org, Sage Weil <sage@newdream.net>
To: Goffredo Baroncelli <kreijack@libero.it>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201011021958.27578.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 02, 2010 at 07:58:27PM +0100, Goffredo Baroncelli wrote:
> On Monday, 01 November, 2010, Sage Weil wrote:
> > The 'start-sync' command initiates a sync, but does not wait for it to
> > complete.  A transaction is printed that can be fed to 'wait-sync', which
> > will wait for it to commit.
> > 
> > 'wait-sync' can also be used in combination with 'async-snapshot' to wait
> > for an async snapshot creation to commit.
> > 
> > Updates the man page too.
> > 
> > Signed-off-by: Sage Weil <sage@newdream.net>
> > ---
> >  btrfs.c        |    9 +++++++++
> >  btrfs_cmds.c   |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  btrfs_cmds.h   |    2 ++
> >  man/btrfs.8.in |   14 ++++++++++++++
> >  4 files changed, 74 insertions(+), 0 deletions(-)
> > 
> > diff --git a/btrfs.c b/btrfs.c
> > index 46314cf..c871f4a 100644
> > --- a/btrfs.c
> > +++ b/btrfs.c
> > @@ -77,6 +77,15 @@ static struct Command commands[] = {
> >  	  "filesystem sync", "<path>\n"
> >  		"Force a sync on the filesystem <path>."
> >  	},
> > +	{ do_start_sync, 1,
> > +	  "filesystem start-sync", "<path>\n"
> > +	        "Start a sync on the filesystem <path>, and print the 
> resulting\n"
> > +	        "transaction id."
> > +	},
> 
> Like the command "btrfs subvol snapshot", I think that it is better to add a 
> modifier instead of a new command.
> 
>  btrfs filesystem sync [--async]
> 
> Sorry if I noticed this too late. But I don't see a valid reason to add 
> another command. From a UI point of view the meaning of the command is the 
> same, change only slight the behavior.
> 
> Even tough I have to admint that "sync --async" sound strange. May be flush is 
> better ?

   How about "btrfs filesystem sync --background"?

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
            --- You're never alone with a rubber duck... ---             

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFM0Uw0IKyzvlFcI40RAmhpAJ9AgkGGUObuknBs2pwE1nh4E6s/zACdEXlS
nFoAHHyF0XzIeilRHq2cDaQ=
=Z2c1
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
