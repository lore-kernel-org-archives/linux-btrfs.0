From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: [PATCH v2 1/5] commands added
Date: Sun, 10 Jul 2011 19:45:57 +0100
Message-ID: <20110710184557.GK4325@carfax.org.uk>
References: <cover.1301503683.git.list.btrfs@jan-o-sch.net>
 <c1e42995310a3424784535d4f684ea97a5622b2a.1301503683.git.list.btrfs@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3W6riq+uV6J42Ub"
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <c1e42995310a3424784535d4f684ea97a5622b2a.1301503683.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>


--u3W6riq+uV6J42Ub
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 30, 2011 at 06:53:09PM +0200, Jan Schmidt wrote:
> - scrub commands added
> - open_file_or_dir no longer static (needed by scrub.c)
> 
> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
> ---
>  Makefile     |    4 ++--
>  btrfs.c      |   18 +++++++++++++++++-
>  btrfs_cmds.c |    3 ++-
>  btrfs_cmds.h |    5 +++++
>  4 files changed, 26 insertions(+), 4 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 6e6f6c6..6630887 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -37,8 +37,8 @@ all: version $(progs) manpages
>  version:
>  	bash version.sh
>  
> -btrfs: $(objects) btrfs.o btrfs_cmds.o
> -	gcc $(CFLAGS) -o btrfs btrfs.o btrfs_cmds.o \
> +btrfs: $(objects) btrfs.o btrfs_cmds.o scrub.o
> +	gcc -lpthread $(CFLAGS) -o btrfs btrfs.o btrfs_cmds.o scrub.o \
>  		$(objects) $(LDFLAGS) $(LIBS)
>  
>  btrfsctl: $(objects) btrfsctl.o
> diff --git a/btrfs.c b/btrfs.c
> index 46314cf..2dfa0b7 100644
> --- a/btrfs.c
> +++ b/btrfs.c
> @@ -89,12 +89,28 @@ static struct Command commands[] = {
>  	},
>  	{ do_df_filesystem, 1,
>  	  "filesystem df", "<path>\n"
> -		"Show space usage information for a mount point\n."
> +		"Show space usage information for a mount point."
>  	},
>  	{ do_balance, 1,
>  	  "filesystem balance", "<path>\n"
>  		"Balance the chunks across the device."
>  	},
> +	{ do_scrub_start, -1,
> +	  "scrub start", "[-Bdqr] <path>|<device>\n"
> +		"Start a new scrub."

   Could you update this patch with detailed help for the various
command-line options, now that we've got a field for it in struct
Command?

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- There is no dark side to the Moon, really. As a matter of ---    
                          fact,  it's all dark.                          

--u3W6riq+uV6J42Ub
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOGfNlIKyzvlFcI40RAvISAJ9Bf6vhrAU+o/TsR7zLPJn4BY1/HQCgv36N
iv3HgjaIJDDcm52z31BdtFc=
=ErRO
-----END PGP SIGNATURE-----

--u3W6riq+uV6J42Ub--
