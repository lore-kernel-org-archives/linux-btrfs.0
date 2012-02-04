From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: [PATCH 2/3] Btrfs-progs: implement new subcommand parser
Date: Sat, 4 Feb 2012 16:45:25 +0200
Message-ID: <20120204144525.GA10916@zambezi.lan>
References: <1328304240-26100-1-git-send-email-idryomov@gmail.com>
 <1328304240-26100-3-git-send-email-idryomov@gmail.com>
 <201202041354.23686.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Goffredo Baroncelli <kreijack@libero.it>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201202041354.23686.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 04, 2012 at 01:54:23PM +0100, Goffredo Baroncelli wrote:
> Hi Ilya
> 
> On Friday, 03 February, 2012 22:23:59 you wrote:
> > This completely replaces the existing subcommand infrastructure, which
> > is not flexible enough to accomodate our needs. 
> 
> Could you explain what you means with "our needs" ?

Hi Goffredo,

I've described the problem earlier: I need to preserve the old behaviour
of 'btrfs fi balance <path>', and I can't do that when all I'm able to
do is to assign individual command handlers.  In addition we might want
to have per-command-group options in future, which won't be possible w/o
a complete rewrite of the current system.

> 
> > Instead of a global
> > command table we now have per-level tables and command group handlers,
> > which allows command-group-specific handling of options and subcommands.
> > The new parser exports a clear interface and gets out of the way - all
> > control over how matching is done is passed to commands and command
> > group handlers.
> 
> The same could be done with the actual system. For example if you want to to 
> handle the "filesystem balance" subcommands family, you could handle every 
> syntax you want with changing the function do_balance; without forcing 
> everybody to develop a "group handlers". Of course a bit of work should be 
> done on the handling the help.

Nope, it couldn't.  I didn't really want to do all this work so I went
that way first.  But the problem is that ambiguity interface, help
interface and everything else is buried deep in the parser and is not
exported.  Suppose I change do_balance(), then I have to write my own
ambiguity engine to handle balance commands (eg I have 'start' and
'status'), I have to write my own usage/help functions, I have to fixup
argv array so it contains the right subcommand name, etc, etc.

In addition to not being exported it's plain hard to change it because
it's written with the global multi-token command table in mind and is
not modular.  So I went ahead and wrote a simple parse_command function,
a simple usage/help interface and switched everybody to use it.  In
general it adds about ~250 lines and most of it is usage strings.

> 
> 
> > One side effect of this is that command implementors have to check the
> > number of arguments themselves - patch to fix up all existing commands
> > follows.
> 
> I agree with you that the current systema has somes problems; the first is the 
> help which should be improved.
> 
> For example, using the syntax of the C we can extend the struct Command with 
> some additional fields:
> - (*help_handler)();		/* if != NULL -> generic handler for the 
> 					    command help */
> - min_args;			/* if != -1 -> minimum arguments */
> - max_args;			/* if != -1 -> maximum arguments */
> 
> A command definition could became:
> 
> 	{ function, 0,
> 		"cmd sub_cmd sub_sub_cmd", 
> 		.help_handler =	my_help_function,
> 		.min_args =		10,
> 		.max_args = 		20,
> 	}
> 
> 
> what do you think

The min_args/max_args won't help because it doesn't take options into
account.  Some commands then use getopt to parse options, others don't.
The problem with your approach is that you simply count distinct tokens,
including options for those commands that have them and then we end up
with arbitrary error messages because commands with options still have
to check argc anyway after the options are parsed.  (and they do that,
and then they dump some arbitrary string instead of help)  As for the
help_handler, this is pretty much the same I did.

However these two problems are not the point of the patch, it's just
something I fixed along the way.  The real issue is the pure parser
interface and (to a lesser extent) the global command table.

Thanks,

		Ilya
