Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56416 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbaHAL3b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Aug 2014 07:29:31 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XDB1e-0000oA-Gy
	for linux-btrfs@vger.kernel.org; Fri, 01 Aug 2014 13:29:30 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Aug 2014 13:29:30 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Aug 2014 13:29:30 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: open_ctree failed on 3.16.0
Date: Fri, 1 Aug 2014 11:29:20 +0000 (UTC)
Message-ID: <pan$aa380$cfda0300$d7b3a968$e36385c0@cox.net>
References: <53DB64CF.7060601@terrorise.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Frankie Fisher posted on Fri, 01 Aug 2014 10:58:39 +0100 as excerpted:

> A circuit breaker failed a few times and now I can't mount my btrfs
> volume - it fails with open_ctree failed:

[snip stacktrace, which as a btrfs user not dev doesn't give me much 
anyway]

> 
> mount -o recovery doesn't succeed, nor does mount -o recovery,ro.
> 
> I have tried the above with kernel 3.13.0 first and 3.16.0 later and the
> behaviour seems identical. This may or may not be relevant, but after I
> initialised the filesystem by copying some files to it (with kernel
> 3.13.0), one of the files failed a checksum error. I hadn't yet compared
> the file that was written with the original to determine whether the
> error was with the checksum or otherwise.
> 
> What are the next steps I should try? Should I try btrfs-zero-log? Or
> should I try btrfsck? Or something else?

The standard advice concerning btrfs check (aka btrfsck) is that running 
it without --repair or similar won't hurt as in that case it's read-only, 
but by the same token, it won't help, except possibly to give you an idea 
of what's wrong.  And don't run it with --repair except either on the 
direct advice of a someone here after seeing the read-only run output, or 
if you've otherwise given up and the next step would be a new mkfs as in 
that case you have nothing to lose, because check doesn't yet understand 
everything that can go wrong and in some cases may make the problem worse 
instead of better.

The first thing you may want to do is make an image using dd or the like, 
so you can restore to the current state if nothing works.  Of course 
that'll take quite some space...

Another read-only alternative is btrfs restore.  This is run on the 
/unmounted/ filesystem, allowing recovery of files from the filesystem 
without the possibility of damaging it further.  If you don't have a good 
backup, this is likely to be your best shot at, more or less, making one 
after-the-fact.  It may not recover everything and in particular, from my 
own experience I know it doesn't recover symlinks or file owner and 
permissions information, but in the absence of a proper current backup it 
does give you a reasonably good shot at recovering a good portion of the 
files.  Of course this will require at least enough space on other 
filesystems to write the recovered files.

If btrfs restore with the default options doesn't prove satisfactory, you 
can use the -l (list roots) -t (use tree location) and --dry-run options 
along with btrfs-find-root to hopefully find a better previous root, 
which can then be fet to the -t option to hopefully get a better 
recovery.  Additionally, when I used btrfs restore here, I had to use it 
with the -i option and run it repeatedly, feeding it the same path each 
time, as it kept giving up with a looping too much error on some of the 
larger directories, but would progress further each time as it could skip 
more files that were already there.

There's also btrfs-show-super to examine your superblocks and ensure 
they're not damaged, as well as to compare current generation/transid vs 
that of find-root and restore.  Show-super can also be used with btrfs 
rescue as noted below, to recover from a bad superblock, should it be 
necessary.

See the wiki page on restore for more details on it.

https://btrfs.wiki.kernel.org/index.php/Restore

You can then use btrfs-image to create a metadata image that you can give 
to the devs if they want to see what they can do with it.  That doesn't 
give them the data but will let them see filenames unless you use the -s 
option to sanitize them, which I'd recommend if you have sensitive 
filenames you don't want others to see.

With either a good backup or having restored as much as you can using 
restore, you can move on to potentially destructive attempts at further 
restoration.  Here's a slightly dated (nearing a year old, select-super 
and chunk-recover are part of the main btrfs command, under rescue, now) 
but still useful list of what to try and in what order, there.

http://permalink.gmane.org/gmane.comp.file-systems.btrfs/27999

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

