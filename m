From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH 0/3] Btrfs-progs: restriper interface
Date: Sat, 4 Feb 2012 14:06:28 +0100
Message-ID: <201202041406.28273.kreijack@inwind.it>
References: <1328305752-32160-1-git-send-email-idryomov@gmail.com>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Ilya Dryomov <idryomov@gmail.com>, Hugo Mills <hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1328305752-32160-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Ilya,

On Friday, 03 February, 2012 22:49:09 Ilya Dryomov wrote:
> Hello,
> 
> This is the userspace part of restriper, rebased onto the new progs
> infrastructure.  Restriper commands are located under 'balance' prefix,
> which is now the top level command group.  However to not confuse
> existing users 'balance' prefix is also available under 'filesystem':
> 
> btrfs [filesystem] balance start
> btrfs [filesystem] balance pause
> btrfs [filesystem] balance cancel
> btrfs [filesystem] balance resume
> btrfs [filesystem] balance status
> 
> Backwards compatibility is fully preserved thanks to the new command
> parser: the old 'btrfs filesystem balance <path>' works as expected.

I prefer to avoid prefix which may confuse the user. If I have a subvolume 
called "s", what means:

	btrfs filesystem balance s

Is it a missing argument (the path required for btrfs filesystem balance) or 
is it a synonymus of

	btrfs filesystem balance start ./s

(or btrfs filesystem balance stop ./s)

?

To me I prefer to add another family of command called

	btrfs balance *

and to leave

	btrfs filesystem balance 

as synonymus of

	btrfs balance start


This was discussed several years ago. Allowing the user to abbreviate the 
commands fights with the ability to have different length of commands , when 
an option could beconfused with a command (s vs start/stop....).
> 
> The patchset is on top of the new parser posted half an hour ago,
> available at:
> 
> git://github.com/idryomov/btrfs-progs.git restriper
> 
> Thanks,
> 
> 		Ilya
> 
> 
> Ilya Dryomov (3):
>   Btrfs-progs: add restriper headers
>   Btrfs-progs: add 'balance' command group infrastructure
>   Btrfs-progs: add restriper commands
> 
>  Makefile          |    2 +-
>  btrfs.c           |    1 +
>  cmds-balance.c    |  684
> +++++++++++++++++++++++++++++++++++++++++++++++++++++ cmds-filesystem.c | 
>  38 +---
>  commands.h        |    2 +
>  ctree.h           |   23 ++-
>  ioctl.h           |   53 ++++
>  print-tree.c      |    6 +
>  volumes.h         |   31 +++
>  9 files changed, 795 insertions(+), 45 deletions(-)
>  create mode 100644 cmds-balance.c
