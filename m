From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: [PATCH] Btrfs-progs: restriper interface
Date: Sat, 7 Jan 2012 16:25:29 +0200
Message-ID: <20120107142529.GA8404@zambezi.lan>
References: <1325860680-19403-1-git-send-email-idryomov@gmail.com>
 <201201071348.45052.kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: Goffredo Baroncelli <kreijack@inwind.it>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201201071348.45052.kreijack@inwind.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 07, 2012 at 01:48:44PM +0100, Goffredo Baroncelli wrote:
> On Friday, 06 January, 2012 15:37:59 Ilya Dryomov wrote:
> > Hello,
> > 
> > This is an update of userspace restriper interface.  The main change is
> > that restriper commands have been moved under balance prefix.  So now we
> > have:
> > 
> > btrfs fi balance start
> > btrfs fi balance pause
> > btrfs fi balance cancel
> > btrfs fi balance resume
> > btrfs fi balance status
> > 
> > This breaks btrfs-progs backwards compatibility: to get the old
> > balancing behaviour you have to call 'btrfs fi balance start' instead of
> > 'btrfs fi balance'.  This is caused by stupidity of the core sub-command
> > matcher.
> 
> Hi Ilya,
> 
> what you called "stupidity of the core sub-command matcher" was a design 
> decision.
> 
> If you make "btrfs balance" a both command and a prefix you (my opinion) 
> confuses a possible user and complex the interface:
> 
> for example what means:
> 
> # btrfs filesystem balance pause
> 
> when 'pause' (and all the valid abbreviation like "pa" or "p" ) is a valid 
> mount point ?

pause needs an argument so technically we have a way out here, but at
the expense of an awful interface (because then we have to be able to
deal with sub-commands with no arguments, etc)

You are right, I was too quick to call it stupid.  I guess my problem is
that I never bought this "the shortest abbreviation possible" thing.
IMHO it would be much better if we had our long names and a handful of
predefined abbreviations (like ip command for example).

> 
> My opinion, in order to not break the backward compatibility is to add another 
> subcommand family, like 'restriper' or whatsoever, then deprecating the 
> 'balance' sub command.

It was that way initially, but half of what restriper does is selective
balancing.  The other half is profile changing, but that also boils down
to a balance.  So I decided not to introduce another obscure term.

As for compatibility, I guess we will have to eat it and have everybody
switch from "btrfs fi balance" to "btrfs fi balance start" if we want
that shortest match behaviour.  However if people feel strong about it I
surely can put it under "restripe" and keep "btrfs fi balance" intact.

Chris ?

> 
> Finally, please could you update the man page too ?

I will, this version was not intended for pulling anyway because of this
problem.

Thanks,

		Ilya

