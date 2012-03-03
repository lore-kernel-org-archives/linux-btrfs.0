From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: nocow flags
Date: Sat, 3 Mar 2012 05:45:28 +0000 (UTC)
Message-ID: <pan.2012.03.03.05.45.28@cox.net>
References: <COL113-W450746A36272A165E90E1FB06D0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Kyle Gates posted on Fri, 02 Mar 2012 11:29:40 -0600 as excerpted:

> I set the C (NOCOW) and z (Not_Compressed) flags on a folder but the
> extent counts of files contained there keep increasing.
> Said files are large and frequently modified but not changing in size.
> This does not happen when the filesystem is mounted with nodatacow.
> 
> I'm using this as a workaround since subvolumes can't be mounted with
> different options simultaneously. ie. one with COW, one with nodatacow
> 
> Any ideas why the flags are being ignored?
> 
> I'm running 32bit 3.3rc4 with
> noatime,nodatasum,space_cache,autodefrag,inode_cache on a 3 disk RAID0
> data RAID1 metadata filesystem.

I'm not sure if it applies here or not, but there's a note on the wiki 
under the defrag discussion, that mentions that defrag, anyway, is per-
file, and defragging a dir doesn't defrag the files in that dir.  I'm
/guessing/ the same thing may apply here since these are per-file flags.

There's a workaround suggested.  Let me see if I can find that note 
again...

Found it in the problem FAQ:

http://btrfs.ipv5.de/index.php?
title=Problem_FAQ#Defragmenting_a_directory_doesn.27t_work

>>>>>

Defragmenting a directory doesn't work

Running this:

# btrfs filesystem defragment ~/stuff

doesn't defragment the contents of the directory.

This is by design. btrfs fi defrag operates on the single filesystem 
object passed to it. This means that the command defragments just the 
metadata held by the directory object, and not the contents of the 
directory. If you want to defragment the contents of the directory, 
something like this would be more useful:

# find -type f -xdev -print0 | xargs -0 btrfs fi defrag

<<<<<

Perhaps you need to do something similar to set the flags on all the 
files under a specific dir?

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

