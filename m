From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: [PATCH 0/3] Btrfs-progs: restriper interface
Date: Tue, 7 Feb 2012 11:30:37 +0200
Message-ID: <20120207093037.GA9690@zambezi.lan>
References: <1328305752-32160-1-git-send-email-idryomov@gmail.com>
 <201202041406.28273.kreijack@inwind.it>
 <20120204144717.GB10916@zambezi.lan>
 <201202062320.19154.kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>
To: Goffredo Baroncelli <kreijack@inwind.it>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201202062320.19154.kreijack@inwind.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 06, 2012 at 11:20:18PM +0100, Goffredo Baroncelli wrote:
> On Saturday, 04 February, 2012 15:47:17 Ilya Dryomov wrote:
> > On Sat, Feb 04, 2012 at 02:06:28PM +0100, Goffredo Baroncelli wrote:
> > > Hi Ilya,
> > > 
> > > On Friday, 03 February, 2012 22:49:09 Ilya Dryomov wrote:
> > > > Hello,
> > > > 
> > > > This is the userspace part of restriper, rebased onto the new progs
> > > > infrastructure.  Restriper commands are located under 'balance' prefix,
> > > > which is now the top level command group.  However to not confuse
> > > > existing users 'balance' prefix is also available under 'filesystem':
> > > > 
> > > > btrfs [filesystem] balance start
> > > > btrfs [filesystem] balance pause
> > > > btrfs [filesystem] balance cancel
> > > > btrfs [filesystem] balance resume
> > > > btrfs [filesystem] balance status
> > > > 
> > > > Backwards compatibility is fully preserved thanks to the new command
> > > > parser: the old 'btrfs filesystem balance <path>' works as expected.
> > > 
> > > I prefer to avoid prefix which may confuse the user. If I have a
> > > subvolume
> > > 
> > > called "s", what means:
> > > 	btrfs filesystem balance s
> > > 
> > > Is it a missing argument (the path required for btrfs filesystem balance)
> > > or is it a synonymus of
> > > 
> > > 	btrfs filesystem balance start ./s
> > > 
> > > (or btrfs filesystem balance stop ./s)
> > > 
> > > ?
> > 
> > It's a path.  It's unambiguous because every subcommand requires an
> > argument. If you omit the path argument you get the following:
> 
> Sorry, I disagree. It is ambiguous because you are not able to  understand if 
> there is an error of missing parameters.
> 
> If exist a filesystem called 's' 
> 
> # btrfs fi bal s
> 
> could be:
> 
> 1) an error (missing parameters for the command "btrfs filesystem balance 
> start/status" )
> 2) the starting of the balance of the filesystem 's'

It's true, but you are supposed to look at the synopsis before using new
commands.  The old user (who doesn't know anything about these new fancy
commands) won't see the difference.  The new users should take a look at
the man page or at least at the help output.

To make things even more clear I'll merge a slight change to allow
multi-line synopsis for command groups.  So the help looks like:

btrfs-progs-new$ ./btrfs fi bal --help
usage: btrfs [filesystem] balance <command> [options] <path>
   or: btrfs [filesystem] balance <path>

    btrfs [filesystem] balance start [options] <path>
        Balance chunks across the devices
    btrfs [filesystem] balance pause <path>
        Pause running balance
    btrfs [filesystem] balance cancel <path>
        Cancel running or paused balance
    btrfs [filesystem] balance resume <path>
        Resume interrupted balance
    btrfs [filesystem] balance status [-v] <path>
        Show status of running or paused balance

'btrfs filesystem balance' command is deprecated, please use
'btrfs balance start' command instead.

It clearly shows that 's' in your example will be interpreted as a path.

Thanks,

		Ilya
