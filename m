From: Nuutti Kotivuori <naked@iki.fi>
Subject: Somewhat borked filesystem in need of fixing
Date: Tue, 17 Nov 2009 22:48:48 +0200
Message-ID: <87r5rw3mj3.fsf@kiiro.naked.iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I recently told here about a broken filesystem after btrfs-convert &
friends and I was informed that this was a known bug and fixed in later
releases. I should've reformatted the partition and copied in the files
anew, but I didn't, since this isn't a crucial production system for me.

So, after a day or two, I got in a case where I had done a hibernate,
several suspend/resume cycles and exhausted the swap space so OOM killer
was running wild and stuff.

And I managed to get an endless stream of errors to the system log that
looked more or less like this:

  parent transid verify failed on 39620608 wanted 5946 found 5944

I don't know if I'd be able to reproduce the problem, if spending a lot
of time on it, but atleast for now, this was just a one time off case.

So I rebooted the machine, and got the same stream of errors upon
mounting the filesystem. 500 per second. So I tried fsck, and it gave
the same error and promptly segmentation faulted. btrfs-image did the
same I think (though I'm not sure about this one).

Anyhow, I'd love to have a more reliable btrfsck, that is able to fix
all kinds of corruptions, even then ones that are "never supposed to
happen". So, personally, I'd like to work on this issue until btrfsck is
able to fix the filesystem in to perfect working order - or atleast in
such a good state, that files can be copied off from it.

However, if you'd rather debug the mount problems, that can be done as
well - though that's more of a problem since I will have to do it in a
virtual machine as to not mess up my server.

Anyhow, long story short, here's the error reported by btrfsck:

---------------------------------------------------------------------------
$ sudo ./btrfsck /dev/mapper/perspire-root
parent transid verify failed on 39620608 wanted 5946 found 5944
Segmentation fault
---------------------------------------------------------------------------

And here's valgrind telling what goes awry:

---------------------------------------------------------------------------
parent transid verify failed on 39620608 wanted 5946 found 5944
==17536== Invalid read of size 4            
==17536==    at 0x40F9AB: btrfs_print_leaf (ctree.h:1411)
==17536==    by 0x40C066: btrfs_lookup_extent_info (extent-tree.c:1450)
==17536==    by 0x4023F2: check_extents (btrfsck.c:2509)
==17536==    by 0x405004: main (btrfsck.c:2829)
==17536==  Address 0xc4 is not stack'd, malloc'd or (recently) free'd
---------------------------------------------------------------------------

This is with the current head of btrfs-progs-unstable.

Thank you in advance,
-- Naked
