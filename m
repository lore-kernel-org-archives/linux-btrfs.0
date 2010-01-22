From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: Re: [RFC] Move all btrfs command to only one command
Date: Fri, 22 Jan 2010 09:02:00 +0900
Message-ID: <4B58EAF8.3060102@jp.fujitsu.com>
References: <201001212029.26681.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, davidnicol@gmail.com,
	chris.mason@oracle.com
To: kreijack@gmail.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201001212029.26681.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Goffredo,

It sounds good for me though detailed points need more discussion.
btrfs-progs seems unkind for operator as you mentioned, and many
features will be implemented to btrfsctl from now, it's good that
we arrange and unify btrfs-progs now.

As for me, plain keywords(delete,defrag...) as commands are welcome.

Regards,
taruisi

(2010/01/22 4:29), Goffredo Baroncelli wrote:
> Hi all
> 
> this RFC is about unify all btrfs command (btrfsctl, btrfs-show, btrfs-tune.. 
> ) in only one called "btrfs" (or whatever we want).
> 
> Today "btrfsctl" needs a "bit" of care because
>   * the help is basically wrong [1]
>   * the return codes are incoherent [2]
>   * the syntax of the command are very ugly (a lot of people complained 
>     about the subvolumes/snapshot creation, because they aren't very clear)
>     [3]
>   * the code is a mess (in the main there is a useless for(); there a lot
>     of 'if' because sometime the last argument is the target of ioctl,
>     sometime no..) [4]
>   * The checks of the number of argument are incorrect [5]
> 
> I think that is better to rewrite from scratch a new command instead of 
> patching the old one. So we don't care about the backward compatibility.
> 
> Other filesystem (hammer, tux3, zfs) have only one command for management 
> purpose. Instead we have btrfsctl (which has a lot of different
> function) and btrfs-show, btrfs-tune, btrfs-volume which have few functions.
> 
> There are patches which address [6] some of the previous issues, 
> but these are not integrated (because the developers are busy on other 
> issues). To me rewriting from scratch seems a fast path for solving these 
> issues.
> 
> I made a prototype (see attached file) in bash of what "btrfs" should be. The 
> major different from btrfsctl are:
> - I talk about clone and not snapshot
> - If a sub-volume is required (for example for the cloning), the program check 
> that the argument is a root of the subvolume and not a subdirectory
> - Creating a sub-volume requires only one argument 
> 
> Below some examples:
> 
> $ btrfs                         
> Usage:                                              
>         btrfs clone|-c <source> [<dest>/]<name>     
>                 Clone the subvolume <source> with the name <name> in the 
> <dest>
>                 directory.                                                     
>         btrfs delete|-d <subvolume>                                            
>                 Delete the subvolume <subvolume>.                              
>         btrfs create|-C [<dest>/]<name>
>                 Create a subvolume in <dest> (or the current directory if not
>                 passed.
>         btrfs defrag|-d <file>|<dir> [<file>|<dir>...]
>                 Defragment a file or a directory.
>         btrfs fssync|-s <path>
>                 Force a fs sync on the filesystem <path>
>         btrfs resize|-r [+/-]<newsize>[gkm]|max <filesystem>
>                 Resize the file system. If 'max' is passed, the filesystem
>                 will occupe all available space on the device.
>         btrfs scan|-S [<device> [<device>..]
>                 Scan all device for or the passed device for a btrfs 
> filesystem.
>         btrfs show|-l <dev>|<label> [<dev>|<label>.. ]
>                 Show the btrfs devices
>         btrfs balance|-b <path>
>                 Balance teh chunk across the device
>         btrfs add|-A <dev> <path>
>                 Add a device to a filesystem
>         btrfs rem|-R <dev> <path>
>                 Remove a device to a filesystem
> 
>         btrfs help|--help|-h
>                 Show the help.
> 
> 
> 
> Comment are welcome
> 
> 
> 
> 
> [1] In the help the -r, -c options seem that don't need any further argument; 
> The -D command seems that accpet only "." as 2nd parameter....
> 
> [2] If something goes wrong btrfsctl returns 1; if the ioctl return 0 the 
> command still returns 1...
> 
> [3] See the email in the mailing list
> 
> [4] If I does
>    btrfsctl -c -d -A -S a .
> what result do you aspect ?
> 
> [5] If I pass more argument than the ones needed no error is showed. -D checks 
> if there is only one argument, when it needs two argument...
> 
> [6] 
> - 10/26/09 - little fixme in btrfsctl.c [PATCH] - From: 
> David Nicol <davidnicol@gmail.com>
> - 12/24/09 - [PATCH] btrfs-progs: check slash in deleting subvolumes. - From: 
> TARUISI 
> - 12/13/09 - [PATCH] Improve the btrfsctl help - From: 
> Goffredo Baroncelli <kreijack@gmail.com>
> 
> 

