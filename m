From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: [PATCH 2/3] Btrfs-progs: implement new subcommand parser
Date: Tue, 7 Feb 2012 00:12:13 +0100
Message-ID: <201202070012.13956.kreijack@libero.it>
References: <1328304240-26100-1-git-send-email-idryomov@gmail.com> <201202041354.23686.kreijack@libero.it> <20120204144525.GA10916@zambezi.lan>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Ilya Dryomov <idryomov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120204144525.GA10916@zambezi.lan>
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday, 04 February, 2012 15:45:25 Ilya Dryomov wrote:
> On Sat, Feb 04, 2012 at 01:54:23PM +0100, Goffredo Baroncelli wrote:
> > Hi Ilya
> > 
> > On Friday, 03 February, 2012 22:23:59 you wrote:
> > > This completely replaces the existing subcommand infrastructure, which
> > > is not flexible enough to accomodate our needs.
> > 
> > Could you explain what you means with "our needs" ?
> 
> Hi Goffredo,
> 
> I've described the problem earlier: I need to preserve the old behaviour
> of 'btrfs fi balance <path>', and I can't do that when all I'm able to
> do is to assign individual command handlers.  In addition we might want
> to have per-command-group options in future, which won't be possible w/o
> a complete rewrite of the current system.
> 
> > > Instead of a global
> > > command table we now have per-level tables and command group handlers,
> > > which allows command-group-specific handling of options and
> > > subcommands. The new parser exports a clear interface and gets out of
> > > the way - all control over how matching is done is passed to commands
> > > and command group handlers.
> > 
> > The same could be done with the actual system. For example if you want to
> > to handle the "filesystem balance" subcommands family, you could handle
> > every syntax you want with changing the function do_balance; without
> > forcing everybody to develop a "group handlers". Of course a bit of work
> > should be done on the handling the help.
> 
> Nope, it couldn't.  I didn't really want to do all this work so I went
> that way first.  But the problem is that ambiguity interface, help
> interface and everything else is buried deep in the parser and is not
> exported.  Suppose I change do_balance(), then I have to write my own
> ambiguity engine to handle balance commands (eg I have 'start' and
> 'status'), I have to write my own usage/help functions, I have to fixup
> argv array so it contains the right subcommand name, etc, etc.

I am not enterely convinced that you cannot do this with the actual parser 
implementation. 

However, looking at your code it seems fine to me. I like the help system. My 
only suggestion is to move some checks (like the argument counting check) in a 
more centralized way where possible.

Beside that, I am still not happy about having "balance" both as single 
command and as "group". But this is a completely different question.

BR
G.Baroncelli.
