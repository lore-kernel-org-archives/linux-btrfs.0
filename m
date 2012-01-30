From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: newbie problems (difficulty with mkfs.btrfs and learning how to
 navigate trees
Date: Mon, 30 Jan 2012 05:56:40 +0000 (UTC)
Message-ID: <pan.2012.01.30.05.56.40@cox.net>
References: <CAHb3AmJiv3Leq1QUO3JNQ3tuZ06jFQXWv=Jba65AW9qbk-T4Qw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Rohit Mehta posted on Sun, 29 Jan 2012 22:06:59 -0500 as excerpted:

> Hi everyone, I'm trying to learn about btrfs and the various trees and
> data structures.  To that end I have been trying to create a small RAID
> 1 filesystem (with 2 10MB devices), and it appears mkfs.btrfs does not
> like this. (output follows
> 
>   # ./mkfs.btrfs -d raid1 -m raid1 -b 10485760 /dev/ubdc /dev/ubdb SMALL
>   VOLUME: forcing mixed metadata/data groups
> 
>   WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL WARNING! - see
>   http://btrfs.wiki.kernel.org before using
> 
>   Created a data/metadata chunk of size 1048576 adding device /dev/ubdb
>   id 2 mkfs.btrfs: mkfs.c:221: create_one_raid_group: Assertion `!(ret)'
>   failed.
>   Aborted
> 
> However if I don't set the raid1 options, I can create a 20 MB RAID0
> filesystem, or I can also create a 10 MB filesystem on one disk without
> any errors.  Large disk devices also seem to work as RAID1 or RAID0)
> 
> I'm really just trying to start to dig in and understand the code, but I
> figured a small filesystem would be easier to walk. I might just mess
> with a single disk for now, but I would appreciate any advice.

Hi.  FWIW, I'm only researching btrfs at this point in preparation for 
installing, so while I have the kernel options active and tools 
installed, that's as far as I've gotten on the actually doing it side.  
The below is thus based on recent posts here, the tools manpages, and the 
wiki, at:

https://btrfs.wiki.kernel.org/


First, a general point.  You don't mention what kernel or tools sources 
you are using.  btrfs is still under rapid development and every new 
kernel version brings bugfixes and tweaks, so you really want at least 
the latest stable kernel available (3.2.something at this point), if not 
the development kernels (3.3-rcs at this point or live-git).  Similarly 
with the tools. The 0.19 release was in 2009 and simply isn't current.  
Users of this experimental filesystem really should be running a recently 
built live-git version.  There's actually two trees available, the 
official kernel.org tree, and the "integration tree", which tracks 
patches seen on the list.  See the wiki for more.

Second, the mixed-chunk (data/metadata) code is quite new, and not yet 
well tested.  This doubles-down on the point above -- you WILL want the 
latest code if you're doing mixed-chunk, which you will be with small 
fileystems, see the next point.

Third, "small" is relative!

On the wiki there's a pre-mixed-chunk example of a "small" btrfs 
filesystem of 4 GB!  I'm on record here as grumbling that perhaps it 
makes me old, but I wouldn't call anything measured in the gigabytes 
particularly "small", even if in practical terms it is on today's disks!  
Another spot recommends filesystems no smaller than a gigabyte, noting 
that (again, pre-mixed-chunk), even with that, one should expect to lose 
a quarter of it to metadata, given chunk limitations.

Mixed-chunk does have the down side of more fragmentation, however, so 
it's recommended for filesystems of 1 GB or smaller to better utilize the 
space, but not for > 1 GB.

Obviously, with a 10 MB filesystem you're definitely testing the lower 
limits of a filesystem that calls even a four-gig fileystem "small"!  
Combine that with the newness of the mixed-chunk code and the fact that 
you might be running (relatively) older code (with "older" in this case 
potentially meaning live-git kernel and integration-tree userspace more 
than, say, a week old, especially given the newness of mixed-chunk mode 
itself).

It's quite likely that mixed-mode simply won't yet work on that tiny a 
filesystem created with raid1 mode data, but for sure I'd try it with the 
latest code, in case the problem is now fixed.

So, I'd say try it with something larger, probably 1/8 gig to 1/4 gig at 
least.  Or if that's not convenient at present, run as you mentioned, 
either raid0 mode or one device, no-raid, for now.


Meanwhile, my interest involves raid1 mode on (relatively) small devices, 
tho not 10 MB small, more like 128 MB small, as well.  As such, you may 
wish to check my posts for the last few days.  I've responded to several 
questions such as yours based on the wiki info, but also started a thread 
with a number of related questions (btrfs-raid questions I couldn't find 
an answer to on the wiki, posted last Thursday).

Of particular interest there, we were debating even a 128 MB btrfs image 
(raid1), in my case for a separate /boot partition.  The recommendation 
was to make it bigger, quarter or half gig (which I could do as I have a 
bit of free space on the drives I'll be using, unused with the current 
layout), or for such a small and special-purpose filesystem, to use 
something more traditional, probably either the reiserfs I'm using now or 
ext2/3/4.

(If you just joined the list and don't know where to find an archive to 
look up older posts, I'm using gmane.org, here.  I use the newsgroup 
interface for both reading and posting, but they also have a web 
interface, if you prefer.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

