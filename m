From: Hubert Kario <kario@wit.edu.pl>
Subject: Re: [PATCH 2/2] add detailed help messages to btrfs command
Date: Tue, 12 Jul 2011 12:40:06 +0200
Message-ID: <201107121240.06740.kario@wit.edu.pl>
References: <201101231339.36599.kario@wit.edu.pl> <201101231342.43637.kario@wit.edu.pl> <4E1B1309.2080408@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E1B1309.2080408@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 11 of July 2011 17:13:13 Jan Schmidt wrote:
> Hi Hubert,
> 
> I have to admit I did not recognize this patch but now Hugo is forcing
> me to use the "detailed help messages" and I've got an improvement to
> suggest:
> 
> On 23.01.2011 13:42, Hubert Kario wrote:
[snip]
> >  	{ do_defrag, -1,
> >  	
> >  	  "filesystem defragment", "[-vcf] [-s start] [-l len] [-t size]
> >  	  <file>|<dir> [<file>|<dir>...]\n"
> > 
> > -		"Defragment a file or a directory."
> > +		"Defragment a file or a directory.",
> > +          "[-vcf] [-s start] [-l len] [-t size] <file>|<dir>
> > [<file>|<dir>...]\n" +          "Defragment file data or directory
> > metadata.\n"
> > +                "-v         be verbose\n"
> > +                "-c         compress the file while defragmenting\n"
> > +                "-f         flush data to disk immediately after
> > defragmenting\n" +                "-s start   defragment only from byte
> > onward\n" +                "-l len     defragment only up to len
> > bytes\n"
> > +                "-t size    minimal size of file to be considered for
> > defragmenting\n"
> 
> Lots of too long lines.

you mean the code or the printed messages? 
messages fit a 80 column screen, I remember I double checked it

> 
> I don't like to repeat the synopsis passage. How about adding the
> general ->help when printing ->adv_help as well? This reduces the need
> of duplication.

I think I added it because of differences in formatting.
Also I'd say we don't want to overload the user with information when he 
mistypes a command so the main help command should be as concise as possible 
while the advanced may be much more detailed (looking at the mailing list, `fi 
df` could definitely use some more verbose help message)

> 
> To prove my point, looking at the current version in Hugo's integration
> branch, your two synopsis lines already got inconsistent regarding the
> -c option :-)

That's because the patches are submitted with base as Chris tree, not the 
Hugo's so the result is a real patchwork that needs some clean-up

[snip]

> > @@ -148,10 +184,10 @@ static void help(char *np)
> > 
> >  	printf("Usage:\n");
> >  	for( cp = commands; cp->verb; cp++ )
> > 
> > -		print_help(np, cp);
> > +		print_help(np, cp, BASIC_HELP);
> > 
> >  	printf("\n\t%s help|--help|-h\n\t\tShow the help.\n",np);
> 
>                             ^^^^^^^^^
> You did not change this, but as we are here, ...

I wanted to leave as much code unchanged as possible (this /was/ my first 
patch to btrfs-tools)

> 
> > -	printf("\n\t%s <cmd> --help\n\t\tShow detailed help for a command
> > or\n\t\t" +	printf("\n\t%s <cmd> --help\n\t\tShow detailed help for a
> > command or"
> 
>                              ^^^^^^^
> ... why not extending the general rule so that help messages will be
> printed with --help and -h?

We have to remember that this way we loose -h switch, quite intuitive to show 
base 2 sizes with `btrfs file df`... 

-- 
Hubert
