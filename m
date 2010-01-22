From: "Michael Niederle" <mniederle@gmx.at>
Subject: Re: [RFC] Move all btrfs command to only one command
Date: Fri, 22 Jan 2010 01:11:07 +0100
Message-ID: <20100122011107.7bc36b2b@simplux>
References: <201001212029.26681.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org, David Nicol <davidnicol@gmail.com>,
	taruishi.hiroak@jp.fujitsu.com
To: Goffredo Baroncelli <kreijack@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201001212029.26681.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

> $ btrfs                         
> Usage:                                              
>         btrfs clone|-c <source> [<dest>/]<name>     
>                 Clone the subvolume <source> with the name <name> in the 
> <dest>
>                 directory.                                                     
>         btrfs delete|-d
> <subvolume> Delete the subvolume <subvolume>.                              
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

I like this idea!

Just a small suggestion:

"btrfs remove" instead of "btrfs rem"

-----

Another question: Is there a simple way to convert a directory into a subvolume?

Currently I first create the new subvolume; copy or move the data of the
directory into the new subvolume, then delete the directory and finally
rename the subvolume.

Greetings, Michael
