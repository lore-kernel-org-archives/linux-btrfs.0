From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: [PATCH 2/2] add detailed help messages to btrfs command
Date: Tue, 12 Jul 2011 11:43:05 +0100
Message-ID: <20110712104305.GB10498@carfax.org.uk>
References: <201101231339.36599.kario@wit.edu.pl>
 <201101231342.43637.kario@wit.edu.pl>
 <4E1B1309.2080408@jan-o-sch.net>
 <201107121240.06740.kario@wit.edu.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8GpibOaaTibBMecb"
Cc: Jan Schmidt <list.btrfs@jan-o-sch.net>, linux-btrfs@vger.kernel.org
To: Hubert Kario <kario@wit.edu.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201107121240.06740.kario@wit.edu.pl>
List-ID: <linux-btrfs.vger.kernel.org>


--8GpibOaaTibBMecb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 12, 2011 at 12:40:06PM +0200, Hubert Kario wrote:
> On Monday 11 of July 2011 17:13:13 Jan Schmidt wrote:
> > Hi Hubert,
> > 
> > I have to admit I did not recognize this patch but now Hugo is forcing
> > me to use the "detailed help messages" and I've got an improvement to
> > suggest:
> > 
> > On 23.01.2011 13:42, Hubert Kario wrote:
> [snip]
> > >  	{ do_defrag, -1,
> > >  	
> > >  	  "filesystem defragment", "[-vcf] [-s start] [-l len] [-t size]
> > >  	  <file>|<dir> [<file>|<dir>...]\n"
> > > 
> > > -		"Defragment a file or a directory."
> > > +		"Defragment a file or a directory.",
> > > +          "[-vcf] [-s start] [-l len] [-t size] <file>|<dir>
> > > [<file>|<dir>...]\n" +          "Defragment file data or directory
> > > metadata.\n"
> > > +                "-v         be verbose\n"
> > > +                "-c         compress the file while defragmenting\n"
> > > +                "-f         flush data to disk immediately after
> > > defragmenting\n" +                "-s start   defragment only from byte
> > > onward\n" +                "-l len     defragment only up to len
> > > bytes\n"
> > > +                "-t size    minimal size of file to be considered for
> > > defragmenting\n"
> > 
> > Lots of too long lines.
> 
> you mean the code or the printed messages? 
> messages fit a 80 column screen, I remember I double checked it
> 
> > 
> > I don't like to repeat the synopsis passage. How about adding the
> > general ->help when printing ->adv_help as well? This reduces the need
> > of duplication.
> 
> I think I added it because of differences in formatting.
> Also I'd say we don't want to overload the user with information when he 
> mistypes a command so the main help command should be as concise as possible 
> while the advanced may be much more detailed (looking at the mailing list, `fi 
> df` could definitely use some more verbose help message)
> 
> > 
> > To prove my point, looking at the current version in Hugo's integration
> > branch, your two synopsis lines already got inconsistent regarding the
> > -c option :-)
> 
> That's because the patches are submitted with base as Chris tree, not the 
> Hugo's so the result is a real patchwork that needs some clean-up
> 
> [snip]
> 
> > > @@ -148,10 +184,10 @@ static void help(char *np)
> > > 
> > >  	printf("Usage:\n");
> > >  	for( cp = commands; cp->verb; cp++ )
> > > 
> > > -		print_help(np, cp);
> > > +		print_help(np, cp, BASIC_HELP);
> > > 
> > >  	printf("\n\t%s help|--help|-h\n\t\tShow the help.\n",np);
> > 
> >                             ^^^^^^^^^
> > You did not change this, but as we are here, ...
> 
> I wanted to leave as much code unchanged as possible (this /was/ my first 
> patch to btrfs-tools)
> 
> > 
> > > -	printf("\n\t%s <cmd> --help\n\t\tShow detailed help for a command
> > > or\n\t\t" +	printf("\n\t%s <cmd> --help\n\t\tShow detailed help for a
> > > command or"
> > 
> >                              ^^^^^^^
> > ... why not extending the general rule so that help messages will be
> > printed with --help and -h?
> 
> We have to remember that this way we loose -h switch, quite intuitive to show 
> base 2 sizes with `btrfs file df`... 

   Indeed. To quote from "df --help":

  -h, --human-readable  print sizes in human readable format (e.g., 1K 234M 2G)
  -H, --si              likewise, but use powers of 1000 not 1024
[...]
      --help     display this help and exit

   I should probably resurrect my patch to implement this for btrfs.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- To an Englishman, 100 miles is a long way;  to an American, ---   
                        100 years is a long time.                        

--8GpibOaaTibBMecb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOHCU5IKyzvlFcI40RAn46AJ4+nlQLuIa4R2BQasAiWndeqfc5OwCgisNU
MTZNPfjfQG24KMSXnQ1/pAw=
=J94C
-----END PGP SIGNATURE-----

--8GpibOaaTibBMecb--
