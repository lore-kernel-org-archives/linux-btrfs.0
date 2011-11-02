From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: [BTRFS-PROG][PATCH 1/7] Correct xstrip() function
Date: Wed, 2 Nov 2011 21:39:40 +0000
Message-ID: <20111102213940.GA28749@carfax.org.uk>
References: <1341299.kzfvzJ2fHp@venice>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com,
	Arne Jansen <sensille@gmx.net>,
	Ilya Dryomov <idryomov@gmail.com>
To: Goffredo Baroncelli <kreijack@inwind.it>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1341299.kzfvzJ2fHp@venice>
List-ID: <linux-btrfs.vger.kernel.org>


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 02, 2011 at 10:22:41PM +0100, Goffredo Baroncelli wrote:
> this is the first of 7 patches, which improve the man page of the btrfs 
> command.
> I added some basic text fro the man page for the "filesystem restriper *" and 
> the "quota/qgroup *" commands. I put in CC the writer hoping that they will 
> care to maintain aligned the documentation with the code.
> 
> These patches are base on the latest "Hugo Mills" integration branch.

   Please don't do this -- it makes it harder for me to integrate,
because I throw away each integration branch before making the next
one, so I have to rebase your patches back to master before I can
integrate them...

   Basing patches on Chris's master (or my for-chris branch, if I've
got one) is greatly preferred from my point of view.

   Hugo.

> This patch correct a bug in the xstrip() function, which prevented to erase the
>  unneeded spaces.
> 
> Comments are welcome.
> 
> BR
> G.Baroncelli
> 
> Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
> 
> ---
>  helpextract.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/helpextract.c b/helpextract.c
> index 9489ea0..a729074 100644
> --- a/helpextract.c
> +++ b/helpextract.c
> @@ -38,20 +38,21 @@ static char *xstrip(char *s){
>  
>  	char *last=NULL;
>  	char *first;
> +	char prev;
>  
>  	while(*s && isspace(*s) ) s++;
>  
>  	first=s;
> -
> +	prev=*s;
>  	while(*s){
> -		if(isspace(*s)) last=s;
> +		if(!isspace(prev) && isspace(*s)) last=s;
> +		prev=*s;
>  		s++;
>  	}
>  
>  	if(last) *last=0;
>  	return first;
>  
> -
>  }
>  
>  static void addtuple(char *key, char *cmdline, char *short_help, 
> @@ -184,7 +185,7 @@ static int search_in_file(char *nf){
>  	return 0;
>  }
>  
> -/* remove all the escape sequence excepet \\ */
> +/* remove all the escape sequence except \\ */
>  static char * my_escape(char *src, char *filters[] ){
>  
>  	static char buffer[LINEBUF*5];
> 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- Startle, startle, little twink.  How I wonder what you think. ---  

--liOOAslEiF7prFVr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOsbicIKyzvlFcI40RAjEvAKCbSIlaZ+G/DPRVQMaMdEtQssFQewCghx1g
SsQb27yjP3oLXwt0VJQueCQ=
=x7vl
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
