From: Hubert Kario <kario@wit.edu.pl>
Subject: Re: [PATCH 2/2] add detailed help messages to btrfs command
Date: Tue, 12 Jul 2011 12:49:32 +0200
Message-ID: <201107121249.32700.kario@wit.edu.pl>
References: <201101231339.36599.kario@wit.edu.pl> <4E1B4ADC.1000202@jan-o-sch.net> <20110711222201.GN4325@carfax.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Cc: Jan Schmidt <list.btrfs@jan-o-sch.net>,
	Goffredo Baroncelli <kreijack@libero.it>,
	linux-btrfs@vger.kernel.org
To: Hugo Mills <hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110711222201.GN4325@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 12 of July 2011 00:22:01 Hugo Mills wrote:
> On Mon, Jul 11, 2011 at 09:11:24PM +0200, Jan Schmidt wrote:
> > On 07/11/2011 08:38 PM, Goffredo Baroncelli wrote:
[snip]
> > > A script extracts from the comment in the source both:
> > > - the text for the man page
> > > - the text for the detailed help.
> 
>    Or possibly going the other direction: from the man page (which
> contains all of the information we need to reproduce in the code), it
> should be possible, with appropriate structuring, to retrieve the bits
> that the code needs to know about, and insert them into a table in a
> generated .c file. Just a thought.

I think that the first line in normal help message and advanced help message 
can and sometimes should be different.

The basic as concise as possible, while the advanced verbose and quite 
detailed (for example explaining what a filesystem scrub /is/)
 
>    Oh, and the current man page needs some major work on its
> typography -- it's inconsistent with both itself, and with most other
> man pages, as far as I can tell. I did have a patch for that, but it
> was a long time ago, and clashed with almost everything.

Yes, until we won't have a single current tree for btrfs-progs there will be 
inconsistencies that will need to be fixed later.

But I guess that with Hugo's tree we're getting there.
 
> > Does anybody have such a script around? I suppose we're not the first
> > ones writing help texts and man pages.
> > 
> > > So we can reach the following goals:
> > > - the help is linked to the code
> > > - is less likely to forget to update the message
> > > - the man page, the helps are always aligned
> > 
> > Only, we still will need like short and long help. E.g. the full text in
> > the man page may be inappropriate as a --help message. Also, we do need
> > a clever idea to get indentation right in the man pages. I fiddled a lot
> > on the man pages for scrub parameter indentation (to get the second line
> > describing a command line option indented correctly to start below the
> > text of the first line, that was).
> 
>    We actually need three levels of help:
> [snip]

I'd that the biggest problem, putting it all in code and formatting will be a 
real pain...

Hubert
