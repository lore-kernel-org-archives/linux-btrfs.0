From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 1/2] Re: New btrfs command pushed into the btrfs-progs
 subvol branch - commands
Date: Thu, 11 Mar 2010 22:27:12 -0500
Message-ID: <20100312032712.GC3035@think>
References: <20100311185421.GM6509@think>
 <201003112003.18245.kreijack@inwind.it>
 <20100311190828.GN6509@think>
 <201003112244.31375.kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: kreijack@inwind.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201003112244.31375.kreijack@inwind.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 11, 2010 at 10:44:21PM +0100, Goffredo Baroncelli wrote:
> Hi Chris,
> 
> I updated my git repository. You can pull from 
> 
> git pull http://cassiopea.homelinux.net/git/btrfs-command.git mlc-subvol
> 
> (branch mlc-subvol, commit e59135a27dc1fde6acc4fb198499be2b6cbd9f6f)
> 
> $ git diff remotes/origin/subvol | diffstat
>  btrfs-list.c   |   15 +++--
>  btrfs.c        |   56 +++++++++++++++++-
>  btrfs_cmds.c   |   84 +++++++++++++++++-----------
>  btrfs_cmds.h   |    1 
>  man/btrfs.8.in |  150 +++++++++++++++++++++++++++++++++++++++++++++[...]
>  5 files changed, 283 insertions(+), 43 deletions(-)
> 
> 
> As you requested I update the parser in order set the argv[0] argument as the 
> program name + the verb. For example if I do
> 
> 	$ btrfs dev add
> 
> the argv[0] will be equal to "btrfs device add". I hope that is what you 
> requested.

Great.

> 
> Due to this change I update all the commands in order to evaluate the 
> arguments from argv[1] and not from argv[0] anymore. (I update also your 
> do_defrag() function)
> 
> Also because I implemented that already the week ago:
> - I made some small modification to btrfs-list.c in order to be more friendly 
> in case of error (replace some "exit(2)" with "return -ERR")
> - I implemented the command "btrf subvolume set-default"

Wonderful.  I've rebased this and put it into the subvol branch.  I
think I got all the commits and differences.  The big reason for the
rebase is to avoid the small string of single liner fixup commits.
If you have other work pending I'm happy to rebase it in, otherwise
please try to work against my subvol branch.

Thanks again!

-chris

