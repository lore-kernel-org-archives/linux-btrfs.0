Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:52235 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752733AbdCXFtU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Mar 2017 01:49:20 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1crI5x-0007MA-1y
        for linux-btrfs@vger.kernel.org; Fri, 24 Mar 2017 06:49:05 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Bug: btrfs dev del missing fails where it shouldn't
Date: Fri, 24 Mar 2017 05:48:45 +0000 (UTC)
Message-ID: <pan$6d207$1e762e21$4d82ed9e$78bb3ca@cox.net>
References: <63b13b68a616abf8f828d6725f792be4@webmail.pados.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Károly Pados posted on Thu, 23 Mar 2017 14:07:31 +0000 as excerpted:

[ Kernel 4.9.13, progs 4.9.1:

1) Mkfs.btrfs a two-device raid1 data/metadata btrfs and mount it.

Don't put any data on it.

2) Remove a device physically or at the block level

3) Remount degraded and balance-convert data to single, metadata to dup. ]

> 4) Obviously the array still has a missing device, check this:
> 
> btrfs fi show Label: none  uuid: 55fa0da0-26b5-4a66-ba54-e9488e47cf6e
>         Total devices 2 FS bytes used 320.00KiB
>         devid    1 size 3.74GiB used 896.00MiB path /dev/sda
>         *** Some devices missing
> 
> 5) Try to remove missing device and see the error:
> 
> btrfs dev del missing /mnt/volatile
> ERROR: error removing device 'missing':
> no missing devices found to remove
> 
> 
> Step 5) failed and can be replaced by:
> 
> btrfs dev del 2 /mnt/volatile/
> [  402.828294] BTRFS info (device sdb): device deleted: id 2

> btrfs fi
> show Label: none  uuid: [...]
>         Total devices 1 FS bytes used 320.00KiB
>         devid    1 size 3.74GiB used 896.00MiB path /dev/sda
> 
> Still, 'missing' should be working, and having to use the devid is a
> PITA for both humans and scripts (the reason why 'missing' was added in
> the first place).

btrfs dev del missing has had a bit of a history and is I believe broken 
on newer kernels (tho I'm not entirely sure whether it's entirely broken, 
or whether it still works in some specific cases, see why it couldn't be 
expected to work in yours, below).  Obviously it's at least partially 
broken on 4.9.  If you trace the delete-by-devid patches, you'll see the 
history there and that they were actually introduced in part to work 
around the broken delete missing feature.

FWIW, the btrfs-device manpage, as of the progs-4.9 I still have 
installed here, at least, doesn't even appear to list "missing" as an 
option any longer.

The wiki does still discuss using missing, at least on the multiple-
devices page, which obviously hasn't been updated in that regard recently 
as it doesn't (on quick read at least) appear to mention using dev-id at 
all, and it still uses delete instead of the newer remove (see below), 
too.

But, even there, a close read says missing tells btrfs to delete the 
first device described by the filesystem metadata that wasn't present 
when the filesystem was mounted.  And since your case does a remount, not 
a full unmount and clean mount, that "missing" device was present when 
the filesystem was mounted, so attempting to delete missing /should/ be 
expected to fail.

Meanwhile, it's also worth noting that btrfs device delete is itself 
deprecated and only maintained for backward compatibility, in favor of 
btrfs device remove.  Apparently, some people believe that "remove" is 
more technically correct, altho for me personally remove/delete are 
synonyms and I can't really see a difference in correctness, here.

> (Probably unrelated question: In the last btrfs fi show you can see
> 896MB is used on a 3.74GB filesystem. The filesystem was just created
> however as described in the above steps, it is 100% empty with no prior
> use or wear. So the brand-new formatted drive seems to be 23% full, is
> this normal?)

This is actually the more interesting question for me and thus why I'm 
replying.  The output is not an error, it's just not reporting what you 
think it's reporting.

The first thing to note is that while you don't have a btrfs fi show from 
immediately after the mkfs, before killing a device and doing the 
balance, the two show outputs from before and after the btrfs dev delete 
both show 896 MiB used for the remaining device (device level).

** But they both show only 320 KiB used at the filesystem level.

If you run the newer btrfs fi usage command (and it's dev counterpart, 
btrfs dev usage), you'll get a more complete picture and a bit of a hint 
as to what's actually going on.

The key here is understanding that btrfs allocates space in two stages, 
first to larger chunks, data or metadata, then as necessary from the 
chunk to individual data extents or metadata blocks.  Data chunks are 
nominally 1 GiB, while metadata chunks are 256 MiB, altho either one can 
be larger or smaller than nominal under specific circumstances.

What btrfs fi show is reporting in the per-device lines is the chunk 
allocation.  If you take a look at the usage output, you should find that 
the reported chunk allocations per device (in usage and df, size, not 
used) totals equal the show output device line used.

Meanwhile, show does report the actual used space in the global line -- 
compare it to the actual used space reported in df and (fi) usage.  (Even 
an empty filesystem has some actual usage, 320 KiB in your case, actually 
not too bad on a multi-TiB filesystem.)

As you can see, show actually doesn't show much info at all, compared to 
usage.  You basically have to combine the older show and df outputs to 
get the information in usage, and even then, you're still missing a bit 
of the detail that usage provides.

But usage has two main drawbacks.  It can only be run on mounted 
filesystems, and it's a relatively newer command that wasn't available in 
earlier iterations.

So particularly when a filesystem can't be mounted, show is sometimes all 
the information we can get.  The other advantage of show is that on 
systems where there's many btrfs, show will list them all, mounted and 
unmounted both, if it's not told to list specific ones, which makes it 
handy as a general multi-btrfs overview command.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

