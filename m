From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: [PATCH v1 0/2] Btrfs-progs: commands "resolve inode" and "resolve
 logical"
Date: Fri, 08 Jul 2011 01:19:17 +0200
Message-ID: <4E163EF5.4070405@libero.it>
References: <cover.1310053983.git.list.btrfs@jan-o-sch.net>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1310053983.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/07/2011 06:01 PM, Jan Schmidt wrote:
> The kernel patch series just sent (Subject: "Btrfs: scrub: print path to
> corrupted files and trigger nodatasum fixup") introduces two new ioctls to
> do in-kernel filesystem path construction. This series provides the
> corresponding userspace changes, adding two new commands to the btrfs utility:

Which is the aim of these commands ? It seems more a "debug" utilities
than a standard command. If so, these commands may be put under a new
group called "debug" or "test" or whichever we decided to use. But,
please, highlight the fact that these commands aren't for a general use.

I suggest to use

	btrfs debug resolve ...

Or better

	btrfs inspect resolve ...

> 
> --
> btrfs resolve inode [-v] <inode> <path>
> 	resolves an <inode> to all filesystem paths local to the fs mounted
> 	at <path>.
> 		-v  print count of returned and missed paths
> 
> btrfs resolve logical [-v] [-P] <logical> <path>
> 	resolves a <logical> address to all filesystem paths in the file
> 	system mounted at <path> and all its subvolumes.
> 		-v  print count of returned and missed inode/offset/root
> 		    triples
> 		-P  do not resolve the path but stop after finding all
> 		    inodes at this logical address and print them instead
> --
> 
> These patches are based on Hugo's current integration branch.
> 
> Please try them out and report bugs here. I'll send an update to the manpages
> later.

Please update the man pages at the same time of the code. Develop the
man page coupled with the code may help to design a "good interface"
(from an user point of view) and to explain better the aim of the new
command.


BR
G.Baroncelli


> 
> -Jan
> 
> Jan Schmidt (2):
>   btrfs-list: split list_subvols
>   added ioctls and commands to resolve inodes and logical addresses
> 
>  btrfs-list.c |  139 ++++++++++++++++++++++++++++++++++------------
>  btrfs.c      |   10 +++
>  btrfs_cmds.c |  177 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  btrfs_cmds.h |    3 +
>  ioctl.h      |   29 ++++++++++
>  5 files changed, 323 insertions(+), 35 deletions(-)
> 

