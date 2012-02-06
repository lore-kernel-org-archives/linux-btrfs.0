From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH 0/3] Btrfs-progs: restriper interface
Date: Mon, 6 Feb 2012 23:20:18 +0100
Message-ID: <201202062320.19154.kreijack@inwind.it>
References: <1328305752-32160-1-git-send-email-idryomov@gmail.com> <201202041406.28273.kreijack@inwind.it> <20120204144717.GB10916@zambezi.lan>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>
To: Ilya Dryomov <idryomov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120204144717.GB10916@zambezi.lan>
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday, 04 February, 2012 15:47:17 Ilya Dryomov wrote:
> On Sat, Feb 04, 2012 at 02:06:28PM +0100, Goffredo Baroncelli wrote:
> > Hi Ilya,
> > 
> > On Friday, 03 February, 2012 22:49:09 Ilya Dryomov wrote:
> > > Hello,
> > > 
> > > This is the userspace part of restriper, rebased onto the new progs
> > > infrastructure.  Restriper commands are located under 'balance' prefix,
> > > which is now the top level command group.  However to not confuse
> > > existing users 'balance' prefix is also available under 'filesystem':
> > > 
> > > btrfs [filesystem] balance start
> > > btrfs [filesystem] balance pause
> > > btrfs [filesystem] balance cancel
> > > btrfs [filesystem] balance resume
> > > btrfs [filesystem] balance status
> > > 
> > > Backwards compatibility is fully preserved thanks to the new command
> > > parser: the old 'btrfs filesystem balance <path>' works as expected.
> > 
> > I prefer to avoid prefix which may confuse the user. If I have a
> > subvolume
> > 
> > called "s", what means:
> > 	btrfs filesystem balance s
> > 
> > Is it a missing argument (the path required for btrfs filesystem balance)
> > or is it a synonymus of
> > 
> > 	btrfs filesystem balance start ./s
> > 
> > (or btrfs filesystem balance stop ./s)
> > 
> > ?
> 
> It's a path.  It's unambiguous because every subcommand requires an
> argument. If you omit the path argument you get the following:

Sorry, I disagree. It is ambiguous because you are not able to  understand if 
there is an error of missing parameters.

If exist a filesystem called 's' 

# btrfs fi bal s

could be:

1) an error (missing parameters for the command "btrfs filesystem balance 
start/status" )
2) the starting of the balance of the filesystem 's'




> 
> btrfs-progs-new$ ./btrfs fi balance
> usage: btrfs [filesystem] balance [<command>] [options] <path>
> 
>     btrfs [filesystem] balance start [options] <path>
>         Balance chunks across the devices
>     btrfs [filesystem] balance pause <path>
>         Pause running balance
>     btrfs [filesystem] balance cancel <path>
>         Cancel running or paused balance
>     btrfs [filesystem] balance resume <path>
>         Resume interrupted balance
>     btrfs [filesystem] balance status [-v] <path>
>         Show status of running or paused balance
> 
> 'btrfs filesystem balance' command is deprecated, please use
> 'btrfs balance start' command instead.
> 
> which clearly indicates that <command> is optional.  Finally, if you type
> 
> 	btrfs fi balance s /mnt
> 
> (which is ambiguous because 's' could mean 'start' or 'status') you get
> the following:
> 
> btrfs-progs-new$ ./btrfs fi balance s /mnt
> btrfs filesystem balance: ambiguous token 's'
> 
> Did you mean one of these ?
> 	start
> 	status
> 
> Pretty clear to me.
> 
> > To me I prefer to add another family of command called
> > 
> > 	btrfs balance *
> > 
> > and to leave
> > 
> > 	btrfs filesystem balance
> > 
> > as synonymus of
> > 
> > 	btrfs balance start
> 
> I discussed this with Chris and we agreed that it will be confusing if
> 'btrfs filesystem balance' is different from 'btrfs balance'.
> 
> > This was discussed several years ago. Allowing the user to abbreviate the
> > commands fights with the ability to have different length of commands ,
> > when an option could beconfused with a command (s vs start/stop....).
> 
> It generally does, but in this particular case (where every subcommand
> in the group requires at least one argument) it does not.
> 
> Thanks,
> 
> 		Ilya
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
