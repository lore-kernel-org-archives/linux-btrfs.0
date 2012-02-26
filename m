From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: filesystem full when it's not?  out of inodes?  huh?
Date: Sun, 26 Feb 2012 08:52:06 +0000 (UTC)
Message-ID: <pan.2012.02.26.08.52.06@cox.net>
References: <jic3e1$gpe$1@dough.gmane.org> <4F499498.1040006@gmail.com>
	<jic4m8$j6g$1@dough.gmane.org> <4F499AE4.80908@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Fahrzin Hemmati posted on Sat, 25 Feb 2012 18:37:24 -0800 as excerpted:

> On 2/25/2012 6:16 PM, Brian J. Murrell wrote:
>>> Others might know of a way of changing the allocation size to less
>>> than 1GB, but otherwise I recommend switching to something more stable
>>> like ext4/reiserfs/etc.

>> So btrfs is still not yet suitable to be a root/usr/var filesystem,
>> even in kernel 3.0.0?
>>
> Nope, still in heavy development, though you should upgrade to 3.2.
> Also, the devs mentioned in several places it's not friendly to small
> drives, and I'm pretty sure 5GB is considered tiny.
> 
> I don't think you need to separate /usr out to it's own disk. You could
> instead create a single drive with multiple subvolumes for /, /var,
> /usr, etc. When you have Ubuntu use btrfs for /, it creates @ and @home
> for / and /home, respectively, so it's a common phenomenon if you look
> for help.

It's astonishing to me the number of people that come in here complaining 
about problems with a filesystem the kernel option of which says 

Title:

Btrfs filesystem (EXPERIMENTAL) Unstable disk format

Description (excerpt):

Btrfs is highly experimental, and THE DISK FORMAT IS NOT YET
FINALIZED.  You should say N here unless you are interested in
testing Btrfs with non-critical data.


So, does testing with non-critical data sound like it's appropriate for 
running on your (OP's) root or home (or anything else you might be using 
it for) filesystem, the way you're doing it now?  If not, what are you 
doing on btrfs?  You better either change your choice of filesystem, or 
your update and backup strategy, to be more in line with the testing 
that's an appropriate use of btrfs at this point.

About twice a week we get people on the list asking about recovery tools 
because the filesystem won't mount, too, and they apparently had no 
backups.  WTF?  Not only should they have had backups (that's normal with 
every filesystem, you always have backups if the data's valuable to you, 
and always test them), but btrfs isn't appropriate for anything besides 
testing data that they *EXPECT* the file system to chew up and spit out 
at them!  IOW, not only should there be backups, but the btrfs copy 
should be considered the non-primary copy, essentially garbage, because 
there's a very real chance that's what it'll be if something goes wrong!

Of course, anyone who *IS* using it as intended at this point will be 
following the lists, know what bugs are being seen frequently, know the 
status of the various recovery tools, etc.  They won't HAVE to ask, as 
they'll already KNOW if they're using the filesystem as intended, for 
testing, reporting bugs, and possibly submitting patches if they have the 
skills, in coordination with the devs and other testers on the list, at 
this point.

Meanwhile, if you DO decide to continue with btrfs for testing...

There's a wiki covering the ENOSPC problem, discussing kernel and tools 
status (keep upto date, the kernel especially is in HEAVY development, 
and even running the latest stable kernel, means you're already missing 
the bug-fixes and better stability in the current development kernel!), 
etc.

Actually, there's two wikis, the kernel.org wiki which is static content 
(not updated and thus not upto date) ATM due to the kernel.org breakin a 
few months ago, and a "temporary" one that's rather more current.

Here's the link to both:

Kernel.org wiki (outdated static ATM):
https://btrfs.wiki.kernel.org/

Temporary upto-date wiki:
http://btrfs.ipv5.de/index.php?title=Main_Page

There, the second paragraph of the main page says:

Btrfs is under heavy development, but every effort is being made to keep 
the filesystem stable and fast. Because of the speed of development, you 
should run the latest kernel you can (either the latest release kernel 
from kernel.org, or the latest -rc kernel.

So YES, a 3.0 kernel is *OLD*!  Even the latest stable 3.2.x kernel won't 
have the latest btrfs fixes.  For that, you need the latest 3.3-rc if you 
aren't running git kernels and updating between the rcs!

The FAQ page there has a whole section titled "Help! I ran out of disk 
space!"  In particular, see the "If your device is small" subsection.

http://btrfs.ipv5.de/index.php?title=FAQ

Also, down further in the FAQ, see

Why does df show incorrect free space for my RAID volume?
Aaargh! My filesystem is full, and I've put almost nothing into it!
Why are there so many ways to check the amount of free space?

(That's one section covering the three.)  Plus the answers to these two 
as well:

Why is free space so complicated?

Why is there so much space overhead?

Meanwhile, what you SHOULD have read before even STARTING with btrfs, the 
getting started page:

http://btrfs.ipv5.de/index.php?title=Getting_started

Right at the top:
[begin quote]

btrfs is a fast-moving target. There are typically a great many bug fixes 
and enhancements between one kernel release and the next. Therefore:

* If you have btrfs filesystems, run the latest kernel. *

If you are running a kernel two or more versions behind the latest one 
available from kernel.org, the first thing you will be asked to when you 
report a problem is to upgrade to the latest kernel. Some distributions 
keep backports of recent kernels to earlier releases -- see the page 
below for details.

Having the latest user-space tools are also useful, as they contain 
additional features and tools which may be of use in debugging or 
recovering your filesystem if something goes wrong.

Note also that btrfs is still considered experimental. While many people 
use it reliably, there are still problems being found.

* You should keep and test backups of your data, and be prepared to use 
them. *

[end quote]

So YES, UPGRADE.  If you're not interested in keeping up with the latest 
kernels, why are you running a testing filesystem?

And here again, from the source code page:

http://btrfs.ipv5.de/index.php?title=Btrfs_source_repositories

[begin quote]
Warning, Btrfs evolves very quickly do not test it unless:

1. You have good backups and you have tested the restore capability
2. You have a backup installation that you can switch to when
       something breaks
3. You are willing to report any issues you find
4. You can apply patches and compile the latest btrfs code against
       your kernel (quite easy with git and dkms, see below)
5. You acknowledge that btrfs may eat your data
6. Backups! Backups! Backups! 

[end quote]


Meanwhile, new enough it's not on the wiki that I saw, and it wasn't in 
3.0 I don't believe but 3.2 has it, and it'll require a current btrfs-
progs (the git version, updated regularly, is best), but mkbtrfs aka 
mkfs.btrfs now has the --mixed/-M option, with this description in the 
mkfs.btrfs (8) manpage:

-M, --mixed
  Mix data and metadata chunks together for more efficient space
  utilization.   This  feature incurs  a  performance  penalty
  in  larger  filesystems.   It  is recommended for use with
  filesystems of 1 GiB or smaller.

You could try that on 5-gig filesystems as well.

Finally, the previous smallest allocation block was 1/4 GiB (256 MiB).  
Combine that with the fact that until recently each such block could be 
set to date OR metadata, NOT mixed (fixed at mkfs time with the option 
above), and btrfs really was NOT suited to small filesystems.

Very new, so new I know it's in 3.3 but am not sure it's in 3.2, that 256 
MiB lower end limitation is now gone, and btrfs can make use of "the 
small change" space it previously couldn't do anything with.

Combine those two very new changes together, and it's actually semi-
practical to use btrfs for smaller filesystems now.  But they're both 
quite new, I believe both newer than your actually relatively ancient (in 
btrfs terms) kernel 3.0.  It's exactly that sort of thing that's behind 
the emphasis on keeping up, as you'll be doing anyway if you're using the 
filesystem as intended at this point, for rapid-turn-around testing, 
reporting problems, and getting fixes with each kernel version and often 
in between (with 3.3, there was the merge-window changes before rc1, and 
just a few days ago a whole host of fixes submitted, that if Linus pulled 
them, they'd be in rc4).

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

