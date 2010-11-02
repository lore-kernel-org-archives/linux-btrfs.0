From: Sage Weil <sage@newdream.net>
Subject: Re: [PATCH 2/3] btrfs: implement 'async-snapshot' command
Date: Tue, 2 Nov 2010 11:45:52 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.1011021144130.9887@cobra.newdream.net>
References: <1288461366-26914-1-git-send-email-sage@newdream.net>
 <201010302027.20084.kreijack@libero.it> <Pine.LNX.4.64.1011010929330.29194@cobra.newdream.net>
 <201011021942.32781.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Goffredo Baroncelli <kreijack@libero.it>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201011021942.32781.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2 Nov 2010, Goffredo Baroncelli wrote:
> On Monday, 01 November, 2010, Sage Weil wrote:
> > On Sat, 30 Oct 2010, Goffredo Baroncelli wrote:
> > > On Saturday, 30 October, 2010, Sage Weil wrote:
> > > > This is identical to 'snapshot', but uses the new async snapshot 
> creation
> > > > ioctl, and prints out the transid the new snapshot will be committed
> > > > with.
> > > > 
> > > > Signed-off-by: Sage Weil <sage@newdream.net>
> > > > ---
> > > >  btrfs.c      |    8 +++++++-
> > > >  btrfs_cmds.c |   32 +++++++++++++++++++++++++++-----
> > > >  btrfs_cmds.h |    3 ++-
> > > >  3 files changed, 36 insertions(+), 7 deletions(-)
> > > > 
> > > > diff --git a/btrfs.c b/btrfs.c
> > > > index 46314cf..c4b9a31 100644
> > > > --- a/btrfs.c
> > > > +++ b/btrfs.c
> > > > @@ -44,11 +44,17 @@ static struct Command commands[] = {
> > > >  	/*
> > > >  		avoid short commands different for the case only
> > > >  	*/
> > > > -	{ do_clone, 2,
> > > > +	{ do_create_snap, 2,
> > > >  	  "subvolume snapshot", "<source> [<dest>/]<name>\n"
> > > >  		"Create a writable snapshot of the subvolume <source> with\n"
> > > >  		"the name <name> in the <dest> directory."
> > > >  	},
> > > > +	{ do_create_snap_async, 2,
> > > > +	  "subvolume async-snapshot", "<source> [<dest>/]<name>\n"
> > > > +		"Create a writable snapshot of the subvolume <source> with\n"
> > > > +		"the name <name> in the <dest> directory.  Do not wait for\n"
> > > > +	        "the snapshot creation to commit to disk before returning."
> > > > +	},
> > > 
> > > Why create another command ? I think that it is better add a switch like
> > > 
> > > btrfs subvolume snapshot [--async] <source> [<dest>/]<name>
> > 
> > How about
> > 
> >  btrfs subvolume snapshot <source> [<dest>/]<name> [async]
> > 
> > That avoids ambiguity when <source> is named '--async' and simplifies 
> > parsing.  Updated patches follow (including man page updates).
> > 
> > sage
> > 
> 
> No please ! Sorry but this is too strange as syntax.
> 
> When the <source> is named "--async" it is possible to execute the command 
> passing "./--async". This workaround is used in any unix command (have you 
> ever thought what happens if you execute "rm *" when exists a file named "-rf"  
> ?).

Oh right, that's better.  I'm used to using -- (as in 'grep -- -foo'; rm 
supports the same syntax).  Will resend.

sage


> I think that "--async" is a modification of the standard behaviour of "btrfs s 
> s" command, so it is natural to use the switch syntax (30+ years of unix say 
> so :-) )
> 
> Goffredo
> 
> -- 
> gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
> Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
> 
> 
