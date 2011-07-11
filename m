From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: [PATCH 2/2] add detailed help messages to btrfs command
Date: Mon, 11 Jul 2011 23:22:01 +0100
Message-ID: <20110711222201.GN4325@carfax.org.uk>
References: <201101231339.36599.kario@wit.edu.pl>
 <201101231342.43637.kario@wit.edu.pl>
 <4E1B1309.2080408@jan-o-sch.net>
 <4E1B430C.3020008@libero.it>
 <4E1B4ADC.1000202@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hD6P3ib1XCFtz2ni"
Cc: Goffredo Baroncelli <kreijack@libero.it>,
	linux-btrfs@vger.kernel.org, Hubert Kario <kario@wit.edu.pl>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E1B4ADC.1000202@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>


--hD6P3ib1XCFtz2ni
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 11, 2011 at 09:11:24PM +0200, Jan Schmidt wrote:
> On 07/11/2011 08:38 PM, Goffredo Baroncelli wrote:
> > what about generating the man page on the basis of the btrfs help
> > detailed messages ?
> > 
> > My idea is the following:
> > before the function source associated to the command we can put a
> > comment with a detailed help. The comment may be:
> > 
> > [...]
> > /*** man:btrfs subvolume create
> >  *
> >  *  btrfs subvolume create <path>
> >  *     create a new subvolume
> >  *
> >  *  The command [b]btrfs subvolume create[b] is used.....
> >  *
> >  ***/
> > 
> > void do_create_subvolume(int argc, char **argv)
> > {
> > [...]
> 
> Reminds me of java, but nevertheless, I like the general idea.

   In principle, it's attractive. I still have some reservations as to
the amount of effort involved in automating the process (vs manually
updating things), and in the levels of detail needed (see the
discussion below).

> > A script extracts from the comment in the source both:
> > - the text for the man page
> > - the text for the detailed help.

   Or possibly going the other direction: from the man page (which
contains all of the information we need to reproduce in the code), it
should be possible, with appropriate structuring, to retrieve the bits
that the code needs to know about, and insert them into a table in a
generated .c file. Just a thought. 

   Oh, and the current man page needs some major work on its
typography -- it's inconsistent with both itself, and with most other
man pages, as far as I can tell. I did have a patch for that, but it
was a long time ago, and clashed with almost everything.

> Does anybody have such a script around? I suppose we're not the first
> ones writing help texts and man pages.
> 
> > So we can reach the following goals:
> > - the help is linked to the code
> > - is less likely to forget to update the message
> > - the man page, the helps are always aligned
> 
> Only, we still will need like short and long help. E.g. the full text in
> the man page may be inappropriate as a --help message. Also, we do need
> a clever idea to get indentation right in the man pages. I fiddled a lot
> on the man pages for scrub parameter indentation (to get the second line
> describing a command line option indented correctly to start below the
> text of the first line, that was).

   We actually need three levels of help:

 * A one-liner "headline" version that comes in the synopsis section
   of the man page and the output of "btrfs --help"

    = btrfs filesystem defragment [-vf] [-c{zlib,lzo}] [-s <start>] <file>|<dir> [...]
	=   Defragment a file or directory

 * A collection of one-liners summarising all the switches, that comes
   as the output of "btrfs foo bar --help": a repeat of the "headline"
   version, plus a single (half-)line for each switch.

    = btrfs filesystem defragment [-vf] [-c{zlib,lzo}] [-s <start>] <file>|<dir> [...]
	=   Defragment a file or directory
	=   -v				verbose output
	=	-f				do the f thing
	=	-c				force compression algorithm (zlib or lzo)
	=   -s <start>		start the defrag from offset <start> in the file

 * A detailed description of the command as a whole and each option,
   which appears in the detail section of the man page.

    = btrfs filesystem defragment [-vf] [-c{zlib,lzo}] [-s <start>] <file>|<dir> [...]

	=   Defragment the given file(s) or directories. Defrag does not
	=   operate recursively, so if you want to defragment an entire
	=   subdirectory and all its children, you should use find(1) to list
	=   the files, and pass the list to btrfs fi defrag. [etc]
    =   -s <start>		Start the defragmentation operation at offset
	=                   <start> within the file.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
        --- Great oxymorons of the world, no. 2: Common Sense ---        

--hD6P3ib1XCFtz2ni
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOG3eJIKyzvlFcI40RAhS4AKC37m31U9RVkxY/INM4NPiJ08rFGQCfTgEu
4aIkU8CEEcMndfVuTXujI5Q=
=2hoO
-----END PGP SIGNATURE-----

--hD6P3ib1XCFtz2ni--
